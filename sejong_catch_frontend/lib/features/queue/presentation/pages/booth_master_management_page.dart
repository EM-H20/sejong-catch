import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/presentation/controllers/auth_state_controller.dart';
import '../../data/models/response/booth_master.dart';
import '../controllers/queue_controller.dart';

/// 🏷️ 부스 타입 관리 페이지 (Admin 전용)
///
/// 부스 타입(BoothMaster)의 생성, 수정, 삭제를 관리합니다.
/// - 부스 타입 목록 표시
/// - 새 부스 타입 추가
/// - 기존 부스 타입 수정/삭제
///
/// **권한**: admin 역할만 접근 가능
class BoothMasterManagementPage extends ConsumerStatefulWidget {
  const BoothMasterManagementPage({super.key});

  @override
  ConsumerState<BoothMasterManagementPage> createState() =>
      _BoothMasterManagementPageState();
}

class _BoothMasterManagementPageState
    extends ConsumerState<BoothMasterManagementPage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateControllerProvider);
    final queueState = ref.watch(queueControllerProvider);

    // 권한 체크: admin만 접근 가능
    final isAdmin = authState.currentUser?.role == 'admin';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('부스 타입 관리', style: AppTextStyles.headingBold20),
        centerTitle: true,
      ),
      body: !isAdmin
          ? _buildAccessDenied()
          : queueState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(queueState.boothMasters),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => _showCreateDialog(context),
              backgroundColor: AppColors.brandCrimson,
              child: Icon(Icons.add, color: AppColors.pureWhite),
            )
          : null,
    );
  }

  /// 접근 거부 화면
  Widget _buildAccessDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 64.sp, color: AppColors.textTertiary),
          AppSpacing.verticalSpaceMD,
          Text(
            '관리자만 접근할 수 있어요',
            style: AppTextStyles.bodySemiBold16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// 부스 타입 목록 콘텐츠
  Widget _buildContent(List<BoothMaster> boothMasters) {
    if (boothMasters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64.sp,
              color: AppColors.textTertiary,
            ),
            AppSpacing.verticalSpaceMD,
            Text(
              '아직 부스 타입이 없어요',
              style: AppTextStyles.bodySemiBold16.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              '+ 버튼을 눌러 새 타입을 추가하세요',
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: AppSpacing.screenPadding,
      itemCount: boothMasters.length,
      separatorBuilder: (context, index) => AppSpacing.verticalSpaceSM,
      itemBuilder: (context, index) {
        final master = boothMasters[index];
        return _BoothMasterCard(
          master: master,
          onEdit: () => _showEditDialog(context, master),
          onDelete: () => _showDeleteConfirm(context, master),
        );
      },
    );
  }

  /// 생성 다이얼로그
  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('새 부스 타입', style: AppTextStyles.titleSemiBold18),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '예: 음식, 게임, 포토존',
            hintStyle: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.brandCrimson, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty) return;

              Navigator.pop(context);

              final success = await ref
                  .read(queueControllerProvider.notifier)
                  .createBoothMaster(name);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? '부스 타입이 추가되었어요! 🎉' : '추가에 실패했어요 😢',
                    ),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            child: Text(
              '추가',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 수정 다이얼로그
  void _showEditDialog(BuildContext context, BoothMaster master) {
    final controller = TextEditingController(text: master.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('부스 타입 수정', style: AppTextStyles.titleSemiBold18),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '새 이름 입력',
            hintStyle: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textTertiary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.brandCrimson, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isEmpty || name == master.name) {
                Navigator.pop(context);
                return;
              }

              Navigator.pop(context);

              final success = await ref
                  .read(queueControllerProvider.notifier)
                  .updateBoothMaster(master.id, name);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? '수정 완료! ✏️' : '수정에 실패했어요 😢'),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            child: Text(
              '수정',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.brandCrimson,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _showDeleteConfirm(BuildContext context, BoothMaster master) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('정말 삭제할까요?', style: AppTextStyles.titleSemiBold18),
        content: Text(
          '"${master.name}" 타입을 삭제하면\n이 타입의 부스를 더 이상 만들 수 없어요.',
          style: AppTextStyles.bodyRegular14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await ref
                  .read(queueControllerProvider.notifier)
                  .deleteBoothMaster(master.id);

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? '삭제 완료! 🗑️'
                          : '삭제 실패! (이 타입을 사용하는 부스가 있을 수 있어요)',
                    ),
                    backgroundColor: success
                        ? AppColors.success
                        : AppColors.error,
                  ),
                );
              }
            },
            child: Text(
              '삭제',
              style: AppTextStyles.bodyMedium14.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 부스 타입 카드 위젯
class _BoothMasterCard extends StatelessWidget {
  final BoothMaster master;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BoothMasterCard({
    required this.master,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 아이콘
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: AppColors.brandCrimsonLight,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.category,
              color: AppColors.brandCrimson,
              size: 24.sp,
            ),
          ),

          AppSpacing.horizontalSpaceMD,

          // 이름
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(master.name, style: AppTextStyles.titleBold16),
                AppSpacing.verticalSpaceXS,
                Text(
                  'ID: ${master.id.substring(0, 8)}...',
                  style: AppTextStyles.bodyRegular12.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),

          // 수정 버튼
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, color: AppColors.textSecondary),
            tooltip: '수정',
          ),

          // 삭제 버튼
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: '삭제',
          ),
        ],
      ),
    );
  }
}
