import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../shared/adaptive_slide_layout.dart';
import '../shared/slide_header.dart';
import '../shared/before_after_comparison.dart';
import '../interactive/problem_state_visual.dart';
import '../interactive/solution_state_visual.dart';

/// 🔄 문제 인식 & 해결책 제시 슬라이드
/// "세종인, 이런 고민 있으시죠?" → Before/After 비교 → "세종 캐치가 해결해드려요"
class ProblemSolutionSlide extends StatefulWidget {
  final VoidCallback? onNext;

  const ProblemSolutionSlide({super.key, this.onNext});

  @override
  State<ProblemSolutionSlide> createState() => _ProblemSolutionSlideState();
}

class _ProblemSolutionSlideState extends State<ProblemSolutionSlide>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _comparisonController;
  late AnimationController _footerController;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _comparisonController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _footerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _startAnimationSequence();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _comparisonController.dispose();
    _footerController.dispose();
    super.dispose();
  }

  /// 🎬 애니메이션 시퀀스 실행
  void _startAnimationSequence() async {
    // 1. 헤더 등장
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) _headerController.forward();

    // 2. Before/After 비교 등장
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) _comparisonController.forward();

    // 3. 하단 메시지 등장
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) _footerController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSlideLayout(
      header: _buildHeader(),
      visual: _buildComparisonVisual(),
      content: _buildFooterContent(),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
    );
  }

  /// 🎯 슬라이드 헤더 - "세종인, 이런 고민 있으시죠?"
  Widget _buildHeader() {
    return SlideHeader(
      brandTitle: "세종인,",
      subtitle: "이런 고민 있으시죠?",
      controller: _headerController,
      useGradient: true,
      gradientColors: const [
        Color(0xFFDC2626), // 문제 상황 빨강
        Color(0xFFF59E0B), // 주의 노랑
        Color(0xFFDC2626), // 문제 상황 빨강
      ],
    );
  }

  /// 🔄 Before/After 비교 비주얼
  Widget _buildComparisonVisual() {
    return BeforeAfterComparison(
      beforeState: ProblemStateVisual(
        controller: _comparisonController,
        isCompact: _isCompactLayout(),
      ),
      afterState: SolutionStateVisual(
        controller: _comparisonController,
        isCompact: _isCompactLayout(),
      ),
      beforeTitle: "BEFORE",
      afterTitle: "AFTER",
      controller: _comparisonController,
      showTransitionArrow: true,
      onTransition: () {
        // 클릭 시 전환 효과 (선택적)
        _comparisonController.reset();
        _comparisonController.forward();
      },
    );
  }

  /// 💬 하단 결론 메시지
  Widget _buildFooterContent() {
    return Column(
      children: [
        // 🌊 상단 여백 추가로 메시지를 아래로 밀어내기
        SizedBox(height: 20.h),

        // 🎯 메인 메시지
        _buildMainMessage(),

        SizedBox(height: 12.h),

        // ✨ 핵심 가치 제안
        _buildValueProposition(),

        SizedBox(height: 16.h),

        // 📋 핵심 혜택 목록
        _buildBenefitsList(),
      ],
    );
  }

  /// 🎯 메인 메시지 - "세종 캐치가 해결해드려요"
  Widget _buildMainMessage() {
    Widget messageWidget = RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: "세종 캐치",
            style: TextStyle(
              fontSize: _getMainMessageSize(),
              fontWeight: FontWeight.w800,
              color: const Color(0xFFDC143C), // 브랜드 크림슨
              height: 1.2,
            ),
          ),
          TextSpan(
            text: "가\n해결해드려요!",
            style: TextStyle(
              fontSize: _getMainMessageSize(),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
              height: 1.2,
            ),
          ),
        ],
      ),
    );

    if (_footerController.isAnimating || _footerController.isCompleted) {
      messageWidget = messageWidget
          .animate(controller: _footerController)
          .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutExpo)
          .fadeIn(duration: 400.ms);
    }

    return messageWidget;
  }

  /// ✨ 핵심 가치 제안
  Widget _buildValueProposition() {
    Widget propositionWidget = Text(
      "모든 정보를 한 곳에서, 맞춤형으로!",
      style: TextStyle(
        fontSize: _getSubMessageSize(),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF059669),
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    );

    if (_footerController.isAnimating || _footerController.isCompleted) {
      propositionWidget = propositionWidget
          .animate(controller: _footerController)
          .slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutExpo)
          .fadeIn(delay: 200.ms, duration: 400.ms);
    }

    return propositionWidget;
  }

  /// 📋 핵심 혜택 목록
  Widget _buildBenefitsList() {
    final benefits = [
      _BenefitItem(
        icon: Icons.hub_rounded,
        title: "통합 정보",
        description: "공모전·취업·논문·공지를\n한 곳에서",
      ),
      _BenefitItem(
        icon: Icons.filter_alt_rounded,
        title: "스마트 필터",
        description: "내 학과·관심사 기반\n맞춤 추천",
      ),
      _BenefitItem(
        icon: Icons.priority_high_rounded,
        title: "우선순위",
        description: "마감임박·중요도별\n알림 관리",
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: benefits.asMap().entries.map((entry) {
        final index = entry.key;
        final benefit = entry.value;

        Widget benefitWidget = benefit;

        if (_footerController.isAnimating || _footerController.isCompleted) {
          benefitWidget = benefitWidget
              .animate(controller: _footerController)
              .slideY(
                begin: 0.4,
                duration: 400.ms,
                delay: (300 + 100 * index).ms,
                curve: Curves.easeOutExpo,
              )
              .fadeIn(delay: (300 + 100 * index).ms, duration: 300.ms);
        }

        return benefitWidget;
      }).toList(),
    );
  }

  /// 📏 화면 크기별 메인 메시지 사이즈
  double _getMainMessageSize() {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 700) return 18.sp; // compact
    if (screenHeight < 850) return 22.sp; // medium
    return 26.sp; // large
  }

  /// 📏 화면 크기별 서브 메시지 사이즈
  double _getSubMessageSize() {
    final screenHeight = MediaQuery.of(context).size.height;
    if (screenHeight < 700) return 12.sp; // compact
    if (screenHeight < 850) return 14.sp; // medium
    return 16.sp; // large
  }

  /// 📱 컴팩트 레이아웃 여부 확인
  bool _isCompactLayout() {
    return MediaQuery.of(context).size.height < 700;
  }
}

/// 🎁 혜택 아이템 위젯
class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isCompact = screenHeight < 700;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 아이콘
        Container(
          width: isCompact ? 32.w : 40.w,
          height: isCompact ? 32.w : 40.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFDC143C), Color(0xFFB0102F)],
            ),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDC143C).withValues(alpha: 0.2),
                blurRadius: 8.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isCompact ? 16.sp : 20.sp,
          ),
        ),

        SizedBox(height: 8.h),

        // 제목
        Text(
          title,
          style: TextStyle(
            fontSize: isCompact ? 10.sp : 12.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1F2937),
          ),
        ),

        SizedBox(height: 4.h),

        // 설명
        Text(
          description,
          style: TextStyle(
            fontSize: isCompact ? 8.sp : 10.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
