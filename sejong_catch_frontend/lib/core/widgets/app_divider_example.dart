import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';
import 'package:sejong_catch_frontend/core/theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/widgets/app_divider.dart';

/// AppDivider 사용 예시 페이지
///
/// 얇은/중간/굵은 구분선의 실제 사용 패턴을 보여줍니다.
class AppDividerExamplePage extends StatelessWidget {
  const AppDividerExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('AppDivider 사용 예시'),
        backgroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            // 1. 얇은 구분선 (Thin Divider)
            // ============================================================
            _buildSectionTitle('1. 얇은 구분선 (Thin - 1.h)'),
            AppSpacing.verticalSpaceSM,
            _buildCard(
              children: [
                _buildListItem('리스트 아이템 1'),
                AppDivider.thin(), // ← 얇은 구분선
                _buildListItem('리스트 아이템 2'),
                AppDivider.thin(),
                _buildListItem('리스트 아이템 3'),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ============================================================
            // 2. 중간 구분선 (Medium Divider)
            // ============================================================
            _buildSectionTitle('2. 중간 구분선 (Medium - 4.h)'),
            AppSpacing.verticalSpaceSM,
            _buildCard(
              children: [
                _buildSectionContent('헤더 섹션', '중요한 정보를 표시합니다.'),
                AppDivider.medium(), // ← 중간 구분선
                _buildSectionContent('컨텐츠 섹션', '본문 내용을 표시합니다.'),
                AppDivider.medium(),
                _buildSectionContent('푸터 섹션', '부가 정보를 표시합니다.'),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ============================================================
            // 3. 굵은 구분선 (Thick Divider)
            // ============================================================
            _buildSectionTitle('3. 굵은 구분선 (Thick - 8.h)'),
            AppSpacing.verticalSpaceSM,
            Column(
              children: [
                _buildCard(
                  children: [
                    _buildSectionContent('주요 섹션 A', '첫 번째 주요 영역입니다.'),
                  ],
                ),
                AppDivider.thick(), // ← 굵은 구분선 (페이지 섹션 구분)
                _buildCard(
                  children: [
                    _buildSectionContent('주요 섹션 B', '두 번째 주요 영역입니다.'),
                  ],
                ),
              ],
            ),

            AppSpacing.verticalSpaceXL,

            // ============================================================
            // 4. 커스텀 구분선 (Custom Divider)
            // ============================================================
            _buildSectionTitle('4. 커스텀 구분선 (Custom)'),
            AppSpacing.verticalSpaceSM,
            _buildCard(
              children: [
                Text(
                  '커스텀 색상 구분선',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.verticalSpaceSM,
                AppDivider.custom(
                  height: 2,
                  color: AppColors.brandCrimson, // 크림슨 레드 색상
                  margin: EdgeInsets.symmetric(vertical: 8.h),
                ),
                Text(
                  'Indent가 있는 구분선',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.verticalSpaceSM,
                AppDivider.custom(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  '마진이 있는 구분선',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppDivider.thin(
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                ),
                Text(
                  '구분선 아래 텍스트',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            AppSpacing.verticalSpaceHuge,
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Helper Widgets
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildListItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 20.sp, color: AppColors.success),
          AppSpacing.horizontalSpaceMD,
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalSpaceXS,
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
