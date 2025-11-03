import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/text_styles.dart';

/// 🚨 세종 캐치 공통 에러 처리 유틸리티
///
/// CLAUDE.md 원칙:
/// ✅ 중복 에러 처리 코드 제거
/// ✅ 일관된 사용자 경험 제공
/// ✅ 한국적 메시지로 친화적 안내
class ErrorHandler {
  ErrorHandler._();

  /// 📱 SnackBar로 에러 표시 (가벼운 에러용)
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.white, size: 20.r),
            AppSpacing.horizontalSpaceSM,
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: AppSpacing.cardPadding,
      ),
    );
  }

  /// ✅ SnackBar로 성공 메시지 표시
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: AppColors.white,
              size: 20.r,
            ),
            AppSpacing.horizontalSpaceSM,
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: AppSpacing.cardPadding,
      ),
    );
  }

  /// ⚠️ SnackBar로 경고 메시지 표시
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_outlined, color: AppColors.white, size: 20.r),
            AppSpacing.horizontalSpaceSM,
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.warning,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: AppSpacing.cardPadding,
      ),
    );
  }

  /// 🚨 Dialog로 에러 표시 (심각한 에러용)
  static void showErrorDialog(
    BuildContext context,
    String title,
    String message, {
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 24.r),
            AppSpacing.horizontalSpaceSM,
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('다시 시도'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  /// 🔄 공통 에러 메시지 표준화
  static String getStandardErrorMessage(Object error) {
    final errorStr = error.toString().toLowerCase();

    // 네트워크 관련 에러
    if (errorStr.contains('socket') ||
        errorStr.contains('network') ||
        errorStr.contains('connection')) {
      return '인터넷 연결을 확인해주세요 📶';
    }

    // 타임아웃 에러
    if (errorStr.contains('timeout')) {
      return '서버 응답이 지연되고 있어요. 잠시 후 다시 시도해주세요 ⏰';
    }

    // 권한 에러
    if (errorStr.contains('permission') ||
        errorStr.contains('unauthorized') ||
        errorStr.contains('forbidden')) {
      return '접근 권한이 없어요. 로그인을 확인해주세요 🔐';
    }

    // 서버 에러
    if (errorStr.contains('server') ||
        errorStr.contains('500') ||
        errorStr.contains('502') ||
        errorStr.contains('503')) {
      return '서버에 일시적인 문제가 발생했어요. 잠시 후 다시 시도해주세요 🛠️';
    }

    // 데이터 관련 에러
    if (errorStr.contains('not found') || errorStr.contains('404')) {
      return '요청한 정보를 찾을 수 없어요 🔍';
    }

    // 기본 에러 메시지
    return '예상치 못한 오류가 발생했어요. 잠시 후 다시 시도해주세요 😅';
  }

  /// 🎯 컨트롤러용 에러 처리 헬퍼
  static String handleControllerError(Object error, String operation) {
    final standardMessage = getStandardErrorMessage(error);
    return '$operation 중 문제가 발생했어요\n$standardMessage';
  }

  /// 🚫 미구현 기능 안내 (TODO 대신 사용)
  static void showNotImplementedSnackBar(BuildContext context, String feature) {
    showWarningSnackBar(
      context,
      '$feature 기능은 곧 추가될 예정입니다! 조금만 기다려주세요 🚀',
      duration: const Duration(seconds: 2),
    );
  }

  /// 🎉 성공 액션 피드백
  static void showActionSuccess(BuildContext context, String action) {
    showSuccessSnackBar(context, '$action 완료! 🎉');
  }
}
