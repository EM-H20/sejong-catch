// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$envConfigHash() => r'c3a7b9f3108250797c91070caaeae0d083179533';

/// 환경 설정 (개발/스테이징/프로덕션)
///
/// 참조: AUTH_API_SPEC.md - 환경 설정 관리
///
/// Copied from [envConfig].
@ProviderFor(envConfig)
final envConfigProvider = AutoDisposeProvider<EnvConfig>.internal(
  envConfig,
  name: r'envConfigProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$envConfigHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnvConfigRef = AutoDisposeProviderRef<EnvConfig>;
String _$flutterSecureStorageHash() =>
    r'd4dea813f8be6fafe4b485fe85286590ba2ca2eb';

/// FlutterSecureStorage 인스턴스
///
/// Copied from [flutterSecureStorage].
@ProviderFor(flutterSecureStorage)
final flutterSecureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
      flutterSecureStorage,
      name: r'flutterSecureStorageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$flutterSecureStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FlutterSecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$tokenRepositoryHash() => r'1675bf891cd37a6cc294ad74411629e8cc653cb0';

/// 토큰 저장소 (FlutterSecureStorage 구현체)
///
/// 참조: AUTH_API_SPEC.md - TokenRepository
///
/// Copied from [tokenRepository].
@ProviderFor(tokenRepository)
final tokenRepositoryProvider = AutoDisposeProvider<TokenRepository>.internal(
  tokenRepository,
  name: r'tokenRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tokenRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TokenRepositoryRef = AutoDisposeProviderRef<TokenRepository>;
String _$dioHash() => r'b52ea523c3698c441a1b5c4f2d43f50949deac37';

/// Dio 인스턴스 (AuthInterceptor 포함)
///
/// 참조: AUTH_API_SPEC.md - Dio 인스턴스 설정
///
/// Copied from [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$authRemoteDataSourceHash() =>
    r'f8d1a1c21512c47b95fbc196cf882813c11b92d5';

/// 인증 API 원격 데이터 소스 (Retrofit)
///
/// 참조: AUTH_API_SPEC.md - Retrofit API 인터페이스
///
/// Copied from [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider =
    AutoDisposeProvider<AuthRemoteDataSource>.internal(
      authRemoteDataSource,
      name: r'authRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = AutoDisposeProviderRef<AuthRemoteDataSource>;
String _$authRepositoryHash() => r'eda82d3f5fc1003332755a35a57448215f531c60';

/// 인증 저장소 (Domain Layer 인터페이스)
///
/// 참조: AUTH_API_SPEC.md - Repository 패턴
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
