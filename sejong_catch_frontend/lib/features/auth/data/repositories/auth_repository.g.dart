// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authApiHash() => r'ac66c1c9810f43bc53db0d8c94d4bfaa679a0734';

/// AuthApi Provider
///
/// Copied from [authApi].
@ProviderFor(authApi)
final authApiProvider = AutoDisposeProvider<AuthApi>.internal(
  authApi,
  name: r'authApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthApiRef = AutoDisposeProviderRef<AuthApi>;
String _$authRepositoryHash() => r'91301b1242a3f3077a88e874d5d0fde584c13038';

/// 인증 Repository
///
/// Copied from [AuthRepository].
@ProviderFor(AuthRepository)
final authRepositoryProvider =
    AutoDisposeNotifierProvider<AuthRepository, void>.internal(
      AuthRepository.new,
      name: r'authRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthRepository = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
