import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 세종 캐치 앱에서 사용하는 모든 확장 함수들
/// 
/// 기존 클래스에 편리한 메서드를 추가해서 
/// 개발 생산성을 극대화합니다.

// ============================================================================
// String 확장 (String Extensions)
// ============================================================================

extension StringExtensions on String {
  /// 빈 문자열 여부 확인 (null safe)
  bool get isBlank => trim().isEmpty;
  
  /// 빈 문자열이 아닌지 확인
  bool get isNotBlank => !isBlank;
  
  /// 첫 글자를 대문자로 변환
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
  
  /// 각 단어의 첫 글자를 대문자로 변환
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// 한국어 조사 자동 처리
  String josa(String josaType) {
    if (isEmpty) return this;
    
    final lastChar = characters.last;
    final lastCharCode = lastChar.codeUnitAt(0);
    
    // 한글인지 확인
    if (lastCharCode < 0xAC00 || lastCharCode > 0xD7A3) {
      return this; // 한글이 아니면 조사 추가 안함
    }
    
    // 받침 유무 확인
    final hasBatchim = (lastCharCode - 0xAC00) % 28 != 0;
    
    switch (josaType) {
      case '은는':
        return hasBatchim ? '$this은' : '$this는';
      case '이가':
        return hasBatchim ? '$this이' : '$this가';
      case '을를':
        return hasBatchim ? '$this을' : '$this를';
      default:
        return this;
    }
  }
  
  /// 문자열에서 숫자만 추출
  String get digitsOnly => replaceAll(RegExp(r'[^0-9]'), '');
  
  /// 이메일 형식 여부 확인
  bool get isEmail {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }
  
  /// 휴대폰 번호 형식 여부 확인
  bool get isPhoneNumber {
    final phoneRegex = RegExp(r'^01[016789]\d{8}$');
    return phoneRegex.hasMatch(digitsOnly);
  }
  
  /// URL 형식 여부 확인
  bool get isUrl {
    try {
      final uri = Uri.parse(this);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
  
  /// 문자열을 정수로 안전하게 변환
  int? get toIntOrNull => int.tryParse(this);
  
  /// 문자열을 실수로 안전하게 변환
  double? get toDoubleOrNull => double.tryParse(this);
  
  /// HTML 태그 제거
  String get removeHtmlTags => replaceAll(RegExp(r'<[^>]*>'), '');
  
  /// 연속된 공백을 하나로 압축
  String get compressWhitespace => replaceAll(RegExp(r'\s+'), ' ').trim();
  
  /// Base64로 인코딩
  String get toBase64 => base64Encode(utf8.encode(this));
  
  /// 단순 해시 생성 (개발용, 보안용 아님)
  int get simpleHash => hashCode;
}

// ============================================================================
// DateTime 확장 (DateTime Extensions)
// ============================================================================

extension DateTimeExtensions on DateTime {
  /// 한국어 형식 날짜 문자열
  String get toKoreanDate => '$year년 ${month.toString().padLeft(2, '0')}월 ${day.toString().padLeft(2, '0')}일';
  
  /// 한국어 형식 날짜시간 문자열
  String get toKoreanDateTime => '$toKoreanDate ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  
  /// 상대적 시간 표시
  String get toRelativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inSeconds < 60) {
      return '방금 전';
    } else if (difference.inMinutes < 60) {
      return '$difference.inMinutes분 전';
    } else if (difference.inHours < 24) {
      return '$difference.inHours시간 전';
    } else if (difference.inDays < 7) {
      return '$difference.inDays일 전';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks주 전';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months개월 전';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years년 전';
    }
  }
  
  /// D-Day 문자열
  String get toDdayString {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(year, month, day);
    final difference = targetDate.difference(today).inDays;
    
    if (difference < 0) {
      return '마감';
    } else if (difference == 0) {
      return 'D-Day';
    } else {
      return 'D-$difference';
    }
  }
  
  /// 하루의 시작 (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);
  
  /// 하루의 끝 (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  
  /// 주의 시작 (월요일)
  DateTime get startOfWeek {
    final daysFromMonday = weekday - 1;
    return subtract(Duration(days: daysFromMonday)).startOfDay;
  }
  
