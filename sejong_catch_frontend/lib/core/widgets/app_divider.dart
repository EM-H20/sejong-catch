import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';

/// Sejong Catch 앱의 표준 구분선 컴포넌트
///
/// 얇은/중간/굵은 구분선을 제공하며, 모든 크기는 ScreenUtil로 반응형 지원
///
/// **사용 예시**:
/// ```dart
/// AppDivider.thin()        // 얇은 구분선 (1.h)
/// AppDivider.medium()      // 중간 구분선 (4.h)
/// AppDivider.thick()       // 굵은 구분선 (8.h)
/// AppDivider.custom(       // 커스텀 구분선
///   height: 2,
///   color: Colors.red,
///   margin: EdgeInsets.symmetric(horizontal: 20),
/// )
/// ```
class AppDivider extends StatelessWidget {
  final double height;
  final Color color;
  final EdgeInsets? margin;
  final double? indent;
  final double? endIndent;

  const AppDivider._({
    super.key,
    required this.height,
    required this.color,
    this.margin,
    this.indent,
    this.endIndent,
  });

  /// 얇은 구분선 (1.h)
  ///
  /// 카드 내부, 리스트 아이템 구분 등에 사용
  ///
  /// **사용 예시**:
  /// ```dart
  /// Column(
  ///   children: [
  ///     Text('제목'),
  ///     AppDivider.thin(),
  ///     Text('내용'),
  ///   ],
  /// )
  /// ```
  factory AppDivider.thin({
    Key? key,
    EdgeInsets? margin,
    double? indent,
    double? endIndent,
  }) {
    return AppDivider._(
      key: key,
      height: 1.h,
      color: AppColors.divider,
      margin: margin,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// 중간 구분선 (4.h)
  ///
  /// 섹션 구분, 그룹 구분 등에 사용
  ///
  /// **사용 예시**:
  /// ```dart
  /// Column(
  ///   children: [
  ///     _buildHeaderSection(),
  ///     AppDivider.medium(),
  ///     _buildContentSection(),
  ///   ],
  /// )
  /// ```
  factory AppDivider.medium({
    Key? key,
    EdgeInsets? margin,
    double? indent,
    double? endIndent,
  }) {
    return AppDivider._(
      key: key,
      height: 4.h,
      color: AppColors.divider,
      margin: margin,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// 굵은 구분선 (8.h)
  ///
  /// 페이지 주요 섹션 구분, 강한 시각적 구분이 필요할 때 사용
  ///
  /// **사용 예시**:
  /// ```dart
  /// Column(
  ///   children: [
  ///     _buildMainSection(),
  ///     AppDivider.thick(),
  ///     _buildSubSection(),
  ///   ],
  /// )
  /// ```
  factory AppDivider.thick({
    Key? key,
    EdgeInsets? margin,
    double? indent,
    double? endIndent,
  }) {
    return AppDivider._(
      key: key,
      height: 8.h,
      color: AppColors.surface, // 굵은 구분선은 배경색과 같은 톤 사용
      margin: margin,
      indent: indent,
      endIndent: endIndent,
    );
  }

  /// 커스텀 구분선
  ///
  /// 특수한 경우에 사용자 정의 높이/색상 적용
  ///
  /// **파라미터**:
  /// - `height`: 구분선 높이 (자동으로 .h 적용)
  /// - `color`: 구분선 색상 (기본: AppColors.divider)
  /// - `margin`: 외부 여백
  /// - `indent`: 시작 들여쓰기
  /// - `endIndent`: 끝 들여쓰기
  ///
  /// **사용 예시**:
  /// ```dart
  /// AppDivider.custom(
  ///   height: 2,
  ///   color: AppColors.brandCrimson,
  ///   margin: EdgeInsets.symmetric(vertical: 16),
  ///   indent: 20,
  /// )
  /// ```
  factory AppDivider.custom({
    Key? key,
    required double height,
    Color? color,
    EdgeInsets? margin,
    double? indent,
    double? endIndent,
  }) {
    return AppDivider._(
      key: key,
      height: height.h,
      color: color ?? AppColors.divider,
      margin: margin,
      indent: indent,
      endIndent: endIndent,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Container(
      height: height,
      color: color,
    );

    // indent/endIndent가 있으면 Divider 위젯 사용 (Material에서 지원)
    if (indent != null || endIndent != null) {
      divider = Divider(
        height: height,
        thickness: height,
        color: color,
        indent: indent?.w,
        endIndent: endIndent?.w,
      );
    }

    // margin이 있으면 Padding으로 감싸기
    if (margin != null) {
      return Padding(
        padding: margin!,
        child: divider,
      );
    }

    return divider;
  }
}
