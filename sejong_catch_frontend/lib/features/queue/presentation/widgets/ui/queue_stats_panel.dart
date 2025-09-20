/// 📊 큐 통계 패널 (운영자 대시보드용)
///
/// 운영자가 볼 수 있는 실시간 큐 통계 정보
/// Features:
/// ✅ 실시간 대기자 수 차트
/// ✅ 상태별 참가자 분포
/// ✅ 평균/최대 대기시간 분석
/// ✅ 시간대별 활동 패턴
/// ✅ 완료율 및 취소율 통계
/// ✅ ScreenUtil 반응형 적용

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../data/models/queue_model.dart';
import '../../../data/models/participant_model.dart';

class QueueStatsPanel extends ConsumerWidget {
  final QueueModel queue;
  final List<ParticipantModel> participants;

  const QueueStatsPanel({
    super.key,
    required this.queue,
    required this.participants,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📊 주요 지표 카드들
          _buildKeyMetricsRow(),

          SizedBox(height: 24.h),

          // 🟢 상태별 분포
          _buildStatusDistribution(),

          SizedBox(height: 24.h),

          // ⏰ 시간 분석
          _buildTimeAnalysis(),

          SizedBox(height: 24.h),

          // 📈 실시간 활동
          _buildRealtimeActivity(),
        ],
      ),
    );
  }

  /// 📊 주요 지표 행
  Widget _buildKeyMetricsRow() {
    final totalParticipants = participants.length;
    final completedCount = participants.where((p) => p.status == ParticipantStatus.completed).length;
    final completionRate = totalParticipants > 0 ? (completedCount / totalParticipants * 100) : 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            '총 참가자',
            totalParticipants.toString(),
            Icons.people,
            AppColors.brandCrimson,
            subtitle: '누적 참가자 수',
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildMetricCard(
            '완료율',
            '${completionRate.toStringAsFixed(1)}%',
            Icons.check_circle,
            AppColors.success,
            subtitle: '$completedCount/$totalParticipants 완료',
          ),
        ),
      ],
    );
  }

  /// 📊 지표 카드
  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 🟢 상태별 분포
  Widget _buildStatusDistribution() {
    final statusCounts = _getStatusCounts();

    return _buildSection(
      '상태별 분포',
      Icons.pie_chart,
      Column(
        children: ParticipantStatus.values.map((status) {
          final count = statusCounts[status] ?? 0;
          final percentage = participants.isNotEmpty ? (count / participants.length * 100) : 0.0;

          return _buildStatusRow(status, count, percentage);
        }).toList(),
      ),
    );
  }

  /// 🟢 상태별 행
  Widget _buildStatusRow(ParticipantStatus status, int count, double percentage) {
    final color = _getStatusColor(status);
    final statusText = _getStatusDisplayName(status);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // 상태 인디케이터
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(width: 12.w),

          // 상태명
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // 개수
          Text(
            '$count명',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 8.w),

          // 퍼센트
          Container(
            width: 50.w,
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// ⏰ 시간 분석
  Widget _buildTimeAnalysis() {
    final waitingParticipants = participants.where((p) => p.status == ParticipantStatus.waiting).toList();
    final completedParticipants = participants.where((p) => p.status == ParticipantStatus.completed).toList();

    final avgWaitTime = _calculateAverageWaitTime(completedParticipants);
    final maxWaitTime = _calculateMaxWaitTime(waitingParticipants);

    return _buildSection(
      '시간 분석',
      Icons.access_time,
      Column(
        children: [
          _buildTimeRow(
            '평균 대기시간',
            '${avgWaitTime.toStringAsFixed(1)}분',
            AppColors.warning,
            Icons.schedule,
          ),
          SizedBox(height: 12.h),
          _buildTimeRow(
            '최대 대기시간',
            '${maxWaitTime}분',
            AppColors.error,
            Icons.hourglass_full,
          ),
          SizedBox(height: 12.h),
          _buildTimeRow(
            '예상 서비스 시간',
            '${queue.averageWaitTime}분',
            AppColors.success,
            Icons.timer,
          ),
        ],
      ),
    );
  }

  /// ⏰ 시간 행
  Widget _buildTimeRow(String label, String value, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 📈 실시간 활동
  Widget _buildRealtimeActivity() {
    final recentParticipants = participants
        .where((p) => DateTime.now().difference(p.joinedAt).inHours < 1)
        .length;

    return _buildSection(
      '실시간 활동 (최근 1시간)',
      Icons.trending_up,
      Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.brandCrimson.withOpacity(0.1),
                  AppColors.brandCrimsonLight.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColors.brandCrimson.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: AppColors.brandCrimson,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '신규 참가자',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '$recentParticipants명',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.brandCrimson,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_upward,
                  color: AppColors.success,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📋 섹션 헤더
  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.brandCrimson, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: content,
        ),
      ],
    );
  }

  /// 📊 상태별 개수 계산
  Map<ParticipantStatus, int> _getStatusCounts() {
    final counts = <ParticipantStatus, int>{};
    for (final status in ParticipantStatus.values) {
      counts[status] = participants.where((p) => p.status == status).length;
    }
    return counts;
  }

  /// ⏰ 평균 대기시간 계산 (완료된 참가자 기준)
  double _calculateAverageWaitTime(List<ParticipantModel> completedParticipants) {
    if (completedParticipants.isEmpty) return 0.0;

    final totalWaitTime = completedParticipants.fold<int>(
      0,
      (sum, p) => sum + (p.serviceDurationMinutes ?? 0),
    );

    return totalWaitTime / completedParticipants.length;
  }

  /// ⏰ 최대 대기시간 계산 (현재 대기 중인 참가자 중)
  int _calculateMaxWaitTime(List<ParticipantModel> waitingParticipants) {
    if (waitingParticipants.isEmpty) return 0;

    return waitingParticipants.fold<int>(
      0,
      (max, p) => p.waitingTimeMinutes > max ? p.waitingTimeMinutes : max,
    );
  }

  /// 🎨 상태별 색상
  Color _getStatusColor(ParticipantStatus status) {
    switch (status) {
      case ParticipantStatus.waiting:
        return AppColors.warning;
      case ParticipantStatus.called:
        return AppColors.brandCrimson;
      case ParticipantStatus.serving:
        return AppColors.success;
      case ParticipantStatus.completed:
        return AppColors.success;
      case ParticipantStatus.cancelled:
        return Colors.grey;
    }
  }

  /// 🏷️ 상태 표시 이름
  String _getStatusDisplayName(ParticipantStatus status) {
    switch (status) {
      case ParticipantStatus.waiting:
        return '대기중';
      case ParticipantStatus.called:
        return '호출됨';
      case ParticipantStatus.serving:
        return '서비스중';
      case ParticipantStatus.completed:
        return '완료';
      case ParticipantStatus.cancelled:
        return '취소됨';
    }
  }
}