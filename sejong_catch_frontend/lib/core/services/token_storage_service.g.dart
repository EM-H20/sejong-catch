// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'77df30c7098a9f252222741225993ef719fafe36';

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
    r'd3b07dc9c777d0d41ddc79a62a68a0acb8d7c7e8';

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