  /// 월의 시작
  DateTime get startOfMonth => DateTime(year, month, 1);
  
  /// 월의 끝
  DateTime get endOfMonth => DateTime(year, month + 1, 0).endOfDay;
  
  /// 오늘인지 확인
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// 어제인지 확인
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
  
  /// 내일인지 확인
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }
  
  /// 이번 주인지 확인
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfThisWeek = now.startOfWeek;
    final endOfThisWeek = startOfThisWeek.add(const Duration(days: 6)).endOfDay;
    
    return isAfter(startOfThisWeek.subtract(const Duration(microseconds: 1))) &&
           isBefore(endOfThisWeek.add(const Duration(microseconds: 1)));
  }
  
  /// 이번 달인지 확인
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }
}

// ============================================================================
// List 확장 (List Extensions)
// ============================================================================

extension ListExtensions<T> on List<T> {
  /// 안전한 인덱스 접근 (범위 벗어나면 null 반환)
  T? getOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
  
  /// 리스트가 비어있지 않은지 확인
  bool get isNotEmpty => !isEmpty;
  
  /// 첫 번째 요소 안전하게 가져오기
  T? get firstOrNull => isEmpty ? null : first;
  
  /// 마지막 요소 안전하게 가져오기
  T? get lastOrNull => isEmpty ? null : last;
  
  /// 중복 제거
  List<T> get unique => toSet().toList();
  
  /// 조건에 맞는 첫 번째 요소 찾기 (없으면 null)
  T? firstWhereOrNull(bool Function(T) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
  
  /// 청크 단위로 분할
  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (int i = 0; i < length; i += size) {
      final end = (i + size < length) ? i + size : length;
      chunks.add(sublist(i, end));
    }
    return chunks;
  }
  
  /// 랜덤 요소 가져오기
  T? get randomOrNull {
    if (isEmpty) return null;
    final random = Random();
    return this[random.nextInt(length)];
  }
  
  /// 조건에 맞는 요소 개수
  int countWhere(bool Function(T) test) {
    return where(test).length;
  }
  
  /// 안전한 sublist (범위 벗어나지 않도록)
  List<T> safeSublist(int start, [int? end]) {
    final safeStart = start.clamp(0, length);
    final safeEnd = (end ?? length).clamp(safeStart, length);
    return sublist(safeStart, safeEnd);
  }
}

// ============================================================================
// Map 확장 (Map Extensions)  
// ============================================================================

extension MapExtensions<K, V> on Map<K, V> {
  /// 안전한 값 가져오기 (키가 없으면 기본값 반환)
  V getOrDefault(K key, V defaultValue) {
    return this[key] ?? defaultValue;
  }
  
  /// 여러 키로 값 가져오기 (첫 번째로 찾은 값 반환)
  V? getByKeys(List<K> keys) {
    for (final key in keys) {
      if (containsKey(key)) return this[key];
    }
    return null;
  }
  
  /// 조건에 맞는 키-값 쌍만 필터링
  Map<K, V> whereEntries(bool Function(K key, V value) test) {
    final result = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        result[key] = value;
      }
    });
    return result;
  }
  
  /// 키만 추출
  List<K> get keysList => keys.toList();
  
  /// 값만 추출
  List<V> get valuesList => values.toList();
  
  /// null 값 제거
  Map<K, V> get removeNulls {
    final result = <K, V>{};
    forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }
  
  /// 깊은 복사 (값이 Map인 경우 재귀적으로 복사)
  Map<K, dynamic> get deepCopy {
    final result = <K, dynamic>{};
    forEach((key, value) {
      if (value is Map) {
        result[key] = (value as Map<K, dynamic>).deepCopy;
      } else if (value is List) {
        result[key] = List.from(value);
      } else {
        result[key] = value;
      }
    });
    return result;
  }
}

// ============================================================================
// BuildContext 확장 (BuildContext Extensions)
// ============================================================================

extension BuildContextExtensions on BuildContext {
  /// MediaQuery 데이터
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// 화면 크기
  Size get screenSize => mediaQuery.size;
  
  /// 화면 너비
  double get screenWidth => screenSize.width;
  
  /// 화면 높이
  double get screenHeight => screenSize.height;
  
