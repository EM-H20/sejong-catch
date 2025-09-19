import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// 세종 캐치 앱의 UI 관련 유틸리티 함수들
///
/// 공통으로 사용되는 UI 로직, 스낵바, 다이얼로그,
/// 키보드 처리 등을 편리하게 사용할 수 있어요.
class UiUtils {
  // Private constructor - 인스턴스 생성 방지
  UiUtils._();

  // ============================================================================
  // 스낵바 유틸리티 (SnackBar Utilities)
  // ============================================================================

  /// 기본 스낵바 표시
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: textColor ?? Colors.white, fontSize: 14.sp),
        ),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: backgroundColor ?? AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        action: action,
      ),
    );
  }

  /// 성공 스낵바 표시
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: AppColors.success,
    );
  }

  /// 에러 스낵바 표시
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
    VoidCallback? onRetry,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration ?? const Duration(seconds: 5),
      backgroundColor: AppColors.error,
      action: onRetry != null
          ? SnackBarAction(
              label: '다시 시도',
              textColor: Colors.white,
              onPressed: onRetry,
            )
          : null,
    );
  }

  /// 경고 스낵바 표시
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: AppColors.warning,
    );
  }

  /// 정보 스낵바 표시
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    showSnackBar(
      context,
      message,
      duration: duration,
      backgroundColor: AppColors.brandCrimson,
    );
  }

  // ============================================================================
  // 다이얼로그 유틸리티 (Dialog Utilities)
  // ============================================================================

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
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDangerous ? AppColors.error : AppColors.brandCrimson,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
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
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
                if (message != null) ...[
                  SizedBox(width: 16.w),
                  Flexible(
                    child: Text(message, style: TextStyle(fontSize: 14.sp)),
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
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
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
                  style: TextStyle(
                    fontSize: 14.sp,
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
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
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
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message != null) ...[
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 16.h),
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
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
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
              style: TextStyle(
                color: AppColors.brandCrimson,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 바텀시트 유틸리티 (Bottom Sheet Utilities)
  // ============================================================================

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

  // ============================================================================
  // 키보드 유틸리티 (Keyboard Utilities)
  // ============================================================================

  /// 키보드 숨기기
  static void hideKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }

  /// 키보드 표시 여부 확인
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// 키보드 높이 반환
  static double getKeyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  // ============================================================================
  // 햅틱 피드백 유틸리티 (Haptic Feedback Utilities)
  // ============================================================================

  /// 가벼운 햅틱 피드백
  static void lightHaptic() {
    HapticFeedback.lightImpact();
  }

  /// 중간 햅틱 피드백
  static void mediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  /// 강한 햅틱 피드백
  static void heavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  /// 선택 햅틱 피드백
  static void selectionHaptic() {
    HapticFeedback.selectionClick();
  }

  /// 진동 패턴
  static void vibrate() {
    HapticFeedback.vibrate();
  }

  // ============================================================================
  // 색상 유틸리티 (Color Utilities)
  // ============================================================================

  /// 색상을 더 밝게 만들기
  static Color lightenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// 색상을 더 어둡게 만들기
  static Color darkenColor(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// 텍스트에 적합한 대비 색상 반환 (흰색 또는 검은색)
  static Color getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// 16진수 문자열을 Color로 변환
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // 알파값 추가
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Color를 16진수 문자열로 변환
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  // ============================================================================
  // 애니메이션 유틸리티 (Animation Utilities)
  // ============================================================================

  /// 페이드 인 애니메이션
  static Widget fadeIn(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    double? delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }

  /// 슬라이드 인 애니메이션
  static Widget slideIn(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    Offset begin = const Offset(0.0, 1.0),
    Offset end = Offset.zero,
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      tween: Tween(begin: begin, end: end),
      builder: (context, value, child) =>
          Transform.translate(offset: value, child: child),
      child: child,
    );
  }

  /// 스케일 인 애니메이션
  static Widget scaleIn(
    Widget child, {
    Duration duration = const Duration(milliseconds: 300),
    double begin = 0.0,
    double end = 1.0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      tween: Tween(begin: begin, end: end),
      builder: (context, value, child) =>
          Transform.scale(scale: value, child: child),
      child: child,
    );
  }

  // ============================================================================
  // 기타 유틸리티 (Miscellaneous Utilities)
  // ============================================================================

  /// 안전 영역 여백 가져오기
  static EdgeInsets getSafeAreaPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// 상태바 높이 가져오기
  static double getStatusBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// 바텀 네비게이션 높이 가져오기
  static double getBottomNavigationHeight(BuildContext context) {
    return kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom;
  }

  /// 화면 방향 확인
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// 화면 방향 확인
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// 태블릿 여부 확인 (화면 대각선 크기 기준)
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    return diagonal > 1100; // 7인치 이상
  }

  /// 디버그용: UI 유틸리티 정보 출력
  static void printUiInfo(BuildContext context) {
    // 개발 모드에서만 출력
    assert(() {
      final mediaQuery = MediaQuery.of(context);
      final theme = Theme.of(context);

      // ignore: avoid_print
      print('''
📱 세종 캐치 UI 정보
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📐 화면 크기: ${mediaQuery.size.width.toInt()} x ${mediaQuery.size.height.toInt()}
📱 화면 방향: ${isPortrait(context) ? '세로' : '가로'}
💾 기기 유형: ${isTablet(context) ? '태블릿' : '폰'}
📶 상태바: ${getStatusBarHeight(context).toInt()}px
⌨️ 키보드: ${isKeyboardVisible(context) ? '표시됨' : '숨김'}
🎨 테마: ${theme.brightness == Brightness.dark ? '다크' : '라이트'}
🔤 폰트 크기: ${mediaQuery.textScaler.scale(1.0).toStringAsFixed(1)}x
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
      return true;
    }());
  }
}

// ============================================================================
// 편의성 확장 함수들 (Convenience Extensions)
// ============================================================================

/// 빌드 컨텍스트에 UI 유틸리티 추가
extension UiContextExtensions on BuildContext {
  /// 성공 스낵바 표시
  void showSuccess(String message) =>
      UiUtils.showSuccessSnackBar(this, message);

  /// 에러 스낵바 표시
  void showError(String message, {VoidCallback? onRetry}) =>
      UiUtils.showErrorSnackBar(this, message, onRetry: onRetry);

  /// 경고 스낵바 표시
  void showWarning(String message) =>
      UiUtils.showWarningSnackBar(this, message);

  /// 정보 스낵바 표시
  void showInfo(String message) => UiUtils.showInfoSnackBar(this, message);

  /// 확인 다이얼로그 표시
  Future<bool?> showConfirm({
    required String title,
    required String message,
    String confirmText = '확인',
    String cancelText = '취소',
    bool isDangerous = false,
  }) => UiUtils.showConfirmDialog(
    this,
    title: title,
    message: message,
    confirmText: confirmText,
    cancelText: cancelText,
    isDangerous: isDangerous,
  );

  /// 로딩 다이얼로그 표시
  void showLoading({String? message}) =>
      UiUtils.showLoadingDialog(this, message: message);

  /// 로딩 다이얼로그 닫기
  void hideLoading() => UiUtils.hideLoadingDialog(this);

  /// 키보드 숨기기
  void hideKeyboard() => UiUtils.hideKeyboard(this);

  /// 가벼운 햅틱 피드백
  void lightHaptic() => UiUtils.lightHaptic();

  /// 선택 햅틱 피드백
  void selectionHaptic() => UiUtils.selectionHaptic();

  /// 화면이 태블릿인지 확인
  bool get isTablet => UiUtils.isTablet(this);

  /// 화면이 세로 방향인지 확인
  bool get isPortrait => UiUtils.isPortrait(this);

  /// 키보드가 표시되었는지 확인
  bool get isKeyboardVisible => UiUtils.isKeyboardVisible(this);
}
