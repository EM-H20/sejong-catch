// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedApiHash() => r'7dd5c56677b491c3dcb926ba046ed32d4ef77ed8';

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
String _$feedRepositoryHash() => r'9fb45e5dbba5206883b621447ac90ee02fd390c6';

/// 피드 Repository
///
/// **2가지 모드 자동 전환**:
/// - **Mock 모드** (개발): `USE_MOCK_AUTH=true` → 하드코딩 더미 5개
/// - **Real 모드** (프로덕션): `USE_MOCK_AUTH=false` → /crawler/crawl-results (1,000개 + 10분 캐싱)
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
