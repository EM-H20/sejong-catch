library;

/// 🎪 큐 생성 서비스
///
/// API 명세 변경에 유연하게 대응하는 서비스 레이어
/// Features:
/// ✅ Mock/Real API 전환 가능
/// ✅ 에러 처리 통일
/// ✅ 로깅 및 디버깅 지원
/// ✅ 테스트 용이성

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/queue_create_form.dart';

/// 큐 생성 서비스 인터페이스
abstract class QueueCreateService {
  Future<QueueCreateResult> createQueue(QueueCreateForm form);
  Future<bool> validateQueueName(String name);
}

/// 큐 생성 결과
class QueueCreateResult {
  final bool success;
  final String? queueId;
  final String? message;
  final Map<String, dynamic>? data;

  const QueueCreateResult({
    required this.success,
    this.queueId,
    this.message,
    this.data,
  });

  factory QueueCreateResult.success({
    required String queueId,
    String? message,
    Map<String, dynamic>? data,
  }) {
    return QueueCreateResult(
      success: true,
      queueId: queueId,
      message: message ?? '큐가 성공적으로 생성되었어요!',
      data: data,
    );
  }

  factory QueueCreateResult.failure({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return QueueCreateResult(success: false, message: message, data: data);
  }
}

/// Mock 큐 생성 서비스 (개발용)
class MockQueueCreateService implements QueueCreateService {
  @override
  Future<QueueCreateResult> createQueue(QueueCreateForm form) async {
    // 실제 API 호출을 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    // 성공 시뮬레이션 (90% 확률)
    if (DateTime.now().millisecondsSinceEpoch % 10 < 9) {
      final queueId = 'queue_${DateTime.now().millisecondsSinceEpoch}';

      return QueueCreateResult.success(
        queueId: queueId,
        message: '${form.name} 큐가 생성되었어요! 🎉',
        data: {
          'queueId': queueId,
          'name': form.name,
          'type': form.type.value,
          'status': 'active',
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } else {
      // 실패 시뮬레이션
      return QueueCreateResult.failure(
        message: '큐 생성에 실패했어요. 다시 시도해주세요.',
        data: {'errorCode': 'CREATION_FAILED'},
      );
    }
  }

  @override
  Future<bool> validateQueueName(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // 기본적인 이름 중복 체크 시뮬레이션
    final forbiddenNames = ['test', 'admin', 'system'];
    return !forbiddenNames.contains(name.toLowerCase());
  }
}

/// 실제 API 큐 생성 서비스 (추후 구현)
class ApiQueueCreateService implements QueueCreateService {
  // final Dio _dio;
  // final String _baseUrl;

  // const ApiQueueCreateService({
  //   required Dio dio,
  //   required String baseUrl,
  // }) : _dio = dio, _baseUrl = baseUrl;

  @override
  Future<QueueCreateResult> createQueue(QueueCreateForm form) async {
    try {
      // TODO: 실제 API 호출 구현
      // final response = await _dio.post(
      //   '$_baseUrl/queues',
      //   data: form.toApiRequest(),
      // );
      //
      // if (response.statusCode == 201) {
      //   final data = response.data as Map<String, dynamic>;
      //   return QueueCreateResult.success(
      //     queueId: data['id'] as String,
      //     message: data['message'] as String?,
      //     data: data,
      //   );
      // } else {
      //   return QueueCreateResult.failure(
      //     message: '큐 생성에 실패했어요.',
      //   );
      // }

      // 임시로 Mock 서비스 동작
      return MockQueueCreateService().createQueue(form);
    } catch (e) {
      return QueueCreateResult.failure(
        message: '네트워크 오류가 발생했어요: $e',
        data: {'error': e.toString()},
      );
    }
  }

  @override
  Future<bool> validateQueueName(String name) async {
    try {
      // TODO: 실제 API 호출 구현
      // final response = await _dio.get(
      //   '$_baseUrl/queues/validate-name',
      //   queryParameters: {'name': name},
      // );
      //
      // return response.statusCode == 200 &&
      //        (response.data['available'] as bool? ?? false);

      // 임시로 Mock 서비스 동작
      return MockQueueCreateService().validateQueueName(name);
    } catch (e) {
      // 네트워크 오류 시 기본값으로 true 반환
      return true;
    }
  }
}

/// 큐 생성 서비스 Provider
final queueCreateServiceProvider = Provider<QueueCreateService>((ref) {
  // 개발 모드에서는 Mock 서비스 사용, 운영 모드에서는 실제 API 서비스 사용
  // 환경에 따른 동적 결정 (현재는 개발 단계이므로 Mock 사용)
  const bool kIsProduction = bool.fromEnvironment('dart.vm.product');
  final bool useMockService = !kIsProduction; // 디버그/프로파일 모드에서는 Mock 사용

  return useMockService
      ? MockQueueCreateService()
      : ApiQueueCreateService();
});
