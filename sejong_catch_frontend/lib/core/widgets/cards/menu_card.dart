import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/text_styles.dart';

/// 📋 범용 메뉴 카드 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 UI 위젯 (프로필, 설정, 기타 메뉴)
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
/// ✅ 디자인 토큰 100% 사용 (AppColors, AppSpacing, AppTextStyles)
class MenuCard extends StatelessWidget {
  const MenuCard({super.key, required this.title, required this.menuItems});

  final String title;
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _buildMenuTile(
                icon: item.icon,
                title: item.title,
                onTap: item.onTap,
                trailing: item.trailing,
                titleColor: item.titleColor,
              ),
              if (index < menuItems.length - 1) _buildDivider(),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 📋 메뉴 타일
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24.r,
        color: titleColor ?? AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: titleColor ?? AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing:
          trailing ??
          Icon(Icons.chevron_right, size: 20.r, color: AppColors.textTertiary),
      onTap: onTap,
      contentPadding: AppSpacing.symmetric(horizontal: 16, vertical: 4),
    );
  }

  /// ➖ 구분선
  Widget _buildDivider() {
    return Divider(
      height: 1.h,
      thickness: 1,
      color: AppColors.divider,
      indent: 56.w,
    );
  }
}

/// 📋 메뉴 아이템 모델 (범용)
class MenuItem {
  const MenuItem({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? titleColor;
}
