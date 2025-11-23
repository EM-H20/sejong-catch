// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MyQueueItem _$MyQueueItemFromJson(Map<String, dynamic> json) {
  return _MyQueueItem.fromJson(json);
}

/// @nodoc
mixin _$MyQueueItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get myNumber => throw _privateConstructorUsedError; // 내 순번
  int get currentNumber => throw _privateConstructorUsedError; // 현재 순번
  int get peopleAhead => throw _privateConstructorUsedError; // 앞 대기 인원
  int get estimatedWait => throw _privateConstructorUsedError;

  /// Serializes this MyQueueItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyQueueItemCopyWith<MyQueueItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyQueueItemCopyWith<$Res> {
  factory $MyQueueItemCopyWith(
    MyQueueItem value,
    $Res Function(MyQueueItem) then,
  ) = _$MyQueueItemCopyWithImpl<$Res, MyQueueItem>;
  @useResult
  $Res call({
    String id,
    String name,
    int myNumber,
    int currentNumber,
    int peopleAhead,
    int estimatedWait,
  });
}

/// @nodoc
class _$MyQueueItemCopyWithImpl<$Res, $Val extends MyQueueItem>
    implements $MyQueueItemCopyWith<$Res> {
  _$MyQueueItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? myNumber = null,
    Object? currentNumber = null,
    Object? peopleAhead = null,
    Object? estimatedWait = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            myNumber: null == myNumber
                ? _value.myNumber
                : myNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            currentNumber: null == currentNumber
                ? _value.currentNumber
                : currentNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            peopleAhead: null == peopleAhead
                ? _value.peopleAhead
                : peopleAhead // ignore: cast_nullable_to_non_nullable
                      as int,
            estimatedWait: null == estimatedWait
                ? _value.estimatedWait
                : estimatedWait // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MyQueueItemImplCopyWith<$Res>
    implements $MyQueueItemCopyWith<$Res> {
  factory _$$MyQueueItemImplCopyWith(
    _$MyQueueItemImpl value,
    $Res Function(_$MyQueueItemImpl) then,
  ) = __$$MyQueueItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int myNumber,
    int currentNumber,
    int peopleAhead,
    int estimatedWait,
  });
}

/// @nodoc
class __$$MyQueueItemImplCopyWithImpl<$Res>
    extends _$MyQueueItemCopyWithImpl<$Res, _$MyQueueItemImpl>
    implements _$$MyQueueItemImplCopyWith<$Res> {
  __$$MyQueueItemImplCopyWithImpl(
    _$MyQueueItemImpl _value,
    $Res Function(_$MyQueueItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? myNumber = null,
    Object? currentNumber = null,
    Object? peopleAhead = null,
    Object? estimatedWait = null,
  }) {
    return _then(
      _$MyQueueItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        myNumber: null == myNumber
            ? _value.myNumber
            : myNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        currentNumber: null == currentNumber
            ? _value.currentNumber
            : currentNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        peopleAhead: null == peopleAhead
            ? _value.peopleAhead
            : peopleAhead // ignore: cast_nullable_to_non_nullable
                  as int,
        estimatedWait: null == estimatedWait
            ? _value.estimatedWait
            : estimatedWait // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyQueueItemImpl implements _MyQueueItem {
  const _$MyQueueItemImpl({
    required this.id,
    required this.name,
    required this.myNumber,
    required this.currentNumber,
    required this.peopleAhead,
    required this.estimatedWait,
  });

  factory _$MyQueueItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyQueueItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int myNumber;
  // 내 순번
  @override
  final int currentNumber;
  // 현재 순번
  @override
  final int peopleAhead;
  // 앞 대기 인원
  @override
  final int estimatedWait;

  @override
  String toString() {
    return 'MyQueueItem(id: $id, name: $name, myNumber: $myNumber, currentNumber: $currentNumber, peopleAhead: $peopleAhead, estimatedWait: $estimatedWait)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyQueueItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.myNumber, myNumber) ||
                other.myNumber == myNumber) &&
            (identical(other.currentNumber, currentNumber) ||
                other.currentNumber == currentNumber) &&
            (identical(other.peopleAhead, peopleAhead) ||
                other.peopleAhead == peopleAhead) &&
            (identical(other.estimatedWait, estimatedWait) ||
                other.estimatedWait == estimatedWait));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    myNumber,
    currentNumber,
    peopleAhead,
    estimatedWait,
  );

  /// Create a copy of MyQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyQueueItemImplCopyWith<_$MyQueueItemImpl> get copyWith =>
      __$$MyQueueItemImplCopyWithImpl<_$MyQueueItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyQueueItemImplToJson(this);
  }
}

abstract class _MyQueueItem implements MyQueueItem {
  const factory _MyQueueItem({
    required final String id,
    required final String name,
    required final int myNumber,
    required final int currentNumber,
    required final int peopleAhead,
    required final int estimatedWait,
  }) = _$MyQueueItemImpl;

  factory _MyQueueItem.fromJson(Map<String, dynamic> json) =
      _$MyQueueItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get myNumber; // 내 순번
  @override
  int get currentNumber; // 현재 순번
  @override
  int get peopleAhead; // 앞 대기 인원
  @override
  int get estimatedWait;

  /// Create a copy of MyQueueItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyQueueItemImplCopyWith<_$MyQueueItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
