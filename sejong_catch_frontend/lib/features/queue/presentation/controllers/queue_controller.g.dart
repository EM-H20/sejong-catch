// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queueControllerHash() => r'cab1f648045db2fdbb4bb53cff8b982e26f14d70';

/// 큐 페이지 컨트롤러
///
/// 큐 목록, 내 대기열, 큐 참여/포기 등의 상태와 비즈니스 로직을 관리합니다.
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
