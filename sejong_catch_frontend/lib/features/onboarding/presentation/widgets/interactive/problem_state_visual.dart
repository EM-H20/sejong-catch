import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 😵‍💫 문제 상황 시각화 컴포넌트
/// 정보 과부하와 혼란스러운 상태를 여러 앱 아이콘과 놓친 알림으로 표현
class ProblemStateVisual extends StatelessWidget {
  final AnimationController? controller;
  final bool isCompact;

  const ProblemStateVisual({
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

          // 🔥 혼란스러운 앱 아이콘들
          ..._buildChaoticApps(),

          // 📢 놓친 알림들
          ..._buildMissedNotifications(),

          // 😵‍💫 스트레스 이모지
          _buildStressEmoji(),

          // 🌀 혼란 효과
          _buildChaosEffect(),
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
            color: const Color(0xFF374151),
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
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
                color: const Color(0xFF6B7280),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // 화면 영역
            Expanded(
              child: Container(
                margin: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2), // 연한 빨강 - 스트레스 표현
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
                color: const Color(0xFF6B7280),
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

  /// 🔥 혼란스러운 앱 아이콘들 - 화면 곳곳에 흩어져 있음
  List<Widget> _buildChaoticApps() {
    final apps = [
      _AppIcon(Icons.school, Colors.blue, "학교", isCompact),
      _AppIcon(Icons.email, Colors.red, "메일", isCompact),
      _AppIcon(Icons.chrome_reader_mode, Colors.orange, "공지", isCompact),
      _AppIcon(Icons.work, Colors.green, "취업", isCompact),
      _AppIcon(Icons.event, Colors.purple, "행사", isCompact),
      _AppIcon(Icons.description, Colors.teal, "논문", isCompact),
    ];

    // 🎯 중앙 집중형 3x2 그리드 레이아웃
    final positions = [
      Offset(0.25, 0.30), // 좌상 (중앙 그리드)
      Offset(0.50, 0.25), // 중상
      Offset(0.75, 0.30), // 우상 (중앙 그리드)
      Offset(0.25, 0.55), // 좌하 (중앙 그리드)
      Offset(0.50, 0.60), // 중하
      Offset(0.75, 0.55), // 우하 (중앙 그리드)
    ];

    return apps.asMap().entries.map((entry) {
      final index = entry.key;
      final app = entry.value;
      final position = positions[index % positions.length];

      // 🎯 애니메이션을 Positioned 내부 child에만 적용
      Widget animatedApp = app;
      if (controller != null) {
        animatedApp = animatedApp
            .animate(controller: controller!)
            .scale(
              begin: const Offset(0.0, 0.0),
              duration: 400.ms,
              delay: (100 * index).ms,
              curve: Curves.elasticOut,
            )
            .shake(
              delay: (500 + 100 * index).ms,
              duration: 200.ms,
              hz: 3,
            );
      }

      // 🎯 Positioned는 애니메이션 적용 없이 순수하게 유지
      return Positioned(
        left: position.dx * (isCompact ? 140.w : 160.w),
        top: position.dy * (isCompact ? 160.h : 200.h),
        child: animatedApp,
      );
    }).toList();
  }

  /// 📢 놓친 알림들 - 빨간 뱃지로 표현
  List<Widget> _buildMissedNotifications() {
    final badges = [
      _NotificationBadge("99+", isCompact),
      _NotificationBadge("15", isCompact),
      _NotificationBadge("7", isCompact),
      _NotificationBadge("새", isCompact),
    ];

    // 🎯 중앙 집중형 다이아몬드 배치
    final positions = [
      Offset(0.50, 0.15), // 상단 중앙
      Offset(0.65, 0.35), // 우측 중앙
      Offset(0.35, 0.65), // 좌측 중앙
      Offset(0.50, 0.80), // 하단 중앙
    ];

    return badges.asMap().entries.map((entry) {
      final index = entry.key;
      final badge = entry.value;
      final position = positions[index % positions.length];

      // 🎯 애니메이션을 Positioned 내부 child에만 적용
      Widget animatedBadge = badge;
      if (controller != null) {
        animatedBadge = animatedBadge
            .animate(controller: controller!)
            .scale(
              begin: const Offset(0.0, 0.0),
              duration: 300.ms,
              delay: (200 + 150 * index).ms,
              curve: Curves.bounceOut,
            )
            .then()
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.1, 1.1),
              duration: 1000.ms,
              curve: Curves.easeInOut,
            );
      }

      // 🎯 Positioned는 애니메이션 적용 없이 순수하게 유지
      return Positioned(
        left: position.dx * (isCompact ? 140.w : 160.w),
        top: position.dy * (isCompact ? 160.h : 200.h),
        child: animatedBadge,
      );
    }).toList();
  }

  /// 😵‍💫 스트레스 이모지
  Widget _buildStressEmoji() {
    // 🎯 애니메이션을 Positioned 내부 child에만 적용
    Widget animatedEmoji = Text(
      "😵‍💫",
      style: TextStyle(
        fontSize: isCompact ? 20.sp : 24.sp,
      ),
    );

    if (controller != null) {
      animatedEmoji = animatedEmoji
          .animate(controller: controller!)
          .fadeIn(delay: 800.ms, duration: 400.ms)
          .scale(
            delay: 800.ms,
            duration: 300.ms,
            curve: Curves.bounceOut,
          )
          .then()
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .rotate(
            begin: -0.05,
            end: 0.05,
            duration: 1500.ms,
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

  /// 🌀 혼란 효과 - 가벼운 물결 효과
  Widget _buildChaosEffect() {
    // 🎯 애니메이션을 Positioned.fill 내부 child에만 적용
    Widget animatedContainer = Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.8,
          colors: [
            const Color(0xFFDC2626).withValues(alpha: 0.05),
            const Color(0xFFDC2626).withValues(alpha: 0.02),
            Colors.transparent,
          ],
        ),
      ),
    );

    if (controller != null) {
      animatedContainer = animatedContainer
          .animate(controller: controller!)
          .fadeIn(delay: 1000.ms, duration: 600.ms)
          .then()
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 2000.ms,
            curve: Curves.easeInOut,
          );
    }

    // 🎯 Positioned.fill는 애니메이션 적용 없이 순수하게 유지
    return Positioned.fill(
      child: animatedContainer,
    );
  }
}

/// 📱 앱 아이콘 위젯
class _AppIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool isCompact;

  const _AppIcon(this.icon, this.color, this.label, this.isCompact);

  @override
  Widget build(BuildContext context) {
    final size = isCompact ? 20.w : 24.w;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isCompact ? 12.sp : 14.sp,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: isCompact ? 6.sp : 8.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}

/// 📢 알림 뱃지 위젯
class _NotificationBadge extends StatelessWidget {
  final String count;
  final bool isCompact;

  const _NotificationBadge(this.count, this.isCompact);

  @override
  Widget build(BuildContext context) {
    final size = isCompact ? 16.w : 20.w;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626),
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC2626).withValues(alpha: 0.4),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count,
          style: TextStyle(
            fontSize: isCompact ? 8.sp : 10.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}