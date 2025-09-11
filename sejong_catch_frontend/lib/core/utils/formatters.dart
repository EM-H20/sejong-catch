import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// 세종 캐치 앱에서 사용하는 모든 데이터 포맷팅 함수들
/// 
/// 날짜, 시간, 숫자, 텍스트 등을 사용자 친화적인 형태로 
/// 변환하는 함수들을 제공합니다.
class AppFormatters {
  // Private constructor - 인스턴스 생성 방지
  AppFormatters._();

  // ============================================================================
  // 날짜 & 시간 포맷팅 (Date & Time Formatting)
  // ============================================================================
  
  /// 한국어 날짜 포맷터들
  static final DateFormat _koreanDate = DateFormat('yyyy년 MM월 dd일');
  static final DateFormat _koreanDateTime = DateFormat('yyyy년 MM월 dd일 HH:mm');
  static final DateFormat _koreanTime = DateFormat('HH:mm');
  static final DateFormat _monthDay = DateFormat('MM/dd');
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd');
  
  /// 날짜를 한국어 형식으로 포맷팅
  /// 예: 2024년 03월 15일
  static String formatKoreanDate(DateTime date) {
    return _koreanDate.format(date);
  }
  
  /// 날짜와 시간을 한국어 형식으로 포맷팅
  /// 예: 2024년 03월 15일 14:30
  static String formatKoreanDateTime(DateTime dateTime) {
    return _koreanDateTime.format(dateTime);
  }
  
  /// 시간만 포맷팅
  /// 예: 14:30
  static String formatTime(DateTime dateTime) {
    return _koreanTime.format(dateTime);
  }
  
  /// 월/일 형식으로 포맷팅 (간단한 표시용)
  /// 예: 03/15
  static String formatMonthDay(DateTime date) {
    return _monthDay.format(date);
  }
  
  /// ISO 날짜 형식으로 포맷팅 (API 전송용)
  /// 예: 2024-03-15
  static String formatIsoDate(DateTime date) {
    return _isoDate.format(date);
  }
  
  /// 상대적 시간 표시 (몇 분 전, 몇 시간 전 등)
  /// 예: "방금 전", "5분 전", "2시간 전", "3일 전"
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
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
  
  /// D-Day 계산 및 포맷팅
  /// 예: "D-5", "D-1", "D-Day", "마감"
  static String formatDday(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    final difference = deadlineDate.difference(today).inDays;
    
    if (difference < 0) {
      return '마감';
    } else if (difference == 0) {
      return 'D-Day';
    } else {
      return 'D-$difference';
    }
  }
  
  /// 마감일 상태에 따른 스타일 정보 반환
  /// UI에서 색상 결정에 사용
  static String getDdayStyle(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDate = DateTime(deadline.year, deadline.month, deadline.day);
    final difference = deadlineDate.difference(today).inDays;
    
    if (difference < 0) {
      return 'expired'; // 만료됨
    } else if (difference == 0) {
      return 'urgent'; // 긴급 (오늘 마감)
    } else if (difference <= 3) {
      return 'warning'; // 경고 (3일 이내)
    } else if (difference <= 7) {
      return 'caution'; // 주의 (7일 이내)
    } else {
      return 'normal'; // 일반
    }
  }

  // ============================================================================
  // 숫자 포맷팅 (Number Formatting)
  // ============================================================================
  
  /// 한국어 숫자 포맷터들
  static final NumberFormat _koreanNumber = NumberFormat('#,###');
  static final NumberFormat _koreanCurrency = NumberFormat('#,###원');
  static final NumberFormat _percentage = NumberFormat('#,##0.0%');
  
  /// 숫자를 천 단위 콤마로 포맷팅
  /// 예: 1,234,567
  static String formatNumber(int number) {
    return _koreanNumber.format(number);
  }
  
  /// 금액을 한국 원화 형식으로 포맷팅
  /// 예: 1,500,000원
  static String formatCurrency(int amount) {
    return _koreanCurrency.format(amount);
  }
  
