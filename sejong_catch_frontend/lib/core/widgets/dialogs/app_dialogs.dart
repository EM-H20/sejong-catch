import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/app_button.dart';

/// Nucleus UI 기반 다이얼로그 및 모달 시스템
/// 세종캐치 앱의 모든 다이얼로그, 바텀시트, 모달을 담당하는 핵심 컴포넌트
///
/// 사용법:
/// ```dart
/// AppDialogs.showConfirmation(
///   context: context,
///   title: "삭제 확인",
///   message: "정말로 삭제하시겠습니까?",
///   onConfirm: () => deleteItem(),
/// );
/// ```

class AppDialogs {
  // ============================================================================
  // CONFIRMATION DIALOGS
  // ============================================================================
  
  /// 확인/취소 다이얼로그
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = "확인",
    String cancelText = "취소",
    AppButtonType confirmType = AppButtonType.primary,
    bool isDanger = false,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmType: isDanger ? AppButtonType.danger : confirmType,
        onConfirm: () {
          Navigator.of(context).pop(true);
          onConfirm?.call();
        },
        onCancel: () {
          Navigator.of(context).pop(false);
          onCancel?.call();
        },
      ),
    );
  }

  /// 삭제 확인 다이얼로그 (위험한 액션용)
  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
    VoidCallback? onConfirm,
  }) {
    return showConfirmation(
      context: context,
      title: "삭제 확인",
      message: "'$itemName'을(를) 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.",
      confirmText: "삭제",
      isDanger: true,
      onConfirm: onConfirm,
    );
  }

  // ============================================================================
  // ALERT DIALOGS
  // ============================================================================
  
  /// 알림 다이얼로그 (확인 버튼만)
  static Future<void> showAlert({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = "확인",
    AppDialogType type = AppDialogType.info,
    VoidCallback? onPressed,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AppAlertDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        type: type,
        onPressed: () {
          Navigator.of(context).pop();
          onPressed?.call();
        },
      ),
    );
  }

  /// 에러 다이얼로그
  static Future<void> showError({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onPressed,
  }) {
    return showAlert(
      context: context,
      title: title ?? "오류",
      message: message,
      type: AppDialogType.error,
      onPressed: onPressed,
    );
  }

  /// 성공 다이얼로그
  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    VoidCallback? onPressed,
  }) {
    return showAlert(
      context: context,
      title: title ?? "성공",
      message: message,
      type: AppDialogType.success,
      onPressed: onPressed,
    );
  }

  // ============================================================================
  // BOTTOM SHEETS
  // ============================================================================
  
  /// 기본 바텀시트
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
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
      builder: (context) => AppBottomSheet(
        child: child,
        height: height,
      ),
    );
  }

  /// 옵션 선택 바텀시트
  static Future<T?> showOptions<T>({
    required BuildContext context,
    required String title,
    required List<AppBottomSheetOption<T>> options,
    String? subtitle,
  }) {
    return showBottomSheet<T>(
      context: context,
      child: AppOptionsBottomSheet<T>(
        title: title,
        subtitle: subtitle,
        options: options,
      ),
    );
  }

  // ============================================================================
  // LOADING DIALOGS
  // ============================================================================
  
  /// 로딩 다이얼로그
  static void showLoading({
    required BuildContext context,
    String? message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppLoadingDialog(message: message),
    );
  }

  /// 로딩 다이얼로그 닫기
  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
}

// ============================================================================
// DIALOG WIDGETS
// ============================================================================

