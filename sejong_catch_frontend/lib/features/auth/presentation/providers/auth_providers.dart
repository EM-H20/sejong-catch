/// 🔐 인증 관련 Provider 정의
///
/// 참조: claudedocs/AUTH_API_SPEC.md
/// 모든 Auth 관련 의존성 주입 (DI) 설정
///
/// CLAUDE.md 원칙:
/// ✅ @riverpod 어노테이션 사용
/// ✅ 의존성 자동 주입
/// ✅ 코드 생성으로 타입 안전성 보장

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/env_config.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/repositories/token_repository.dart';
import '../../../../core/repositories/token_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

// ═══════════════════════════════════════════════════
// 🌍 환경 설정 Provider
// ═══════════════════════════════════════════════════

/// 환경 설정 (개발/스테이징/프로덕션)
///
/// 참조: AUTH_API_SPEC.md - 환경 설정 관리
@riverpod
EnvConfig envConfig(EnvConfigRef ref) {
  // TODO: --dart-define으로 환경 지정 시 여기서 읽어오기
  // 현재는 개발 환경 고정
  return EnvConfig(Environment.development);
}

// ═══════════════════════════════════════════════════
// 🔐 보안 저장소 Provider
// ═══════════════════════════════════════════════════

/// FlutterSecureStorage 인스턴스
@riverpod
FlutterSecureStorage flutterSecureStorage(FlutterSecureStorageRef ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
}

/// 토큰 저장소 (FlutterSecureStorage 구현체)
///
/// 참조: AUTH_API_SPEC.md - TokenRepository
@riverpod
TokenRepository tokenRepository(TokenRepositoryRef ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return TokenRepositoryImpl(storage);
}

// ═══════════════════════════════════════════════════
// 🌐 네트워크 Provider
// ═══════════════════════════════════════════════════

/// Dio 인스턴스 (AuthInterceptor 포함)
///
/// 참조: AUTH_API_SPEC.md - Dio 인스턴스 설정
@riverpod
Dio dio(DioRef ref) {
  final envConfig = ref.watch(envConfigProvider);
  final tokenRepository = ref.watch(tokenRepositoryProvider);

  return createDio(tokenRepository, envConfig.baseUrl);
}

// ═══════════════════════════════════════════════════
// 📡 데이터 소스 Provider
// ═══════════════════════════════════════════════════

/// 인증 API 원격 데이터 소스 (Retrofit)
///
/// 참조: AUTH_API_SPEC.md - Retrofit API 인터페이스
@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  final dio = ref.watch(dioProvider);
  final envConfig = ref.watch(envConfigProvider);

  return AuthRemoteDataSource(dio, baseUrl: envConfig.baseUrl);
}

// ═══════════════════════════════════════════════════
// 🏪 Repository Provider
// ═══════════════════════════════════════════════════

/// 인증 저장소 (Domain Layer 인터페이스)
///
/// 참조: AUTH_API_SPEC.md - Repository 패턴
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final tokenRepository = ref.watch(tokenRepositoryProvider);

  return AuthRepositoryImpl(remoteDataSource, tokenRepository);
}
