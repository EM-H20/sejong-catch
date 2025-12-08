import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/controllers/auth_state_controller.dart';
import '../../features/auth/presentation/models/auth_state.dart';

/// 🔐 인증 상태 변화를 GoRouter에 전달하는 ChangeNotifier
///
/// **핵심 역할**:
/// - Riverpod의 authStateControllerProvider를 구독
/// - 인증 상태(isAuthenticated) 변경 시 notifyListeners() 호출
/// - GoRouter의 refreshListenable로 사용되어 자동 redirect 트리거
///
/// **왜 필요한가?**:
/// - GoRouter는 Listenable 기반 refresh만 지원
/// - Riverpod StateNotifier는 Listenable이 아님
/// - 이 클래스가 둘 사이의 브릿지 역할을 수행
///
/// **세션 만료 플로우**:
/// 1. API 401 → AuthInterceptor가 세션 만료 이벤트 발행
/// 2. AuthStateController가 이벤트 수신 → isAuthenticated = false
/// 3. AuthNotifier가 변화 감지 → notifyListeners()
/// 4. GoRouter가 refresh 트리거 → redirect 실행 → /auth로 이동
class AuthNotifier extends ChangeNotifier {
  /// Riverpod Provider 구독 핸들
  late final ProviderSubscription<AuthState> _subscription;

  /// 마지막 인증 상태 (변화 감지용)
  bool _wasAuthenticated = false;

  /// 세션 만료 여부 (로그인 페이지에서 메시지 표시용)
  bool _sessionExpired = false;
  bool get sessionExpired => _sessionExpired;

  /// 세션 만료 메시지
  String? _sessionExpiredMessage;
  String? get sessionExpiredMessage => _sessionExpiredMessage;

  AuthNotifier(ProviderContainer container) {
    // 🔥 authStateControllerProvider 구독 시작
    _subscription = container.listen<AuthState>(
      authStateControllerProvider,
      (previous, next) {
        final nowAuthenticated = next.isAuthenticated;
        final errorMessage = next.error;

        // 🎯 인증 상태가 true → false로 변경됐을 때만 (로그아웃/세션만료)
        if (_wasAuthenticated && !nowAuthenticated) {
          debugPrint('[AuthNotifier] 🔴 인증 해제 감지! redirect 트리거');

          // 에러 메시지가 있으면 세션 만료로 판단
          if (errorMessage != null && errorMessage.isNotEmpty) {
            _sessionExpired = true;
            _sessionExpiredMessage = errorMessage;
          }

          notifyListeners();
        }

        // 🎯 인증 상태가 false → true로 변경됐을 때 (로그인 성공)
        if (!_wasAuthenticated && nowAuthenticated) {
          debugPrint('[AuthNotifier] 🟢 인증 성공 감지! 세션 만료 플래그 초기화');
          _sessionExpired = false;
          _sessionExpiredMessage = null;
          notifyListeners();
        }

        _wasAuthenticated = nowAuthenticated;
      },
      fireImmediately: true, // 초기 상태도 확인
    );

    // 초기 상태 저장
    _wasAuthenticated = container
        .read(authStateControllerProvider)
        .isAuthenticated;
    debugPrint(
      '[AuthNotifier] 🚀 초기화 완료 (isAuthenticated: $_wasAuthenticated)',
    );
  }

  /// 세션 만료 플래그 초기화 (로그인 페이지에서 메시지 표시 후 호출)
  void clearSessionExpired() {
    _sessionExpired = false;
    _sessionExpiredMessage = null;
  }

  @override
  void dispose() {
    debugPrint('[AuthNotifier] 🗑️ 구독 해제');
    _subscription.close();
    super.dispose();
  }
}
