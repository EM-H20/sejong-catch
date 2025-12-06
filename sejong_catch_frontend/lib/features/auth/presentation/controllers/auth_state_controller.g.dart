// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authStateControllerHash() =>
    r'a2aec5cc108a33b83af66558e4662c9fbce3b024';

/// 앱 전역 인증 상태 관리 컨트롤러
///
/// **역할**:
/// - 앱 시작 시 자동으로 로그인 상태 체크
/// - 로그인/로그아웃 시 전역 상태 업데이트
/// - Profile 페이지 등에서 사용자 정보 제공
///
/// **상태**:
/// - `isAuthenticated`: 로그인 여부
/// - `currentUser`: 현재 사용자 정보 (UserDto)
/// - `isLoading`: 상태 체크 중
///
/// **사용처**:
/// - ProfilePage: 사용자 정보 표시
/// - AppRouter: 라우팅 가드
/// - LoginController: 로그인/로그아웃 시 상태 업데이트
///
/// Copied from [AuthStateController].
@ProviderFor(AuthStateController)
final authStateControllerProvider =
    AutoDisposeNotifierProvider<AuthStateController, AuthState>.internal(
      AuthStateController.new,
      name: r'authStateControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authStateControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthStateController = AutoDisposeNotifier<AuthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
