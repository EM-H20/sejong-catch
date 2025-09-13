import 'package:flutter/foundation.dart';

/// 탭 전환 애니메이션 방향
enum SlideDirection {
  /// 좌에서 우로 슬라이드 (인덱스 증가)
  leftToRight,
  
  /// 우에서 좌로 슬라이드 (인덱스 감소) 
  rightToLeft,
  
  /// 동일 탭 (애니메이션 없음)
  none,
}

/// 탭 애니메이션 제어 시스템
/// 
/// 하단 네비게이션 탭 전환 시 방향성 있는 슬라이드 애니메이션을 제공합니다.
/// - 확장성: 탭 개수가 늘어나도 자동 대응
/// - 건너뛰기 지원: 0→2, 1→4 같은 경우도 자연스럽게 처리
/// - 적응형 속도: 건너뛰는 단계에 따라 애니메이션 속도 자동 조정
class TabAnimationController {
  // Private constructor - 인스턴스 생성 방지 (유틸리티 클래스)
  TabAnimationController._();

  // ============================================================================
  // 핵심 알고리즘 (Core Algorithm)
  // ============================================================================

  /// 탭 이동 방향 계산
  /// 
  /// [fromIndex]: 현재 탭 인덱스
  /// [toIndex]: 이동할 탭 인덱스
  /// 
  /// 반환값:
  /// - [SlideDirection.leftToRight]: 앞으로 이동 (0→1, 0→2, 1→3 등)
  /// - [SlideDirection.rightToLeft]: 뒤로 이동 (3→2, 3→0, 2→1 등)
  /// - [SlideDirection.none]: 동일 탭 (애니메이션 불필요)
  /// 
  /// 예시:
  /// ```dart
  /// calculateDirection(0, 2); // SlideDirection.leftToRight (건너뛰기)
  /// calculateDirection(3, 1); // SlideDirection.rightToLeft (2단계 뒤로)
  /// calculateDirection(1, 1); // SlideDirection.none (동일 탭)
  /// ```
  static SlideDirection calculateDirection(int fromIndex, int toIndex) {
    if (toIndex > fromIndex) {
      // 앞으로 이동: 피드→검색, 피드→대기열, 검색→프로필 등
      return SlideDirection.leftToRight;
    } else if (toIndex < fromIndex) {
      // 뒤로 이동: 프로필→대기열, 대기열→피드, 프로필→피드 등
      return SlideDirection.rightToLeft;
    } else {
      // 동일 인덱스: 같은 탭을 다시 선택한 경우
      return SlideDirection.none;
    }
  }

  /// 건너뛰는 단계 수 계산
  /// 
  /// [fromIndex]: 현재 탭 인덱스
  /// [toIndex]: 이동할 탭 인덱스
  /// 
  /// 예시:
  /// ```dart
  /// getStepCount(0, 1); // 1 (한 단계)
  /// getStepCount(0, 2); // 2 (두 단계 건너뛰기)
  /// getStepCount(3, 0); // 3 (세 단계 역방향)
  /// ```
  static int getStepCount(int fromIndex, int toIndex) {
    return (toIndex - fromIndex).abs();
  }

  /// 애니메이션 지속시간 계산 (적응형 속도)
  /// 
  /// 기본 300ms에서 시작해서 건너뛰는 단계마다 50ms씩 추가
  /// - 1단계: 300ms (기본)
  /// - 2단계: 350ms (건너뛰기)
  /// - 3단계: 400ms (2단계 건너뛰기)
  /// - 4단계: 450ms (3단계 건너뛰기)
  /// 
  /// [fromIndex]: 현재 탭 인덱스
  /// [toIndex]: 이동할 탭 인덱스
  /// 
  /// 예시:
  /// ```dart
  /// getAnimationDuration(0, 1); // Duration(milliseconds: 300)
  /// getAnimationDuration(0, 3); // Duration(milliseconds: 400)
  /// ```
  static Duration getAnimationDuration(int fromIndex, int toIndex) {
    final steps = getStepCount(fromIndex, toIndex);
    
    // 기본 300ms + 추가 단계마다 50ms
    // 최대 600ms로 제한 (너무 느리면 답답함)
    final milliseconds = (300 + (steps - 1) * 50).clamp(300, 600);
    
    return Duration(milliseconds: milliseconds);
  }

