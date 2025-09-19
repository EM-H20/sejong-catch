import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

/// 🎭 맞춤형 빈 상태
///
/// "검색 결과가 없어요"보다 훨씬 친근하고 따뜻한 빈 상태!
/// 세종대 마스코트보다 귀여운 UI로 사용자의 마음을 사로잡습니다 🤗
///
/// 기능:
/// - 상황별 다른 일러스트
/// - 친근한 한국어 메시지
/// - 액션 버튼 (필터 초기화, 알림 설정)
/// - 부드러운 애니메이션
class EmptyFeedState extends StatefulWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onRetry;
  final VoidCallback? onAction;

  const EmptyFeedState({
    super.key,
    required this.message,
    this.actionText,
    this.onRetry,
    this.onAction,
  });

  @override
  State<EmptyFeedState> createState() => _EmptyFeedStateState();
}

class _EmptyFeedStateState extends State<EmptyFeedState>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 귀여운 일러스트
                _buildIllustration(),

                SizedBox(height: 24.h),

                // 친근한 메시지
                _buildMessage(),

                SizedBox(height: 32.h),

                // 액션 버튼들
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 상황별 일러스트 구성
  Widget _buildIllustration() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIllustrationIcon(),
        size: 64.w,
        color: AppColors.brandCrimson,
      ),
    );
  }

  /// 상황별 아이콘 반환
  IconData _getIllustrationIcon() {
    final message = widget.message.toLowerCase();

    if (message.contains('검색')) {
      return Icons.search_off;
    } else if (message.contains('카테고리')) {
      return Icons.category;
    } else if (message.contains('필터')) {
      return Icons.filter_alt_off;
    } else if (message.contains('네트워크') || message.contains('인터넷')) {
      return Icons.wifi_off;
    } else {
      return Icons.inbox; // 기본 아이콘
    }
  }

  /// 친근한 메시지 구성
  Widget _buildMessage() {
    return Column(
      children: [
        Text(
          '앗! 아직 정보가 없어요',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12.h),
        Text(
          widget.message,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          _getEncouragementMessage(),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// 격려 메시지 반환
  String _getEncouragementMessage() {
    final messages = [
      '잠시만 기다려주세요! 곧 좋은 정보들이 올라올 거예요 ⭐',
      '세종대생을 위한 맞춤 정보를 준비하고 있어요 📚',
      '새로운 기회를 놓치지 않도록 알림을 켜보세요 🔔',
      '다른 카테고리에서 원하는 정보를 찾아보세요 🔍',
    ];

    final index = DateTime.now().millisecond % messages.length;
    return messages[index];
  }

  /// 액션 버튼들 구성
  Widget _buildActionButtons() {
    return Column(
      children: [
        // 재시도 버튼
        if (widget.onRetry != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandCrimson,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.refresh, size: 20.w),
                  SizedBox(width: 8.w),
                  Text(
                    '새로고침',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 추가 액션 버튼
        if (widget.onAction != null) ...[
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: widget.onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.brandCrimson,
                side: BorderSide(color: AppColors.brandCrimson, width: 1.5.w),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                widget.actionText ?? '설정하기',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],

        // 도움말 링크들
        SizedBox(height: 24.h),
        _buildHelpLinks(),
      ],
    );
  }

  /// 도움말 링크들
  Widget _buildHelpLinks() {
    return Column(
      children: [
        Text(
          '이런 것들을 시도해보세요!',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildHelpChip('전체 카테고리 보기', Icons.dashboard),
            _buildHelpChip('알림 설정', Icons.notifications),
            _buildHelpChip('검색하기', Icons.search),
          ],
        ),
      ],
    );
  }

  /// 도움말 칩
  Widget _buildHelpChip(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.w,
            color: AppColors.brandCrimson,
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.brandCrimson,
            ),
          ),
        ],
      ),
    );
  }
}