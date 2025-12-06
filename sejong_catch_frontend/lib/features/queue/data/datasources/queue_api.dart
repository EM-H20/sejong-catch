import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/request/booth_master_request.dart';
import '../models/request/booth_request.dart';
import '../models/request/queue_request.dart';
import '../models/response/booth.dart';
import '../models/response/booth_manager.dart';
import '../models/response/booth_master.dart';
import '../models/response/enqueue_result.dart';
import '../models/response/my_queue_status.dart';
import '../models/response/queue_entry.dart';

part 'queue_api.g.dart';

/// 큐/부스 API 인터페이스 (Retrofit)
///
/// 백엔드 API 명세서 기반:
/// - 부스 CRUD: /catch/booths/*
/// - 대기열 (학생): /catch/queues/*
/// - 대기열 (관리자): /catch/admin/queues/*
@RestApi()
abstract class QueueApi {
  factory QueueApi(Dio dio, {String baseUrl}) = _QueueApi;

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏷️ 부스 타입 (Booth Master) API
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 타입 목록 조회 🔒
  @GET('/catch/booth-masters')
  Future<BoothMasterListResponse> getBoothMasters();

  /// 부스 타입 생성 🔒 (admin only)
  @POST('/catch/booth-masters')
  Future<BoothMasterResponse> createBoothMaster(
    @Body() CreateBoothMasterRequest request,
  );

  /// 부스 타입 수정 🔒 (admin only)
  @PATCH('/catch/booth-masters/{id}')
  Future<BoothMasterResponse> updateBoothMaster(
    @Path('id') String id,
    @Body() UpdateBoothMasterRequest request,
  );

  /// 부스 타입 삭제 🔒 (admin only)
  @DELETE('/catch/booth-masters/{id}')
  Future<void> deleteBoothMaster(@Path('id') String id);

  // ═══════════════════════════════════════════════════════════════════════════
  // 🏪 부스 API
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 목록 조회 (기본: OPERATING)
  @GET('/catch/booths')
  Future<BoothListResponse> getBooths({
    @Query('status') String? status, // PREPARING | OPERATING | ENDED
  });

  /// 부스 상세 조회
  @GET('/catch/booths/{boothId}')
  Future<BoothResponse> getBooth(@Path('boothId') String boothId);

  /// 부스 생성 🔒
  @POST('/catch/booths')
  Future<BoothResponse> createBooth(@Body() CreateBoothRequest request);

  /// 부스 수정 🔒
  @PATCH('/catch/booths/{boothId}')
  Future<BoothResponse> updateBooth(
    @Path('boothId') String boothId,
    @Body() UpdateBoothRequest request,
  );

  /// 부스 상태 변경 🔒
  @PATCH('/catch/booths/{boothId}/status')
  Future<BoothResponse> updateBoothStatus(
    @Path('boothId') String boothId,
    @Body() UpdateBoothStatusRequest request,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎫 대기열 API (학생용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 대기열 등록 🔒
  @POST('/catch/queues/enqueue')
  Future<EnqueueResultResponse> enqueue(@Body() BoothIdRequest request);

  /// 대기 취소 🔒
  @POST('/catch/queues/cancel')
  Future<void> cancel(@Body() BoothIdRequest request);

  /// 내 대기 순번 조회 🔒
  @POST('/catch/queues/me-status')
  Future<MyQueueStatusResponse> getMyStatus(@Body() BoothIdRequest request);

  // ═══════════════════════════════════════════════════════════════════════════
  // 🎛️ 대기열 API (관리자용)
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 대기 목록 조회 🔒
  @POST('/catch/admin/queues/list')
  Future<QueueListResponse> getQueueList(@Body() BoothIdRequest request);

  /// 이용 종료 + 다음 팀 입장 🔒
  @POST('/catch/admin/queues/rotate')
  Future<void> rotateQueue(@Body() BoothIdRequest request);

  // ═══════════════════════════════════════════════════════════════════════════
  // 👨‍💼 부스 관리자 API
  // ═══════════════════════════════════════════════════════════════════════════

  /// 부스 관리자 목록 조회 🔒
  @GET('/catch/booths/{boothId}/managers')
  Future<BoothManagerListResponse> getBoothManagers(
    @Path('boothId') String boothId,
  );

  /// 부스 관리자 추가 🔒 (admin only)
  @POST('/catch/booths/{boothId}/managers')
  Future<BoothManager> addBoothManager(
    @Path('boothId') String boothId,
    @Body() AddBoothManagerRequest request,
  );

  /// 부스 관리자 삭제 🔒 (admin only)
  @DELETE('/catch/booths/{boothId}/managers/{userId}')
  Future<void> removeBoothManager(
    @Path('boothId') String boothId,
    @Path('userId') String userId,
  );
}

// ═══════════════════════════════════════════════════════════════════════════
// 📦 API 응답 래퍼 (백엔드 { "data": ... } 구조)
// ═══════════════════════════════════════════════════════════════════════════

/// 부스 타입 목록 응답 래퍼
class BoothMasterListResponse {
  final List<BoothMaster> data;

  BoothMasterListResponse({required this.data});

  factory BoothMasterListResponse.fromJson(Map<String, dynamic> json) {
    return BoothMasterListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => BoothMaster.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 부스 타입 단일 응답 래퍼 (생성/수정용)
class BoothMasterResponse {
  final BoothMaster data;

  BoothMasterResponse({required this.data});

  factory BoothMasterResponse.fromJson(Map<String, dynamic> json) {
    return BoothMasterResponse(
      data: BoothMaster.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

/// 부스 목록 응답 래퍼
class BoothListResponse {
  final List<Booth> data;

  BoothListResponse({required this.data});

  factory BoothListResponse.fromJson(Map<String, dynamic> json) {
    return BoothListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Booth.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 부스 단일 응답 래퍼 (생성/수정/상세조회용)
class BoothResponse {
  final Booth data;

  BoothResponse({required this.data});

  factory BoothResponse.fromJson(Map<String, dynamic> json) {
    return BoothResponse(
      data: Booth.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

/// 대기열 등록 결과 응답 래퍼
class EnqueueResultResponse {
  final EnqueueResult data;

  EnqueueResultResponse({required this.data});

  factory EnqueueResultResponse.fromJson(Map<String, dynamic> json) {
    return EnqueueResultResponse(
      data: EnqueueResult.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

/// 내 대기 순번 응답 래퍼
class MyQueueStatusResponse {
  final MyQueueStatus data;

  MyQueueStatusResponse({required this.data});

  factory MyQueueStatusResponse.fromJson(Map<String, dynamic> json) {
    return MyQueueStatusResponse(
      data: MyQueueStatus.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

/// 대기 목록 응답 래퍼
class QueueListResponse {
  final List<QueueEntry> data;

  QueueListResponse({required this.data});

  factory QueueListResponse.fromJson(Map<String, dynamic> json) {
    return QueueListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => QueueEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 부스 관리자 목록 응답 래퍼
class BoothManagerListResponse {
  final List<BoothManager> data;

  BoothManagerListResponse({required this.data});

  factory BoothManagerListResponse.fromJson(Map<String, dynamic> json) {
    return BoothManagerListResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => BoothManager.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
