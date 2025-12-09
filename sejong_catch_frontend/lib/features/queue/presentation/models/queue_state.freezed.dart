// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QueueState {
  // 🏷️ 부스 타입 목록 (부스 생성 시 선택)
  List<BoothMaster> get boothMasters =>
      throw _privateConstructorUsedError; // 📋 부스 목록
  List<Booth> get booths =>
      throw _privateConstructorUsedError; // 🎫 내 대기 상태 (부스별)
  Map<String, MyQueueStatus> get myQueueStatuses =>
      throw _privateConstructorUsedError; // 🎛️ 관리자용: 대기 목록
  List<QueueEntry> get queueEntries =>
      throw _privateConstructorUsedError; // 🔄 로딩/에러 상태
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError; // 🎯 UI 상태
  int get currentTabIndex =>
      throw _privateConstructorUsedError; // 0: 전체 부스, 1: 내 대기열
  String? get selectedBoothId =>
      throw _privateConstructorUsedError; // 선택된 부스 (관리자 뷰)
  // 🔐 booth_manager용: 내가 관리하는 부스 ID 목록
  List<String> get myManagedBoothIds => throw _privateConstructorUsedError;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QueueStateCopyWith<QueueState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueueStateCopyWith<$Res> {
  factory $QueueStateCopyWith(
    QueueState value,
    $Res Function(QueueState) then,
  ) = _$QueueStateCopyWithImpl<$Res, QueueState>;
  @useResult
  $Res call({
    List<BoothMaster> boothMasters,
    List<Booth> booths,
    Map<String, MyQueueStatus> myQueueStatuses,
    List<QueueEntry> queueEntries,
    bool isLoading,
    String? error,
    int currentTabIndex,
    String? selectedBoothId,
    List<String> myManagedBoothIds,
  });
}

