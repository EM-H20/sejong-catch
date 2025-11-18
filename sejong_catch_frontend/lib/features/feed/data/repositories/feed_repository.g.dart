// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedApiHash() => r'9fd1cb6c479feca2ac2456d5624e3a335bcf4039';

/// FeedApi Provider
///
/// Copied from [feedApi].
@ProviderFor(feedApi)
final feedApiProvider = AutoDisposeProvider<FeedApi>.internal(
  feedApi,
  name: r'feedApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedApiRef = AutoDisposeProviderRef<FeedApi>;
String _$feedRepositoryHash() => r'237707d5e8e5065ce039c34529d02002b0d4ef56';

/// 피드 Repository
///
/// **Mock/Real 자동 전환**:
/// - `USE_MOCK_AUTH=true` (기본값) → Mock 데이터 반환
/// - `USE_MOCK_AUTH=false` → 실제 백엔드 API 호출
///
/// Copied from [FeedRepository].
@ProviderFor(FeedRepository)
final feedRepositoryProvider =
    AutoDisposeNotifierProvider<FeedRepository, void>.internal(
      FeedRepository.new,
      name: r'feedRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FeedRepository = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
