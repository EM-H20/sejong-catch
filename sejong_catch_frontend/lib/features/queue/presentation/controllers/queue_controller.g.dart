// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queueRepositoryHash() => r'9743b3ebca935d18408f3cac5c1f04fe1171be04';

/// 🏭 Repository Provider (의존성 주입 + 자동 dispose)
///
/// Copied from [queueRepository].
@ProviderFor(queueRepository)
final queueRepositoryProvider = AutoDisposeProvider<QueueRepository>.internal(
  queueRepository,
  name: r'queueRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$queueRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QueueRepositoryRef = AutoDisposeProviderRef<QueueRepository>;
String _$queueStreamHash() => r'6475135f4f41cf649ba481f5c294b9a77b180ea1';

/// 🎛️ 실시간 큐 목록 Provider (Stream)
///
/// Copied from [queueStream].
@ProviderFor(queueStream)
final queueStreamProvider =
    AutoDisposeStreamProvider<List<QueueModel>>.internal(
      queueStream,
      name: r'queueStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$queueStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QueueStreamRef = AutoDisposeStreamProviderRef<List<QueueModel>>;
String _$participantsStreamHash() =>
    r'18d92d1f8328f3613be6a09fd9aabff77ce8f747';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
///
/// Copied from [participantsStream].
@ProviderFor(participantsStream)
const participantsStreamProvider = ParticipantsStreamFamily();

/// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
///
/// Copied from [participantsStream].
class ParticipantsStreamFamily
    extends Family<AsyncValue<List<ParticipantModel>>> {
  /// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
  ///
  /// Copied from [participantsStream].
  const ParticipantsStreamFamily();

  /// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
  ///
  /// Copied from [participantsStream].
  ParticipantsStreamProvider call(String queueId) {
    return ParticipantsStreamProvider(queueId);
  }

  @override
  ParticipantsStreamProvider getProviderOverride(
    covariant ParticipantsStreamProvider provider,
  ) {
    return call(provider.queueId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'participantsStreamProvider';
}

/// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
///
/// Copied from [participantsStream].
class ParticipantsStreamProvider
    extends AutoDisposeStreamProvider<List<ParticipantModel>> {
  /// 🙋‍♂️ 실시간 참가자 목록 Provider (Stream)
  ///
  /// Copied from [participantsStream].
  ParticipantsStreamProvider(String queueId)
    : this._internal(
        (ref) => participantsStream(ref as ParticipantsStreamRef, queueId),
        from: participantsStreamProvider,
        name: r'participantsStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$participantsStreamHash,
        dependencies: ParticipantsStreamFamily._dependencies,
        allTransitiveDependencies:
            ParticipantsStreamFamily._allTransitiveDependencies,
        queueId: queueId,
      );

  ParticipantsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.queueId,
  }) : super.internal();

  final String queueId;

  @override
  Override overrideWith(
    Stream<List<ParticipantModel>> Function(ParticipantsStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ParticipantsStreamProvider._internal(
        (ref) => create(ref as ParticipantsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        queueId: queueId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<ParticipantModel>> createElement() {
    return _ParticipantsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ParticipantsStreamProvider && other.queueId == queueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, queueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ParticipantsStreamRef
    on AutoDisposeStreamProviderRef<List<ParticipantModel>> {
  /// The parameter `queueId` of this provider.
  String get queueId;
}

class _ParticipantsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ParticipantModel>>
    with ParticipantsStreamRef {
  _ParticipantsStreamProviderElement(super.provider);

  @override
  String get queueId => (origin as ParticipantsStreamProvider).queueId;
}

String _$myParticipationStreamHash() =>
    r'92e356873f6eb41566f915272e814736fd2f2d09';

/// 👤 내 참여 상태 실시간 Provider (Stream)
///
/// Copied from [myParticipationStream].
@ProviderFor(myParticipationStream)
const myParticipationStreamProvider = MyParticipationStreamFamily();

/// 👤 내 참여 상태 실시간 Provider (Stream)
///
/// Copied from [myParticipationStream].
class MyParticipationStreamFamily
    extends Family<AsyncValue<ParticipantModel?>> {
  /// 👤 내 참여 상태 실시간 Provider (Stream)
  ///
  /// Copied from [myParticipationStream].
  const MyParticipationStreamFamily();

  /// 👤 내 참여 상태 실시간 Provider (Stream)
  ///
  /// Copied from [myParticipationStream].
  MyParticipationStreamProvider call(String queueId) {
    return MyParticipationStreamProvider(queueId);
  }

  @override
  MyParticipationStreamProvider getProviderOverride(
    covariant MyParticipationStreamProvider provider,
  ) {
    return call(provider.queueId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'myParticipationStreamProvider';
}

/// 👤 내 참여 상태 실시간 Provider (Stream)
///
/// Copied from [myParticipationStream].
class MyParticipationStreamProvider
    extends AutoDisposeStreamProvider<ParticipantModel?> {
  /// 👤 내 참여 상태 실시간 Provider (Stream)
  ///
  /// Copied from [myParticipationStream].
  MyParticipationStreamProvider(String queueId)
    : this._internal(
        (ref) =>
            myParticipationStream(ref as MyParticipationStreamRef, queueId),
        from: myParticipationStreamProvider,
        name: r'myParticipationStreamProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$myParticipationStreamHash,
        dependencies: MyParticipationStreamFamily._dependencies,
        allTransitiveDependencies:
            MyParticipationStreamFamily._allTransitiveDependencies,
        queueId: queueId,
      );

  MyParticipationStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.queueId,
  }) : super.internal();

  final String queueId;

  @override
  Override overrideWith(
    Stream<ParticipantModel?> Function(MyParticipationStreamRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MyParticipationStreamProvider._internal(
        (ref) => create(ref as MyParticipationStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        queueId: queueId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<ParticipantModel?> createElement() {
    return _MyParticipationStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MyParticipationStreamProvider && other.queueId == queueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, queueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MyParticipationStreamRef
    on AutoDisposeStreamProviderRef<ParticipantModel?> {
  /// The parameter `queueId` of this provider.
  String get queueId;
}

class _MyParticipationStreamProviderElement
    extends AutoDisposeStreamProviderElement<ParticipantModel?>
    with MyParticipationStreamRef {
  _MyParticipationStreamProviderElement(super.provider);

  @override
  String get queueId => (origin as MyParticipationStreamProvider).queueId;
}

String _$queueControllerHash() => r'600e686f9d7fd88b80f4d74b82ea1f08a8edc3a1';

/// 🎪 메인 큐 목록 Controller
///
/// Copied from [QueueController].
@ProviderFor(QueueController)
final queueControllerProvider =
    AutoDisposeNotifierProvider<QueueController, QueueState>.internal(
      QueueController.new,
      name: r'queueControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$queueControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$QueueController = AutoDisposeNotifier<QueueState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