/// @nodoc
class _$QueueStateCopyWithImpl<$Res, $Val extends QueueState>
    implements $QueueStateCopyWith<$Res> {
  _$QueueStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boothMasters = null,
    Object? booths = null,
    Object? myQueueStatuses = null,
    Object? queueEntries = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? currentTabIndex = null,
    Object? selectedBoothId = freezed,
    Object? myManagedBoothIds = null,
  }) {
    return _then(
      _value.copyWith(
            boothMasters: null == boothMasters
                ? _value.boothMasters
                : boothMasters // ignore: cast_nullable_to_non_nullable
                      as List<BoothMaster>,
            booths: null == booths
                ? _value.booths
                : booths // ignore: cast_nullable_to_non_nullable
                      as List<Booth>,
            myQueueStatuses: null == myQueueStatuses
                ? _value.myQueueStatuses
                : myQueueStatuses // ignore: cast_nullable_to_non_nullable
                      as Map<String, MyQueueStatus>,
            queueEntries: null == queueEntries
                ? _value.queueEntries
                : queueEntries // ignore: cast_nullable_to_non_nullable
                      as List<QueueEntry>,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentTabIndex: null == currentTabIndex
                ? _value.currentTabIndex
                : currentTabIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            selectedBoothId: freezed == selectedBoothId
                ? _value.selectedBoothId
                : selectedBoothId // ignore: cast_nullable_to_non_nullable
                      as String?,
            myManagedBoothIds: null == myManagedBoothIds
                ? _value.myManagedBoothIds
                : myManagedBoothIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QueueStateImplCopyWith<$Res>
    implements $QueueStateCopyWith<$Res> {
  factory _$$QueueStateImplCopyWith(
    _$QueueStateImpl value,
    $Res Function(_$QueueStateImpl) then,
  ) = __$$QueueStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<BoothMaster> boothMasters,
    List<Booth> booths,
    Map<String, MyQueueStatus> myQueueStatuses,
    List<QueueEntry> queueEntries,
    bool isLoading,
    String? error,
    int currentTabIndex,
    String? selectedBoothId,
    List<String> myManagedBoothIds,
  });
}

/// @nodoc
class __$$QueueStateImplCopyWithImpl<$Res>
    extends _$QueueStateCopyWithImpl<$Res, _$QueueStateImpl>
    implements _$$QueueStateImplCopyWith<$Res> {
  __$$QueueStateImplCopyWithImpl(
    _$QueueStateImpl _value,
    $Res Function(_$QueueStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? boothMasters = null,
    Object? booths = null,
    Object? myQueueStatuses = null,
    Object? queueEntries = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? currentTabIndex = null,
    Object? selectedBoothId = freezed,
    Object? myManagedBoothIds = null,
  }) {
    return _then(
      _$QueueStateImpl(
        boothMasters: null == boothMasters
            ? _value._boothMasters
            : boothMasters // ignore: cast_nullable_to_non_nullable
                  as List<BoothMaster>,
        booths: null == booths
            ? _value._booths
            : booths // ignore: cast_nullable_to_non_nullable
                  as List<Booth>,
        myQueueStatuses: null == myQueueStatuses
            ? _value._myQueueStatuses
            : myQueueStatuses // ignore: cast_nullable_to_non_nullable
                  as Map<String, MyQueueStatus>,
        queueEntries: null == queueEntries
            ? _value._queueEntries
            : queueEntries // ignore: cast_nullable_to_non_nullable
                  as List<QueueEntry>,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentTabIndex: null == currentTabIndex
            ? _value.currentTabIndex
            : currentTabIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        selectedBoothId: freezed == selectedBoothId
            ? _value.selectedBoothId
            : selectedBoothId // ignore: cast_nullable_to_non_nullable
                  as String?,
        myManagedBoothIds: null == myManagedBoothIds
            ? _value._myManagedBoothIds
            : myManagedBoothIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$QueueStateImpl extends _QueueState {
  const _$QueueStateImpl({
    final List<BoothMaster> boothMasters = const [],
    final List<Booth> booths = const [],
    final Map<String, MyQueueStatus> myQueueStatuses = const {},
    final List<QueueEntry> queueEntries = const [],
    this.isLoading = false,
    this.error = null,
    this.currentTabIndex = 0,
    this.selectedBoothId = null,
    final List<String> myManagedBoothIds = const [],
  }) : _boothMasters = boothMasters,
       _booths = booths,
       _myQueueStatuses = myQueueStatuses,
       _queueEntries = queueEntries,
       _myManagedBoothIds = myManagedBoothIds,
       super._();

  // 🏷️ 부스 타입 목록 (부스 생성 시 선택)
  final List<BoothMaster> _boothMasters;
  // 🏷️ 부스 타입 목록 (부스 생성 시 선택)
  @override
  @JsonKey()
  List<BoothMaster> get boothMasters {
    if (_boothMasters is EqualUnmodifiableListView) return _boothMasters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_boothMasters);
  }

  // 📋 부스 목록
  final List<Booth> _booths;
  // 📋 부스 목록
  @override
  @JsonKey()
  List<Booth> get booths {
    if (_booths is EqualUnmodifiableListView) return _booths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_booths);
  }

  // 🎫 내 대기 상태 (부스별)
  final Map<String, MyQueueStatus> _myQueueStatuses;
  // 🎫 내 대기 상태 (부스별)
  @override
  @JsonKey()
  Map<String, MyQueueStatus> get myQueueStatuses {
    if (_myQueueStatuses is EqualUnmodifiableMapView) return _myQueueStatuses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_myQueueStatuses);
  }

  // 🎛️ 관리자용: 대기 목록
  final List<QueueEntry> _queueEntries;
  // 🎛️ 관리자용: 대기 목록
  @override
  @JsonKey()
  List<QueueEntry> get queueEntries {
    if (_queueEntries is EqualUnmodifiableListView) return _queueEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queueEntries);
  }

  // 🔄 로딩/에러 상태
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;
  // 🎯 UI 상태
  @override
  @JsonKey()
  final int currentTabIndex;
  // 0: 전체 부스, 1: 내 대기열
  @override
  @JsonKey()
  final String? selectedBoothId;
  // 선택된 부스 (관리자 뷰)
  // 🔐 booth_manager용: 내가 관리하는 부스 ID 목록
  final List<String> _myManagedBoothIds;
  // 선택된 부스 (관리자 뷰)
  // 🔐 booth_manager용: 내가 관리하는 부스 ID 목록
  @override
  @JsonKey()
  List<String> get myManagedBoothIds {
    if (_myManagedBoothIds is EqualUnmodifiableListView)
      return _myManagedBoothIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myManagedBoothIds);
  }

  @override
  String toString() {
    return 'QueueState(boothMasters: $boothMasters, booths: $booths, myQueueStatuses: $myQueueStatuses, queueEntries: $queueEntries, isLoading: $isLoading, error: $error, currentTabIndex: $currentTabIndex, selectedBoothId: $selectedBoothId, myManagedBoothIds: $myManagedBoothIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueStateImpl &&
            const DeepCollectionEquality().equals(
              other._boothMasters,
              _boothMasters,
            ) &&
            const DeepCollectionEquality().equals(other._booths, _booths) &&
            const DeepCollectionEquality().equals(
              other._myQueueStatuses,
              _myQueueStatuses,
            ) &&
            const DeepCollectionEquality().equals(
              other._queueEntries,
              _queueEntries,
            ) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentTabIndex, currentTabIndex) ||
                other.currentTabIndex == currentTabIndex) &&
            (identical(other.selectedBoothId, selectedBoothId) ||
                other.selectedBoothId == selectedBoothId) &&
            const DeepCollectionEquality().equals(
              other._myManagedBoothIds,
              _myManagedBoothIds,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_boothMasters),
    const DeepCollectionEquality().hash(_booths),
    const DeepCollectionEquality().hash(_myQueueStatuses),
    const DeepCollectionEquality().hash(_queueEntries),
    isLoading,
    error,
    currentTabIndex,
    selectedBoothId,
    const DeepCollectionEquality().hash(_myManagedBoothIds),
  );

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueStateImplCopyWith<_$QueueStateImpl> get copyWith =>
      __$$QueueStateImplCopyWithImpl<_$QueueStateImpl>(this, _$identity);
}

abstract class _QueueState extends QueueState {
  const factory _QueueState({
    final List<BoothMaster> boothMasters,
    final List<Booth> booths,
    final Map<String, MyQueueStatus> myQueueStatuses,
    final List<QueueEntry> queueEntries,
    final bool isLoading,
    final String? error,
    final int currentTabIndex,
    final String? selectedBoothId,
    final List<String> myManagedBoothIds,
  }) = _$QueueStateImpl;
  const _QueueState._() : super._();

  // 🏷️ 부스 타입 목록 (부스 생성 시 선택)
  @override
  List<BoothMaster> get boothMasters; // 📋 부스 목록
  @override
  List<Booth> get booths; // 🎫 내 대기 상태 (부스별)
  @override
  Map<String, MyQueueStatus> get myQueueStatuses; // 🎛️ 관리자용: 대기 목록
  @override
  List<QueueEntry> get queueEntries; // 🔄 로딩/에러 상태
  @override
  bool get isLoading;
  @override
  String? get error; // 🎯 UI 상태
  @override
  int get currentTabIndex; // 0: 전체 부스, 1: 내 대기열
  @override
  String? get selectedBoothId; // 선택된 부스 (관리자 뷰)
  // 🔐 booth_manager용: 내가 관리하는 부스 ID 목록
  @override
  List<String> get myManagedBoothIds;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueStateImplCopyWith<_$QueueStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
