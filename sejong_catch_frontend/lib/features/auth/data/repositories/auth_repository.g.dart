// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authApiHash() => r'1b5d5329ae170f8123b0f4a636ea2a0433ad7ecc';

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
String _$authRepositoryHash() => r'749fbe924642002790fc48e54a93cb8b38fce453';

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
