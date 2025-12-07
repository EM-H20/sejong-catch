import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_provider.dart';
import '../datasources/queue_api.dart';
import '../models/request/booth_master_request.dart';
import '../models/request/booth_request.dart';
import '../models/request/queue_request.dart';
import '../models/response/booth.dart';
import '../models/response/booth_manager.dart';
import '../models/response/booth_master.dart';
import '../models/response/enqueue_result.dart';
import '../models/response/my_queue_status.dart';
import '../models/response/queue_entry.dart';

part 'queue_repository.g.dart';

/// QueueApi Provider
@riverpod
QueueApi queueApi(Ref ref) {
  final dio = ref.read(dioProvider);
  return QueueApi(dio);
}

/// 큐 Repository Provider
@riverpod
QueueRepository queueRepository(Ref ref) {
  return QueueRepository(ref);
}

/// 큐 Repository
///
/// Mock/Real 모드에 따라 더미 데이터 또는 실제 API를 호출합니다.
class QueueRepository {
  final Ref ref;

  QueueRepository(this.ref);

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏷️ 부스 타입 (Booth Master) 조회
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 타입 목록 조회
  Future<List<BoothMaster>> getBoothMasters() async {
    if (EnvConfig.useMockAuth) {
      return _mockGetBoothMasters();
    } else {
      return _realGetBoothMasters();
    }
  }

  /// 부스 타입 생성 🔒 (admin only)
  Future<BoothMaster> createBoothMaster(String name) async {
    if (EnvConfig.useMockAuth) {
      return _mockCreateBoothMaster(name);
    } else {
      return _realCreateBoothMaster(name);
    }
  }

  /// 부스 타입 수정 🔒 (admin only)
  Future<BoothMaster> updateBoothMaster(String id, String name) async {
    if (EnvConfig.useMockAuth) {
      return _mockUpdateBoothMaster(id, name);
    } else {
      return _realUpdateBoothMaster(id, name);
    }
  }