/// 확인/취소 다이얼로그 위젯
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText = "확인",
    this.cancelText = "취소",
    this.confirmType = AppButtonType.primary,
  });

  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmText;
  final String cancelText;
  final AppButtonType confirmType;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
      contentPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      
      title: Text(
        title,
        style: AppTextStyles.title3.copyWith(
          color: AppColors.textPrimary(context),
        ),
      ),
      
      content: Text(
        message,
        style: AppTextStyles.bodyText.copyWith(
          color: AppColors.textSecondary(context),
        ),
      ),
      
      actions: [
        AppButton(
          text: cancelText,
          type: AppButtonType.secondary,
          size: AppButtonSize.medium,
          onPressed: onCancel,
        ),
        SizedBox(width: 8.w),
        AppButton(
          text: confirmText,
          type: confirmType,
          size: AppButtonSize.medium,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}

/// 알림 다이얼로그 위젯
class AppAlertDialog extends StatelessWidget {
  const AppAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onPressed,
    this.buttonText = "확인",
    this.type = AppDialogType.info,
  });

  final String title;
  final String message;
  final VoidCallback onPressed;
  final String buttonText;
  final AppDialogType type;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      titlePadding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
      contentPadding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      
      title: Row(
        children: [
          if (_getIcon() != null) ...[
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: _getIconBackgroundColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIcon(),
                size: 20.w,
                color: _getIconColor(context),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.title3.copyWith(
                color: AppColors.textPrimary(context),
              ),
            ),
          ),
        ],
      ),
      
      content: Text(
        message,
        style: AppTextStyles.bodyText.copyWith(
          color: AppColors.textSecondary(context),
        ),
      ),
      
      actions: [
        AppButton(
          text: buttonText,
          type: _getButtonType(),
          size: AppButtonSize.medium,
          fullWidth: true,
          onPressed: onPressed,
        ),
      ],
    );
  }

  IconData? _getIcon() {
    switch (type) {
      case AppDialogType.success:
        return Icons.check_circle_outline;
      case AppDialogType.warning:
        return Icons.warning_outlined;
      case AppDialogType.error:
        return Icons.error_outline;
      case AppDialogType.info:
        return Icons.info_outline;
    }
  }

  Color _getIconBackgroundColor(BuildContext context) {
    switch (type) {
      case AppDialogType.success:
        return AppColors.successLightest;
      case AppDialogType.warning:
        return AppColors.warningLightest;
      case AppDialogType.error:
        return AppColors.errorLightest;
      case AppDialogType.info:
        return AppColors.infoLightest;
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (type) {
      case AppDialogType.success:
        return AppColors.success;
      case AppDialogType.warning:
        return AppColors.warning;
      case AppDialogType.error:
        return AppColors.error;
      case AppDialogType.info:
        return AppColors.info;
    }
  }

  AppButtonType _getButtonType() {
    switch (type) {
      case AppDialogType.success:
        return AppButtonType.success;
      case AppDialogType.warning:
        return AppButtonType.secondary;
      case AppDialogType.error:
        return AppButtonType.danger;
      case AppDialogType.info:
        return AppButtonType.primary;
    }
  }
}

/// 로딩 다이얼로그 위젯
class AppLoadingDialog extends StatelessWidget {
  const AppLoadingDialog({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceContainer(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      contentPadding: EdgeInsets.all(24.w),
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: AppTextStyles.regularRegular.copyWith(
                color: AppColors.textSecondary(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// BOTTOM SHEET WIDGETS
// ============================================================================

/// 기본 바텀시트 래퍼
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.child,
    this.height,
  });

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer(context),
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
            width: 36.w,
            height: 4.h,
            margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: AppColors.divider(context),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          // 내용
          Flexible(child: child),
        ],
      ),
    );
  }
}

/// 옵션 선택 바텀시트
class AppOptionsBottomSheet<T> extends StatelessWidget {
  const AppOptionsBottomSheet({
    super.key,
    required this.title,
    required this.options,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<AppBottomSheetOption<T>> options;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            title,
            style: AppTextStyles.title3.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          
          // 부제목
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
          
          SizedBox(height: 16.h),
          
          // 옵션 리스트
          ...options.map((option) => _buildOptionItem(context, option)),
          
          // 하단 여백 (Safe Area 대응)
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, AppBottomSheetOption<T> option) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      leading: option.icon != null
          ? Icon(
              option.icon,
              size: 24.w,
              color: option.isDestructive
                  ? AppColors.error
                  : AppColors.textPrimary(context),
            )
          : null,
      title: Text(
        option.title,
        style: AppTextStyles.regularMedium.copyWith(
          color: option.isDestructive
              ? AppColors.error
              : AppColors.textPrimary(context),
        ),
      ),
      subtitle: option.subtitle != null
          ? Text(
              option.subtitle!,
              style: AppTextStyles.smallRegular.copyWith(
                color: AppColors.textSecondary(context),
              ),
            )
          : null,
      onTap: () {
        Navigator.of(context).pop(option.value);
        option.onTap?.call();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}

// ============================================================================
// DATA CLASSES & ENUMS
// ============================================================================

enum AppDialogType {
  info,
  success,
  warning,
  error,
}

/// 바텀시트 옵션 아이템
class AppBottomSheetOption<T> {
  const AppBottomSheetOption({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.isDestructive = false,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;
  final bool isDestructive;
  final VoidCallback? onTap;
}

// ============================================================================
// 편의성 확장 메서드들
// ============================================================================

extension AppDialogExtensions on BuildContext {
  /// 간편한 확인 다이얼로그
  Future<bool?> showConfirm(
    String title,
    String message, {
    VoidCallback? onConfirm,
  }) {
    return AppDialogs.showConfirmation(
      context: this,
      title: title,
      message: message,
      onConfirm: onConfirm,
    );
  }

  /// 간편한 에러 다이얼로그
  Future<void> showError(String message) {
    return AppDialogs.showError(context: this, message: message);
  }

  /// 간편한 성공 다이얼로그
  Future<void> showSuccess(String message) {
    return AppDialogs.showSuccess(context: this, message: message);
  }

  /// 간편한 로딩 표시
  void showLoading([String? message]) {
    AppDialogs.showLoading(context: this, message: message);
  }

  /// 간편한 로딩 숨기기
  void hideLoading() {
    AppDialogs.hideLoading(this);
  }
}