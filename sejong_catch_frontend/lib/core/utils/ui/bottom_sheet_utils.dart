import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

/// 📄 세종 캐치 BottomSheet 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 바텀시트 모음
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 일관된 UI/UX (드래그 핸들 포함)
class BottomSheetUtils {
  BottomSheetUtils._();

  /// 기본 바텀시트 표시
  static Future<T?> showAppBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 드래그 핸들
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  /// 목록 선택 바텀시트
  static Future<T?> showListBottomSheet<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    Widget Function(T)? iconBuilder,
    T? selectedItem,
  }) {
    return showAppBottomSheet<T>(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Text(
              title,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedItem;

                return ListTile(
                  leading: iconBuilder?.call(item),
                  title: Text(
                    itemBuilder(item),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isSelected
                          ? AppColors.brandCrimson
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: AppColors.brandCrimson,
                          size: 20.w,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}