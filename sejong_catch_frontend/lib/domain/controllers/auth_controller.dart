import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 사용자 인증 상태를 나타내는 열거형
enum AuthStatus {
  /// 인증되지 않음 (게스트 상태)
  unauthenticated,

  /// 로그인 진행 중
  authenticating,

  /// 인증 완료 (학생 로그인)
  authenticated,

  /// 인증 오류
  error,
}

/// 사용자 역할을 나타내는 열거형
enum UserRole {
  /// 게스트 - 제한된 기능 이용 가능
  guest('guest', '게스트', '일부 정보만 볼 수 있어요'),

  /// 학생 - 대부분 기능 이용 가능
  student('student', '학생', '맞춤 추천과 대기열을 이용할 수 있어요'),

  /// 운영자 - 수집 규칙 관리 가능
  operator('operator', '운영자', '정보 수집 규칙을 관리할 수 있어요'),

  /// 관리자 - 모든 기능 이용 가능
  admin('admin', '관리자', '모든 시스템을 관리할 수 있어요');

  const UserRole(this.code, this.displayName, this.description);

  final String code;
  final String displayName;
  final String description;

  /// 코드로부터 UserRole 찾기
  static UserRole fromCode(String code) {
    return UserRole.values.firstWhere(
      (role) => role.code == code,
      orElse: () => UserRole.guest,
    );
  }
}

/// 사용자 정보를 담는 데이터 클래스
class User {
  final String id;
  final String email;
  final String? name;
  final String? department;
  final String? studentId;
  final UserRole role;
  final DateTime? lastLoginAt;

  const User({
    required this.id,
    required this.email,
    this.name,
    this.department,
    this.studentId,
    this.role = UserRole.student,
    this.lastLoginAt,
  });

  /// JSON에서 User 객체 생성
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      department: json['department'] as String?,
      studentId: json['student_id'] as String?,
      role: UserRole.fromCode(json['role'] as String? ?? 'student'),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  /// User 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'department': department,
      'student_id': studentId,
      'role': role.code,
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  /// 사용자 표시 이름 (이름이 없으면 이메일 사용)
  String get displayName => name ?? email.split('@').first;

  /// 학생 여부 확인
  bool get isStudent => role == UserRole.student || isOperator || isAdmin;

  /// 운영자 여부 확인
  bool get isOperator => role == UserRole.operator || isAdmin;

  /// 관리자 여부 확인
  bool get isAdmin => role == UserRole.admin;

  /// 게스트 여부 확인
  bool get isGuest => role == UserRole.guest;
}

/// 세종 캐치 앱의 인증 상태를 관리하는 컨트롤러
///
/// 로그인/로그아웃, 토큰 관리, 사용자 정보 저장 등을 담당합니다.
/// Flutter Secure Storage를 사용해서 민감한 정보를 안전하게 저장해요.
class AuthController extends ChangeNotifier {
  // 상태 변수들
  AuthStatus _status = AuthStatus.unauthenticated;
  User? _currentUser;
  String? _errorMessage;

  // 보안 저장소와 일반 저장소
  static const _secureStorage = FlutterSecureStorage();

  // 저장소 키 상수들
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserInfo = 'user_info';

  // Getters - 외부에서 상태를 읽을 수 있도록
  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _status == AuthStatus.authenticated && _currentUser != null;
  bool get isGuest => !isAuthenticated;
  UserRole get currentRole => _currentUser?.role ?? UserRole.guest;

