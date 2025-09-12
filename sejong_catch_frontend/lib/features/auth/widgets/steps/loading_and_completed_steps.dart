/// 로딩 및 완료 단계 위젯들
/// 
/// 로그인 처리 중 상태와 성공 완료 상태를 표시하는 위젯들입니다.
/// 사용자에게 명확한 피드백을 제공하고 성취감을 느낄 수 있도록 해요! ⏳✨
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/app_button.dart';

/// 로딩 단계 위젯
/// 
/// 로그인이나 인증 처리 중일 때 표시하는 위젯입니다.
/// 진행 상태를 명확히 보여주고 사용자가 기다릴 수 있도록 안내해요.
class LoadingStepWidget extends StatelessWidget {
  /// 로딩 메시지
  final String message;

  /// 서브 메시지 (선택사항)
  final String? subMessage;

  /// 로딩 스타일
  final LoadingStyle style;

  /// 진행률 (0.0 ~ 1.0, 선택사항)
  final double? progress;

  /// 취소 버튼 콜백 (선택사항)
  final VoidCallback? onCancel;

  const LoadingStepWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.style = LoadingStyle.circular,
    this.progress,
    this.onCancel,
  });

  /// 학생 로그인용 로딩 위젯
  factory LoadingStepWidget.studentLogin({
    Key? key,
    VoidCallback? onCancel,
  }) {
    return LoadingStepWidget(
      key: key,
      message: '로그인 중이에요...',
      subMessage: '세종대 시스템에 인증 중입니다',
      style: LoadingStyle.pulsing,
      onCancel: onCancel,
    );
  }

  /// 게스트 로그인용 로딩 위젯
  factory LoadingStepWidget.guestLogin({
    Key? key,
    VoidCallback? onCancel,
  }) {
    return LoadingStepWidget(
      key: key,
      message: '인증 중이에요...',
      subMessage: '인증번호를 확인하고 있습니다',
      style: LoadingStyle.pulsing,
      onCancel: onCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 로딩 인디케이터
          _buildLoadingIndicator(),
          
          SizedBox(height: 24.h),
          
          // 메인 메시지
          Text(
            message,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (subMessage != null) ...[
            SizedBox(height: 8.h),
            Text(
              subMessage!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          // 진행률 표시
          if (progress != null) ...[
            SizedBox(height: 24.h),
            _buildProgressBar(),
          ],
          
          // 취소 버튼
          if (onCancel != null) ...[
            SizedBox(height: 32.h),
            AppButton.text(
              text: '취소',
              onPressed: onCancel,
            ),
          ],
        ],
      ),
    );
  }

  /// 로딩 인디케이터 빌드
  Widget _buildLoadingIndicator() {
    switch (style) {
      case LoadingStyle.circular:
        return SizedBox(
          width: 60.w,
          height: 60.h,
          child: CircularProgressIndicator(
            strokeWidth: 4.w,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandCrimson),
          ),
        );

      case LoadingStyle.pulsing:
        return _PulsingLoadingIndicator();

      case LoadingStyle.dots:
        return _DotsLoadingIndicator();
    }
  }

  /// 진행률 바 빌드
  Widget _buildProgressBar() {
    return Container(
      width: 200.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.brandCrimson,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

/// 완료 단계 위젯
/// 
/// 로그인이나 인증이 성공적으로 완료되었을 때 표시하는 위젯입니다.
/// 축하 메시지와 함께 사용자에게 성취감을 제공해요!
class CompletedStepWidget extends StatelessWidget {
  /// 완료 메시지
  final String message;

  /// 서브 메시지 (선택사항)
  final String? subMessage;

  /// 사용자 이름 (개인화된 메시지용)
  final String? userName;

  /// 학생 로그인 여부
  final bool isStudentLogin;

  /// 시작하기 버튼 콜백
  final VoidCallback? onStart;

  /// 시작하기 버튼 텍스트
  final String? startButtonText;

  const CompletedStepWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.userName,
    this.isStudentLogin = false,
    this.onStart,
    this.startButtonText,
  });

  /// 학생 로그인 완료 위젯
  factory CompletedStepWidget.studentLogin({
    Key? key,
    String? userName,
    VoidCallback? onStart,
  }) {
    return CompletedStepWidget(
      key: key,
      message: '환영합니다! 🎉',
      subMessage: userName != null 
          ? '$userName님의 로그인이 완료되었습니다'
          : '세종대학교 학생 로그인이 완료되었습니다',
      userName: userName,
      isStudentLogin: true,
      onStart: onStart,
      startButtonText: '세종 캐치 시작하기 🚀',
    );
  }

  /// 게스트 로그인 완료 위젯
  factory CompletedStepWidget.guestLogin({
    Key? key,
    required String userName,
    VoidCallback? onStart,
  }) {
    return CompletedStepWidget(
      key: key,
      message: '환영합니다! 🎉',
      subMessage: '${userName}님의 게스트 로그인이 완료되었습니다',
      userName: userName,
      isStudentLogin: false,
      onStart: onStart,
      startButtonText: '세종 캐치 둘러보기 ✨',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 성공 애니메이션 아이콘
          _buildSuccessIcon(),
          
          SizedBox(height: 32.h),
          
          // 완료 메시지
          Text(
            message,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (subMessage != null) ...[
            SizedBox(height: 16.h),
            Text(
              subMessage!,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          SizedBox(height: 40.h),
          
          // 시작하기 버튼
          if (onStart != null)
            AppButton.primary(
              text: startButtonText ?? '시작하기',
              onPressed: onStart,
              isExpanded: true,
              size: AppButtonSize.large,
            ),
        ],
      ),
    );
  }

  /// 성공 아이콘 빌드 (애니메이션 포함)
  Widget _buildSuccessIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.3),
                  blurRadius: 20.r,
                  spreadRadius: 5.r,
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              size: 50.w,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

/// 로딩 스타일 열거형
enum LoadingStyle {
  /// 원형 프로그레스 인디케이터
  circular,
  
  /// 펄스 효과
  pulsing,
  
  /// 점 애니메이션
  dots,
}

/// 펄스 효과 로딩 인디케이터
class _PulsingLoadingIndicator extends StatefulWidget {
  @override
  State<_PulsingLoadingIndicator> createState() => _PulsingLoadingIndicatorState();
}

class _PulsingLoadingIndicatorState extends State<_PulsingLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: AppColors.brandCrimson.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.favorite,
            size: 30.w,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

/// 점 애니메이션 로딩 인디케이터
class _DotsLoadingIndicator extends StatefulWidget {
  @override
  State<_DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<_DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.w,
      height: 20.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final progress = (_controller.value - (index * 0.2)) % 1.0;
              final opacity = progress < 0.5 ? progress * 2 : (1.0 - progress) * 2;
              
              return Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: AppColors.brandCrimson.withValues(alpha: opacity.clamp(0.2, 1.0)),
                  shape: BoxShape.circle,
                ),
              );
            },
          );
        }),
      ),
    );
  }
}