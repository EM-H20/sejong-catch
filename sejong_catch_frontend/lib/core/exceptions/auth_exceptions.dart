/// 🔐 세종 캐치 인증 예외 클래스
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Exception 클래스 정의
/// 모든 인증 관련 예외를 정의하고 HTTP 상태 코드와 매핑
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ statusCode를 통한 명확한 에러 타입 구분
/// ✅ 한국어 친화적 에러 메시지
library;

/// 기본 인증 예외
///
/// 모든 auth 관련 예외의 부모 클래스
/// statusCode를 통해 HTTP 상태 코드와 매핑
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  AuthException(this.message, {this.statusCode});

  @override
  String toString() => 'AuthException: $message (statusCode: $statusCode)';
}

/// 400 - 입력 검증 실패
///
/// 사용 예시:
/// - 학번 또는 비밀번호 누락
/// - Refresh Token 필드 누락
/// - 잘못된 입력 형식
class ValidationException extends AuthException {
  ValidationException(super.message) : super(statusCode: 400);
}

/// 401 - 인증 실패 (일반)
///
/// 사용 예시:
/// - 학번 또는 비밀번호 불일치
/// - 잘못된 Access Token
/// - Authorization 헤더 누락
class UnauthorizedException extends AuthException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}

/// 401 - Refresh Token 만료 (로그아웃 필요)
///
/// 사용 예시:
/// - Refresh Token이 만료되어 더 이상 갱신 불가
/// - 자동 로그아웃 처리 필요
///
/// 참조: AUTH_API_SPEC.md - POST /api/auth/refresh 에러 응답
class SessionExpiredException extends AuthException {
  SessionExpiredException(super.message) : super(statusCode: 401);
}

/// 404 - 리소스 없음
///
/// 사용 예시:
/// - DB에 해당 학번의 사용자 없음
/// - 존재하지 않는 엔드포인트 요청
class NotFoundException extends AuthException {
  NotFoundException(super.message) : super(statusCode: 404);
}

/// 429 - Rate Limit 초과
///
/// 사용 예시:
/// - 로그인 시도 15분에 5회 초과
/// - 15분 대기 필요
///
/// 참조: AUTH_API_SPEC.md - Rate Limiting (15분당 5회 제한)
class RateLimitException extends AuthException {
  RateLimitException(super.message) : super(statusCode: 429);
}

/// 500 - 서버 내부 오류
///
/// 사용 예시:
/// - 서버 측 예기치 않은 오류
/// - 나중에 다시 시도 필요
class ServerException extends AuthException {
  ServerException(super.message) : super(statusCode: 500);
}

/// 네트워크 연결 오류
///
/// 사용 예시:
/// - 인터넷 연결 끊김
/// - Connection Timeout
/// - Receive Timeout
class NetworkException extends AuthException {
  NetworkException(super.message);
}

/// 알 수 없는 오류
///
/// 사용 예시:
/// - 예상하지 못한 DioException
/// - statusCode가 정의되지 않은 에러
class UnknownException extends AuthException {
  UnknownException(super.message);
}
