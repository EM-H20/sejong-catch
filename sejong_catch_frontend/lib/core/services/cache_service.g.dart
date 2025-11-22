// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'7cd30c9640ca952d1bcf1772c709fc45dc47c8b3';

/// SharedPreferences Provider
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
      sharedPreferences,
      name: r'sharedPreferencesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sharedPreferencesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$cacheServiceHash() => r'e39ffd389e91d963bec80ec747edfb03fab35c83';

/// 캐시 서비스
///
/// **기능**:
/// - 크롤러 데이터를 SharedPreferences에 저장
/// - 10분 TTL (Time To Live) 적용
/// - TTL 만료 시 자동 무효화
///
/// Copied from [CacheService].
@ProviderFor(CacheService)
final cacheServiceProvider =
    AutoDisposeNotifierProvider<CacheService, void>.internal(
      CacheService.new,
      name: r'cacheServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cacheServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CacheService = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
