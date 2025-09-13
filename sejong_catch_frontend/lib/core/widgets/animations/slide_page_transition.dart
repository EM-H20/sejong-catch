import 'package:flutter/material.dart';
import '../../controllers/tab_animation_controller.dart';

/// 페이지 슬라이드 전환 애니메이션 위젯
/// 
/// 좌우 방향성 있는 슬라이드 애니메이션을 제공합니다.
/// TabAnimationController와 연동하여 스마트한 방향 결정이 가능해요.
class SlidePageTransition extends StatelessWidget {
  /// 전환할 자식 위젯
  final Widget child;
  
  /// 애니메이션 컨트롤러
  final Animation<double> animation;
  
  /// 슬라이드 방향
  final SlideDirection direction;
  
  /// 애니메이션 커브 (기본: fastOutSlowIn)
  final Curve curve;

  const SlidePageTransition({
    super.key,
    required this.child,
    required this.animation,
    required this.direction,
    this.curve = Curves.fastOutSlowIn,
  });

  @override
  Widget build(BuildContext context) {
    // 방향에 따라 시작/끝 오프셋 결정
    final Offset beginOffset = _getBeginOffset();
    final Offset endOffset = Offset.zero;

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve,
      )),
      child: child,
    );
  }

  /// 방향에 따른 시작 오프셋 계산
  Offset _getBeginOffset() {
    switch (direction) {
      case SlideDirection.leftToRight:
        // 좌에서 우로: 왼쪽에서 시작 (-1.0, 0)
        return const Offset(-1.0, 0.0);
      case SlideDirection.rightToLeft:
        // 우에서 좌로: 오른쪽에서 시작 (1.0, 0)
        return const Offset(1.0, 0.0);
      case SlideDirection.none:
        // 애니메이션 없음: 제자리
        return Offset.zero;
    }
  }
}

/// 듀얼 슬라이드 전환 애니메이션
/// 
/// 이전 페이지는 나가는 애니메이션, 새 페이지는 들어오는 애니메이션을 
/// 동시에 실행하여 더욱 부드러운 전환을 제공합니다.
class DualSlideTransition extends StatelessWidget {
  /// 이전 페이지 위젯
  final Widget? previousChild;
  
  /// 현재 페이지 위젯
  final Widget currentChild;
  
  /// 애니메이션 컨트롤러
  final Animation<double> animation;
  
  /// 슬라이드 방향
  final SlideDirection direction;
  
  /// 애니메이션 커브
  final Curve curve;

  const DualSlideTransition({
    super.key,
    this.previousChild,
    required this.currentChild,
    required this.animation,
    required this.direction,
    this.curve = Curves.fastOutSlowIn,
  });

  @override
  Widget build(BuildContext context) {
    if (direction == SlideDirection.none || previousChild == null) {
      // 애니메이션이 없거나 이전 페이지가 없으면 현재 페이지만 표시
      return currentChild;
    }

    return Stack(
      children: [
        // 이전 페이지 (나가는 애니메이션)
        _buildExitingPage(),
        
        // 현재 페이지 (들어오는 애니메이션)
        _buildEnteringPage(),
      ],
    );
  }

  /// 나가는 페이지 애니메이션
  Widget _buildExitingPage() {
    final exitOffset = _getExitOffset();
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: exitOffset,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve,
      )),
      child: previousChild!,
    );
  }

  /// 들어오는 페이지 애니메이션  
  Widget _buildEnteringPage() {
    final enterOffset = _getEnterOffset();
    
    return SlideTransition(
      position: Tween<Offset>(
        begin: enterOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve,
      )),
      child: currentChild,
    );
  }

  /// 나가는 방향 오프셋 계산
  Offset _getExitOffset() {
    switch (direction) {
      case SlideDirection.leftToRight:
        // 좌→우 이동 시: 이전 페이지는 왼쪽으로 나감
        return const Offset(-1.0, 0.0);
      case SlideDirection.rightToLeft:
        // 우→좌 이동 시: 이전 페이지는 오른쪽으로 나감  
        return const Offset(1.0, 0.0);
      case SlideDirection.none:
        return Offset.zero;
    }
  }

  /// 들어오는 방향 오프셋 계산
  Offset _getEnterOffset() {
    switch (direction) {
      case SlideDirection.leftToRight:
        // 좌→우 이동 시: 새 페이지는 오른쪽에서 들어옴
        return const Offset(1.0, 0.0);
      case SlideDirection.rightToLeft:
        // 우→좌 이동 시: 새 페이지는 왼쪽에서 들어옴
        return const Offset(-1.0, 0.0);
      case SlideDirection.none:
        return Offset.zero;
    }
  }
}

