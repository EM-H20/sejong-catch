import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_slide.dart';
import '../widgets/onboarding_footer.dart';

/// 온보딩 메인 페이지
class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(onboardingControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // 건너뛰기 버튼 (우상단)
          if (!controller.isLastPage)
            TextButton(
              onPressed: () => controller.skipOnboarding(context),
              child: Text(
                '건너뛰기',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // 온보딩 슬라이드
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                controller.setPage(index);
              },
              itemCount: controller.totalPages,
              itemBuilder: (context, index) {
                return OnboardingSlide(data: OnboardingController.pages[index]);
              },
            ),
          ),

          // 하단 버튼과 인디케이터
          OnboardingFooter(pageController: _pageController),
        ],
      ),
    );
  }
}
