import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_divider.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../auth/data/models/user_role.dart';
import '../../../auth/presentation/controllers/auth_state_controller.dart';
import '../../../queue/presentation/controllers/queue_controller.dart';
import '../../../queue/data/models/response/booth.dart';
import '../../../queue/data/models/response/booth_manager.dart';
import '../../../queue/data/models/response/queue_entry.dart';

/// 🛡️ 관리자 페이지 - 부스 및 관리자 관리
///
/// **접근 권한**:
/// - `booth_manager`: 자신이 관리하는 부스만 조회/관리
/// - `admin`: 모든 부스 조회/관리, 관리자 추가/삭제
///
/// **기능**:
/// - 부스 목록 조회 (상태별 필터링)
/// - 부스 상태 변경 (PREPARING → OPERATING → ENDED)
/// - 부스 관리자 추가/삭제 (admin only)
class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedStatus = 'ALL';

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
    final authState = ref.watch(authStateControllerProvider);
    final userRole = UserRole.fromString(authState.currentUser?.role);
    final queueState = ref.watch(queueControllerProvider);

    // 🔐 권한 체크 (부스 관리자 또는 관리자만 접근 가능)
    if (!userRole.canCreateQueue) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: _buildAppBar(userRole),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64.sp,
                color: AppColors.textTertiary,
              ),
              AppSpacing.verticalSpaceLG,
              Text(
                '접근 권한이 없습니다',
                style: AppTextStyles.headingBold20.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.verticalSpaceSM,
              Text(
                '관리자 또는 부스 관리자만 접근할 수 있어요',
                style: AppTextStyles.bodyMedium14.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(userRole),
      body: queueState.isLoading
          ? const LoadingWidget()
          : queueState.error != null
          ? AppErrorWidget(message: queueState.error!)
          : _buildBody(queueState.booths, userRole),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar(UserRole userRole) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, size: 20.sp),
        onPressed: () => context.pop(),
      ),
      title: Row(
        children: [
          Icon(
            Icons.admin_panel_settings,
            color: AppColors.brandCrimson,
            size: 24.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            userRole.isAdmin ? '관리자 대시보드' : '부스 관리',
            style: AppTextStyles.headingBold20,
          ),
        ],
      ),
      backgroundColor: AppColors.white,
      elevation: 0,
      // 🏷️ admin만 부스 타입 관리 버튼 표시
      actions: userRole.isAdmin
          ? [
              IconButton(
                icon: Icon(
                  Icons.category_outlined,
                  color: AppColors.brandCrimson,
                  size: 24.sp,
                ),
                tooltip: '부스 타입 관리',
                onPressed: () => context.push(AppRoutes.boothMasterManagement),
              ),
              SizedBox(width: 8.w),
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(48.h),
        child: _buildStatusFilter(),
      ),
    );
  }

  /// 🏷️ 상태 필터
  Widget _buildStatusFilter() {
    final statuses = [
      ('ALL', '전체'),
      ('PREPARING', '준비중'),
      ('OPERATING', '운영중'),
      ('ENDED', '종료'),
    ];

    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final (status, label) = statuses[index];
          final isSelected = _selectedStatus == status;

          return FilterChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedStatus = status;
              });
            },
            backgroundColor: AppColors.white,
            selectedColor: AppColors.brandCrimson.withValues(alpha: 0.15),
            labelStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AppColors.brandCrimson
                  : AppColors.textSecondary,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.brandCrimson : AppColors.divider,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          );
        },
      ),
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(List<Booth> booths, UserRole userRole) {
    // 상태별 필터링
    final filteredBooths = _selectedStatus == 'ALL'
        ? booths
        : booths.where((b) => b.status == _selectedStatus).toList();

    if (filteredBooths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalSpaceLG,
            Text(
              '해당 상태의 부스가 없어요',
              style: AppTextStyles.bodySemiBold16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(queueControllerProvider.notifier).refreshBooths();
      },
      color: AppColors.brandCrimson,
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: filteredBooths.length,
        separatorBuilder: (context, index) => AppSpacing.verticalSpaceMD,
        itemBuilder: (context, index) {
          final booth = filteredBooths[index];
          return _buildBoothCard(booth, userRole);
        },
      ),
    );
  }

  /// 🏪 부스 카드
  Widget _buildBoothCard(Booth booth, UserRole userRole) {
    final statusColor = _getStatusColor(booth.status);
    final statusText = _getStatusText(booth.status);
    // QueueState에서 마스터 이름 조회
    final queueState = ref.read(queueControllerProvider);
    final masterName = queueState.getMasterName(booth.masterId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.basic,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: AppSpacing.cardPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 부스 이름 + 마스터 타입
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booth.title, style: AppTextStyles.titleSemiBold18),
                      if (masterName != null) ...[
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              masterName,
                              style: AppTextStyles.captionMedium11.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 4.h),
                      Text(
                        '좌석 ${booth.seatCount}석 · 평균 ${booth.avgWaitMinutes}분',
                        style: AppTextStyles.bodyMedium14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // 상태 배지
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppDivider.thin(),

          // 액션 버튼들
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // 상태 변경 버튼
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.sync_alt,
                    label: '상태 변경',
                    onTap: () => _showStatusChangeDialog(booth),
                  ),
                ),
                SizedBox(width: 12.w),
                // 대기열 관리 버튼
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.people_outline,
                    label: '대기열 보기',
                    onTap: () => _showQueueListDialog(booth),
                  ),
                ),
                // 관리자만: 관리자 관리 버튼
                if (userRole.isAdmin) ...[
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.person_add_alt,
                      label: '관리자',
                      highlightColor: AppColors.brandCrimson,
                      onTap: () => _showManagerDialog(booth),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔘 액션 버튼
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? highlightColor,
  }) {
    final color = highlightColor ?? AppColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16.sp, color: color),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 상태별 색상
  Color _getStatusColor(String status) {
    switch (status) {
      case 'PREPARING':
        return AppColors.warning;
      case 'OPERATING':
        return AppColors.success;
      case 'ENDED':
        return AppColors.textTertiary;
      default:
        return AppColors.textSecondary;
    }
  }

  /// 📝 상태별 텍스트
  String _getStatusText(String status) {
    switch (status) {
      case 'PREPARING':
        return '준비중';
      case 'OPERATING':
        return '운영중';
      case 'ENDED':
        return '종료';
      default:
        return status;
    }
  }

  /// 💬 상태 변경 다이얼로그
  void _showStatusChangeDialog(Booth booth) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('부스 상태 변경', style: AppTextStyles.headingBold20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${booth.title}의 상태를 변경합니다',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalSpaceLG,
            _buildStatusOption('PREPARING', '준비중', booth),
            AppSpacing.verticalSpaceSM,
            _buildStatusOption('OPERATING', '운영중', booth),
            AppSpacing.verticalSpaceSM,
            _buildStatusOption('ENDED', '종료', booth),
          ],
        ),
      ),
    );
  }

  /// 🔘 상태 옵션 버튼
  Widget _buildStatusOption(String status, String label, Booth booth) {
    final isSelected = status == booth.status;
    final color = _getStatusColor(status);

    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        if (status != booth.status) {
          final success = await ref
              .read(queueControllerProvider.notifier)
              .updateBoothStatus(booth.id, status);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success ? '부스 상태가 $label(으)로 변경되었어요' : '상태 변경에 실패했어요',
                ),
                backgroundColor: success ? color : AppColors.error,
              ),
            );
          }
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, size: 20.sp, color: color),
          ],
        ),
      ),
    );
  }

  /// 💬 대기열 목록 다이얼로그
  void _showQueueListDialog(Booth booth) {
    // 먼저 대기열 목록 조회
    ref.read(queueControllerProvider.notifier).fetchQueueList(booth.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _QueueListBottomSheet(booth: booth),
    );
  }

  /// 💬 관리자 관리 다이얼로그
  void _showManagerDialog(Booth booth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ManagerListBottomSheet(booth: booth),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 🎫 대기열 목록 바텀시트
// ═══════════════════════════════════════════════════════════════════════════

/// 대기열 목록을 보여주는 바텀시트
///
/// - 대기 중인 팀 목록 표시
/// - 다음 팀 입장 (rotate) 버튼
class _QueueListBottomSheet extends ConsumerWidget {
  final Booth booth;

  const _QueueListBottomSheet({required this.booth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueControllerProvider);
    final allEntries = queueState.queueEntries;

    // 🛡️ 방어 로직: 백엔드에서 COMPLETED/CANCELED가 포함되어 와도 UI에서 필터링
    final entries = allEntries
        .where((e) => e.state == 'WAITING' || e.state == 'IN_SERVICE')
        .toList();

    // 다음 팀 입장 가능 여부: WAITING 상태가 있어야 함
    final hasWaitingEntries = entries.any((e) => e.state == 'WAITING');

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들 바
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // 헤더
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.people_outline,
                  color: AppColors.brandCrimson,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${booth.title} 대기열',
                        style: AppTextStyles.headingBold20,
                      ),
                      Text(
                        '총 ${entries.length}팀 대기 중',
                        style: AppTextStyles.bodyMedium14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 24.sp),
                ),
              ],
            ),
          ),

          AppDivider.thin(),

          // 대기열 목록
          Flexible(
            child: queueState.isLoading
                ? const Center(child: LoadingWidget())
                : entries.isEmpty
                ? _buildEmptyState()
                : _buildQueueList(entries),
          ),

          // 다음 팀 입장 버튼: WAITING 상태가 있을 때만 표시
          if (hasWaitingEntries) _buildRotateButton(context, ref),
        ],
      ),
    );
  }

  /// 빈 상태
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64.sp,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              '대기 중인 팀이 없어요',
              style: AppTextStyles.bodySemiBold16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 대기열 목록
  Widget _buildQueueList(List<QueueEntry> entries) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: entries.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildQueueEntryCard(entry, index);
      },
    );
  }

  /// 대기열 항목 카드
  Widget _buildQueueEntryCard(QueueEntry entry, int index) {
    final stateColor = _getStateColor(entry.state);
    final stateText = _getStateText(entry.state);
    final isFirst = index == 0;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isFirst
            ? AppColors.brandCrimson.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFirst ? AppColors.brandCrimson : AppColors.divider,
          width: isFirst ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // 순번
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isFirst ? AppColors.brandCrimson : AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: AppTextStyles.buttonSemiBold15.copyWith(
                color: AppColors.pureWhite,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // 티켓 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '티켓 #${entry.ticketNo}',
                  style: AppTextStyles.bodySemiBold16,
                ),
                Text(
                  _formatTime(entry.joinedAt),
                  style: AppTextStyles.captionMedium11.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // 상태 배지
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: stateColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              stateText,
              style: AppTextStyles.captionBold12.copyWith(color: stateColor),
            ),
          ),
        ],
      ),
    );
  }

  /// 다음 팀 입장 버튼
  Widget _buildRotateButton(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              final success = await ref
                  .read(queueControllerProvider.notifier)
                  .rotateQueue(booth.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '다음 팀이 입장했어요! 🎉' : '입장 처리에 실패했어요'),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandCrimson,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            icon: Icon(
              Icons.arrow_forward,
              color: AppColors.pureWhite,
              size: 20.sp,
            ),
            label: Text(
              '다음 팀 입장',
              style: AppTextStyles.buttonSemiBold15.copyWith(
                color: AppColors.pureWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 상태별 색상
  Color _getStateColor(String state) {
    switch (state) {
      case 'WAITING':
        return AppColors.warning;
      case 'IN_SERVICE':
        return AppColors.success;
      case 'COMPLETED':
        return AppColors.textTertiary;
      case 'CANCELED':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  /// 상태별 텍스트
  String _getStateText(String state) {
    switch (state) {
      case 'WAITING':
        return '대기중';
      case 'IN_SERVICE':
        return '이용중';
      case 'COMPLETED':
        return '완료';
      case 'CANCELED':
        return '취소';
      default:
        return state;
    }
  }

  /// 시간 포맷팅
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} 등록';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 👨‍💼 관리자 목록 바텀시트
// ═══════════════════════════════════════════════════════════════════════════

/// 부스 관리자 목록을 보여주는 바텀시트
///
/// - 현재 관리자 목록 표시
/// - 관리자 추가 (userId 입력)
/// - 관리자 삭제
class _ManagerListBottomSheet extends ConsumerStatefulWidget {
  final Booth booth;

  const _ManagerListBottomSheet({required this.booth});

  @override
  ConsumerState<_ManagerListBottomSheet> createState() =>
      _ManagerListBottomSheetState();
}

class _ManagerListBottomSheetState
    extends ConsumerState<_ManagerListBottomSheet> {
  List<BoothManager> _managers = [];
  bool _isLoading = true;
  final _userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadManagers();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _loadManagers() async {
    setState(() => _isLoading = true);
    final managers = await ref
        .read(queueControllerProvider.notifier)
        .fetchBoothManagers(widget.booth.id);
    if (mounted) {
      setState(() {
        _managers = managers;
        _isLoading = false;
      });
    }
  }

  Future<void> _addManager() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('사용자 ID를 입력해주세요'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final result = await ref
        .read(queueControllerProvider.notifier)
        .addBoothManager(widget.booth.id, userId);

    if (!mounted) return;

    if (result != null) {
      _userIdController.clear();
      await _loadManagers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('관리자가 추가되었어요! 🎉'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('관리자 추가에 실패했어요'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _removeManager(BoothManager manager) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('관리자 삭제', style: AppTextStyles.headingBold20),
        content: Text(
          '${manager.userName ?? manager.userId}님을 관리자에서 삭제할까요?',
          style: AppTextStyles.bodyMedium14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('취소', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('삭제', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ref
        .read(queueControllerProvider.notifier)
        .removeBoothManager(widget.booth.id, manager.userId);

    if (!mounted) return;

    if (success) {
      await _loadManagers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('관리자가 삭제되었어요'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('관리자 삭제에 실패했어요'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들 바
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // 헤더
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.person_add_alt,
                  color: AppColors.brandCrimson,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.booth.title} 관리자',
                        style: AppTextStyles.headingBold20,
                      ),
                      Text(
                        '총 ${_managers.length}명의 관리자',
                        style: AppTextStyles.bodyMedium14.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, size: 24.sp),
                ),
              ],
            ),
          ),

          AppDivider.thin(),

          // 관리자 추가 입력
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userIdController,
                    decoration: InputDecoration(
                      hintText: '추가할 사용자 ID (학번)',
                      hintStyle: AppTextStyles.bodyMedium14.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.divider),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.brandCrimson),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: _addManager,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandCrimson,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    '추가',
                    style: AppTextStyles.buttonSemiBold15.copyWith(
                      color: AppColors.pureWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppDivider.thin(),

          // 관리자 목록
          Flexible(
            child: _isLoading
                ? const Center(child: LoadingWidget())
                : _managers.isEmpty
                ? _buildEmptyState()
                : _buildManagerList(),
          ),
        ],
      ),
    );
  }

  /// 빈 상태
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64.sp,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              '등록된 관리자가 없어요',
              style: AppTextStyles.bodySemiBold16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '위에서 사용자 ID를 입력해 추가해주세요',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 관리자 목록
  Widget _buildManagerList() {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: _managers.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final manager = _managers[index];
        return _buildManagerCard(manager);
      },
    );
  }

  /// 관리자 카드
  Widget _buildManagerCard(BoothManager manager) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // 아바타
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.brandCrimson.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person,
              size: 24.sp,
              color: AppColors.brandCrimson,
            ),
          ),
          SizedBox(width: 12.w),

          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  manager.userName ?? '관리자',
                  style: AppTextStyles.bodySemiBold16,
                ),
                Text(
                  manager.userEmail ?? manager.userId,
                  style: AppTextStyles.captionMedium11.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // 삭제 버튼
          IconButton(
            onPressed: () => _removeManager(manager),
            icon: Icon(
              Icons.remove_circle_outline,
              size: 24.sp,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
