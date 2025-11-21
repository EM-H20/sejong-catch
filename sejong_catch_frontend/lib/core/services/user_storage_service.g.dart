// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_storage_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userStorageServiceHash() =>
    r'5321ca5c1c23f64009e1a0360d7a2cbb91549473';

/// 사용자 정보 로컬 저장소 서비스
///
/// **역할**:
/// - UserDto를 SharedPreferences에 JSON 형태로 저장
/// - 앱 재시작 시 사용자 정보 복원
/// - 로그아웃 시 사용자 정보 삭제
///
/// **사용처**:
/// - AuthStateController: 앱 시작 시 사용자 정보 불러오기
/// - LoginController: 로그인 성공 시 사용자 정보 저장
///
/// Copied from [UserStorageService].
@ProviderFor(UserStorageService)
final userStorageServiceProvider =
    AutoDisposeAsyncNotifierProvider<UserStorageService, void>.internal(
      UserStorageService.new,
      name: r'userStorageServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userStorageServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UserStorageService = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
