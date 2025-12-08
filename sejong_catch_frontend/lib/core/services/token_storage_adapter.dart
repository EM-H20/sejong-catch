/// 🔗 TokenStorageService를 TokenRepository 인터페이스로 래핑하는 어댑터
///
/// **목적**:
/// AuthInterceptor는 Riverpod 외부에서 동작하므로 TokenRepository 인터페이스가 필요.
/// 이 어댑터를 통해 TokenStorageService의 기능을 TokenRepository 인터페이스로 노출.
///
/// **DRY 원칙**:
/// 핵심 토큰 저장 로직은 TokenStorageService에만 존재.
/// 이 어댑터는 단순 위임(delegation)만 수행.
///
/// CLAUDE.md 원칙:
/// ✅ 코드 중복 제거 (TokenRepositoryImpl 삭제 가능)
/// ✅ 단일 책임: 어댑터 패턴으로 인터페이스 변환만 담당

library;

import '../repositories/token_repository.dart';
import 'token_storage_service.dart';

class TokenStorageAdapter implements TokenRepository {
  final TokenStorageService _service;

  TokenStorageAdapter(this._service);

  @override
  Future<String?> getAccessToken() => _service.getAccessToken();

  @override
  Future<String?> getRefreshToken() => _service.getRefreshToken();

  @override
  Future<void> saveAccessToken(String token) => _service.saveAccessToken(token);

  @override
  Future<void> saveRefreshToken(String token) =>
      _service.saveRefreshToken(token);

  @override
  Future<void> clearTokens() => _service.clearTokens();

  @override
  Future<String?> getStudentId() => _service.getStudentId();

  @override
  Future<void> saveStudentId(String studentId) =>
      _service.saveStudentId(studentId);
}
