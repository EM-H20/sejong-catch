import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../admin/data/datasources/admin_api.dart';
import '../../../admin/data/models/request/change_role_request.dart';
import '../../../auth/data/models/user_role.dart';
import '../../data/models/response/booth.dart';
import '../../data/models/response/booth_manager.dart';
import '../../data/models/response/booth_master.dart';
import '../../data/models/response/my_queue_status.dart';
import '../models/queue_state.dart';
import '../../data/repositories/queue_repository.dart';
import '../../../auth/presentation/controllers/auth_state_controller.dart';

part 'queue_controller.g.dart';

/// 큐 페이지 컨트롤러
///
/// 부스 목록 조회, 대기열 등록/취소, 관리자 기능 등을 담당합니다.
/// Repository 패턴을 사용하여 Mock/Real 모드를 자동 분기합니다.
@riverpod
class QueueController extends _$QueueController {
  @override
  QueueState build() {
    // 초기 데이터 로드
    _loadInitialData();
    return const QueueState(isLoading: true);
  }

  /// 초기 데이터 로드 (부스 목록 + 부스 타입 목록)
  Future<void> _loadInitialData() async {
    try {
      final repository = ref.read(queueRepositoryProvider);

      // 병렬로 부스 목록과 부스 타입 조회
      final results = await Future.wait([
        repository.getBooths(),
        repository.getBoothMasters(),
      ]);

      state = state.copyWith(
        isLoading: false,
        booths: (results[0] as List).cast<Booth>(),
        boothMasters: (results[1] as List).cast<BoothMaster>(),
      );

      // 🔐 booth_manager인 경우 내가 관리하는 부스 ID 목록 조회
      final authState = ref.read(authStateControllerProvider);
      final userRole = UserRole.fromString(authState.currentUser?.role);
      if (userRole == UserRole.boothManager) {
        await _fetchMyManagedBooths();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 🔐 booth_manager용: 내가 관리하는 부스 ID 목록 조회
  ///
  /// 모든 부스를 순회하며 각 부스의 관리자 목록에 내가 포함되어 있는지 확인합니다.
  /// catch_booth_managers 테이블 기반으로 필터링합니다.
  Future<void> _fetchMyManagedBooths() async {
    final authState = ref.read(authStateControllerProvider);
    final currentUserId = authState.currentUser?.id;

    if (currentUserId == null) {
      debugPrint('⚠️ [_fetchMyManagedBooths] 현재 유저 ID가 없음');
      return;
    }

    debugPrint('🔐 [_fetchMyManagedBooths] 내가 관리하는 부스 조회 시작: userId=$currentUserId');

    final myBoothIds = <String>[];
    final repository = ref.read(queueRepositoryProvider);

    for (final booth in state.booths) {
      try {
        final managers = await repository.getBoothManagers(booth.id);
        // 내가 이 부스의 관리자인지 확인
        final isMyBooth = managers.any((m) => m.userId == currentUserId);
        if (isMyBooth) {
          myBoothIds.add(booth.id);
          debugPrint('  ✅ ${booth.title} (${booth.id}) - 내가 관리자임!');
        }
      } catch (e) {
        // 관리자 목록 조회 실패 시 무시 (권한 문제 등)
        debugPrint('  ⚠️ ${booth.title} 관리자 목록 조회 실패: $e');
      }
    }

    debugPrint('🔐 [_fetchMyManagedBooths] 내가 관리하는 부스: ${myBoothIds.length}개');

    state = state.copyWith(myManagedBoothIds: myBoothIds);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎯 UI 상태 관리
  // ═══════════════════════════════════════════════════════════════════════════

  /// 탭 변경
  ///
  /// **"내 대기열" 탭 (index=1) 선택 시**:
  /// 모든 부스에 대해 me-status API를 호출하여 내 대기 상태 조회
  Future<void> changeTab(int index) async {
    state = state.copyWith(currentTabIndex: index);

    // 🎯 "내 대기열" 탭 선택 시 내 대기 상태 조회
    if (index == 1) {
      await fetchAllMyStatuses();
    }
  }

  /// 🎫 모든 부스에 대해 내 대기 상태 조회
  ///
  /// 현재 로드된 모든 부스에 대해 me-status API를 호출합니다.
  /// **중요**: 백엔드 me-status API는 WAITING 상태만 반환하므로,
  /// IN_SERVICE 상태는 getQueueList API로 별도 확인합니다.
  Future<void> fetchAllMyStatuses() async {
    final repository = ref.read(queueRepositoryProvider);
    final updatedStatuses = <String, MyQueueStatus>{};

    // 현재 로그인한 유저 ID 가져오기
    final authState = ref.read(authStateControllerProvider);
    final currentUserId = authState.currentUser?.id;

    // 모든 부스에 대해 me-status 조회
    for (final booth in state.booths) {
      try {
        // 1️⃣ 먼저 me-status API로 WAITING 상태 확인
        final myStatus = await repository.getMyStatus(booth.id);
        updatedStatuses[booth.id] = myStatus;
        // ignore: avoid_print
        print('✅ [QueueController] ${booth.title} 대기 상태 조회 성공 (WAITING)');
      } catch (e) {
        // 2️⃣ me-status 실패 (404) → getQueueList로 IN_SERVICE 확인!
        if (currentUserId != null) {
          try {
            final entries = await repository.getQueueList(booth.id);
            // 내 userId와 매칭되는 IN_SERVICE 엔트리 찾기
            final myEntry = entries
                .where(
                  (entry) =>
                      entry.visitorId == currentUserId &&
                      entry.state == 'IN_SERVICE',
                )
                .firstOrNull;

            if (myEntry != null) {
              // IN_SERVICE 상태 발견! → MyQueueStatus로 변환
              final myStatus = MyQueueStatus(
                boothId: booth.id,
                visitorId: myEntry.visitorId ?? '',
                ticketNo: myEntry.ticketNo,
                state: 'IN_SERVICE',
                teamsAhead: 0, // 내 차례니까 0
                position: 1, // 내 차례니까 1
              );
              updatedStatuses[booth.id] = myStatus;
              // ignore: avoid_print
              print('✅ [QueueController] ${booth.title} IN_SERVICE 상태 발견!');
            } else {
              // ignore: avoid_print
              print('ℹ️ [QueueController] ${booth.title} 대기 정보 없음');
            }
          } catch (listError) {
            // getQueueList도 실패 → 진짜 대기 정보 없음
            // ignore: avoid_print
            print('ℹ️ [QueueController] ${booth.title} 대기 정보 없음 (list 조회도 실패)');
          }
        } else {
          // ignore: avoid_print
          print('ℹ️ [QueueController] ${booth.title} 대기 정보 없음 (userId 없음)');
        }
      }
    }

    state = state.copyWith(myQueueStatuses: updatedStatuses);
  }

  /// 부스 선택 (관리자 뷰)
  void selectBooth(String? boothId) {
    state = state.copyWith(selectedBoothId: boothId);
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📋 부스 조회
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 목록 새로고침
  Future<void> refreshBooths({String? status}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final booths = await repository.getBooths(status: status);

      state = state.copyWith(isLoading: false, booths: booths);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎫 대기열 (학생용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 대기열 등록
  ///
  /// **반환값**: 즉시 입장 여부 (true = IN_SERVICE, false = WAITING)
  ///
  /// **에러 처리**:
  /// - 409: 이미 대기 또는 이용 중 → 에러 메시지 표시
  /// - 404 (getMyStatus): 즉시 입장 시 WAITING 상태 없음 → 정상 케이스로 처리
  Future<bool> enqueue(String boothId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final result = await repository.enqueue(boothId);

      final isImmediate = result.mode == 'IN_SERVICE';

      // ✅ EnqueueResult.entry에서 MyQueueStatus 생성하여 상태 저장
      // 백엔드 me-status API는 WAITING만 반환하므로, IN_SERVICE도 직접 처리!
      final myStatus = MyQueueStatus(
        boothId: boothId,
        visitorId: result.entry.visitorId ?? '',
        ticketNo: result.entry.ticketNo,
        state: isImmediate ? 'IN_SERVICE' : 'WAITING',
        teamsAhead: isImmediate ? 0 : (result.remainingSeats > 0 ? 0 : 1),
        position: isImmediate ? 1 : (result.remainingSeats > 0 ? 1 : 2),
      );

      final updatedStatuses = {...state.myQueueStatuses};
      updatedStatuses[boothId] = myStatus;

      state = state.copyWith(
        isLoading: false,
        myQueueStatuses: updatedStatuses,
      );

      // 🎯 WAITING일 때만 추가로 me-status API 호출하여 정확한 position 조회
      if (!isImmediate) {
        try {
          final accurateStatus = await repository.getMyStatus(boothId);
          final refreshedStatuses = {...state.myQueueStatuses};
          refreshedStatuses[boothId] = accurateStatus;
          state = state.copyWith(myQueueStatuses: refreshedStatuses);
        } catch (e) {
          // me-status 실패해도 이미 기본값 저장됨 → 무시
          // ignore: avoid_print
          print('ℹ️ [QueueController] me-status 조회 실패, 기본값 사용: $e');
        }
      }

      return isImmediate;
    } catch (e) {
      // 🚨 409 에러: "이미 대기 또는 이용 중"
      final errorMessage = e.toString();
      final userFriendlyMessage = errorMessage.contains('409')
          ? '이미 이 부스에 줄서기 중이에요! 🎫'
          : errorMessage;

      state = state.copyWith(isLoading: false, error: userFriendlyMessage);
      return false;
    }
  }

  /// 대기 취소
  Future<void> cancelQueue(String boothId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.cancel(boothId);

      // ✅ 타입 안전하게 Map 복사 후 제거
      final updatedStatuses = {...state.myQueueStatuses};
      updatedStatuses.remove(boothId);

      state = state.copyWith(
        isLoading: false,
        myQueueStatuses: updatedStatuses,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 내 대기 상태 조회
  Future<void> fetchMyStatus(String boothId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final myStatus = await repository.getMyStatus(boothId);

      // ✅ 타입 안전하게 Map 복사 (Map<String, MyQueueStatus>)
      final updatedStatuses = {...state.myQueueStatuses};
      updatedStatuses[boothId] = myStatus;

      state = state.copyWith(myQueueStatuses: updatedStatuses);
    } catch (e) {
      // 대기 정보 없음 → 에러 무시 (정상 케이스)
    }
  }

  /// 모든 대기 중인 부스의 상태 새로고침
  Future<void> refreshMyStatuses() async {
    final repository = ref.read(queueRepositoryProvider);
    // ✅ 타입 안전한 Map 선언 (Map<String, MyQueueStatus>)
    final updatedStatuses = <String, MyQueueStatus>{};

    for (final boothId in state.myQueueStatuses.keys) {
      try {
        final myStatus = await repository.getMyStatus(boothId);
        updatedStatuses[boothId] = myStatus;
      } catch (e) {
        // 대기 종료됨 → 목록에서 제거
      }
    }

    state = state.copyWith(myQueueStatuses: updatedStatuses);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎛️ 부스 관리 (관리자용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 생성
  Future<bool> createBooth({
    required String masterId,
    required String title,
    int? seatCount,
    int? avgWaitMinutes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final newBooth = await repository.createBooth(
        masterId: masterId,
        title: title,
        seatCount: seatCount,
        avgWaitMinutes: avgWaitMinutes,
      );

      state = state.copyWith(
        isLoading: false,
        booths: [...state.booths, newBooth],
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// 부스 상태 변경
  Future<bool> updateBoothStatus(String boothId, String status) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final updatedBooth = await repository.updateBoothStatus(boothId, status);

      final updatedBooths = state.booths.map((b) {
        return b.id == boothId ? updatedBooth : b;
      }).toList();

      state = state.copyWith(booths: updatedBooths);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// 대기 목록 조회 (관리자)
  Future<void> fetchQueueList(String boothId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final entries = await repository.getQueueList(boothId);

      state = state.copyWith(
        isLoading: false,
        queueEntries: entries,
        selectedBoothId: boothId,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 다음 팀 입장 (관리자)
  Future<bool> rotateQueue(String boothId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.rotateQueue(boothId);

      // 대기 목록 새로고침
      await fetchQueueList(boothId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 👨‍💼 부스 관리자 관리 (Admin)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 관리자 목록 조회
  Future<List<BoothManager>> fetchBoothManagers(String boothId) async {
    debugPrint('👨‍💼 [fetchBoothManagers] 호출됨: boothId=$boothId');
    try {
      final repository = ref.read(queueRepositoryProvider);
      final managers = await repository.getBoothManagers(boothId);
      debugPrint('👨‍💼 [fetchBoothManagers] 받은 관리자 목록: ${managers.length}명');
      for (final m in managers) {
        debugPrint(
          '  - id=${m.id}, userId=${m.userId}, createdAt=${m.createdAt}',
        );
      }
      return managers;
    } catch (e, stackTrace) {
      debugPrint('🚨 [fetchBoothManagers] 에러 발생: $e');
      debugPrint('🚨 [fetchBoothManagers] 스택트레이스: $stackTrace');
      state = state.copyWith(error: e.toString());
      return [];
    }
  }

  /// 부스 관리자 추가
  ///
  /// 1. catch_booth_managers 테이블에 추가
  /// 2. 유저 role을 booth_manager로 변경
  Future<bool> addBoothManager(String boothId, String userId) async {
    bool managerAdded = false;

    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.addBoothManager(boothId, userId);
      managerAdded = true;
    } catch (e) {
      // 🔍 파싱 에러면 성공으로 처리 (백엔드 버그 대응)
      final errorStr = e.toString();
      if (errorStr.contains('type') && errorStr.contains('not a subtype')) {
        debugPrint('⚠️ [addBoothManager] 파싱 에러지만 추가는 성공한 것으로 처리: $e');
        managerAdded = true;
      } else {
        state = state.copyWith(error: errorStr);
        return false;
      }
    }

    // 부스 관리자 추가 성공 시 role 변경
    if (managerAdded) {
      debugPrint('🔄 [addBoothManager] role 변경 시도: userId=$userId');
      try {
        final adminApi = ref.read(adminApiProvider);
        debugPrint('🔄 [addBoothManager] PATCH /core/admin/users/$userId/role 호출...');
        await adminApi.changeUserRole(
          userId,
          const ChangeRoleRequest(role: 'booth_manager'),
        );
        debugPrint('✅ [addBoothManager] role을 booth_manager로 변경 완료: $userId');
      } catch (e, stackTrace) {
        // role 변경 실패해도 부스 관리자 추가는 유지 (로그만 남김)
        debugPrint('⚠️ [addBoothManager] role 변경 실패: $e');
        debugPrint('⚠️ [addBoothManager] 스택트레이스: $stackTrace');
      }
    }

    return managerAdded;
  }

  /// 부스 관리자 삭제
  ///
  /// 1. catch_booth_managers 테이블에서 삭제
  /// 2. 유저 role을 student로 변경
  Future<bool> removeBoothManager(String boothId, String userId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.removeBoothManager(boothId, userId);

      // role을 student로 변경
      try {
        final adminApi = ref.read(adminApiProvider);
        await adminApi.changeUserRole(
          userId,
          const ChangeRoleRequest(role: 'student'),
        );
        debugPrint('✅ [removeBoothManager] role을 student로 변경 완료: $userId');
      } catch (e) {
        // role 변경 실패해도 삭제는 유지 (로그만 남김)
        debugPrint('⚠️ [removeBoothManager] role 변경 실패 (무시): $e');
      }

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏷️ 부스 타입 관리 (Admin)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 타입 생성
  ///
  /// ✅ 실패 시 error를 전역 state에 저장하지 않음 (UI에서 스낵바로 처리)
  Future<bool> createBoothMaster(String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final newMaster = await repository.createBoothMaster(name);

      state = state.copyWith(
        isLoading: false,
        boothMasters: [...state.boothMasters, newMaster],
      );
      return true;
    } catch (e) {
      // 🚨 error 저장 안 함! (스낵바로 알림, 전역 에러 오염 방지)
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// 부스 타입 수정
  ///
  /// ✅ 실패 시 error를 전역 state에 저장하지 않음 (UI에서 스낵바로 처리)
  Future<bool> updateBoothMaster(String id, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final updatedMaster = await repository.updateBoothMaster(id, name);

      final updatedList = state.boothMasters.map((m) {
        return m.id == id ? updatedMaster : m;
      }).toList();

      state = state.copyWith(isLoading: false, boothMasters: updatedList);
      return true;
    } catch (e) {
      // 🚨 error 저장 안 함! (스낵바로 알림, 전역 에러 오염 방지)
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  /// 부스 타입 삭제
  ///
  /// ✅ 실패 시 error를 전역 state에 저장하지 않음 (UI에서 스낵바로 처리)
  /// 삭제 실패 원인: FK 제약조건 (이 타입을 사용하는 부스 존재)
  Future<bool> deleteBoothMaster(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.deleteBoothMaster(id);

      final updatedList = state.boothMasters.where((m) => m.id != id).toList();

      state = state.copyWith(isLoading: false, boothMasters: updatedList);
      return true;
    } catch (e) {
      // 🚨 error 저장 안 함! (스낵바로 알림, 전역 에러 오염 방지)
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
