import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// 📋 줄서기 페이지 (Student 이상 권한 필요)
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당, BottomNavigationBar 관련 로직 없음
/// ✅ 대기열 관리 허브 역할
/// ✅ 실시간 순번 확인 및 줄서기/취소 기능 예정
/// ✅ 상태 관리는 별도 Controller에서 처리 예정
class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  /// 🎯 AppBar 구성
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '줄서기',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.brandCrimson,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // BottomNav 탭이므로 뒤로가기 버튼 없음
      actions: [
        IconButton(
          icon: Icon(
            Icons.refresh_outlined,
            size: 24.r,
            color: AppColors.brandCrimson,
          ),
          onPressed: () => _refreshQueue(context),
        ),
      ],
    );
  }

  /// 📄 메인 컨텐츠 영역
  Widget _buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // TODO: 대기열 새로고침 로직 구현
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          // 📊 내 대기 상태 요약
          SliverToBoxAdapter(child: _buildMyQueueSummary()),

          // 📋 대기열 리스트
          SliverToBoxAdapter(child: _buildQueueList(context)),
        ],
      ),
    );
  }

  /// 📊 내 대기 상태 요약 카드
  Widget _buildMyQueueSummary() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.brandCrimsonLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.brandCrimson.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 대기 현황',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.brandCrimson,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('대기 중', '2건', Icons.queue_outlined),
              ),
              Expanded(
                child: _buildStatItem(
                  '호출됨',
                  '1건',
                  Icons.notification_important,
                ),
              ),
              Expanded(
                child: _buildStatItem('완료', '5건', Icons.check_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📈 통계 아이템
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24.r, color: AppColors.brandCrimson),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.brandCrimson,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// 📋 대기열 리스트 (임시 더미 데이터)
  Widget _buildQueueList(BuildContext context) {
    // TODO: 실제 대기열 데이터로 교체 예정
    final dummyQueues = [
      {
        'title': 'SK하이닉스 2024 하계 인턴십 모집',
        'currentPosition': 12,
        'totalWaiting': 45,
        'estimatedTime': '약 30분',
        'status': 'waiting', // waiting, called, expired
        'joinedAt': DateTime.now().subtract(const Duration(minutes: 15)),
      },
      {
        'title': '2024 세종대학교 창업 아이디어 경진대회',
        'currentPosition': 3,
        'totalWaiting': 23,
        'estimatedTime': '약 8분',
        'status': 'called',
        'joinedAt': DateTime.now().subtract(const Duration(hours: 1)),
      },
    ];

    if (dummyQueues.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dummyQueues.length,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemBuilder: (context, index) {
        final queue = dummyQueues[index];
        return _buildQueueCard(queue);
      },
    );
  }

  /// 📄 대기열 카드
  Widget _buildQueueCard(Map<String, dynamic> queue) {
    final status = queue['status'] as String;
    final isWaiting = status == 'waiting';
    final isCalled = status == 'called';
    final isExpired = status == 'expired';

    Color statusColor = AppColors.brandCrimson;
    Color bgColor = Colors.white;
    String statusText = '대기 중';

    if (isCalled) {
      statusColor = AppColors.warning;
      bgColor = AppColors.warning.withValues(alpha: 0.1);
      statusText = '호출됨!';
    } else if (isExpired) {
      statusColor = Colors.grey;
      bgColor = Colors.grey.withValues(alpha: 0.1);
      statusText = '만료됨';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: isCalled ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상태 뱃지
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              if (isWaiting || isCalled)
                TextButton(
                  onPressed: () => _leaveQueue(queue),
                  child: Text(
                    '줄서기 취소',
                    style: TextStyle(fontSize: 12.sp, color: Colors.red[600]),
                  ),
                ),
            ],
          ),

          SizedBox(height: 8.h),

          // 제목
          Text(
            queue['title'] as String,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: isExpired ? Colors.grey[600] : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 12.h),

          // 순번 정보
          if (isWaiting || isCalled) ...[
            Row(
              children: [
                Icon(Icons.people_outline, size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  '내 순번: ${queue['currentPosition']}번 / 전체 ${queue['totalWaiting']}명',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  '예상 대기시간: ${queue['estimatedTime']}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// 📭 빈 상태 UI
  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Icon(Icons.queue_outlined, size: 64.r, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            '아직 대기 중인 항목이 없어요',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '인기 정보에 줄을 서보세요!\n순서가 되면 알려드릴게요 🔔',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              // TODO: 피드 탭으로 이동하는 로직 구현
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandCrimson,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text('인기 정보 보러가기', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  /// 🔄 대기열 새로고침
  void _refreshQueue(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('대기열을 새로고침했어요! 🔄'),
        backgroundColor: AppColors.brandCrimson,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// ❌ 줄서기 취소
  void _leaveQueue(Map<String, dynamic> queue) {
    // TODO: 실제 줄서기 취소 로직 구현
    debugPrint('줄서기 취소: ${queue['title']}');
  }
}
