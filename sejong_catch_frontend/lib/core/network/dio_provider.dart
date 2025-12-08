import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/api_config.dart';
import '../services/token_storage_service.dart';
import '../services/token_storage_adapter.dart';
import 'auth_interceptor.dart';

part 'dio_provider.g.dart';

/// Dio 인스턴스 Provider
///
/// **DRY 원칙 적용**:
/// TokenStorageService → TokenStorageAdapter → AuthInterceptor
/// 토큰 저장 로직은 TokenStorageService에만 존재!
@riverpod
Dio dio(Ref ref) {
  // TokenStorageService를 TokenRepository 인터페이스로 래핑
  final tokenService = ref.read(tokenStorageServiceProvider.notifier);
  final tokenRepository = TokenStorageAdapter(tokenService);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 🛡️ Auth Interceptor 추가 (Authorization 헤더 자동 추가 + 401 시 토큰 갱신)
  dio.interceptors.add(
    AuthInterceptor(dio, tokenRepository, ApiConfig.baseUrl),
  );

  // 로깅 인터셉터 (디버그 모드)
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => debugPrint('[DIO] $obj'),
      ),
    );
  }

  return dio;
}
