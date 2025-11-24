import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/api_config.dart';

part 'dio_provider.g.dart';

/// Dio 인스턴스 Provider
@riverpod
Dio dio(Ref ref) {
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

  // 로깅 인터셉터 (디버그 모드)
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      logPrint: (obj) => debugPrint('[DIO] $obj'),
    ),
  );

  // TODO: 토큰 인터셉터 추가 (access_token 자동 추가)
  // dio.interceptors.add(AuthInterceptor(ref));

  return dio;
}
