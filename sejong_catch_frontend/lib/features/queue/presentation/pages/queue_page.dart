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
import '../../data/models/response/booth.dart';
import '../../data/models/response/my_queue_status.dart';

/// 📋 줄서기 페이지 - 축제/행사 부스 큐 관리
///
/// **API 연동 완료!**
/// - 부스 목록 조회: GET /catch/booths
/// - 대기열 등록: POST /catch/queues/enqueue
/// - 대기 취소: POST /catch/queues/cancel
/// - 내 대기 상태: POST /catch/queues/me-status
/// - 부스 관리 (관리자): PATCH /catch/booths/{boothId}/status
///
/// **디자인 토큰 100% 사용!**
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
          : _buildBody(),
      // 🔐 운영자/관리자만 FAB 표시
      floatingActionButton: _canCreateBooth(authState.currentUser?.role)
          ? _buildFAB()
          : null,
    );
  }

  /// 🔐 부스 생성 권한 확인
  ///
  /// **허용 역할**: operator, admin
  /// **차단 역할**: student, null (로그아웃)
  bool _canCreateBooth(String? roleString) {
    final role = UserRole.fromString(roleString);
    return role.canCreateQueue;
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
          Tab(text: '전체 부스'),
          Tab(text: '내 대기열'),
        ],
      ),
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [_buildAllBoothsTab(), _buildMyQueuesTab()],
    );
  }

  /// 📋 전체 부스 탭
  Widget _buildAllBoothsTab() {
    final state = ref.watch(queueControllerProvider);
    final booths = state.booths;

    if (booths.isEmpty) {
      return const AppEmptyWidget(
        title: '운영 중인 부스가 없어요',
        subtitle: '축제 기간에 다시 확인해보세요! 🎪',
        icon: Icons.event_busy,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(queueControllerProvider.notifier).refreshBooths();
      },
      color: AppColors.brandCrimson,
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: booths.length,
        separatorBuilder: (context, index) => AppSpacing.verticalSpaceMD,
        itemBuilder: (context, index) {
          final booth = booths[index];
          return QueueCard(
            booth: booth,
            onTap: () => _handleBoothTap(booth),
            masterName: state.getMasterName(booth.masterId),
          );
        },
      ),
    );
  }

  /// 🎫 내 대기열 탭
  Widget _buildMyQueuesTab() {
    final state = ref.watch(queueControllerProvider);
    final myStatuses = state.myQueueStatuses;

    if (myStatuses.isEmpty) {
      return const AppEmptyWidget(
        title: '참여 중인 부스가 없어요',
        subtitle: '전체 부스에서 줄서기를 시작해보세요! 🎯',
        icon: Icons.queue_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(queueControllerProvider.notifier).refreshMyStatuses();
      },
      color: AppColors.brandCrimson,
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: myStatuses.length,
        separatorBuilder: (context, index) => AppSpacing.verticalSpaceLG,
        itemBuilder: (context, index) {
          final boothId = myStatuses.keys.elementAt(index);
          final myStatus = myStatuses[boothId]!;
          final booth = state.booths.cast<Booth?>().firstWhere(
            (b) => b?.id == boothId,
            orElse: () => null,
          );

          return MyQueueCard(
            myStatus: myStatus,
            booth: booth,
            onCancel: () => _handleCancelQueue(myStatus, booth),
            masterName: booth != null
                ? state.getMasterName(booth.masterId)
                : null,
          );
        },
      ),
    );
  }

  /// 🎯 부스 탭 핸들러 (역할별 분기!)
  ///
  /// **운영자/관리자**: 부스 관리 바텀시트 (다음 호출, 상태 변경 등)
  /// **학생**: 줄서기 참여 다이얼로그
  void _handleBoothTap(Booth booth) {
    final authState = ref.read(authStateControllerProvider);
    final role = UserRole.fromString(authState.currentUser?.role);

    if (role.canCreateQueue) {
      // 🎛️ 운영자/관리자 → 부스 관리 바텀시트 (줄서기도 가능!)
      ManageQueueBottomSheet.show(
        context,
        booth: booth,
        onJoinQueue: booth.status == 'OPERATING'
            ? () => _handleJoinQueue(booth)
            : null,
      );
    } else {
      // 🎫 학생 → 줄서기 다이얼로그
      if (booth.status == 'OPERATING') {
        JoinQueueDialog.show(
          context,
          booth: booth,
          onConfirm: () => _handleJoinQueue(booth),
        );
      } else {
        final statusText = booth.status == 'PREPARING' ? '준비 중' : '종료';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${booth.title}은(는) 현재 $statusText 상태예요'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
  }

  /// ✅ 대기열 등록 (enqueue)
  ///
  /// **에러 처리**:
  /// - 409: 이미 대기 중 → 스낵바로 안내
  /// - 기타 에러 → 스낵바로 표시
  Future<void> _handleJoinQueue(Booth booth) async {
    final notifier = ref.read(queueControllerProvider.notifier);
    final isImmediate = await notifier.enqueue(booth.id);

    if (!mounted) return;

    // 에러 체크: state.error가 있으면 실패한 것
    final queueState = ref.read(queueControllerProvider);
    if (queueState.error != null) {
      // 🚨 에러 발생 → 스낵바로 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(queueState.error!),
          backgroundColor: AppColors.warning,
        ),
      );
      // 에러 클리어
      notifier.clearError();
      return;
    }

    // ✅ 성공!
    if (isImmediate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${booth.title} 즉시 입장! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${booth.title}에 줄서기 완료! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
      // WAITING일 때만 내 대기열 탭으로 이동
      _tabController.animateTo(1);
    }
  }

  /// ❌ 대기 취소
  void _handleCancelQueue(MyQueueStatus myStatus, Booth? booth) {
    CancelQueueDialog.show(
      context,
      myStatus: myStatus,
      booth: booth,
      onConfirm: () async {
        await ref
            .read(queueControllerProvider.notifier)
            .cancelQueue(myStatus.boothId);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${booth?.title ?? '부스'} 줄서기를 포기했어요'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  /// 🎈 플로팅 액션 버튼 (운영자용 부스 생성)
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: _showCreateBoothBottomSheet,
      backgroundColor: AppColors.brandCrimson,
      child: Icon(Icons.add_rounded, size: 32.sp, color: AppColors.pureWhite),
    );
  }

  /// 🏗️ 부스 생성 바텀시트
  void _showCreateBoothBottomSheet() {
    final state = ref.read(queueControllerProvider);

    CreateQueueBottomSheet.show(
      context,
      boothMasters: state.boothMasters,
      onCreate: (masterId, title, seatCount, avgWaitMinutes) async {
        final success = await ref
            .read(queueControllerProvider.notifier)
            .createBooth(
              masterId: masterId,
              title: title,
              seatCount: seatCount,
              avgWaitMinutes: avgWaitMinutes,
            );

        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title 부스가 생성되었어요! 🎉'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }
}
