import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/app_colors.dart';

/// 대기열 페이지
/// 
/// 인기 있는 기회에 대한 대기열 시스템을 관리합니다.
/// 대기 중/진행 중/완료된 항목들을 탭으로 구분해서 보여줘요.
class QueuePage extends StatefulWidget {
  const QueuePage({super.key});

  @override
  State<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends State<QueuePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대기열 관리'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.brandCrimson,
                borderRadius: BorderRadius.circular(6.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: '대기 중'),
                Tab(text: '진행 중'),
                Tab(text: '완료'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildWaitingTab(),
          _buildInProgressTab(),
          _buildCompletedTab(),
        ],
      ),
    );
  }

  /// 대기 중 탭
  Widget _buildWaitingTab() {
    // 임시 대기 중 데이터
    final waitingItems = [
      {
        'title': '카카오 SW 개발자 채용',
        'category': '취업',
        'position': 15,
        'totalWaiting': 247,
        'estimatedTime': '약 3일',
        'deadline': 'D-5',
        'trustLevel': 'press',
      },
      {
        'title': '2024 창업 아이디어 공모전',
        'category': '공모전',
        'position': 8,
        'totalWaiting': 156,
        'estimatedTime': '약 2일',
        'deadline': 'D-12',
        'trustLevel': 'official',
      },
    ];

    if (waitingItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.queue_outlined,
        title: '대기 중인 항목이 없어요',
        subtitle: '인기 있는 기회에 줄을 서보세요!\n알림을 받아 놓치지 않을 수 있어요.',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: waitingItems.length,
      itemBuilder: (context, index) {
        final item = waitingItems[index];
        return _buildQueueCard(
          title: item['title'] as String,
          category: item['category'] as String,
          position: item['position'] as int,
          totalWaiting: item['totalWaiting'] as int,
          estimatedTime: item['estimatedTime'] as String,
          deadline: item['deadline'] as String,
          trustLevel: item['trustLevel'] as String,
          status: QueueStatus.waiting,
        );
      },
    );
  }

  /// 진행 중 탭
  Widget _buildInProgressTab() {
    // 임시 진행 중 데이터
    final inProgressItems = [
      {
        'title': '삼성전자 하계 인턴십',
        'category': '인턴십',
        'progress': 0.6,
        'currentStep': '서류 심사',
        'nextStep': '면접 대기',
        'deadline': 'D-3',
        'trustLevel': 'official',
      },
    ];

    if (inProgressItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.hourglass_empty,
        title: '진행 중인 항목이 없어요',
        subtitle: '대기열에서 순서가 되면\n여기에 표시됩니다.',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: inProgressItems.length,
      itemBuilder: (context, index) {
        final item = inProgressItems[index];
        return _buildProgressCard(
          title: item['title'] as String,
          category: item['category'] as String,
          progress: item['progress'] as double,
          currentStep: item['currentStep'] as String,
          nextStep: item['nextStep'] as String,
          deadline: item['deadline'] as String,
          trustLevel: item['trustLevel'] as String,
        );
      },
    );
  }

  /// 완료 탭
  Widget _buildCompletedTab() {
    // 임시 완료 데이터
    final completedItems = [
      {
        'title': 'LG CNS 채용 설명회',
        'category': '취업',
        'completedDate': '2024.01.15',
        'result': '참석 완료',
        'trustLevel': 'official',
        'isSuccess': true,
      },
      {
        'title': '스타트업 경진대회',
        'category': '공모전',
        'completedDate': '2024.01.10',
        'result': '마감 종료',
        'trustLevel': 'academic',
        'isSuccess': false,
      },
    ];

    if (completedItems.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: '완료된 항목이 없어요',
        subtitle: '참여했던 대기열 기록이\n여기에 표시됩니다.',
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: completedItems.length,
      itemBuilder: (context, index) {
        final item = completedItems[index];
        return _buildCompletedCard(
          title: item['title'] as String,
          category: item['category'] as String,
          completedDate: item['completedDate'] as String,
          result: item['result'] as String,
          trustLevel: item['trustLevel'] as String,
          isSuccess: item['isSuccess'] as bool,
        );
      },
    );
  }

  /// 대기열 카드 (대기 중)
  Widget _buildQueueCard({
    required String title,
    required String category,
    required int position,
    required int totalWaiting,
    required String estimatedTime,
    required String deadline,
    required String trustLevel,
    required QueueStatus status,
  }) {
    final trustColor = AppColors.getTrustColor(trustLevel);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 상단 정보
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더 (카테고리, 마감일)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: trustColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: trustColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        deadline,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 제목
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 16.h),

                // 대기 정보
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.brandCrimsonLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      // 순서 정보
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              '$position',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandCrimson,
                              ),
                            ),
                            Text(
                              '내 순서',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.brandCrimson,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 구분선
                      Container(
                        width: 1.w,
                        height: 40.h,
                        color: AppColors.brandCrimson.withValues(alpha: 0.3),
                      ),

                      // 전체 대기자
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              '$totalWaiting',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandCrimson,
                              ),
                            ),
                            Text(
                              '전체 대기자',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.brandCrimson,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 구분선
                      Container(
                        width: 1.w,
                        height: 40.h,
                        color: AppColors.brandCrimson.withValues(alpha: 0.3),
                      ),

                      // 예상 시간
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              estimatedTime,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.brandCrimson,
                              ),
                            ),
                            Text(
                              '예상 대기',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.brandCrimson,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 하단 액션 버튼
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 대기열 취소
                      _showCancelDialog(title);
                    },
                    icon: Icon(Icons.close, size: 16.w),
                    label: Text(
                      '대기 취소',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: BorderSide(color: AppColors.error),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: 알림 설정
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('알림이 설정되었습니다!'),
                        ),
                      );
                    },
                    icon: Icon(Icons.notifications, size: 16.w),
                    label: Text(
                      '알림 설정',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 진행 중 카드
  Widget _buildProgressCard({
    required String title,
    required String category,
    required double progress,
    required String currentStep,
    required String nextStep,
    required String deadline,
    required String trustLevel,
  }) {
    final trustColor = AppColors.getTrustColor(trustLevel);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: trustColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: trustColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    deadline,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // 제목
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),

            // 진행률
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '진행률',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandCrimson,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.brandCrimsonLight,
                  valueColor: AlwaysStoppedAnimation(AppColors.brandCrimson),
                  minHeight: 6.h,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // 현재/다음 단계
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '현재 단계',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        currentStep,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 16.w,
                  color: AppColors.textSecondary,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '다음 단계',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        nextStep,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.brandCrimson,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 완료된 카드
  Widget _buildCompletedCard({
    required String title,
    required String category,
    required String completedDate,
    required String result,
    required String trustLevel,
    required bool isSuccess,
  }) {
    final trustColor = AppColors.getTrustColor(trustLevel);
    final resultColor = isSuccess ? AppColors.success : AppColors.textSecondary;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: trustColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: trustColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: resultColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.info,
                        size: 12.w,
                        color: resultColor,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        result,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: resultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // 제목
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),

            // 완료 날짜
            Text(
              '완료일: $completedDate',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.w,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 24.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 대기 취소 확인 다이얼로그
  void _showCancelDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대기 취소'),
        content: Text('$title\n대기열에서 나가시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니요'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('대기가 취소되었습니다')),
              );
            },
            child: const Text('예'),
          ),
        ],
      ),
    );
  }
}

/// 대기열 상태 열거형
enum QueueStatus {
  waiting,
  inProgress,
  completed,
}