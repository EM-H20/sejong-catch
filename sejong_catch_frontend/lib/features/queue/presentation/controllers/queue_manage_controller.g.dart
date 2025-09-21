// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_manage_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queueManageControllerHash() =>
    r'd8965d79f971dde70a74877aeb6aeb2dc5251191';

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

abstract class _$QueueManageController
    extends BuildlessAutoDisposeNotifier<QueueManageState> {
  late final String queueId;

  QueueManageState build(String queueId);
}

/// 🎪 큐 관리 Controller (운영자 전용)
///
/// Copied from [QueueManageController].
@ProviderFor(QueueManageController)
const queueManageControllerProvider = QueueManageControllerFamily();

/// 🎪 큐 관리 Controller (운영자 전용)
///
/// Copied from [QueueManageController].
class QueueManageControllerFamily extends Family<QueueManageState> {
  /// 🎪 큐 관리 Controller (운영자 전용)
  ///
  /// Copied from [QueueManageController].
  const QueueManageControllerFamily();

  /// 🎪 큐 관리 Controller (운영자 전용)
  ///
  /// Copied from [QueueManageController].
  QueueManageControllerProvider call(String queueId) {
    return QueueManageControllerProvider(queueId);
  }

  @override
  QueueManageControllerProvider getProviderOverride(
    covariant QueueManageControllerProvider provider,
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
  String? get name => r'queueManageControllerProvider';
}

/// 🎪 큐 관리 Controller (운영자 전용)
///
/// Copied from [QueueManageController].
class QueueManageControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          QueueManageController,
          QueueManageState
        > {
  /// 🎪 큐 관리 Controller (운영자 전용)
  ///
  /// Copied from [QueueManageController].
  QueueManageControllerProvider(String queueId)
    : this._internal(
        () => QueueManageController()..queueId = queueId,
        from: queueManageControllerProvider,
        name: r'queueManageControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$queueManageControllerHash,
        dependencies: QueueManageControllerFamily._dependencies,
        allTransitiveDependencies:
            QueueManageControllerFamily._allTransitiveDependencies,
        queueId: queueId,
      );

  QueueManageControllerProvider._internal(
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
  QueueManageState runNotifierBuild(covariant QueueManageController notifier) {
    return notifier.build(queueId);
  }

  @override
  Override overrideWith(QueueManageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: QueueManageControllerProvider._internal(
        () => create()..queueId = queueId,
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
  AutoDisposeNotifierProviderElement<QueueManageController, QueueManageState>
  createElement() {
    return _QueueManageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QueueManageControllerProvider && other.queueId == queueId;
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
mixin QueueManageControllerRef
    on AutoDisposeNotifierProviderRef<QueueManageState> {
  /// The parameter `queueId` of this provider.
  String get queueId;
}

class _QueueManageControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          QueueManageController,
          QueueManageState
        >
    with QueueManageControllerRef {
  _QueueManageControllerProviderElement(super.provider);

  @override
  String get queueId => (origin as QueueManageControllerProvider).queueId;
}

String _$participantAlertControllerHash() =>
    r'b516c6c8fd35f9023045802a195879304236a43d';

/// 🔔 호출이 필요한 참가자 알림 Provider
///
/// Copied from [ParticipantAlertController].
@ProviderFor(ParticipantAlertController)
final participantAlertControllerProvider =
    AutoDisposeNotifierProvider<
      ParticipantAlertController,
      List<ParticipantModel>
    >.internal(
      ParticipantAlertController.new,
      name: r'participantAlertControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$participantAlertControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ParticipantAlertController =
    AutoDisposeNotifier<List<ParticipantModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
