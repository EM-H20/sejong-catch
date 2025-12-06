import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/api_config.dart';
import '../repositories/token_repository.dart';
import '../repositories/token_repository_impl.dart';
import 'auth_interceptor.dart';

part 'dio_provider.g.dart';

/// FlutterSecureStorage Provider
@riverpod
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
}

/// TokenRepository Provider
@riverpod
TokenRepository tokenRepository(Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenRepositoryImpl(storage);
}

/// Dio 인스턴스 Provider
@riverpod
Dio dio(Ref ref) {
  final tokenRepository = ref.watch(tokenRepositoryProvider);

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
