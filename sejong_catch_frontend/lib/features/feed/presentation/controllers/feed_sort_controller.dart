import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_sort_controller.g.dart';

/// 📊 피드 정렬 타입
enum FeedSortType {
  /// 최신순 (기본값)
  latest,

  /// 오래된순
  oldest,

  /// 조회수 많은순
  mostViewed,

  /// 조회수 적은순
  leastViewed,
}

/// 📊 피드 정렬 타입 확장
extension FeedSortTypeExtension on FeedSortType {
  /// 한글 라벨
  String get label {
    switch (this) {
      case FeedSortType.latest:
        return '최신순';
      case FeedSortType.oldest:
        return '오래된순';
      case FeedSortType.mostViewed:
        return '조회수 많은순';
      case FeedSortType.leastViewed:
        return '조회수 적은순';
    }
  }

  /// 설명 (서브텍스트)
  String get description {
    switch (this) {
      case FeedSortType.latest:
        return '최근 게시된 순서';
      case FeedSortType.oldest:
        return '오래된 게시글 먼저';
      case FeedSortType.mostViewed:
        return '인기 있는 게시글 먼저';
      case FeedSortType.leastViewed:
        return '조회수 적은 순서';
    }
  }
}

/// 📊 피드 정렬 상태 관리
///
/// **기본값**: 최신순 (FeedSortType.latest)
@riverpod
class FeedSort extends _$FeedSort {
  @override
  FeedSortType build() => FeedSortType.latest;

  /// 정렬 타입 변경
  void changeSortType(FeedSortType type) {
    state = type;
  }

  /// 기본값으로 초기화 (최신순)
  void reset() {
    state = FeedSortType.latest;
  }
}
