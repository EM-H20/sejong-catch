import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/buttons/app_button.dart';

/// 📋 줄서기 페이지 (Student 이상 권한 필요)
///
/// CLAUDE.md 원칙:
/// ✅ 대기열 관리 + 순번 확인 기능
/// ✅ 인기 정보의 스마트 줄서기 시스템
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }


  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📊 나의 대기열 현황
          _buildMyQueueStatus(),

          SizedBox(height: 24.h),

          // 📋 현재 대기 중인 항목들
          _buildActiveQueues(context),

          SizedBox(height: 24.h),

          // 🔥 인기 대기열 (참여 가능)
          _buildPopularQueues(context),
        ],
      ),
    );
  }

  /// 📊 나의 대기열 현황 카드
  Widget _buildMyQueueStatus() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.queue_play_next,
                  color: AppColors.brandCrimson,
                  size: 24.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  '나의 대기 현황',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            Row(
              children: [
                _buildStatusItem('대기 중', '3', AppColors.warning),
                SizedBox(width: 24.w),
                _buildStatusItem('내 차례', '1', AppColors.brandCrimson),
                SizedBox(width: 24.w),
                _buildStatusItem('완료', '5', AppColors.success),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 상태 아이템 위젯
  Widget _buildStatusItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 📋 현재 대기 중인 항목들
  Widget _buildActiveQueues(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '대기 중인 정보',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),

        // 대기 항목들
        _buildQueueItem(
          context,
          title: '2024 창업 아이디어 경진대회',
          position: 12,
          totalWaiting: 45,
          category: '공모전',
          isMyTurn: false,
        ),
        _buildQueueItem(
          context,
          title: 'SK하이닉스 하계 인턴십',
          position: 1,
          totalWaiting: 23,
          category: '취업',
          isMyTurn: true,
        ),
        _buildQueueItem(
          context,
          title: '국제학술대회 논문 발표',
          position: 8,
          totalWaiting: 31,
          category: '논문',
          isMyTurn: false,
        ),
      ],
    );
  }

  /// 📇 대기열 아이템 카드
  Widget _buildQueueItem(
    BuildContext context, {
    required String title,
    required int position,
    required int totalWaiting,
    required String category,
    required bool isMyTurn,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 카테고리 배지
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brandCrimsonLight,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppColors.brandCrimson,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                if (isMyTurn)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandCrimson,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '내 차례!',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 8.h),

            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 8.h),

            Row(
              children: [
                Icon(
                  Icons.people_outline,
                  size: 16.r,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4.w),
                Text(
                  '$position번째 / 총 $totalWaiting명 대기',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                AppButton.text(
                  text: '취소',
                  size: AppButtonSize.small,
                  textColor: AppColors.error,
                  onPressed: () {
                    _showCancelDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 인기 대기열 섹션
  Widget _buildPopularQueues(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔥 인기 대기열',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),

        // 인기 대기열 항목들
        _buildPopularQueueItem(
          context,
          title: '네이버 신입 공채',
          waitingCount: 127,
          category: '취업',
        ),
        _buildPopularQueueItem(
          context,
          title: '국제 AI 논문 경진대회',
          waitingCount: 89,
          category: '논문',
        ),
        _buildPopularQueueItem(
          context,
          title: '교내 창업 지원 프로그램',
          waitingCount: 156,
          category: '공모전',
        ),
      ],
    );
  }

  /// 🔥 인기 대기열 아이템
  Widget _buildPopularQueueItem(
    BuildContext context, {
    required String title,
    required int waitingCount,
    required String category,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      child: ListTile(
        leading: Icon(
          Icons.trending_up,
          color: AppColors.brandCrimson,
          size: 24.r,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text('$waitingCount명 대기 중'),
        trailing: AppButton.primary(
          text: '참여',
          size: AppButtonSize.small,
          onPressed: () {
            _joinQueue(context);
          },
        ),
      ),
    );
  }

  /// 📋 대기열 취소 확인 다이얼로그
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '대기열 취소',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '정말 대기를 취소하시겠어요?\n순서를 다시 받으려면 처음부터 기다려야 해요.',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          AppButton.text(
            text: '계속 대기',
            onPressed: () => Navigator.of(context).pop(),
          ),
          AppButton.primary(
            text: '취소하기',
            backgroundColor: AppColors.error,
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('대기를 취소했어요 😔'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 🔥 대기열 참여 처리
  void _joinQueue(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('대기열에 참여했어요! 순서가 오면 알려드릴게요 🎉'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// 📋 AppBar 윈짓
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '대기열',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.brandCrimson,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            Icons.history,
            size: 24.r,
            color: AppColors.brandCrimson,
          ),
          onPressed: () => _showQueueHistory(context),
        ),
      ],
    );
  }

  /// 📜 대기열 히스토리 보기
  void _showQueueHistory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('대기열 히스토리 기능은 곧 추가될 예정이에요! 📊'),
        backgroundColor: AppColors.brandCrimson,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}