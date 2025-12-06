/// 🔔 글로벌 인증 이벤트 서비스
///
/// 참조: claudedocs/TOKEN_REFRESH_IMPROVEMENT_PLAN.md - Phase 3
///
/// AuthInterceptor는 Riverpod Provider 시스템 외부에 있어서
/// ref를 직접 사용할 수 없음. 따라서 글로벌 이벤트 버스 방식으로
/// "세션 만료" 신호를 AuthStateController에 전달함.
///
/// **사용 흐름**:
/// 1. AuthInterceptor에서 Refresh 실패 시 이벤트 발행
/// 2. AuthStateController가 이벤트 구독
/// 3. 로그아웃 처리 + 로그인 페이지로 이동
///
/// CLAUDE.md 원칙:
/// ✅ Singleton 패턴으로 글로벌 접근
/// ✅ StreamController.broadcast()로 다중 구독 지원
/// ✅ dispose() 메서드로 리소스 해제

library;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// 인증 이벤트 타입
enum AuthEventType {
  /// 세션 만료 (Refresh Token 만료 또는 서버에서 무효화)
  sessionExpired,

  /// 강제 로그아웃 (서버 요청 또는 보안 이슈)
  forceLogout,
}

/// 인증 이벤트
class AuthEvent {
  final AuthEventType type;
  final String? message;

  const AuthEvent({required this.type, this.message});

  @override
  String toString() => 'AuthEvent(type: $type, message: $message)';
}

/// 글로벌 인증 이벤트 서비스 (Singleton)
///
/// **사용 예시**:
/// ```dart
/// // 이벤트 발행 (AuthInterceptor에서)
/// authEventService.emitSessionExpired();
///
/// // 이벤트 구독 (AuthStateController에서)
/// authEventService.stream.listen((event) {
///   if (event.type == AuthEventType.sessionExpired) {
///     // 로그아웃 처리
///   }
/// });
/// ```
class AuthEventService {
  // Singleton 인스턴스
  static final AuthEventService _instance = AuthEventService._internal();
  factory AuthEventService() => _instance;
  AuthEventService._internal();

  // broadcast()로 다중 구독자 지원
  final _controller = StreamController<AuthEvent>.broadcast();

  /// 이벤트 스트림 (구독용)
  Stream<AuthEvent> get stream => _controller.stream;

  /// 세션 만료 이벤트 발행
  ///
  /// Refresh Token이 만료되었거나 서버에서 무효화되었을 때 호출
  void emitSessionExpired({String? message}) {
    debugPrint('[AuthEventService] Session expired event emitted');
    _controller.add(
      AuthEvent(
        type: AuthEventType.sessionExpired,
        message: message ?? '세션이 만료되었습니다. 다시 로그인해주세요.',
      ),
    );
  }

  /// 강제 로그아웃 이벤트 발행
  ///
  /// 서버에서 강제 로그아웃을 요청했거나 보안 이슈가 발생했을 때 호출
  void emitForceLogout({String? message}) {
    debugPrint('[AuthEventService] Force logout event emitted');
    _controller.add(
      AuthEvent(
        type: AuthEventType.forceLogout,
        message: message ?? '보안상의 이유로 로그아웃되었습니다.',
      ),
    );
  }

  /// 리소스 해제
  ///
  /// 앱 종료 시 호출 (일반적으로 호출할 필요 없음)
  void dispose() {
    _controller.close();
  }
}

/// 글로벌 인스턴스
///
/// Singleton이므로 어디서든 동일한 인스턴스에 접근
final authEventService = AuthEventService();
