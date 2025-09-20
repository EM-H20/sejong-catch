import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../controllers/queue_manage_controller.dart';
import 'participant_list_item.dart';

/// 🙋‍♂️ 대기자 목록 탭 컴포넌트
///
/// CLAUDE.md 원칙:
/// ✅ 재사용 가능한 탭 위젯
/// ✅ ScreenUtil 반응형 디자인
/// ✅ 분리된 단일 책임 컴포넌트
class ParticipantsTab extends ConsumerWidget {
  const ParticipantsTab({
    super.key,
    required this.queueId,
    required this.onCallParticipant,
    required this.onCompleteParticipant,
    required this.onCancelParticipant,
  });

  final String queueId;
  final Function(String participantId) onCallParticipant;
  final Function(String participantId) onCompleteParticipant;
  final Function(String participantId) onCancelParticipant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queueManageControllerProvider(queueId));

    // 로딩 상태
    if (state.isLoading) {
      return const LoadingWidget(message: '참가자 목록을 불러오고 있어요');
    }

    // 에러 상태
    if (state.error != null) {
      return AppErrorWidget(
        message: state.error!,
        onRetry: () => ref
            .read(queueManageControllerProvider(queueId).notifier)
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
          .read(queueManageControllerProvider(queueId).notifier)
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
            onCall: () => onCallParticipant(participant.id),
            onComplete: () => onCompleteParticipant(participant.id),
            onCancel: () => onCancelParticipant(participant.id),
          );
        },
      ),
    );
  }
}