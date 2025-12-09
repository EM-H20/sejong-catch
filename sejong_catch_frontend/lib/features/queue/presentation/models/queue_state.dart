import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/response/booth.dart';
import '../../data/models/response/booth_master.dart';
import '../../data/models/response/my_queue_status.dart';
import '../../data/models/response/queue_entry.dart';

part 'queue_state.freezed.dart';

/// 큐 페이지 상태 모델
///
/// 부스 목록, 내 대기 상태, 로딩 상태 등을 관리합니다.
@freezed
class QueueState with _$QueueState {
  const factory QueueState({
    // 🏷️ 부스 타입 목록 (부스 생성 시 선택)
    @Default([]) List<BoothMaster> boothMasters,

    // 📋 부스 목록
    @Default([]) List<Booth> booths,

    // 🎫 내 대기 상태 (부스별)
    @Default({}) Map<String, MyQueueStatus> myQueueStatuses,

    // 🎛️ 관리자용: 대기 목록
    @Default([]) List<QueueEntry> queueEntries,

    // 🔄 로딩/에러 상태
    @Default(false) bool isLoading,
    @Default(null) String? error,

    // 🎯 UI 상태
    @Default(0) int currentTabIndex, // 0: 전체 부스, 1: 내 대기열
    @Default(null) String? selectedBoothId, // 선택된 부스 (관리자 뷰)

    // 🔐 booth_manager용: 내가 관리하는 부스 ID 목록
    @Default([]) List<String> myManagedBoothIds,
  }) = _QueueState;

  const QueueState._();

  /// 운영 중인 부스만 필터링
  List<Booth> get operatingBooths =>
      booths.where((b) => b.status == 'OPERATING').toList();

  /// 준비 중인 부스만 필터링
  List<Booth> get preparingBooths =>
      booths.where((b) => b.status == 'PREPARING').toList();

  /// 종료된 부스만 필터링
  List<Booth> get endedBooths =>
      booths.where((b) => b.status == 'ENDED').toList();

  /// 내가 대기 중인 부스 ID 목록
  List<String> get myWaitingBoothIds => myQueueStatuses.entries
      .where((e) => e.value.state == 'WAITING' || e.value.state == 'IN_SERVICE')
      .map((e) => e.key)
      .toList();

  /// 특정 부스에 대기 중인지 확인
  bool isWaitingAt(String boothId) => myQueueStatuses.containsKey(boothId);

  /// 특정 부스의 내 대기 상태 조회
  MyQueueStatus? getMyStatusAt(String boothId) => myQueueStatuses[boothId];

  /// masterId로 부스 타입(마스터) 이름 조회
  ///
  /// 부스의 masterId를 받아 해당하는 BoothMaster의 name을 반환합니다.
  /// 찾지 못하면 null을 반환합니다.
  String? getMasterName(String masterId) {
    final master = boothMasters.where((m) => m.id == masterId).firstOrNull;
    return master?.name;
  }

  /// masterId로 부스 타입(마스터) 이름 조회 (기본값 포함)
  ///
  /// 찾지 못하면 기본값(defaultName)을 반환합니다.
  String getMasterNameOrDefault(
    String masterId, {
    String defaultName = '알 수 없음',
  }) {
    return getMasterName(masterId) ?? defaultName;
  }
}