  /// SafeArea 패딩
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  
  /// 키보드 높이
  double get keyboardHeight => mediaQuery.viewInsets.bottom;
  
  /// 테마 데이터
  ThemeData get theme => Theme.of(this);
  
  /// 컬러 스킴
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// 텍스트 테마
  TextTheme get textTheme => theme.textTheme;
  
  /// 다크 모드 여부
  bool get isDarkMode => theme.brightness == Brightness.dark;
  
  /// 라이트 모드 여부
  bool get isLightMode => !isDarkMode;
  
  /// Scaffold Messenger
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);
  
  /// Navigator
  NavigatorState get navigator => Navigator.of(this);
  
  /// 스낵바 표시
  void showSnackBar(String message, {Duration? duration, Color? backgroundColor}) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        backgroundColor: backgroundColor,
      ),
    );
  }
  
  /// 에러 스낵바 표시
  void showErrorSnackBar(String message) {
    showSnackBar(
      message, 
      backgroundColor: theme.colorScheme.error,
    );
  }
  
  /// 성공 스낵바 표시
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.green,
    );
  }
  
  /// 경고 스낵바 표시
  void showWarningSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: Colors.orange,
    );
  }
  
  /// 다이얼로그 표시
  Future<T?> showAppDialog<T>({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                navigator.pop();
                onCancel?.call();
              },
              child: Text(cancelText),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: () {
                navigator.pop();
                onConfirm?.call();
              },
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }
  
  /// 로딩 다이얼로그 표시
  void showLoadingDialog({String? message}) {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              SizedBox(width: 16.w),
              Text(message),
            ],
          ],
        ),
      ),
    );
  }
  
  /// 로딩 다이얼로그 닫기
  void hideLoadingDialog() {
    navigator.pop();
  }
}

// ============================================================================
// Widget 확장 (Widget Extensions)
// ============================================================================

extension WidgetExtensions on Widget {
  /// 패딩 추가
  Widget padding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }
  
  /// 모든 방향 패딩
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding.r),
      child: this,
    );
  }
  
  /// 대칭 패딩
  Widget paddingSymmetric({double? horizontal, double? vertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal?.w ?? 0,
        vertical: vertical?.h ?? 0,
      ),
      child: this,
    );
  }
  
  /// 특정 방향 패딩
  Widget paddingOnly({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left?.w ?? 0,
        top: top?.h ?? 0,
        right: right?.w ?? 0,
        bottom: bottom?.h ?? 0,
      ),
      child: this,
    );
  }
  
  /// 마진 추가 (Container로 감싸기)
  Widget margin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }
  
  /// 모든 방향 마진
  Widget marginAll(double margin) {
    return Container(
      margin: EdgeInsets.all(margin.r),
      child: this,
    );
  }
  
  /// 중앙 정렬
  Widget center() {
    return Center(child: this);
  }
  
  /// 확장 (Expanded로 감싸기)
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }
  
  /// 유연한 크기 (Flexible로 감싸기)
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) {
    return Flexible(flex: flex, fit: fit, child: this);
  }
  
  /// 탭 제스처 추가
  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }
  
  /// 길게 누르기 제스처 추가
  Widget onLongPress(VoidCallback? onLongPress) {
    return GestureDetector(onLongPress: onLongPress, child: this);
  }
  
  /// 조건부 표시
  Widget visible(bool visible) {
    return Visibility(visible: visible, child: this);
  }
  
  /// 투명도 설정
  Widget opacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }
  
  /// 회전
  Widget rotate(double angle) {
    return Transform.rotate(angle: angle, child: this);
  }
  
  /// 크기 조정
  Widget scale(double scale) {
    return Transform.scale(scale: scale, child: this);
  }
  
  /// 위치 이동
  Widget translate({double? x, double? y}) {
    return Transform.translate(
      offset: Offset(x ?? 0, y ?? 0),
      child: this,
    );
  }
  
  /// SafeArea로 감싸기
  Widget safeArea() {
    return SafeArea(child: this);
  }
  
  /// Hero 애니메이션 태그 추가
  Widget hero(String tag) {
    return Hero(tag: tag, child: this);
  }
  
  /// 슬라이버로 변환
  Widget toSliver() {
    return SliverToBoxAdapter(child: this);
  }
}

