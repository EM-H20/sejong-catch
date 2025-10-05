import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 😊 해결 상태 시각화 컴포넌트
/// 세종 캐치로 통합된 깔끔하고 정리된 상태를 표현
class SolutionStateVisual extends StatelessWidget {
  final AnimationController? controller;
  final bool isCompact;

  const SolutionStateVisual({
    super.key,
    this.controller,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 📱 스마트폰 아웃라인
          _buildPhoneOutline(),

          // 🎯 세종 캐치 앱 중앙 배치
          _buildSejongCatchApp(),

          // ✅ 정리된 정보 카드들
          ..._buildOrganizedCards(),

          // 😊 만족 이모지
          _buildHappyEmoji(),

          // ✨ 깔끔함 효과
          _buildCleanEffect(),

          // 🔔 스마트 알림
          _buildSmartNotification(),
        ],
      ),
    );
  }

  /// 📱 스마트폰 기본 아웃라인
  Widget _buildPhoneOutline() {
    final phoneWidth = isCompact ? 100.w : 120.w;
    final phoneHeight = isCompact ? 160.h : 200.h;

    Widget phoneWidget = Center(
      child: Container(
        width: phoneWidth,
        height: phoneHeight,
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF059669),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF059669).withValues(alpha:0.2),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // 상단 노치
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // 화면 영역
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4), // 연한 초록 - 평화로운 느낌
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),

            // 하단 홈 인디케이터
            Container(
              width: 30.w,
              height: 3.h,
              margin: EdgeInsets.only(bottom: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ),
          ],
        ),
      ),
    );

    if (controller != null) {
      phoneWidget = phoneWidget
          .animate(controller: controller!)
          .scale(
            begin: const Offset(0.8, 0.8),
            duration: 600.ms,
            curve: Curves.easeOutBack,
          )
          .fadeIn(duration: 400.ms);
    }

    return phoneWidget;
  }

  /// 🎯 세종 캐치 메인 앱 - 중앙에 크게 배치
  Widget _buildSejongCatchApp() {
    final appSize = isCompact ? 35.w : 45.w;

    Widget appWidget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 세종 캐치 아이콘
          Container(
            width: appSize,
            height: appSize,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDC143C), // 크림슨 레드
                  Color(0xFFB0102F), // 다크 크림슨
                ],
              ),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDC143C).withValues(alpha:0.3),
                  blurRadius: 8.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(
              Icons.school, // 세종대학교를 상징하는 아이콘
              color: Colors.white,
              size: isCompact ? 20.sp : 24.sp,
            ),
          ),

          SizedBox(height: 4.h),

          // 앱 이름
          Text(
            "세종 캐치",
            style: TextStyle(
              fontSize: isCompact ? 8.sp : 10.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFDC143C),
            ),
          ),

          SizedBox(height: 2.h),

          // 서브 타이틀
          Text(
            "모든 정보가 여기에!",
            style: TextStyle(
              fontSize: isCompact ? 6.sp : 7.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF059669),
            ),
          ),
        ],
      ),
    );

    if (controller != null) {
      appWidget = appWidget
          .animate(controller: controller!)
          .scale(
            begin: const Offset(0.0, 0.0),
            duration: 500.ms,
            delay: 300.ms,
            curve: Curves.elasticOut,
          )
          .shimmer(
            delay: 800.ms,
            duration: 1000.ms,
            color: const Color(0xFFDC143C).withValues(alpha:0.3),
          );
    }

    return appWidget;
  }

  /// ✅ 정리된 정보 카드들 - 주변에 깔끔하게 배치
  List<Widget> _buildOrganizedCards() {
    final cards = [
      _InfoCard("공모전", Icons.emoji_events, isCompact),
      _InfoCard("취업", Icons.work, isCompact),
      _InfoCard("논문", Icons.description, isCompact),
      _InfoCard("공지", Icons.announcement, isCompact),
    ];

    // 🎯 중앙 집중형 2x2 그리드 레이아웃
    final positions = [
      Offset(0.35, 0.35), // 좌상 (중앙 그리드)
      Offset(0.65, 0.35), // 우상 (중앙 그리드)
      Offset(0.35, 0.65), // 좌하 (중앙 그리드)
      Offset(0.65, 0.65), // 우하 (중앙 그리드)
    ];

    return cards.asMap().entries.map((entry) {
      final index = entry.key;
      final card = entry.value;
      final position = positions[index % positions.length];

      // 🎯 애니메이션을 Positioned 내부 child에만 적용
      Widget animatedCard = card;
      if (controller != null) {
        animatedCard = animatedCard
            .animate(controller: controller!)
            .scale(
              begin: const Offset(0.0, 0.0),
              duration: 400.ms,
              delay: (500 + 100 * index).ms,
              curve: Curves.easeOutBack,
            )
            .fadeIn(
              delay: (500 + 100 * index).ms,
              duration: 300.ms,
            );
      }

      // 🎯 Positioned는 애니메이션 적용 없이 순수하게 유지
      return Positioned(
        left: position.dx * (isCompact ? 140.w : 160.w) - (isCompact ? 15.w : 20.w),
        top: position.dy * (isCompact ? 160.h : 200.h) - (isCompact ? 8.h : 10.h),
        child: animatedCard,
      );
    }).toList();
  }

  /// 😊 만족 이모지
  Widget _buildHappyEmoji() {
    // 🎯 애니메이션을 Positioned 내부 child에만 적용
    Widget animatedEmoji = Text(
      "😊",
      style: TextStyle(
        fontSize: isCompact ? 20.sp : 24.sp,
      ),
    );

    if (controller != null) {
      animatedEmoji = animatedEmoji
          .animate(controller: controller!)
          .fadeIn(delay: 1000.ms, duration: 400.ms)
          .scale(
            delay: 1000.ms,
            duration: 300.ms,
            curve: Curves.bounceOut,
          )
          .then()
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.1, 1.1),
            duration: 2000.ms,
            curve: Curves.easeInOut,
          );
    }

    // 🎯 Positioned는 애니메이션 적용 없이 순수하게 유지
    return Positioned(
      right: isCompact ? 10.w : 15.w,
      top: isCompact ? 10.h : 15.h,
      child: animatedEmoji,
    );
  }

  /// ✨ 깔끔함 효과 - 부드러운 광택 효과
  Widget _buildCleanEffect() {
    // 🎯 애니메이션을 Positioned.fill 내부 child에만 적용
    Widget animatedContainer = Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            const Color(0xFF059669).withValues(alpha:0.08),
            const Color(0xFF059669).withValues(alpha:0.04),
            Colors.transparent,
          ],
        ),
      ),
    );

    if (controller != null) {
      animatedContainer = animatedContainer
          .animate(controller: controller!)
          .fadeIn(delay: 1200.ms, duration: 800.ms)
          .then()
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .shimmer(
            duration: 3000.ms,
            color: const Color(0xFF059669).withValues(alpha:0.1),
          );
    }

    // 🎯 Positioned.fill는 애니메이션 적용 없이 순수하게 유지
    return Positioned.fill(
      child: animatedContainer,
    );
  }

  /// 🔔 스마트 알림 - 1개의 깔끔한 알림
  Widget _buildSmartNotification() {
    // 🎯 애니메이션을 Positioned 내부 child에만 적용
    Widget animatedNotification = Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6.w : 8.w,
        vertical: isCompact ? 3.h : 4.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF059669),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha:0.3),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_active,
            color: Colors.white,
            size: isCompact ? 10.sp : 12.sp,
          ),
          SizedBox(width: 2.w),
          Text(
            "1",
            style: TextStyle(
              fontSize: isCompact ? 8.sp : 10.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (controller != null) {
      animatedNotification = animatedNotification
          .animate(controller: controller!)
          .scale(
            begin: const Offset(0.0, 0.0),
            duration: 400.ms,
            delay: 900.ms,
            curve: Curves.bounceOut,
          )
          .then()
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 2500.ms,
            curve: Curves.easeInOut,
          );
    }

    // 🎯 Positioned는 애니메이션 적용 없이 순수하게 유지
    return Positioned(
      left: isCompact ? 45.w : 55.w,
      top: isCompact ? 25.h : 30.h,
      child: animatedNotification,
    );
  }
}

/// ✅ 정보 카드 위젯
class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isCompact;

  const _InfoCard(this.title, this.icon, this.isCompact);

  @override
  Widget build(BuildContext context) {
    final cardWidth = isCompact ? 30.w : 40.w;
    final cardHeight = isCompact ? 16.h : 20.h;

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: EdgeInsets.all(isCompact ? 4.w : 6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha:0.2),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha:0.1),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF059669),
            size: isCompact ? 8.sp : 10.sp,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isCompact ? 6.sp : 7.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}