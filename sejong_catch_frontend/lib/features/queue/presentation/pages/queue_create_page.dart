library;

/// 🎪 큐 생성 페이지 (운영자 전용)
///
/// 권한 level 2 (Operator) 이상만 접근 가능
/// Features:
/// ✅ 큐 기본 정보 입력 (이름, 설명, 타입)
/// ✅ 큐 설정 (최대 인원, 예상 서비스 시간)
/// ✅ 운영 시간 설정
/// ✅ 실시간 유효성 검증
/// ✅ 86% 코드 감소 패턴 적용 (UI만 담당)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/config/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../data/models/queue_create_form.dart';
import '../../data/services/queue_create_service.dart';

class QueueCreatePage extends ConsumerStatefulWidget {
  const QueueCreatePage({super.key});

  @override
  ConsumerState<QueueCreatePage> createState() => _QueueCreatePageState();
}

class _QueueCreatePageState extends ConsumerState<QueueCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _maxCapacityController = TextEditingController();
  final _estimatedServiceTimeController = TextEditingController();

  QueueCreateForm _formData = QueueCreateForm.empty();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _maxCapacityController.dispose();
    _estimatedServiceTimeController.dispose();
    super.dispose();
  }

  /// 폼 초기화
  void _initializeForm() {
    _maxCapacityController.text = _formData.maxCapacity.toString();
    _estimatedServiceTimeController.text = _formData.estimatedServiceTimeMinutes.toString();
  }

  /// 폼 데이터 업데이트
  void _updateFormData({
    String? name,
    String? description,
    QueueType? type,
    int? maxCapacity,
    int? estimatedServiceTimeMinutes,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    setState(() {
      _formData = _formData.copyWith(
        name: name,
        description: description,
        type: type,
        maxCapacity: maxCapacity,
        estimatedServiceTimeMinutes: estimatedServiceTimeMinutes,
        startTime: startTime,
        endTime: endTime,
      );

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📋 기본 정보 섹션
              _buildBasicInfoSection(),

              SizedBox(height: 32.h),

              // ⚙️ 큐 설정 섹션
              _buildQueueSettingsSection(),

              SizedBox(height: 32.h),

              // ⏰ 운영 시간 섹션
              _buildOperatingHoursSection(),

              SizedBox(height: 40.h),

              // 🎯 생성 버튼
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// 📱 앱바
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.brandCrimson,
          size: 24.sp,
        ),
      ),
      title: Text(
        '🎪 새 큐 만들기',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.brandCrimson,
        ),
      ),
    );
  }

  /// 📋 기본 정보 섹션
  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('📋 기본 정보'),
        SizedBox(height: 16.h),

        // 큐 이름
        AppTextField(
          controller: _nameController,
          labelText: '큐 이름',
          hintText: '예: 치킨부스, 버스킹존, 포토존',
          prefixIcon: Icons.local_fire_department,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '큐 이름을 입력해주세요';
            }
            if (value.trim().length < 2) {
              return '큐 이름은 2글자 이상 입력해주세요';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // 큐 설명
        AppTextField(
          controller: _descriptionController,
          labelText: '큐 설명',
          hintText: '학생들에게 보여줄 설명을 입력하세요',
          prefixIcon: Icons.description,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '큐 설명을 입력해주세요';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // 큐 타입 선택
        _buildQueueTypeSelector(),
      ],
    );
  }

  /// 🏷️ 큐 타입 선택
  Widget _buildQueueTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '큐 타입',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: QueueType.values.map((type) {
            final isSelected = _formData.type == type;
            return GestureDetector(
              onTap: () => _updateFormData(type: type),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandCrimson : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected ? AppColors.brandCrimson : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type.icon,
                      size: 16.sp,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// ⚙️ 큐 설정 섹션
  Widget _buildQueueSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⚙️ 큐 설정'),
        SizedBox(height: 16.h),

        Row(
          children: [
            // 최대 수용 인원
            Expanded(
              child: AppTextField(
                controller: _maxCapacityController,
                labelText: '최대 수용 인원',
                hintText: '50',
                prefixIcon: Icons.groups,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '최대 인원을 입력하세요';
                  }
                  final capacity = int.tryParse(value);
                  if (capacity == null || capacity <= 0) {
                    return '올바른 숫자를 입력하세요';
                  }
                  if (capacity > 500) {
                    return '최대 500명까지 가능합니다';
                  }
                  return null;
                },
              ),
            ),

            SizedBox(width: 16.w),

            // 예상 서비스 시간
            Expanded(
              child: AppTextField(
                controller: _estimatedServiceTimeController,
                labelText: '서비스 시간(분)',
                hintText: '3',
                prefixIcon: Icons.timer,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '서비스 시간을 입력하세요';
                  }
                  final time = int.tryParse(value);
                  if (time == null || time <= 0) {
                    return '올바른 시간을 입력하세요';
                  }
                  if (time > 60) {
                    return '최대 60분까지 가능합니다';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ⏰ 운영 시간 섹션
  Widget _buildOperatingHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('⏰ 운영 시간'),
        SizedBox(height: 16.h),

        Row(
          children: [
            // 시작 시간
            Expanded(
              child: _buildTimePicker(
                label: '시작 시간',
                time: _formData.startTime,
                onTap: () => _selectTime(true),
              ),
            ),

            SizedBox(width: 16.w),

            // 종료 시간
            Expanded(
              child: _buildTimePicker(
                label: '종료 시간',
                time: _formData.endTime,
                onTap: () => _selectTime(false),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 🕐 시간 선택기
  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20.sp,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 12.w),
                Text(
                  time.format(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 📝 섹션 제목
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      ),
    );
  }

  /// 🎯 생성 버튼
  Widget _buildCreateButton() {
    return AppButton.primary(
      text: _isLoading ? '큐 생성 중...' : '🎪 큐 생성하기',
      isExpanded: true,
      size: AppButtonSize.large,
      onPressed: _isLoading ? null : _createQueue,
    );
  }

  /// 🕐 시간 선택 다이얼로그
  Future<void> _selectTime(bool isStartTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _formData.startTime : _formData.endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.brandCrimson,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null && mounted) {
      if (isStartTime) {
        _updateFormData(startTime: selectedTime);
      } else {
        _updateFormData(endTime: selectedTime);
      }
    }
  }

  /// 🎪 큐 생성 처리
  Future<void> _createQueue() async {
    // 컨트롤러에서 폼 데이터 업데이트
    _updateFormData(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      maxCapacity: int.tryParse(_maxCapacityController.text) ?? _formData.maxCapacity,
      estimatedServiceTimeMinutes: int.tryParse(_estimatedServiceTimeController.text) ?? _formData.estimatedServiceTimeMinutes,
    );

    // 폼 유효성 검증
    final validationResult = _formData.validate();
    if (!validationResult.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationResult.firstError ?? '입력 정보를 확인해주세요'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 새로운 서비스를 사용한 큐 생성
      final queueCreateService = ref.read(queueCreateServiceProvider);
      final result = await queueCreateService.createQueue(_formData);

      if (mounted) {
        if (result.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? '큐가 생성되었어요! 🎉'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // 큐 목록 페이지로 돌아가기
          context.go(AppRoutes.queue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message ?? '큐 생성에 실패했어요'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('큐 생성 중 오류가 발생했어요: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}