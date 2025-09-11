import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 온보딩 1단계: 앱 소개 페이지
/// 
/// 세종 캐치 앱을 소개하고 주요 특징을 설명합니다.
/// 세종대학교 학생들을 위한 정보 허브라는 컨셉을 강조해요.
class OnboardingIntroPage extends StatefulWidget {
  const OnboardingIntroPage({super.key});

  @override
  State<OnboardingIntroPage> createState() => _OnboardingIntroPageState();
}

class _OnboardingIntroPageState extends State<OnboardingIntroPage>
    with TickerProviderStateMixin {
  
  late AnimationController _iconController;
  late AnimationController _textController;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // 아이콘 애니메이션
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // 텍스트 애니메이션
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _iconScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    ));
    
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));
    
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    ));
    
    // 순차적 애니메이션 시작
    _startAnimations();
  }
  
  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _iconController.forward();
    
    await Future.delayed(const Duration(milliseconds: 400));
    _textController.forward();
  }
  
  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 로고/아이콘 영역
          ScaleTransition(
            scale: _iconScaleAnimation,
            child: _buildLogoSection(),
          ),
          
          SizedBox(height: 40.h),
          
          // 메인 텍스트 영역
          FadeTransition(
            opacity: _textFadeAnimation,
            child: SlideTransition(
              position: _textSlideAnimation,
              child: _buildTextSection(),
            ),
          ),
          
          SizedBox(height: 40.h),
          
          // 특징 카드들
          FadeTransition(
            opacity: _textFadeAnimation,
            child: _buildFeatureCards(),
          ),
        ],
      ),
    );
  }
  
  /// 로고 섹션
  Widget _buildLogoSection() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandCrimson,
            AppColors.brandCrimsonDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandCrimson.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Icon(
        Icons.school,
        size: 60.w,
        color: AppColors.white,
      ),
    );
  }
  
  /// 메인 텍스트 섹션
  Widget _buildTextSection() {
    return Column(
      children: [
        // 메인 타이틀
        Text(
          '세종 캐치',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        
        SizedBox(height: 8.h),
        
        // 서브 타이틀
        Text(
          '세종인을 위한 단 하나의 정보 허브',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.brandCrimson,
            height: 1.3,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // 설명 텍스트
        Text(
          '흩어져 있는 공모전, 취업 정보, 논문, 공지사항을\n한 곳에서 똑똑하게 관리하세요',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// 특징 카드들
  Widget _buildFeatureCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.auto_fix_high,
                title: '자동 수집',
                description: '정보를 자동으로\n수집해드려요',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.filter_list,
                title: '똑똑한 필터',
                description: '중복 제거와\n우선순위 적용',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.stars,
                title: '맞춤 추천',
                description: '내 관심사에 맞는\n정보만 골라서',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.queue,
                title: '대기열 시스템',
                description: '인기 기회는\n줄서기로 공정하게',
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// 개별 특징 카드
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.brandCrimsonLight,
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.brandCrimson.withValues(alpha: 0.08),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 아이콘
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.brandCrimsonLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20.w,
              color: AppColors.brandCrimson,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // 제목
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // 설명
          Text(
            description,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}