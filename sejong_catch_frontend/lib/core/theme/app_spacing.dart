import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱 전체에서 사용하는 간격(Spacing) 상수
///
/// 모든 패딩, 마진, 간격은 이 클래스를 통해 일관되게 관리합니다.
/// ScreenUtil을 사용하여 반응형 크기를 지원합니다.
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  // ==================== 기본 간격 단위 ====================
  /// 최소 간격: 4
  static double get xs => 4.w;

  /// 아주 작은 간격: 8
  static double get sm => 8.w;

  /// 작은 간격: 12
  static double get md => 12.w;

  /// 중간 간격: 16
  static double get lg => 16.w;

  /// 큰 간격: 20
  static double get xl => 20.w;

  /// 아주 큰 간격: 24
  static double get xxl => 24.w;

  /// 매우 큰 간격: 32
  static double get xxxl => 32.w;

  /// 초대형 간격: 40
  static double get huge => 40.w;

  // ==================== SliverAppBar 전용 높이 ====================
  /// SliverAppBar 확장 높이: 220 (축소 시 Overflow 완전 방지)
  static double get sliverAppBarExpandedHeight => 220.h;

  /// 카테고리 필터 높이: 56
  static double get categoryFilterHeight => 56.h;

  // ==================== Feed 전용 크기 ====================
  /// 피드 카드 썸네일 높이: 140
  static double get feedThumbnailHeight => 140.h;

  /// 썸네일 내부 요소 간격: 12 (배지, 북마크 버튼 위치)
  static double get thumbnailElementSpacing => 12.w;

  /// 북마크 버튼 패딩: 8
  static EdgeInsets get bookmarkButtonPadding => EdgeInsets.all(8.w);

  /// 카테고리 칩 패딩: 가로 16, 세로 8
  static EdgeInsets get categoryChipPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h);

  /// 카테고리 필터 리스트 패딩: 가로 18, 세로 8
  static EdgeInsets get categoryFilterPadding =>
      EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h);

  // ==================== 화면별 패딩 ====================
  /// 화면 메인 패딩 (기본): 18
  static EdgeInsets get screenPadding => EdgeInsets.all(18.w);

  /// 화면 가로 패딩만: 18
  static EdgeInsets get screenHorizontal =>
      EdgeInsets.symmetric(horizontal: 18.w);

  /// 화면 큰 패딩 (로그인, 온보딩): 32
  static EdgeInsets get screenPaddingLarge => EdgeInsets.all(xxxl);

  /// 화면 큰 가로 패딩: 32
  static EdgeInsets get screenHorizontalLarge =>
      EdgeInsets.symmetric(horizontal: xxxl);

  // ==================== 카드/컨테이너 패딩 ====================
  /// 카드 내부 패딩: 16
  static EdgeInsets get cardPadding => EdgeInsets.all(lg);

  /// 카드 작은 패딩: 12
  static EdgeInsets get cardPaddingSmall => EdgeInsets.all(md);

  /// 리스트 아이템 패딩: 16
  static EdgeInsets get listItemPadding => EdgeInsets.all(lg);

  /// 리스트 아이템 가로 패딩: 16
  static EdgeInsets get listItemHorizontal =>
      EdgeInsets.symmetric(horizontal: lg);

  // ==================== 버튼 패딩 ====================
  /// 버튼 기본 패딩: 가로 24, 세로 14
  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: xxl, vertical: 14.h);

  /// 버튼 작은 패딩: 가로 16, 세로 12
  static EdgeInsets get buttonPaddingSmall =>
      EdgeInsets.symmetric(horizontal: lg, vertical: 12.h);

  /// 버튼 큰 패딩: 가로 32, 세로 16
  static EdgeInsets get buttonPaddingLarge =>
      EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h);

  // ==================== 수직 간격 (SizedBox용) ====================
  /// 최소 수직 간격: 4
  static SizedBox get verticalSpaceXS => SizedBox(height: 4.h);

  /// 아주 작은 수직 간격: 8
  static SizedBox get verticalSpaceSM => SizedBox(height: 8.h);

  /// 작은 수직 간격: 12
  static SizedBox get verticalSpaceMD => SizedBox(height: 12.h);

  /// 중간 수직 간격: 16
  static SizedBox get verticalSpaceLG => SizedBox(height: 16.h);

  /// 큰 수직 간격: 20
  static SizedBox get verticalSpaceXL => SizedBox(height: 20.h);

  /// 아주 큰 수직 간격: 24
  static SizedBox get verticalSpaceXXL => SizedBox(height: 24.h);

  /// 매우 큰 수직 간격: 32
  static SizedBox get verticalSpaceXXXL => SizedBox(height: 32.h);

  /// 초대형 수직 간격: 40
  static SizedBox get verticalSpaceHuge => SizedBox(height: 40.h);

  // ==================== 수평 간격 (SizedBox용) ====================
  /// 최소 수평 간격: 4
  static SizedBox get horizontalSpaceXS => SizedBox(width: 4.w);

  /// 아주 작은 수평 간격: 8
  static SizedBox get horizontalSpaceSM => SizedBox(width: 8.w);

  /// 작은 수평 간격: 12
  static SizedBox get horizontalSpaceMD => SizedBox(width: 12.w);

  /// 중간 수평 간격: 16
  static SizedBox get horizontalSpaceLG => SizedBox(width: 16.w);

  /// 큰 수평 간격: 20
  static SizedBox get horizontalSpaceXL => SizedBox(width: 20.w);

  /// 아주 큰 수평 간격: 24
  static SizedBox get horizontalSpaceXXL => SizedBox(width: 24.w);

  /// 매우 큰 수평 간격: 32
  static SizedBox get horizontalSpaceXXXL => SizedBox(width: 32.w);

  // ==================== 모달/다이얼로그 패딩 ====================
  /// 모달 내부 패딩: 24
  static EdgeInsets get modalPadding => EdgeInsets.all(xxl);

  /// 다이얼로그 내부 패딩: 24
  static EdgeInsets get dialogPadding => EdgeInsets.all(xxl);

  // ==================== 특수 패딩 ====================
  /// 세션 정보 컨테이너 패딩: 가로 16, 세로 12
  static EdgeInsets get sessionInfoPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

  /// AppBar 타이틀 좌측 패딩: 8
  static EdgeInsets get appBarTitlePadding => EdgeInsets.only(left: 8.w);

  /// AppBar 액션 우측 패딩: 8
  static EdgeInsets get appBarActionPadding => EdgeInsets.only(right: 8.w);

  /// 리스트 하단 여백 (스크롤용): 80
  static SizedBox get listBottomSpace => SizedBox(height: 80.h);

  // ==================== 유틸리티 메서드 ====================
  /// 커스텀 수직 간격
  static SizedBox verticalSpace(double height) => SizedBox(height: height.h);

  /// 커스텀 수평 간격
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  /// 커스텀 패딩 (전체)
  static EdgeInsets all(double value) => EdgeInsets.all(value.w);

  /// 커스텀 패딩 (대칭)
  static EdgeInsets symmetric({double? horizontal, double? vertical}) =>
      EdgeInsets.symmetric(
        horizontal: horizontal?.w ?? 0,
        vertical: vertical?.h ?? 0,
      );

  /// 커스텀 패딩 (개별)
  static EdgeInsets only({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => EdgeInsets.only(
    left: left?.w ?? 0,
    top: top?.h ?? 0,
    right: right?.w ?? 0,
    bottom: bottom?.h ?? 0,
  );
}
