import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../data/models/response/booth_master.dart';

/// 🏗️ 부스 생성 바텀시트
///
/// 운영자가 새로운 부스를 생성하는 바텀시트입니다.
/// - 부스 타입 선택 (BoothMaster)
/// - 부스 이름 입력
/// - 좌석 수 입력
/// - 평균 대기 시간 입력
/// - 생성 버튼
///
/// **API: POST /catch/booths (CreateBoothRequest)**
/// **디자인 토큰 100% 사용!**
class CreateQueueBottomSheet extends StatefulWidget {
  /// 부스 타입 목록 (드롭다운에 표시)
  final List<BoothMaster> boothMasters;

  /// 부스 생성 콜백 (masterId, title, seatCount, avgWaitMinutes)
  final Function(String masterId, String title, int seatCount, int avgWaitMinutes)
      onCreate;

  const CreateQueueBottomSheet({
    super.key,
    required this.boothMasters,
    required this.onCreate,
  });

  /// 바텀시트 표시 헬퍼 메서드
  static Future<void> show(
    BuildContext context, {
    required List<BoothMaster> boothMasters,
    required Function(String masterId, String title, int seatCount, int avgWaitMinutes)
        onCreate,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateQueueBottomSheet(
        boothMasters: boothMasters,
        onCreate: onCreate,
      ),
    );
  }

  @override
  State<CreateQueueBottomSheet> createState() => _CreateQueueBottomSheetState();
}

class _CreateQueueBottomSheetState extends State<CreateQueueBottomSheet> {
  final _titleController = TextEditingController();
  final _seatCountController = TextEditingController();
  final _waitTimeController = TextEditingController();

  /// 선택된 부스 타입
  BoothMaster? _selectedBoothMaster;

  @override
  void initState() {
    super.initState();
    // 기본값 설정
    _seatCountController.text = '4';
    _waitTimeController.text = '10';

    // 부스 타입이 하나뿐이면 자동 선택
    if (widget.boothMasters.length == 1) {
      _selectedBoothMaster = widget.boothMasters.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _seatCountController.dispose();
    _waitTimeController.dispose();
    super.dispose();
  }

  bool get _canCreate {
    return _selectedBoothMaster != null &&
        _titleController.text.trim().isNotEmpty &&
        _seatCountController.text.trim().isNotEmpty &&
        _waitTimeController.text.trim().isNotEmpty &&
        int.tryParse(_seatCountController.text.trim()) != null &&
        int.tryParse(_waitTimeController.text.trim()) != null;
  }

  void _handleCreate() {
    if (!_canCreate) return;

    final masterId = _selectedBoothMaster!.id;
    final title = _titleController.text.trim();
    final seatCount = int.parse(_seatCountController.text.trim());
    final avgWaitMinutes = int.parse(_waitTimeController.text.trim());

    widget.onCreate(masterId, title, seatCount, avgWaitMinutes);
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
                  '새 부스 만들기',
                  style: AppTextStyles.headingBold20,
                ),

                AppSpacing.verticalSpaceXL,

                // 🏷️ 부스 타입 선택 (드롭다운)
                Text(
                  '부스 타입',
                  style: AppTextStyles.labelMedium14,
                ),
                AppSpacing.verticalSpaceSM,
                _buildBoothMasterDropdown(),

                AppSpacing.verticalSpaceXL,

                // 부스 이름 입력
                Text(
                  '부스 이름',
                  style: AppTextStyles.labelMedium14,
                ),
                AppSpacing.verticalSpaceSM,
                AppTextField(
                  controller: _titleController,
                  hintText: '예: 🍗 치킨부스, 🍺 주점',
                  onChanged: (_) => setState(() {}),
                ),

                AppSpacing.verticalSpaceXL,

                // 좌석 수와 평균 대기 시간 (가로 배치)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '좌석 수',
                            style: AppTextStyles.labelMedium14,
                          ),
                          AppSpacing.verticalSpaceSM,
                          AppTextField(
                            controller: _seatCountController,
                            hintText: '4',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.horizontalSpaceMD,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '평균 대기 (분)',
                            style: AppTextStyles.labelMedium14,
                          ),
                          AppSpacing.verticalSpaceSM,
                          AppTextField(
                            controller: _waitTimeController,
                            hintText: '10',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                      '부스 생성하기',
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

  /// 🏷️ 부스 타입 드롭다운 위젯
  Widget _buildBoothMasterDropdown() {
    // 부스 타입이 없으면 안내 메시지
    if (widget.boothMasters.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.warning),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded,
                color: AppColors.warning, size: 20.sp),
            AppSpacing.horizontalSpaceSM,
            Expanded(
              child: Text(
                '부스 타입이 없습니다. 관리자에게 문의하세요.',
                style: AppTextStyles.bodyMedium14.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _selectedBoothMaster != null
              ? AppColors.brandCrimson
              : AppColors.divider,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BoothMaster>(
          value: _selectedBoothMaster,
          isExpanded: true,
          hint: Text(
            '부스 타입을 선택하세요',
            style: AppTextStyles.bodyMedium14.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 24.sp,
          ),
          items: widget.boothMasters.map((master) {
            return DropdownMenuItem<BoothMaster>(
              value: master,
              child: Text(
                master.name,
                style: AppTextStyles.bodyMedium14,
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBoothMaster = value;
            });
          },
        ),
      ),
    );
  }
}