  /// 부스 타입 삭제 🔒 (admin only)
  Future<void> deleteBoothMaster(String id) async {
    if (EnvConfig.useMockAuth) {
      return _mockDeleteBoothMaster(id);
    } else {
      return _realDeleteBoothMaster(id);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏪 부스 조회
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 목록 조회
  Future<List<Booth>> getBooths({String? status}) async {
    if (EnvConfig.useMockAuth) {
      return _mockGetBooths(status: status);
    } else {
      return _realGetBooths(status: status);
    }
  }

  /// 부스 상세 조회
  Future<Booth> getBooth(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockGetBooth(boothId);
    } else {
      return _realGetBooth(boothId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎫 대기열 (학생용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 대기열 등록
  Future<EnqueueResult> enqueue(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockEnqueue(boothId);
    } else {
      return _realEnqueue(boothId);
    }
  }

  /// 대기 취소
  Future<void> cancel(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockCancel(boothId);
    } else {
      return _realCancel(boothId);
    }
  }

  /// 내 대기 순번 조회
  Future<MyQueueStatus> getMyStatus(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockGetMyStatus(boothId);
    } else {
      return _realGetMyStatus(boothId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎛️ 부스 관리 (관리자용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 생성
  Future<Booth> createBooth({
    required String masterId,
    required String title,
    int? seatCount,
    int? avgWaitMinutes,
  }) async {
    if (EnvConfig.useMockAuth) {
      return _mockCreateBooth(
        masterId: masterId,
        title: title,
        seatCount: seatCount,
        avgWaitMinutes: avgWaitMinutes,
      );
    } else {
      return _realCreateBooth(
        masterId: masterId,
        title: title,
        seatCount: seatCount,
        avgWaitMinutes: avgWaitMinutes,
      );
    }
  }

  /// 부스 상태 변경
  Future<Booth> updateBoothStatus(String boothId, String status) async {
    if (EnvConfig.useMockAuth) {
      return _mockUpdateBoothStatus(boothId, status);
    } else {
      return _realUpdateBoothStatus(boothId, status);
    }
  }

  /// 대기 목록 조회 (관리자)
  Future<List<QueueEntry>> getQueueList(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockGetQueueList(boothId);
    } else {
      return _realGetQueueList(boothId);
    }
  }

  /// 다음 팀 입장 (관리자)
  Future<void> rotateQueue(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockRotateQueue(boothId);
    } else {
      return _realRotateQueue(boothId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 👨‍💼 부스 관리자 관리 (Admin)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 관리자 목록 조회
  Future<List<BoothManager>> getBoothManagers(String boothId) async {
    if (EnvConfig.useMockAuth) {
      return _mockGetBoothManagers(boothId);
    } else {
      return _realGetBoothManagers(boothId);
    }
  }

  /// 부스 관리자 추가
  Future<BoothManager> addBoothManager(String boothId, String userId) async {
    if (EnvConfig.useMockAuth) {
      return _mockAddBoothManager(boothId, userId);
    } else {
      return _realAddBoothManager(boothId, userId);
    }
  }

  /// 부스 관리자 삭제
  Future<void> removeBoothManager(String boothId, String userId) async {
    if (EnvConfig.useMockAuth) {
      return _mockRemoveBoothManager(boothId, userId);
    } else {
      return _realRemoveBoothManager(boothId, userId);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🧪 Mock 구현 (개발용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Mock 부스 타입 데이터
  /// ID는 UUID 형식 (Real API와 동일하게 백엔드에서 생성되는 형태로 시뮬레이션)
  static final List<BoothMaster> _mockBoothMasters = [
    BoothMaster(
      id: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
      name: '음식',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    BoothMaster(
      id: 'b2c3d4e5-f6a7-8901-bcde-f12345678901',
      name: '게임',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    BoothMaster(
      id: 'c3d4e5f6-a7b8-9012-cdef-123456789012',
      name: '포토존',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  Future<List<BoothMaster>> _mockGetBoothMasters() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockBoothMasters);
  }

  Future<BoothMaster> _mockCreateBoothMaster(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // 이름 중복 체크
    if (_mockBoothMasters.any((m) => m.name == name)) {
      throw Exception('이미 존재하는 부스 타입 이름입니다');
    }

    // UUID 형식 ID 생성 (Real API처럼 백엔드에서 생성되는 형태 시뮬레이션)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uuid =
        '${timestamp.toRadixString(16).padLeft(8, '0')}-mock-${timestamp % 10000}-uuid-${name.hashCode.abs().toRadixString(16).padLeft(12, '0')}';

    final newMaster = BoothMaster(
      id: uuid,
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockBoothMasters.add(newMaster);
    return newMaster;
  }

  Future<BoothMaster> _mockUpdateBoothMaster(String id, String name) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockBoothMasters.indexWhere((m) => m.id == id);
    if (index == -1) throw Exception('부스 타입을 찾을 수 없습니다');

    // 다른 부스 타입과 이름 중복 체크
    if (_mockBoothMasters.any((m) => m.id != id && m.name == name)) {
      throw Exception('이미 존재하는 부스 타입 이름입니다');
    }

    final updated = BoothMaster(
      id: _mockBoothMasters[index].id,
      name: name,
      createdAt: _mockBoothMasters[index].createdAt,
      updatedAt: DateTime.now(),
    );

    _mockBoothMasters[index] = updated;
    return updated;
  }

  Future<void> _mockDeleteBoothMaster(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // 존재 여부 확인
    final exists = _mockBoothMasters.any((m) => m.id == id);
    if (!exists) throw Exception('부스 타입을 찾을 수 없습니다');

    // 해당 타입을 사용하는 부스가 있는지 확인
    if (_mockBooths.any((b) => b.masterId == id)) {
      throw Exception('이 타입을 사용하는 부스가 있어서 삭제할 수 없습니다');
    }

    _mockBoothMasters.removeWhere((m) => m.id == id);
  }

  /// Mock 부스 데이터
  /// masterId는 위의 _mockBoothMasters와 연결됨
  static final List<Booth> _mockBooths = [
    Booth(
      id: 'd4e5f6a7-b8c9-0123-def0-123456789abc',
      masterId: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', // 음식
      title: '🍗 치킨부스',
      seatCount: 4,
      avgWaitMinutes: 15,
      status: 'OPERATING',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Booth(
      id: 'e5f6a7b8-c9d0-1234-ef01-23456789abcd',
      masterId: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890', // 음식
      title: '🍺 주점',
      seatCount: 6,
      avgWaitMinutes: 10,
      status: 'OPERATING',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Booth(
      id: 'f6a7b8c9-d0e1-2345-0123-456789abcdef',
      masterId: 'b2c3d4e5-f6a7-8901-bcde-f12345678901', // 게임
      title: '🎮 게임존',
      seatCount: 2,
      avgWaitMinutes: 20,
      status: 'PREPARING',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Booth(
      id: 'a7b8c9d0-e1f2-3456-1234-56789abcdef0',
      masterId: 'b2c3d4e5-f6a7-8901-bcde-f12345678901', // 게임
      title: '📸 포토존',
      seatCount: 1,
      avgWaitMinutes: 5,
      status: 'ENDED',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  /// Mock 대기열 데이터
  static final List<QueueEntry> _mockQueueEntries = [];
  static int _mockTicketCounter = 0;

  Future<List<Booth>> _mockGetBooths({String? status}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (status == null) {
      return List.from(_mockBooths);
    }
    return _mockBooths.where((b) => b.status == status).toList();
  }

  Future<Booth> _mockGetBooth(String boothId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBooths.firstWhere(
      (b) => b.id == boothId,
      orElse: () => throw Exception('부스를 찾을 수 없습니다'),
    );
  }

  Future<EnqueueResult> _mockEnqueue(String boothId) async {
    await Future.delayed(const Duration(seconds: 1));

    final booth = _mockBooths.firstWhere(
      (b) => b.id == boothId,
      orElse: () => throw Exception('부스를 찾을 수 없습니다'),
    );

    _mockTicketCounter++;
    final entry = QueueEntry(
      id: 'entry-${DateTime.now().millisecondsSinceEpoch}',
      boothId: boothId,
      visitorId: 'mock-user-id',
      ticketNo: _mockTicketCounter,
      state: 'WAITING',
      joinedAt: DateTime.now(),
    );

    _mockQueueEntries.add(entry);

    final waitingCount = _mockQueueEntries
        .where((e) => e.boothId == boothId)
        .length;
    final remainingSeats = booth.seatCount - waitingCount;

    return EnqueueResult(
      mode: remainingSeats > 0 ? 'IN_SERVICE' : 'WAITING',
      remainingSeats: remainingSeats > 0 ? remainingSeats : 0,
      entry: entry,
    );
  }

  Future<void> _mockCancel(String boothId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockQueueEntries.removeWhere(
      (e) => e.boothId == boothId && e.visitorId == 'mock-user-id',
    );
  }

  Future<MyQueueStatus> _mockGetMyStatus(String boothId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final myEntry = _mockQueueEntries.firstWhere(
      (e) => e.boothId == boothId && e.visitorId == 'mock-user-id',
      orElse: () => throw Exception('대기 정보가 없습니다'),
    );

    final waitingEntries = _mockQueueEntries
        .where((e) => e.boothId == boothId && e.state == 'WAITING')
        .toList();

    final position = waitingEntries.indexWhere((e) => e.id == myEntry.id) + 1;

    return MyQueueStatus(
      boothId: boothId,
      visitorId: myEntry.visitorId ?? 'unknown',
      ticketNo: myEntry.ticketNo,
      state: myEntry.state,
      teamsAhead: position - 1,
      position: position,
    );
  }

  Future<Booth> _mockCreateBooth({
    required String masterId,
    required String title,
    int? seatCount,
    int? avgWaitMinutes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final newBooth = Booth(
      id: 'booth-${DateTime.now().millisecondsSinceEpoch}',
      masterId: masterId,
      title: title,
      seatCount: seatCount ?? 4,
      avgWaitMinutes: avgWaitMinutes ?? 10,
      status: 'PREPARING',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _mockBooths.add(newBooth);
    return newBooth;
  }

  Future<Booth> _mockUpdateBoothStatus(String boothId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockBooths.indexWhere((b) => b.id == boothId);
    if (index == -1) throw Exception('부스를 찾을 수 없습니다');

    final updated = Booth(
      id: _mockBooths[index].id,
      masterId: _mockBooths[index].masterId,
      title: _mockBooths[index].title,
      seatCount: _mockBooths[index].seatCount,
      avgWaitMinutes: _mockBooths[index].avgWaitMinutes,
      status: status,
      createdAt: _mockBooths[index].createdAt,
      updatedAt: DateTime.now(),
    );

    _mockBooths[index] = updated;
    return updated;
  }

  Future<List<QueueEntry>> _mockGetQueueList(String boothId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // WAITING, IN_SERVICE 상태만 반환 (COMPLETED, CANCELED 제외)
    return _mockQueueEntries
        .where(
          (e) =>
              e.boothId == boothId &&
              (e.state == 'WAITING' || e.state == 'IN_SERVICE'),
        )
        .toList();
  }

  Future<void> _mockRotateQueue(String boothId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final waitingEntries = _mockQueueEntries
        .where((e) => e.boothId == boothId && e.state == 'WAITING')
        .toList();

    if (waitingEntries.isNotEmpty) {
      final index = _mockQueueEntries.indexOf(waitingEntries.first);
      _mockQueueEntries[index] = QueueEntry(
        id: waitingEntries.first.id,
        boothId: waitingEntries.first.boothId,
        visitorId: waitingEntries.first.visitorId,
        ticketNo: waitingEntries.first.ticketNo,
        state: 'COMPLETED',
        joinedAt: waitingEntries.first.joinedAt,
      );
    }
  }

  /// Mock 부스 관리자 데이터
  /// boothId는 위의 _mockBooths와 연결됨
  static final List<BoothManager> _mockBoothManagers = [
    BoothManager(
      id: 'b8c9d0e1-f2a3-4567-2345-6789abcdef01',
      boothId: 'd4e5f6a7-b8c9-0123-def0-123456789abc', // 치킨부스
      userId: 'c9d0e1f2-a3b4-5678-3456-789abcdef012',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userName: '김관리',
      userEmail: '20211234@sju.ac.kr',
    ),
    BoothManager(
      id: 'd0e1f2a3-b4c5-6789-4567-89abcdef0123',
      boothId: 'd4e5f6a7-b8c9-0123-def0-123456789abc', // 치킨부스
      userId: 'e1f2a3b4-c5d6-7890-5678-9abcdef01234',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userName: '이운영',
      userEmail: '20215678@sju.ac.kr',
    ),
  ];

  Future<List<BoothManager>> _mockGetBoothManagers(String boothId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBoothManagers.where((m) => m.boothId == boothId).toList();
  }

  Future<BoothManager> _mockAddBoothManager(
    String boothId,
    String userId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newManager = BoothManager(
      id: 'manager-${DateTime.now().millisecondsSinceEpoch}',
      boothId: boothId,
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userName: '새관리자',
      userEmail: '$userId@sju.ac.kr',
    );

    _mockBoothManagers.add(newManager);
    return newManager;
  }

  Future<void> _mockRemoveBoothManager(String boothId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockBoothManagers.removeWhere(
      (m) => m.boothId == boothId && m.userId == userId,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🌐 Real API 구현 (프로덕션용)
  // ═══════════════════════════════════════════════════════════════════════════

  Future<List<BoothMaster>> _realGetBoothMasters() async {
    final api = ref.read(queueApiProvider);
    final response = await api.getBoothMasters();
    return response.data;
  }

  Future<BoothMaster> _realCreateBoothMaster(String name) async {
    final api = ref.read(queueApiProvider);
    final response = await api.createBoothMaster(
      CreateBoothMasterRequest(name: name),
    );
    return response.data;
  }

  Future<BoothMaster> _realUpdateBoothMaster(String id, String name) async {
    final api = ref.read(queueApiProvider);
    final response = await api.updateBoothMaster(
      id,
      UpdateBoothMasterRequest(name: name),
    );
    return response.data;
  }

  Future<void> _realDeleteBoothMaster(String id) async {
    final api = ref.read(queueApiProvider);
    await api.deleteBoothMaster(id);
  }

  Future<List<Booth>> _realGetBooths({String? status}) async {
    final api = ref.read(queueApiProvider);

    // 특정 상태 지정 시 해당 상태만 조회
    if (status != null) {
      final response = await api.getBooths(status: status);
      return response.data;
    }

    // status가 null이면 모든 상태 병렬 조회 후 합침
    // (서버 기본값이 OPERATING이라서 직접 처리 필요)
    final results = await Future.wait([
      api.getBooths(status: 'PREPARING'),
      api.getBooths(status: 'OPERATING'),
      api.getBooths(status: 'ENDED'),
    ]);

    return [...results[0].data, ...results[1].data, ...results[2].data];
  }

  Future<Booth> _realGetBooth(String boothId) async {
    final api = ref.read(queueApiProvider);
    final response = await api.getBooth(boothId);
    return response.data;
  }

  Future<EnqueueResult> _realEnqueue(String boothId) async {
    final api = ref.read(queueApiProvider);
    final response = await api.enqueue(BoothIdRequest(boothId: boothId));
    return response.data;
  }

  Future<void> _realCancel(String boothId) async {
    final api = ref.read(queueApiProvider);
    await api.cancel(BoothIdRequest(boothId: boothId));
  }

  Future<MyQueueStatus> _realGetMyStatus(String boothId) async {
    final api = ref.read(queueApiProvider);
    final response = await api.getMyStatus(BoothIdRequest(boothId: boothId));
    return response.data;
  }

  Future<Booth> _realCreateBooth({
    required String masterId,
    required String title,
    int? seatCount,
    int? avgWaitMinutes,
  }) async {
    final api = ref.read(queueApiProvider);
    final response = await api.createBooth(
      CreateBoothRequest(
        masterId: masterId,
        title: title,
        seatCount: seatCount,
        avgWaitMinutes: avgWaitMinutes,
      ),
    );
    return response.data;
  }

  Future<Booth> _realUpdateBoothStatus(String boothId, String status) async {
    final api = ref.read(queueApiProvider);
    final response = await api.updateBoothStatus(
      boothId,
      UpdateBoothStatusRequest(status: status),
    );
    return response.data;
  }

  Future<List<QueueEntry>> _realGetQueueList(String boothId) async {
    final api = ref.read(queueApiProvider);
    final response = await api.getQueueList(BoothIdRequest(boothId: boothId));
    return response.data;
  }

  Future<void> _realRotateQueue(String boothId) async {
    final api = ref.read(queueApiProvider);
    await api.rotateQueue(BoothIdRequest(boothId: boothId));
  }

  Future<List<BoothManager>> _realGetBoothManagers(String boothId) async {
    final api = ref.read(queueApiProvider);
    final response = await api.getBoothManagers(boothId);
    return response.data;
  }

  Future<BoothManager> _realAddBoothManager(
    String boothId,
    String userId,
  ) async {
    final api = ref.read(queueApiProvider);
    return await api.addBoothManager(
      boothId,
      AddBoothManagerRequest(userId: userId),
    );
  }

  Future<void> _realRemoveBoothManager(String boothId, String userId) async {
    final api = ref.read(queueApiProvider);
    await api.removeBoothManager(boothId, userId);
  }
}