  // ============================================================================
  // 헬퍼 메서드 (Helper Methods)
  // ============================================================================

  /// 방향성 설명 문자열 반환 (디버깅용)
  static String getDirectionDescription(SlideDirection direction) {
    switch (direction) {
      case SlideDirection.leftToRight:
        return '좌→우 슬라이드';
      case SlideDirection.rightToLeft:
        return '우→좌 슬라이드';
      case SlideDirection.none:
        return '애니메이션 없음';
    }
  }

  /// 애니메이션 정보 요약 반환 (디버깅용)
  static String getAnimationSummary(int fromIndex, int toIndex) {
    final direction = calculateDirection(fromIndex, toIndex);
    final duration = getAnimationDuration(fromIndex, toIndex);
    final steps = getStepCount(fromIndex, toIndex);

    if (direction == SlideDirection.none) {
      return '동일 탭 ($fromIndex→$toIndex): 애니메이션 없음';
    }

    final directionText = getDirectionDescription(direction);
    return '$fromIndex→$toIndex: $directionText ($steps단계, ${duration.inMilliseconds}ms)';
  }

  // ============================================================================
  // 검증 및 디버깅 (Validation & Debug)
  // ============================================================================

  /// 인덱스 범위 검증
  /// 
  /// [index]: 검증할 인덱스
  /// [maxTabCount]: 최대 탭 개수
  /// 
  /// 잘못된 인덱스인 경우 false 반환
  static bool isValidIndex(int index, int maxTabCount) {
    return index >= 0 && index < maxTabCount;
  }

  /// 탭 전환이 유효한지 검증
  /// 
  /// [fromIndex]: 현재 탭 인덱스
  /// [toIndex]: 이동할 탭 인덱스  
  /// [maxTabCount]: 최대 탭 개수
  static bool isValidTransition(int fromIndex, int toIndex, int maxTabCount) {
    return isValidIndex(fromIndex, maxTabCount) && 
           isValidIndex(toIndex, maxTabCount);
  }

  /// 디버그 모드에서 애니메이션 정보 출력
  static void debugPrintAnimation(int fromIndex, int toIndex) {
    if (kDebugMode) {
      final summary = getAnimationSummary(fromIndex, toIndex);
      // ignore: avoid_print
      print('🎬 TabAnimation: $summary');
    }
  }

  // ============================================================================
  // 확장성 테스트 (Scalability Test)
  // ============================================================================

  /// 다양한 탭 개수에서 알고리즘 테스트 (개발용)
  static void testAlgorithmScalability() {
    if (kDebugMode) {
      // ignore: avoid_print
      print('🧪 TabAnimationController 확장성 테스트');
      // ignore: avoid_print
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      
      // 4탭 테스트 (현재)
      _testConfiguration('4탭 (현재)', 4);
      
      // 5탭 테스트 (미래)
      _testConfiguration('5탭 (확장)', 5);
      
      // 7탭 테스트 (극한 확장)
      _testConfiguration('7탭 (극한)', 7);
      
      // ignore: avoid_print
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
  }

  /// 특정 탭 구성에서 테스트
  static void _testConfiguration(String name, int tabCount) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('\n📊 $name:');
      
      // 몇 가지 대표적인 전환 테스트
      final testCases = [
        [0, 1], // 인접 이동
        [0, tabCount - 1], // 최대 건너뛰기
        [tabCount - 1, 0], // 최대 역방향
        [1, tabCount - 2], // 중간 건너뛰기
      ];
      
      for (final testCase in testCases) {
        final from = testCase[0];
        final to = testCase[1];
        
        if (isValidTransition(from, to, tabCount)) {
          final summary = getAnimationSummary(from, to);
          // ignore: avoid_print
          print('   $summary');
        }
      }
    }
  }
}