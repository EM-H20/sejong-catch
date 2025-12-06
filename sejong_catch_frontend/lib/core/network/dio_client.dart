/// 🌐 Dio 클라이언트 설정
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Dio 인스턴스 설정
/// Auth Interceptor + 로깅 설정
///
/// CLAUDE.md 원칙:
/// ✅ 중앙 집중식 Dio 설정
/// ✅ 디버그 모드에서만 로깅
/// ✅ 타임아웃 설정

library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../repositories/token_repository.dart';
import 'auth_interceptor.dart';

/// Dio 클라이언트 생성
///
/// [tokenRepository]: 토큰 저장소
/// [baseUrl]: API 서버 주소
/// Returns: 설정된 Dio 인스턴스
Dio createDio(TokenRepository tokenRepository, String baseUrl) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Auth Interceptor 추가
  dio.interceptors.add(AuthInterceptor(dio, tokenRepository, baseUrl));

  // 디버그 모드에서만 로깅
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (log) => debugPrint(log.toString()),
      ),
    );
  }

  return dio;
}
