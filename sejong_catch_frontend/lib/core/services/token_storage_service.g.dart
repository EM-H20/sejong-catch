// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'273dc403a965c1f24962aaf4d40776611a26f8b8';

/// FlutterSecureStorage Provider
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
    r'2da5309e06e83de0044696f2a8b47688656b709e';

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
