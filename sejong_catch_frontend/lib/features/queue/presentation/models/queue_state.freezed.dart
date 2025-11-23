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
  List<QueueItem> get allQueues =>
      throw _privateConstructorUsedError; // 전체 큐 목록
  List<MyQueueItem> get myQueues => throw _privateConstructorUsedError; // 내 대기열
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  int get currentTabIndex => throw _privateConstructorUsedError;

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
    List<QueueItem> allQueues,
    List<MyQueueItem> myQueues,
    bool isLoading,
    String? error,
    int currentTabIndex,
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
    Object? allQueues = null,
    Object? myQueues = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? currentTabIndex = null,
  }) {
    return _then(
      _value.copyWith(
            allQueues: null == allQueues
                ? _value.allQueues
                : allQueues // ignore: cast_nullable_to_non_nullable
                      as List<QueueItem>,
            myQueues: null == myQueues
                ? _value.myQueues
                : myQueues // ignore: cast_nullable_to_non_nullable
                      as List<MyQueueItem>,
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
    List<QueueItem> allQueues,
    List<MyQueueItem> myQueues,
    bool isLoading,
    String? error,
    int currentTabIndex,
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
    Object? allQueues = null,
    Object? myQueues = null,
    Object? isLoading = null,
    Object? error = freezed,
    Object? currentTabIndex = null,
  }) {
    return _then(
      _$QueueStateImpl(
        allQueues: null == allQueues
            ? _value._allQueues
            : allQueues // ignore: cast_nullable_to_non_nullable
                  as List<QueueItem>,
        myQueues: null == myQueues
            ? _value._myQueues
            : myQueues // ignore: cast_nullable_to_non_nullable
                  as List<MyQueueItem>,
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
      ),
    );
  }
}

/// @nodoc

class _$QueueStateImpl implements _QueueState {
  const _$QueueStateImpl({
    final List<QueueItem> allQueues = const [],
    final List<MyQueueItem> myQueues = const [],
    this.isLoading = false,
    this.error = null,
    this.currentTabIndex = 0,
  }) : _allQueues = allQueues,
       _myQueues = myQueues;

  final List<QueueItem> _allQueues;
  @override
  @JsonKey()
  List<QueueItem> get allQueues {
    if (_allQueues is EqualUnmodifiableListView) return _allQueues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allQueues);
  }

  // 전체 큐 목록
  final List<MyQueueItem> _myQueues;
  // 전체 큐 목록
  @override
  @JsonKey()
  List<MyQueueItem> get myQueues {
    if (_myQueues is EqualUnmodifiableListView) return _myQueues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myQueues);
  }

  // 내 대기열
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String? error;
  @override
  @JsonKey()
  final int currentTabIndex;

  @override
  String toString() {
    return 'QueueState(allQueues: $allQueues, myQueues: $myQueues, isLoading: $isLoading, error: $error, currentTabIndex: $currentTabIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueStateImpl &&
            const DeepCollectionEquality().equals(
              other._allQueues,
              _allQueues,
            ) &&
            const DeepCollectionEquality().equals(other._myQueues, _myQueues) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.currentTabIndex, currentTabIndex) ||
                other.currentTabIndex == currentTabIndex));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_allQueues),
    const DeepCollectionEquality().hash(_myQueues),
    isLoading,
    error,
    currentTabIndex,
  );

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueStateImplCopyWith<_$QueueStateImpl> get copyWith =>
      __$$QueueStateImplCopyWithImpl<_$QueueStateImpl>(this, _$identity);
}

abstract class _QueueState implements QueueState {
  const factory _QueueState({
    final List<QueueItem> allQueues,
    final List<MyQueueItem> myQueues,
    final bool isLoading,
    final String? error,
    final int currentTabIndex,
  }) = _$QueueStateImpl;

  @override
  List<QueueItem> get allQueues; // 전체 큐 목록
  @override
  List<MyQueueItem> get myQueues; // 내 대기열
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  int get currentTabIndex;

  /// Create a copy of QueueState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QueueStateImplCopyWith<_$QueueStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