  /// 인증 컨트롤러 초기화
  ///
  /// 저장된 토큰과 사용자 정보를 복원합니다.
  /// 앱 시작 시 호출해야 해요.
  Future<void> initialize() async {
    try {
      final accessToken = await _secureStorage.read(key: _keyAccessToken);
      final userInfoJson = await _secureStorage.read(key: _keyUserInfo);

      if (accessToken != null && userInfoJson != null) {
        // 저장된 사용자 정보 복원
        final userInfo = Map<String, dynamic>.from(
          // JSON 문자열을 Map으로 파싱 (실제로는 JSON 파싱 라이브러리 사용)
          // 여기서는 간단하게 처리
          {},
        );

        if (userInfo.isNotEmpty) {
          _currentUser = User.fromJson(userInfo);
          _status = AuthStatus.authenticated;

          if (kDebugMode) {
            print('🔐 인증 상태 복원 완료: ${_currentUser?.displayName}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 인증 상태 복원 실패: $e');
      }
      await logout(); // 에러 발생 시 로그아웃 처리
    }

    notifyListeners();
  }

  /// 이메일/비밀번호로 로그인
  ///
  /// 실제 API 연동은 나중에 구현하고, 지금은 목 데이터를 사용합니다.
  Future<bool> loginWithEmail(String email, String password) async {
    if (_status == AuthStatus.authenticating) return false;

    _setAuthenticating();

    try {
      // TODO: 실제 API 호출로 교체
      await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 시뮬레이션

      // 임시 사용자 데이터 (실제로는 서버에서 받아옴)
      final userData = {
        'id': 'user_${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'name': email.split('@').first,
        'department': '컴퓨터공학과',
        'student_id': '20240001',
        'role': 'student',
        'last_login_at': DateTime.now().toIso8601String(),
      };

      final user = User.fromJson(userData);

      // 토큰과 사용자 정보 저장
      await _saveAuthData(
        accessToken: 'mock_access_token_${user.id}',
        refreshToken: 'mock_refresh_token_${user.id}',
        user: user,
      );

      _currentUser = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;

      if (kDebugMode) {
        print('✅ 로그인 성공: ${user.displayName} (${user.role.displayName})');
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('로그인 중 오류가 발생했습니다: $e');
      return false;
    }
  }

  /// 학생 인증으로 로그인 (세종대 포털 연동)
  ///
  /// 실제로는 세종대학교 인증 시스템과 연동됩니다.
  Future<bool> loginWithStudentAuth() async {
    if (_status == AuthStatus.authenticating) return false;

    _setAuthenticating();

    try {
      // TODO: 실제 세종대 인증 API 연동
      await Future.delayed(const Duration(seconds: 2)); // 인증 시간 시뮬레이션

      // 임시 인증된 학생 데이터
      final userData = {
        'id': 'sejong_${DateTime.now().millisecondsSinceEpoch}',
        'email': 'student@sejong.ac.kr',
        'name': '세종학생',
        'department': '컴퓨터공학과',
        'student_id': '20240001',
        'role': 'student',
        'last_login_at': DateTime.now().toIso8601String(),
      };

      final user = User.fromJson(userData);

      await _saveAuthData(
        accessToken: 'sejong_access_token_${user.id}',
        refreshToken: 'sejong_refresh_token_${user.id}',
        user: user,
      );

      _currentUser = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;

      if (kDebugMode) {
        print('🎓 세종대 인증 로그인 성공: ${user.displayName}');
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('학생 인증 중 오류가 발생했습니다: $e');
      return false;
    }
  }

  /// 로그아웃
  ///
  /// 저장된 모든 인증 정보를 삭제하고 게스트 상태로 돌아갑니다.
  Future<void> logout() async {
    try {
      // 보안 저장소에서 인증 정보 삭제
      await _secureStorage.delete(key: _keyAccessToken);
      await _secureStorage.delete(key: _keyRefreshToken);
      await _secureStorage.delete(key: _keyUserInfo);

      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;

      if (kDebugMode) {
        print('👋 로그아웃 완료');
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('❌ 로그아웃 실패: $e');
      }
    }
  }

  /// 토큰 갱신
  ///
  /// 액세스 토큰이 만료되었을 때 리프레시 토큰으로 새로운 토큰을 받아옵니다.
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: _keyRefreshToken);
      if (refreshToken == null) return false;

      // TODO: 실제 토큰 갱신 API 호출
      await Future.delayed(const Duration(milliseconds: 500));

      // 새로운 토큰 저장
      await _secureStorage.write(
        key: _keyAccessToken,
        value: 'new_access_token_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (kDebugMode) {
        print('🔄 토큰 갱신 성공');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 토큰 갱신 실패: $e');
      }
      await logout(); // 토큰 갱신 실패 시 로그아웃
      return false;
    }
  }

  /// 사용자 정보 업데이트
  ///
  /// 프로필 수정 등에서 사용됩니다.
  Future<bool> updateUserInfo({String? name, String? department}) async {
    if (_currentUser == null) return false;

    try {
      // TODO: 실제 API 호출로 서버에 업데이트

      // 로컬 사용자 정보 업데이트
      final updatedUserData = _currentUser!.toJson();
      if (name != null) updatedUserData['name'] = name;
      if (department != null) updatedUserData['department'] = department;

      final updatedUser = User.fromJson(updatedUserData);

      // 저장소에 업데이트된 정보 저장
      await _secureStorage.write(
        key: _keyUserInfo,
        value: updatedUserData.toString(), // 실제로는 JSON.encode 사용
      );

      _currentUser = updatedUser;
      notifyListeners();

      if (kDebugMode) {
        print('👤 사용자 정보 업데이트 완료');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ 사용자 정보 업데이트 실패: $e');
      }
      return false;
    }
  }

  /// 특정 역할 권한 확인
  ///
  /// 라우트 가드에서 사용됩니다.
  bool hasRole(UserRole requiredRole) {
    if (_currentUser == null) return requiredRole == UserRole.guest;

    switch (requiredRole) {
      case UserRole.guest:
        return true; // 모든 사용자가 게스트 권한을 가짐
      case UserRole.student:
        return _currentUser!.isStudent;
      case UserRole.operator:
        return _currentUser!.isOperator;
      case UserRole.admin:
        return _currentUser!.isAdmin;
    }
  }

  /// 특정 기능 접근 권한 확인
  ///
  /// UI에서 기능 활성화/비활성화를 결정할 때 사용됩니다.
  bool canAccess(String feature) {
    switch (feature) {
      case 'queue':
      case 'bookmarks':
      case 'profile':
        return isAuthenticated;
      case 'console':
        return _currentUser?.isOperator ?? false;
      case 'admin':
        return _currentUser?.isAdmin ?? false;
      default:
        return true; // 기본적으로 공개 기능
    }
  }

  // Private 헬퍼 메서드들

  void _setAuthenticating() {
    _status = AuthStatus.authenticating;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    if (kDebugMode) {
      print('❌ 인증 오류: $message');
    }
    notifyListeners();
  }

  Future<void> _saveAuthData({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) async {
    await _secureStorage.write(key: _keyAccessToken, value: accessToken);
    await _secureStorage.write(key: _keyRefreshToken, value: refreshToken);
    await _secureStorage.write(
      key: _keyUserInfo,
      value: user.toJson().toString(),
    );
  }

  /// 디버그 정보 출력 (개발용)
  void printDebugInfo() {
    if (kDebugMode) {
      print('🔍 AuthController 디버그 정보');
      print('   - 상태: $_status');
      print('   - 사용자: ${_currentUser?.displayName ?? '없음'}');
      print('   - 역할: ${_currentUser?.role.displayName ?? '게스트'}');
      print('   - 인증됨: $isAuthenticated');
      if (_errorMessage != null) {
        print('   - 오류: $_errorMessage');
      }
    }
  }
}