/// 애니메이션 빌더 헬퍼
/// 
/// TabAnimationController와 연동하여 자동으로 방향을 결정하고
/// 적절한 애니메이션을 생성하는 편의 함수들
class SlideAnimationBuilder {
  SlideAnimationBuilder._();

  /// 단일 페이지 슬라이드 전환 생성
  /// 
  /// [child]: 전환할 위젯
  /// [animation]: 애니메이션 컨트롤러
  /// [fromIndex]: 이전 탭 인덱스
  /// [toIndex]: 현재 탭 인덱스
  /// [curve]: 애니메이션 커브
  static Widget buildSlideTransition({
    required Widget child,
    required Animation<double> animation,
    required int fromIndex,
    required int toIndex,
    Curve curve = Curves.fastOutSlowIn,
  }) {
    final direction = TabAnimationController.calculateDirection(fromIndex, toIndex);
    
    return SlidePageTransition(
      animation: animation,
      direction: direction,
      curve: curve,
      child: child,
    );
  }

  /// 듀얼 페이지 슬라이드 전환 생성
  /// 
  /// [previousChild]: 이전 페이지 위젯
  /// [currentChild]: 현재 페이지 위젯  
  /// [animation]: 애니메이션 컨트롤러
  /// [fromIndex]: 이전 탭 인덱스
  /// [toIndex]: 현재 탭 인덱스
  /// [curve]: 애니메이션 커브
  static Widget buildDualSlideTransition({
    Widget? previousChild,
    required Widget currentChild,
    required Animation<double> animation,
    required int fromIndex,
    required int toIndex,
    Curve curve = Curves.fastOutSlowIn,
  }) {
    final direction = TabAnimationController.calculateDirection(fromIndex, toIndex);
    
    return DualSlideTransition(
      previousChild: previousChild,
      currentChild: currentChild,
      animation: animation,
      direction: direction,
      curve: curve,
    );
  }

  /// AnimatedSwitcher용 트랜지션 빌더
  /// 
  /// AnimatedSwitcher에서 사용할 수 있는 transition builder를 반환합니다.
  /// 
  /// [fromIndex]: 이전 탭 인덱스
  /// [toIndex]: 현재 탭 인덱스
  static AnimatedSwitcherTransitionBuilder createTransitionBuilder({
    required int fromIndex,
    required int toIndex,
    Curve curve = Curves.fastOutSlowIn,
  }) {
    return (Widget child, Animation<double> animation) {
      return buildSlideTransition(
        child: child,
        animation: animation,
        fromIndex: fromIndex,
        toIndex: toIndex,
        curve: curve,
      );
    };
  }
}

/// 페이지 전환 방향 시각화 위젯 (디버그용)
/// 
/// 개발 모드에서 어느 방향으로 애니메이션이 실행되는지 
/// 시각적으로 확인할 수 있는 오버레이를 제공합니다.
class SlideDirectionIndicator extends StatelessWidget {
  /// 슬라이드 방향
  final SlideDirection direction;
  
  /// 표시 지속시간 (기본: 1초)
  final Duration showDuration;

  const SlideDirectionIndicator({
    super.key,
    required this.direction,
    this.showDuration = const Duration(seconds: 1),
  });

  @override
  Widget build(BuildContext context) {
    // 릴리즈 모드에서는 표시하지 않음
    if (const bool.fromEnvironment('dart.vm.product')) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getDirectionColor().withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getDirectionIcon(),
              size: 16,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              _getDirectionText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 방향에 따른 색상 반환
  Color _getDirectionColor() {
    switch (direction) {
      case SlideDirection.leftToRight:
        return Colors.blue;
      case SlideDirection.rightToLeft:
        return Colors.orange;
      case SlideDirection.none:
        return Colors.grey;
    }
  }

  /// 방향에 따른 아이콘 반환
  IconData _getDirectionIcon() {
    switch (direction) {
      case SlideDirection.leftToRight:
        return Icons.arrow_forward;
      case SlideDirection.rightToLeft:
        return Icons.arrow_back;
      case SlideDirection.none:
        return Icons.stop;
    }
  }

  /// 방향에 따른 텍스트 반환
  String _getDirectionText() {
    switch (direction) {
      case SlideDirection.leftToRight:
        return '좌→우';
      case SlideDirection.rightToLeft:
        return '우→좌';
      case SlideDirection.none:
        return '정지';
    }
  }
}