// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queueControllerHash() => r'b69b5d12a542456d7638cbae4e546e2695dc20cc';

/// 큐 페이지 컨트롤러
///
/// 부스 목록 조회, 대기열 등록/취소, 관리자 기능 등을 담당합니다.
/// Repository 패턴을 사용하여 Mock/Real 모드를 자동 분기합니다.
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
