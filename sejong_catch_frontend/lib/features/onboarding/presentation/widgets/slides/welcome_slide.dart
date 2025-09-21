import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 🎉 환영 메시지 슬라이드 (학과 선택 대신 단순한 환영 메시지)
class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w), // 24.w → 20.w로 축소
      child: Column(
        children: [
          SizedBox(height: 20.h), // 40.h → 20.h로 축소

          // 🎉 환영 아이콘 (크기 축소)
          Container(
            width: 80.w, // 120.w → 80.w로 축소
            height: 80.h, // 120.h → 80.h로 축소
            decoration: BoxDecoration(
              color: const Color(0xFFDC143C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40.r), // 60.r → 40.r로 축소
            ),
            child: Icon(
              Icons.celebration,
              size: 40.sp, // 60.sp → 40.sp로 축소
              color: const Color(0xFFDC143C),
            ),
          )
              .animate(delay: 200.ms)
              .scale(
                duration: 800.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 600.ms),

          SizedBox(height: 24.h), // 40.h → 24.h로 축소

          // 🎯 메인 타이틀 (폰트 크기 축소)
          Text(
            "환영합니다! 🎉",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28.sp, // 32.sp → 28.sp로 축소
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1F2937),
              height: 1.2,
            ),
          )
              .animate(delay: 400.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 600.ms),

          SizedBox(height: 12.h), // 16.h → 12.h로 축소

          // 📝 서브타이틀 (폰트 크기 축소)
          Text(
            "이제 세종 캐치와 함께\n필요한 정보를 놓치지 마세요",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp, // 18.sp → 16.sp로 축소
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
              height: 1.4, // 1.5 → 1.4로 축소
            ),
          )
              .animate(delay: 600.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 600.ms),

          SizedBox(height: 30.h), // 60.h → 30.h로 대폭 축소

          // 🔥 주요 기능 리스트
          ..._buildFeatureList()
              .animate(interval: 200.ms, delay: 800.ms)
              .slideX(
                begin: 0.5,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 500.ms),

          SizedBox(height: 24.h), // Spacer 대신 고정 여백 사용

          // 💡 안내 메시지 (패딩 축소)
          Container(
            padding: EdgeInsets.all(12.w), // 16.w → 12.w로 축소
            decoration: BoxDecoration(
              color: const Color(0xFFF7E3E8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: const Color(0xFFDC143C).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: const Color(0xFFDC143C),
                  size: 18.sp, // 20.sp → 18.sp로 축소
                ),
                SizedBox(width: 10.w), // 12.w → 10.w로 축소
                Expanded(
                  child: Text(
                    "관심사와 맞춤 설정은 로그인 후에 설정할 수 있어요",
                    style: TextStyle(
                      fontSize: 13.sp, // 14.sp → 13.sp로 축소
                      color: const Color(0xFFB0102F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )
              .animate(delay: 1200.ms)
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 500.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 500.ms),

          SizedBox(height: 16.h), // 20.h → 16.h로 축소
        ],
      ),
    );
  }

  /// 🔥 주요 기능 리스트 생성
  List<Widget> _buildFeatureList() {
    final features = [
      _FeatureItem(
        icon: Icons.feed,
        title: "맞춤 정보 피드",
        description: "공모전, 취업, 논문 정보를 한 곳에서",
      ),
      _FeatureItem(
        icon: Icons.search,
        title: "스마트 검색",
        description: "원하는 정보를 빠르게 찾아보세요",
      ),
      _FeatureItem(
        icon: Icons.queue,
        title: "축제 줄서기",
        description: "실시간 대기열로 편리하게 참여",
      ),
      _FeatureItem(
        icon: Icons.notifications_active,
        title: "맞춤 알림",
        description: "놓치면 안 되는 정보를 알려드려요",
      ),
    ];

    return features.map((feature) => _buildFeatureItem(feature)).toList();
  }

  /// 🎯 개별 기능 아이템 위젯 (컴팩트 버전)
  Widget _buildFeatureItem(_FeatureItem feature) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h), // 16.h → 12.h로 축소
      child: Row(
        children: [
          // 아이콘 (크기 축소)
          Container(
            width: 36.w, // 44.w → 36.w로 축소
            height: 36.h, // 44.h → 36.h로 축소
            decoration: BoxDecoration(
              color: const Color(0xFFDC143C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r), // 12.r → 10.r로 축소
            ),
            child: Icon(
              feature.icon,
              color: const Color(0xFFDC143C),
              size: 18.sp, // 22.sp → 18.sp로 축소
            ),
          ),

          SizedBox(width: 12.w), // 16.w → 12.w로 축소

          // 텍스트 (폰트 크기 축소)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    fontSize: 14.sp, // 16.sp → 14.sp로 축소
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 1.h), // 2.h → 1.h로 축소
                Text(
                  feature.description,
                  style: TextStyle(
                    fontSize: 12.sp, // 14.sp → 12.sp로 축소
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 기능 아이템 모델
class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}