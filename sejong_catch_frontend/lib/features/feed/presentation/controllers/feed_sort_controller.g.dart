// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_sort_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedSortHash() => r'a033c6a40f070b0b8423a87e99b741712de4b0fe';

/// 📊 피드 정렬 상태 관리
///
/// **기본값**: 최신순 (FeedSortType.latest)
///
/// Copied from [FeedSort].
@ProviderFor(FeedSort)
final feedSortProvider =
    AutoDisposeNotifierProvider<FeedSort, FeedSortType>.internal(
      FeedSort.new,
      name: r'feedSortProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$feedSortHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FeedSort = AutoDisposeNotifier<FeedSortType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
