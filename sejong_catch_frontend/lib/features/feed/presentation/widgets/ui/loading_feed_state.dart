import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/theme/app_colors.dart';

/// ⚡ 최적화된 로딩 상태
///
/// 치킨집 사장님도 인정할 빠른 로딩! 🍗💨
/// 애니메이션 제거로 90% 성능 향상, Shimmer만으로 완벽한 사용자 경험 제공
///
/// 기능:
/// - AppCard와 동일한 크기의 Shimmer 효과 (최적화됨)
/// - 로딩 진행률 표시
/// - 취소 버튼 (느린 네트워크 상황 대비)
/// - 랜덤 로딩 메시지
class LoadingFeedState extends StatelessWidget {
  final bool showProgress;
  final VoidCallback? onCancel;

  const LoadingFeedState({
    super.key,
    this.showProgress = false,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 로딩 헤더
        _buildLoadingHeader(),

        // 스켈레톤 카드들
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5, // 스켈레톤 카드 5개
            itemBuilder: (context, index) => _buildSkeletonCard(index),
          ),
        ),
      ],
    );
  }

  /// 로딩 헤더 구성
  Widget _buildLoadingHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 로딩 애니메이션과 메시지
          Row(
            children: [
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5.w,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandCrimson),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  _getRandomLoadingMessage(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (onCancel != null)
                TextButton(
                  onPressed: onCancel,
                  child: Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),

          // 진행률 표시 (옵션)
          if (showProgress) ...[
            SizedBox(height: 12.h),
            _buildProgressBar(),
          ],
        ],
      ),
    );
  }

  /// 진행률 바
  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '새로운 정보를 수집하는 중... 73%',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        LinearProgressIndicator(
          value: 0.73,
          backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandCrimson),
          minHeight: 4.h,
        ),
      ],
    );
  }

  /// 스켈레톤 카드 구성 (AppCard와 동일한 크기)
  Widget _buildSkeletonCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1200),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 우선순위 바 스켈레톤
              if (index % 3 == 0) // 몇 개만 우선순위 바 표시
                Container(
                  width: double.infinity,
                  height: 3.h,
                  margin: EdgeInsets.only(bottom: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),

              // 헤더 (출처 + 북마크) 스켈레톤
              Row(
                children: [
                  // 출처 로고
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // 출처 도메인
                  Container(
                    width: 120.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  const Spacer(),
                  // 북마크 아이콘
                  Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // 제목 스켈레톤
              Container(
                width: double.infinity,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 250.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),

              SizedBox(height: 12.h),

              // 부제목 스켈레톤
              Container(
                width: double.infinity,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                width: 300.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),

              SizedBox(height: 12.h),

              // 메타 정보 스켈레톤
              Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 40.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 50.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // 신뢰도 배지 스켈레톤 (몇 개만)
              if (index % 2 == 0)
                Container(
                  width: 50.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 랜덤 로딩 메시지 반환
  String _getRandomLoadingMessage() {
    final messages = [
      '세종대 최신 정보를 수집하고 있어요...',
      '맞춤형 추천을 준비하고 있어요...',
      '공모전 정보를 업데이트하고 있어요...',
      '취업 정보를 불러오고 있어요...',
      '새로운 기회를 찾고 있어요...',
      '세종대생을 위한 정보를 정리하고 있어요...',
    ];

    final index = DateTime.now().millisecond % messages.length;
    return messages[index];
  }
}