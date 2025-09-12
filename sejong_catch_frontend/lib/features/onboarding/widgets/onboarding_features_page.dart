import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 온보딩 2단계: 기능 소개 페이지
///
/// 세종 캐치의 핵심 기능들을 자세히 소개합니다.
/// 수집 → 필터링 → 추천의 플로우를 시각적으로 보여줘요.
class OnboardingFeaturesPage extends StatefulWidget {
  const OnboardingFeaturesPage({super.key});

  @override
  State<OnboardingFeaturesPage> createState() => _OnboardingFeaturesPageState();
}

class _OnboardingFeaturesPageState extends State<OnboardingFeaturesPage>
    with TickerProviderStateMixin {
  late AnimationController _flowController;
  late List<Animation<double>> _stepAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _flowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // 3단계 스텝 애니메이션 생성
    _stepAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _flowController,
          curve: Interval(
            index * 0.3,
            (index * 0.3) + 0.4,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0.0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _flowController,
          curve: Interval(
            index * 0.3,
            (index * 0.3) + 0.4,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    // 애니메이션 시작
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _flowController.forward();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 18.h),
            // 타이틀 섹션
            _buildTitleSection(),

            SizedBox(height: 20.h),

            // 플로우 다이어그램
            _buildFlowDiagram(),

            SizedBox(height: 30.h),

            // 설명 텍스트
            _buildDescriptionSection(),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  /// 타이틀 섹션
  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          '똑똑한 정보 관리',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '수집부터 추천까지, 모든 과정이 자동으로',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 플로우 다이어그램
  Widget _buildFlowDiagram() {
    return Column(
      children: [
        // 1단계: 수집
        _buildFlowStep(
          index: 0,
          icon: Icons.cloud_download,
          title: '자동 수집',
          description: '여러 사이트에서\n정보를 자동 수집',
          color: Colors.blue,
        ),

        // 화살표
        _buildFlowArrow(0),

        // 2단계: 필터링
        _buildFlowStep(
          index: 1,
          icon: Icons.filter_alt,
          title: '똑똑한 필터링',
          description: '중복 제거 &\n신뢰도 검증',
          color: Colors.orange,
        ),

        // 화살표
        _buildFlowArrow(1),

        // 3단계: 추천
        _buildFlowStep(
          index: 2,
          icon: Icons.stars,
          title: '맞춤 추천',
          description: '내 관심사에 맞는\n정보만 선별',
          color: AppColors.brandCrimson,
        ),
      ],
    );
  }

  /// 플로우 단계
  Widget _buildFlowStep({
    required int index,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return FadeTransition(
      opacity: _stepAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2.w),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            children: [
              // 아이콘
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30.w, color: color),
              ),

              SizedBox(width: 16.w),

              // 텍스트
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // 단계 번호
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 플로우 화살표
  Widget _buildFlowArrow(int index) {
    return FadeTransition(
      opacity: _stepAnimations[index],
      child: SizedBox(
        height: 40.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Container(
                width: 2.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.brandCrimson.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.w,
              color: AppColors.brandCrimson,
            ),
          ],
        ),
      ),
    );
  }

  /// 설명 섹션
  Widget _buildDescriptionSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.tips_and_updates,
            size: 32.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(height: 8.h),
          Text(
            '더 이상 정보를 놓치지 마세요',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.brandCrimson,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '매일 수십 개의 사이트를 확인할 필요 없이,\n세종 캐치가 중요한 정보만 골라서 알려드려요',
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
