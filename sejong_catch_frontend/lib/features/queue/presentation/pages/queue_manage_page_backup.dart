/// 🎛️ 큐 관리 페이지 (운영자 전용)
///
/// 권한 level 2 (Operator) 이상만 접근 가능
/// Features:
/// ✅ 실시간 대기열 모니터링
/// ✅ 참가자 호출/완료/취소 관리
/// ✅ 큐 상태 변경 (활성/일시정지/마감/종료)
/// ✅ 통계 대시보드
/// ✅ 86% 코드 감소 패턴 적용
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../controllers/queue_manage_controller.dart';
import '../widgets/ui/participant_list_item.dart';
import '../widgets/ui/queue_status_card.dart';
import '../widgets/ui/queue_stats_panel.dart';

class QueueManagePage extends ConsumerStatefulWidget {
  final String queueId;

  const QueueManagePage({super.key, required this.queueId});

  @override
  ConsumerState<QueueManagePage> createState() => _QueueManagePageState();
}

class _QueueManagePageState extends ConsumerState<QueueManagePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // 페이지 로드 시 큐 정보 불러오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(queueManageControllerProvider(widget.queueId).notifier)
          .loadQueueDetails();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // 🌈 상태 카드 (큐 기본 정보)
          _buildStatusCard(),

          // 📊 탭바
          _buildTabBar(),

          // 📋 탭 컨텐츠
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildParticipantsList(), // 대기자 목록
                _buildStatsPanel(), // 통계 대시보드
                _buildSettingsPanel(), // 설정 패널
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📱 앱바
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final state = ref.watch(queueManageControllerProvider(widget.queueId));

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.sp),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎛️ 큐 관리',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (state.selectedQueue != null)
            Text(
              state.selectedQueue!.title,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
        ],
      ),
      actions: [
        // 새로고침
        IconButton(
          onPressed: () => ref
              .read(queueManageControllerProvider(widget.queueId).notifier)
              .refresh(),
          icon: Icon(Icons.refresh, color: AppColors.brandCrimson, size: 24.sp),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  /// 🌈 상태 카드 (큐 기본 정보)
  Widget _buildStatusCard() {
    final state = ref.watch(queueManageControllerProvider(widget.queueId));

    if (state.selectedQueue == null) {
      return Container(
        height: 120.h,
        margin: EdgeInsets.all(16.w),
        child: const LoadingWidget(message: '큐 정보를 불러오고 있어요'),
      );
    }

    return QueueStatusCard(
      queue: state.selectedQueue!,
      onStatusChanged: (newStatus) => ref
          .read(queueManageControllerProvider(widget.queueId).notifier)
          .updateQueueStatus(newStatus),
    );
  }

  /// 📊 탭바
  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 16.sp),
                SizedBox(width: 4.w),
                Text('대기자', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 16.sp),
                SizedBox(width: 4.w),
                Text('통계', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, size: 16.sp),
                SizedBox(width: 4.w),
                Text('설정', style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        ],
        labelColor: AppColors.brandCrimson,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppColors.brandCrimson,
        indicatorWeight: 2.h,
      ),
    );
  }

  /// 🙋‍♂️ 대기자 목록 탭
  Widget _buildParticipantsList() {
    final state = ref.watch(queueManageControllerProvider(widget.queueId));

    // 로딩 상태
    if (state.isLoading) {
      return const LoadingWidget(message: '참가자 목록을 불러오고 있어요');
    }

    // 에러 상태
    if (state.error != null) {
      return AppErrorWidget(
        message: state.error!,
        onRetry: () => ref
            .read(queueManageControllerProvider(widget.queueId).notifier)
            .loadQueueDetails(),
      );
    }

    // 빈 상태
    if (state.participants.isEmpty) {
      return const AppEmptyWidget(
        title: '아직 대기자가 없어요',
        subtitle: '사용자들이 줄서기를 시작하면 여기에 표시됩니다',
        icon: Icons.people_outline,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(queueManageControllerProvider(widget.queueId).notifier)
          .refresh(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: state.participants.length,
        itemBuilder: (context, index) {
          final participant = state.participants[index];

          return ParticipantListItem(
            participant: participant,
            isOperatorMode: true,
            onCall: () => _callParticipant(participant.id),
            onComplete: () => _completeParticipant(participant.id),
            onCancel: () => _cancelParticipant(participant.id),
          );
        },
      ),
    );
  }

  /// 📊 통계 대시보드 탭
  Widget _buildStatsPanel() {
    final state = ref.watch(queueManageControllerProvider(widget.queueId));

    if (state.selectedQueue == null) {
      return const LoadingWidget(message: '통계를 계산하고 있어요');
    }

    return QueueStatsPanel(
      queue: state.selectedQueue!,
      participants: state.participants,
    );
  }

  /// ⚙️ 설정 패널 탭
  Widget _buildSettingsPanel() {
    final state = ref.watch(queueManageControllerProvider(widget.queueId));

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 큐 기본 설정
          _buildSettingsSection('기본 설정', [
            _buildSettingsTile(
              '최대 대기자 수',
              '${state.selectedQueue?.maxCapacity ?? 0}명',
              Icons.people,
              onTap: () => _showCapacityDialog(),
            ),
            _buildSettingsTile(
              '평균 서비스 시간',
              '${state.selectedQueue?.averageWaitTime ?? 0}분',
              Icons.timer,
              onTap: () => _showServiceTimeDialog(),
            ),
          ]),

          SizedBox(height: 24.h),

          // 위험 영역
          _buildSettingsSection('위험 영역', [
            _buildSettingsTile(
              '모든 대기자 취소',
              '큐를 초기화합니다',
              Icons.warning,
              isDestructive: true,
              onTap: () => _showClearQueueDialog(),
            ),
          ]),
        ],
      ),
    );
  }

  /// ⚙️ 설정 섹션
  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// ⚙️ 설정 타일
  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, {
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20.sp),
    );
  }

  /// 🔔 참가자 호출
  void _callParticipant(String participantId) {
    ref
        .read(queueManageControllerProvider(widget.queueId).notifier)
        .callParticipant(participantId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('참가자를 호출했어요! 📢'),
        backgroundColor: AppColors.brandCrimson,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  /// ✅ 참가자 완료 처리
  void _completeParticipant(String participantId) {
    ref
        .read(queueManageControllerProvider(widget.queueId).notifier)
        .completeParticipant(participantId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('서비스 완료 처리했어요! ✅'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  /// ❌ 참가자 취소
  void _cancelParticipant(String participantId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('대기 취소'),
        content: const Text('이 참가자를 대기열에서 제거하시겠어요?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(queueManageControllerProvider(widget.queueId).notifier)
                  .cancelParticipant(participantId);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('참가자를 취소했어요'),
                  backgroundColor: Colors.grey[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            },
            child: Text('제거하기', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  /// 📋 최대 인원 설정 다이얼로그
  void _showCapacityDialog() {
    // TODO: 구현
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('최대 인원 설정 기능 준비중')));
  }

  /// ⏱️ 서비스 시간 설정 다이얼로그
  void _showServiceTimeDialog() {
    // TODO: 구현
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('서비스 시간 설정 기능 준비중')));
  }

  /// 🚨 큐 초기화 확인 다이얼로그
  void _showClearQueueDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error, size: 24.sp),
            SizedBox(width: 8.w),
            const Text('위험한 작업'),
          ],
        ),
        content: const Text('모든 대기자를 취소하고 큐를 초기화합니다.\n이 작업은 되돌릴 수 없어요.'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref
                  .read(queueManageControllerProvider(widget.queueId).notifier)
                  .clearQueue();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('큐가 초기화되었어요'),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            },
            child: Text(
              '초기화',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
