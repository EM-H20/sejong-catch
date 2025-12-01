import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../auth/data/models/user_role.dart';
import '../../../auth/presentation/controllers/auth_state_controller.dart';
import '../controllers/queue_controller.dart';
import '../widgets/ui/queue_card.dart';
import '../widgets/ui/my_queue_card.dart';
import '../widgets/ui/join_queue_dialog.dart';
import '../widgets/ui/cancel_queue_dialog.dart';
import '../widgets/ui/create_queue_bottom_sheet.dart';
import '../widgets/ui/manage_queue_bottom_sheet.dart';
import '../../data/models/response/queue_item.dart';
import '../../data/models/response/my_queue_item.dart';

/// 📋 줄서기 페이지 - 축제/행사 큐 관리
///
/// **리팩토링 완료!**
/// - 919줄 → 깔끔한 구조로 대폭 축소
/// - 디자인 토큰 100% 적용
/// - 재사용 가능한 컴포넌트로 분리
/// - Riverpod 상태 관리 통합
class QueuePage extends ConsumerStatefulWidget {
  const QueuePage({super.key});

  @override
  ConsumerState<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends ConsumerState<QueuePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(queueControllerProvider);
    final authState = ref.watch(authStateControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(),
      body: state.isLoading
          ? const LoadingWidget()
          : state.error != null
              ? AppErrorWidget(message: state.error!)
              : state.isUnderDevelopment
                  ? _buildUnderDevelopmentMessage()
                  : _buildBody(),
      // 🔐 운영자/관리자만 FAB 표시 (개발 중일 때는 숨김)
      floatingActionButton:
          !state.isUnderDevelopment && _canCreateQueue(authState.currentUser?.role)
              ? _buildFAB()
              : null,
    );
  }

  /// 🔐 큐 생성 권한 확인
  ///
  /// **허용 역할**: operator, admin
  /// **차단 역할**: student, null (로그아웃)
  bool _canCreateQueue(String? roleString) {
    final role = UserRole.fromString(roleString);
    return role.canCreateQueue;
  }

  /// 🚧 개발 중 메시지 (Real 모드 + API 미구현)
  Widget _buildUnderDevelopmentMessage() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 80.sp,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalSpaceLG,
            Text(
              '🚧 아직 개발 중입니다',
              style: AppTextStyles.headingBold20.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSpaceMD,
            Text(
              '줄서기 기능은 현재 준비 중이에요.\n곧 만나볼 수 있어요! 🎉',
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Text(
            '세종 캐치',
            style: AppTextStyles.headingBold20.copyWith(
              color: AppColors.brandCrimson,
            ),
          ),
          SizedBox(width: 6.w),
          Text('줄서기', style: AppTextStyles.headingBold20),
        ],
      ),
      backgroundColor: AppColors.white,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        onTap: (index) {
          ref.read(queueControllerProvider.notifier).changeTab(index);
        },
        indicatorColor: AppColors.brandCrimson,
        labelColor: AppColors.brandCrimson,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.buttonSemiBold15.copyWith(
          color: AppColors.brandCrimson,
        ),
        unselectedLabelStyle: AppTextStyles.buttonMedium15,
        tabs: const [
          Tab(text: '전체 큐'),
          Tab(text: '내 대기열'),
        ],
      ),
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [_buildAllQueuesTab(), _buildMyQueuesTab()],
    );
  }

  /// 📋 전체 큐 탭
  Widget _buildAllQueuesTab() {
    final state = ref.watch(queueControllerProvider);
    final queues = state.allQueues;

    if (queues.isEmpty) {
      return const AppEmptyWidget(
        title: '운영 중인 큐가 없어요',
        subtitle: '축제 기간에 다시 확인해보세요! 🎪',
        icon: Icons.event_busy,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(queueControllerProvider.notifier).refreshQueues();
      },
      color: AppColors.brandCrimson,
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: queues.length,
        separatorBuilder: (context, index) => AppSpacing.verticalSpaceMD,
        itemBuilder: (context, index) {
          final queue = queues[index];
          return QueueCard(queue: queue, onTap: () => _handleQueueTap(queue));
        },
      ),
    );
  }

  /// 🎫 내 대기열 탭
  Widget _buildMyQueuesTab() {
    final state = ref.watch(queueControllerProvider);
    final myQueues = state.myQueues;

    if (myQueues.isEmpty) {
      return const AppEmptyWidget(
        title: '참여 중인 큐가 없어요',
        subtitle: '전체 큐에서 줄서기를 시작해보세요! 🎯',
        icon: Icons.queue_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(queueControllerProvider.notifier).refreshQueues();
      },
      color: AppColors.brandCrimson,
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: myQueues.length,
        separatorBuilder: (context, index) => AppSpacing.verticalSpaceLG,
        itemBuilder: (context, index) {
          final myQueue = myQueues[index];
          return MyQueueCard(
            myQueue: myQueue,
            onCancel: () => _handleCancelQueue(myQueue),
          );
        },
      ),
    );
  }

  /// 🎯 큐 탭 핸들러 (역할별 분기!)
  ///
  /// **운영자/관리자**: 큐 관리 바텀시트 (다음 호출, 일시정지, 마감 등)
  /// **학생**: 줄서기 참여 다이얼로그
  void _handleQueueTap(QueueItem queue) {
    final authState = ref.read(authStateControllerProvider);
    final role = UserRole.fromString(authState.currentUser?.role);

    if (role.canCreateQueue) {
      // 🎛️ 운영자/관리자 → 큐 관리 바텀시트
      ManageQueueBottomSheet.show(context, queue: queue);
    } else {
      // 🎫 학생 → 기존 줄서기 다이얼로그
      if (queue.status == 'active') {
        JoinQueueDialog.show(
          context,
          queue: queue,
          onConfirm: () => _handleJoinQueue(queue),
        );
      } else {
        final statusText = queue.status == 'paused' ? '일시정지' : '마감';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${queue.name}은(는) 현재 $statusText 상태예요'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
  }

  /// ✅ 큐 참여
  Future<void> _handleJoinQueue(QueueItem queue) async {
    await ref.read(queueControllerProvider.notifier).joinQueue(queue.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${queue.name}에 줄서기 완료! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );

      // 내 대기열 탭으로 이동
      _tabController.animateTo(1);
    }
  }

  /// ❌ 큐 포기
  void _handleCancelQueue(MyQueueItem myQueue) {
    CancelQueueDialog.show(
      context,
      myQueue: myQueue,
      onConfirm: () async {
        await ref
            .read(queueControllerProvider.notifier)
            .cancelQueue(myQueue.id);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${myQueue.name} 줄서기를 포기했어요'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  /// 🎈 플로팅 액션 버튼 (운영자용 큐 생성)
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _showCreateQueueBottomSheet,
      backgroundColor: AppColors.brandCrimson,
      child: Icon(Icons.add_rounded, size: 32.sp, color: AppColors.pureWhite),
    );
  }

  /// 🏗️ 큐 생성 바텀시트
  void _showCreateQueueBottomSheet() {
    CreateQueueBottomSheet.show(
      context,
      onCreate: (name, type, avgWaitTime) async {
        await ref
            .read(queueControllerProvider.notifier)
            .createQueue(name: name, type: type, avgWaitTime: avgWaitTime);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$name 큐가 생성되었어요! 🎉'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }
}