  /// 백분율로 포맷팅
  /// 예: 85.5%
  static String formatPercentage(double ratio) {
    return _percentage.format(ratio);
  }
  
  /// 큰 숫자를 간단한 형태로 변환
  /// 예: 1,234 → 1.2K, 1,234,567 → 1.2M
  static String formatCompactNumber(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      final k = number / 1000;
      return k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
    } else if (number < 1000000000) {
      final m = number / 1000000;
      return m % 1 == 0 ? '${m.toInt()}M' : '${m.toStringAsFixed(1)}M';
    } else {
      final b = number / 1000000000;
      return b % 1 == 0 ? '${b.toInt()}B' : '${b.toStringAsFixed(1)}B';
    }
  }
  
  /// 파일 크기 포맷팅
  /// 예: 1024 → 1.0KB, 1048576 → 1.0MB
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)}MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)}GB';
    }
  }

  // ============================================================================
  // 텍스트 포맷팅 (Text Formatting)
  // ============================================================================
  
  /// 텍스트 길이 제한 및 말줄임표 추가
  /// 예: "긴 텍스트입니다" → "긴 텍스..."
  static String truncateText(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) {
      return text;
    }
    
    return text.substring(0, maxLength - suffix.length) + suffix;
  }
  
  /// 줄바꿈 문자를 공백으로 변환 (한 줄 표시용)
  static String singleLine(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  
  /// 이름 마스킹 (개인정보 보호)
  /// 예: "홍길동" → "홍*동", "김철수" → "김*수"
  static String maskName(String name) {
    if (name.length <= 2) {
      return name.replaceRange(1, null, '*');
    } else {
      return name.replaceRange(1, name.length - 1, '*' * (name.length - 2));
    }
  }
  
  /// 이메일 마스킹
  /// 예: "user@example.com" → "u***@example.com"
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final localPart = parts[0];
    final domain = parts[1];
    
    if (localPart.length <= 1) {
      return '$localPart***@$domain';
    } else {
      final maskedLocal = localPart[0] + '*' * (localPart.length - 1);
      return '$maskedLocal@$domain';
    }
  }
  
  /// 휴대폰 번호 마스킹
  /// 예: "010-1234-5678" → "010-****-5678"
  static String maskPhoneNumber(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.length == 11) {
      return '${digitsOnly.substring(0, 3)}-****-${digitsOnly.substring(7)}';
    }
    
    return phoneNumber; // 형식이 맞지 않으면 원본 반환
  }
  
  /// 텍스트의 첫 글자를 대문자로 변환
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
  
  /// 카멜케이스를 읽기 쉬운 형태로 변환
  /// 예: "userName" → "User Name"
  static String camelToReadable(String camelCase) {
    return camelCase
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .trim();
  }

  // ============================================================================
  // 검색 & 하이라이트 (Search & Highlight)
  // ============================================================================
  
  /// 검색어를 텍스트에서 하이라이트하기 위한 범위 반환
  /// UI에서 RichText 구성 시 사용
  static List<TextSpan> highlightSearchText(
    String text, 
    String searchQuery, {
    TextStyle? normalStyle,
    TextStyle? highlightStyle,
  }) {
    if (searchQuery.isEmpty) {
      return [TextSpan(text: text, style: normalStyle)];
    }
    
    final spans = <TextSpan>[];
    final regex = RegExp(RegExp.escape(searchQuery), caseSensitive: false);
    final matches = regex.allMatches(text);
    
    int lastEnd = 0;
    
    for (final match in matches) {
      // 매치 이전 텍스트
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: normalStyle,
        ));
      }
      
      // 매치된 텍스트 (하이라이트)
      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: highlightStyle,
      ));
      
      lastEnd = match.end;
    }
    
    // 마지막 매치 이후 텍스트
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: normalStyle,
      ));
    }
    
    return spans;
  }

  // ============================================================================
  // URL & 링크 포맷팅 (URL & Link Formatting)
  // ============================================================================
  
  /// URL에서 도메인 추출
  /// 예: "https://sejong.ac.kr/page" → "sejong.ac.kr"
  static String extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return url; // 파싱 실패 시 원본 반환
    }
  }
  
  /// URL을 사용자 친화적인 형태로 단축
  /// 예: "https://very-long-domain.com/very/long/path" → "very-long-domain.com/..."
  static String shortenUrl(String url, {int maxLength = 30}) {
    final domain = extractDomain(url);
    
    if (domain.length <= maxLength) {
      return domain;
    }
    
    return truncateText(domain, maxLength);
  }
  
  /// 이메일 주소를 mailto 링크로 변환
  static String emailToMailto(String email) {
    return 'mailto:$email';
  }
  
  /// 전화번호를 tel 링크로 변환
  static String phoneToTel(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    return 'tel:$digitsOnly';
  }

  // ============================================================================
  // 목록 & 배열 포맷팅 (List & Array Formatting)
  // ============================================================================
  
  /// 문자열 목록을 쉼표로 구분해서 연결
  /// 예: ["태그1", "태그2", "태그3"] → "태그1, 태그2, 태그3"
  static String joinWithComma(List<String> items, {int? maxItems}) {
    if (items.isEmpty) return '';
    
    final displayItems = maxItems != null && items.length > maxItems
        ? items.take(maxItems).toList()
        : items;
    
    String result = displayItems.join(', ');
    
    if (maxItems != null && items.length > maxItems) {
      final remaining = items.length - maxItems;
      result += ' 외 $remaining개';
    }
    
    return result;
  }
  
  /// 목록의 마지막 항목을 "과/와"로 연결
  /// 예: ["A", "B", "C"] → "A, B와 C"
  static String joinWithAnd(List<String> items) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items.first;
    if (items.length == 2) return '${items[0]}와 ${items[1]}';
    
    final allButLast = items.take(items.length - 1);
    final last = items.last;
    
    return '${allButLast.join(', ')}와 $last';
  }

  // ============================================================================
  // 유틸리티 함수들 (Utility Functions)
  // ============================================================================
  
  /// 한국어 조사 처리 (은/는, 이/가, 을/를)
  /// 받침 유무에 따라 적절한 조사 선택
  static String addJosa(String word, String josaType) {
    if (word.isEmpty) return word;
    
    final lastChar = word.characters.last;
    final lastCharCode = lastChar.codeUnitAt(0);
    
    // 한글인지 확인
    if (lastCharCode < 0xAC00 || lastCharCode > 0xD7A3) {
      return word; // 한글이 아니면 조사 추가 안함
    }
    
    // 받침 유무 확인
    final hasBatchim = (lastCharCode - 0xAC00) % 28 != 0;
    
    switch (josaType) {
      case '은는':
        return hasBatchim ? '$word은' : '$word는';
      case '이가':
        return hasBatchim ? '$word이' : '$word가';
      case '을를':
        return hasBatchim ? '$word을' : '$word를';
      default:
        return word;
    }
  }
  
  /// 디버그용: 모든 포맷터 정보 출력
  static void printFormatterInfo() {
    // 개발 모드에서만 출력
    assert(() {
      final testDate = DateTime(2024, 3, 15, 14, 30);
      
      // ignore: avoid_print
      print('''
📝 세종 캐치 포맷터 예시
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📅 날짜: ${formatKoreanDate(testDate)}
⏰ 시간: ${formatKoreanDateTime(testDate)}
🕐 상대시간: ${formatRelativeTime(testDate)}
📆 D-Day: ${formatDday(testDate)}
💰 금액: ${formatCurrency(1500000)}
📊 숫자: ${formatCompactNumber(1234567)}
📄 파일: ${formatFileSize(1048576)}
✂️ 텍스트: ${truncateText('긴 텍스트 예시입니다', 5)}
🎭 마스킹: ${maskName('홍길동')} / ${maskEmail('user@example.com')}
🏷️ 태그: ${joinWithComma(['태그1', '태그2', '태그3'])}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
      return true;
    }());
  }
}