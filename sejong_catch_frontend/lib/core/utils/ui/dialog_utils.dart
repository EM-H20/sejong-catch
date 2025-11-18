import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'package:sejong_catch_frontend/core/theme/app_text_styles.dart';

/// 📋 세종 캐치 Dialog 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 다이얼로그 모음
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 일관된 UI/UX
class DialogUtils {
  DialogUtils._();

  /// 기본 알림 다이얼로그
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.headingSemiBold20),
        content: Text(
          message,
          style: AppTextStyles.bodyRegular14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmText,
              style: AppTextStyles.labelMedium14.copyWith(
                color: isDangerous ? AppColors.error : AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 로딩 다이얼로그 표시
  static void showLoadingDialog(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => PopScope(
        canPop: barrierDismissible,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          content: Container(
            padding: AppSpacing.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                if (message != null) ...[
                  AppSpacing.horizontalSpaceLG,
                  Flexible(
                    child: Text(message, style: AppTextStyles.bodyRegular14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 로딩 다이얼로그 닫기
  static void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// 선택 목록 다이얼로그
  static Future<T?> showListDialog<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String Function(T) itemBuilder,
    T? selectedItem,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.headingSemiBold20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;

              return ListTile(
                title: Text(
                  itemBuilder(item),
                  style: AppTextStyles.bodyRegular14.copyWith(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '취소',
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 입력 다이얼로그
  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? message,
    String? hintText,
    String? initialValue,
    String confirmText = '확인',
    String cancelText = '취소',
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: AppTextStyles.headingSemiBold20),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message != null) ...[
                Text(
                  message,
                  style: AppTextStyles.bodyRegular14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.verticalSpaceLG,
              ],
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  counterText: maxLength != null ? '' : null,
                ),
                maxLength: maxLength,
                keyboardType: keyboardType,
                validator: validator,
                autofocus: true,
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              cancelText,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: Text(
              confirmText,
              style: AppTextStyles.labelMedium14.copyWith(
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
