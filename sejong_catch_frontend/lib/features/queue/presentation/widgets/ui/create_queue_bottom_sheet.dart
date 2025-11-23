import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import 'queue_type_chip.dart';

/// 🏗️ 큐 생성 바텀시트
///
/// 운영자가 새로운 큐를 생성하는 바텀시트입니다.
/// - 큐 이름 입력
/// - 큐 타입 선택 (음식/음료/게임/포토/기타)
/// - 평균 대기 시간 입력
/// - 생성 버튼
///
/// **디자인 토큰 100% 사용!**
class CreateQueueBottomSheet extends StatefulWidget {
  final Function(String name, String type, int avgWaitTime) onCreate;

  const CreateQueueBottomSheet({
    super.key,
    required this.onCreate,
  });

  /// 바텀시트 표시 헬퍼 메서드
  static Future<void> show(
    BuildContext context, {
    required Function(String name, String type, int avgWaitTime) onCreate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateQueueBottomSheet(onCreate: onCreate),
    );
  }

  @override
  State<CreateQueueBottomSheet> createState() => _CreateQueueBottomSheetState();
}

class _CreateQueueBottomSheetState extends State<CreateQueueBottomSheet> {
  final _nameController = TextEditingController();
  final _waitTimeController = TextEditingController();
  String _selectedType = 'food';

  @override
  void dispose() {
    _nameController.dispose();
    _waitTimeController.dispose();
    super.dispose();
  }

  bool get _canCreate {
    return _nameController.text.trim().isNotEmpty &&
        _waitTimeController.text.trim().isNotEmpty &&
        int.tryParse(_waitTimeController.text.trim()) != null;
  }

  void _handleCreate() {
    if (!_canCreate) return;

    final name = _nameController.text.trim();
    final avgWaitTime = int.parse(_waitTimeController.text.trim());

    widget.onCreate(name, _selectedType, avgWaitTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.r),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.modalPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 드래그 핸들
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),

                AppSpacing.verticalSpaceLG,

                // 제목
                Text(
                  '새 큐 만들기',
                  style: AppTextStyles.headingBold20,
                ),

                AppSpacing.verticalSpaceXL,

                // 큐 이름 입력
                Text(
                  '큐 이름',
                  style: AppTextStyles.labelMedium14,
                ),
                AppSpacing.verticalSpaceSM,
                AppTextField(
                  controller: _nameController,
                  hintText: '예: 치킨부스, 포토존',
                  onChanged: (_) => setState(() {}),
                ),

                AppSpacing.verticalSpaceXL,

                // 큐 타입 선택
                Text(
                  '큐 타입',
                  style: AppTextStyles.labelMedium14,
                ),
                AppSpacing.verticalSpaceSM,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    QueueTypeChips.food(
                      isSelected: _selectedType == 'food',
                      onTap: () => setState(() => _selectedType = 'food'),
                    ),
                    QueueTypeChips.drink(
                      isSelected: _selectedType == 'drink',
                      onTap: () => setState(() => _selectedType = 'drink'),
                    ),
                    QueueTypeChips.game(
                      isSelected: _selectedType == 'game',
                      onTap: () => setState(() => _selectedType = 'game'),
                    ),
                    QueueTypeChips.photo(
                      isSelected: _selectedType == 'photo',
                      onTap: () => setState(() => _selectedType = 'photo'),
                    ),
                    QueueTypeChips.other(
                      isSelected: _selectedType == 'other',
                      onTap: () => setState(() => _selectedType = 'other'),
                    ),
                  ],
                ),

                AppSpacing.verticalSpaceXL,

                // 평균 대기 시간 입력
                Text(
                  '평균 대기 시간 (분)',
                  style: AppTextStyles.labelMedium14,
                ),
                AppSpacing.verticalSpaceSM,
                AppTextField(
                  controller: _waitTimeController,
                  hintText: '예: 5',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),

                AppSpacing.verticalSpaceXXL,

                // 생성 버튼
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _canCreate ? _handleCreate : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandCrimson,
                      disabledBackgroundColor:
                          AppColors.brandCrimson.withValues(alpha: 0.3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      '큐 생성하기',
                      style: AppTextStyles.buttonSemiBold16.copyWith(
                        color: AppColors.pureWhite,
                      ),
                    ),
                  ),
                ),

                AppSpacing.verticalSpaceMD,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
