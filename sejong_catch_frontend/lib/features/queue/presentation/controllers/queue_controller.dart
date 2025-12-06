import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/response/booth.dart';
import '../../data/models/response/booth_manager.dart';
import '../../data/models/response/booth_master.dart';
import '../models/queue_state.dart';
import '../../data/repositories/queue_repository.dart';

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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎯 UI 상태 관리
  // ═══════════════════════════════════════════════════════════════════════════

  /// 탭 변경
  void changeTab(int index) {
    state = state.copyWith(currentTabIndex: index);
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

      state = state.copyWith(
        isLoading: false,
        booths: booths,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎫 대기열 (학생용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 대기열 등록
  Future<bool> enqueue(String boothId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      final result = await repository.enqueue(boothId);

      // 내 대기 상태 업데이트
      final updatedStatuses = Map<String, dynamic>.from(state.myQueueStatuses);
      final myStatus = await repository.getMyStatus(boothId);
      updatedStatuses[boothId] = myStatus;

      state = state.copyWith(
        isLoading: false,
        myQueueStatuses: Map.from(updatedStatuses),
      );

      return result.mode == 'IN_SERVICE'; // 즉시 입장 여부 반환
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 대기 취소
  Future<void> cancelQueue(String boothId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.cancel(boothId);

      // 내 대기 상태에서 제거
      final updatedStatuses = Map<String, dynamic>.from(state.myQueueStatuses);
      updatedStatuses.remove(boothId);

      state = state.copyWith(
        isLoading: false,
        myQueueStatuses: Map.from(updatedStatuses),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 내 대기 상태 조회
  Future<void> fetchMyStatus(String boothId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      final myStatus = await repository.getMyStatus(boothId);

      final updatedStatuses = Map<String, dynamic>.from(state.myQueueStatuses);
      updatedStatuses[boothId] = myStatus;

      state = state.copyWith(myQueueStatuses: Map.from(updatedStatuses));
    } catch (e) {
      // 대기 정보 없음 → 에러 무시 (정상 케이스)
    }
  }

  /// 모든 대기 중인 부스의 상태 새로고침
  Future<void> refreshMyStatuses() async {
    final repository = ref.read(queueRepositoryProvider);
    final updatedStatuses = <String, dynamic>{};

    for (final boothId in state.myQueueStatuses.keys) {
      try {
        final myStatus = await repository.getMyStatus(boothId);
        updatedStatuses[boothId] = myStatus;
      } catch (e) {
        // 대기 종료됨 → 목록에서 제거
      }
    }

    state = state.copyWith(myQueueStatuses: Map.from(updatedStatuses));
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
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
    try {
      final repository = ref.read(queueRepositoryProvider);
      return await repository.getBoothManagers(boothId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }

  /// 부스 관리자 추가
  Future<BoothManager?> addBoothManager(String boothId, String userId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      return await repository.addBoothManager(boothId, userId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// 부스 관리자 삭제
  Future<bool> removeBoothManager(String boothId, String userId) async {
    try {
      final repository = ref.read(queueRepositoryProvider);
      await repository.removeBoothManager(boothId, userId);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}
