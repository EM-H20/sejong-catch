// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'c3d90388f6d1bb7c95a29ceeda2e56c57deb1ecb';

/// FlutterSecureStorage Provider
///
/// **보안 설정**:
/// - Android: EncryptedSharedPreferences 사용
/// - iOS: Keychain, first_unlock 접근성
///
/// Copied from [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider =
    AutoDisposeProvider<FlutterSecureStorage>.internal(
      secureStorage,
      name: r'secureStorageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$secureStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = AutoDisposeProviderRef<FlutterSecureStorage>;
String _$tokenStorageServiceHash() =>
    r'141e9be6ef2c8faadce032fd25bceff7dba19312';

/// 토큰 저장 서비스
///
/// Copied from [TokenStorageService].
@ProviderFor(TokenStorageService)
final tokenStorageServiceProvider =
    AutoDisposeNotifierProvider<TokenStorageService, void>.internal(
      TokenStorageService.new,
      name: r'tokenStorageServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$tokenStorageServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TokenStorageService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
