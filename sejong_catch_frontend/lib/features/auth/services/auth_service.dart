/// 인증 처리를 담당하는 서비스 클래스
/// 
/// 세종대 학생 로그인, 게스트 로그인, SMS 인증 등 모든 인증 관련 비즈니스 로직을 처리합니다.
/// 실제 API 통신과 인증 로직을 분리하여 테스트하기 쉽고 재사용 가능하도록 설계되었어요! 🔐
library;

import 'package:flutter/foundation.dart';

/// 인증 관련 API 결과를 담는 클래스
/// 
/// 성공/실패를 명확히 구분하고 오류 정보를 포함합니다.
class AuthResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;
  final String? errorCode;

  const AuthResult._({
    required this.isSuccess,
    this.data,
    this.error,
    this.errorCode,
  });

  /// 성공 결과 생성
  factory AuthResult.success(T data) => AuthResult._(
        isSuccess: true,
        data: data,
      );

  /// 실패 결과 생성
  factory AuthResult.failure(String error, {String? errorCode}) => AuthResult._(
        isSuccess: false,
        error: error,
        errorCode: errorCode,
      );

  /// 실패 여부
  bool get isFailure => !isSuccess;

  @override
  String toString() {
    return 'AuthResult(isSuccess: $isSuccess, data: $data, error: $error)';
  }
}

/// 사용자 정보를 담는 모델
class AuthUser {
  final String id;
  final String name;
  final String email;
  final String? department;
  final String? studentId;
  final bool isStudent;
  final DateTime loginTime;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.department,
    this.studentId,
    required this.isStudent,
    required this.loginTime,
  });

  /// 학생 사용자 생성
  factory AuthUser.student({
    required String id,
    required String name,
    required String email,
    required String studentId,
    String? department,
  }) =>
      AuthUser(
        id: id,
        name: name,
        email: email,
        department: department,
        studentId: studentId,
        isStudent: true,
        loginTime: DateTime.now(),
      );

  /// 게스트 사용자 생성
  factory AuthUser.guest({
    required String id,
    required String name,
    required String phone,
  }) =>
      AuthUser(
        id: id,
        name: name,
        email: '$phone@guest.sejongcatch.com', // 임시 이메일
        isStudent: false,
        loginTime: DateTime.now(),
      );

  @override
  String toString() {
    return 'AuthUser(id: $id, name: $name, isStudent: $isStudent)';
  }
}

/// 인증 처리 서비스
/// 
/// 모든 인증 관련 비즈니스 로직을 담당하는 핵심 서비스입니다.
/// Provider와 연동되어 상태 관리를 담당하는 Controller와 분리되어 있어요.
class AuthService {
  // private 생성자 - 인스턴스 생성 방지
  AuthService._();

  // ===== 세종대 학생 로그인 =====

  /// 세종대 학생 로그인 처리
  /// 
  /// 학번, 이메일, 아이디 등 다양한 형식의 계정으로 로그인을 시도합니다.
  /// 실제로는 세종대 시스템과 연동되지만, 현재는 시뮬레이션 코드입니다.
  /// 
  /// [account] 세종대 계정 (학번, 이메일, 아이디 등)
  /// [password] 비밀번호
  /// 
  /// 반환값: 로그인 결과 (성공 시 사용자 정보 포함)
  static Future<AuthResult<AuthUser>> loginWithStudentAccount(
    String account,
    String password,
  ) async {
    try {
      // 로딩 시뮬레이션 (실제 API 호출 시뮬레이션)
      await Future.delayed(const Duration(seconds: 2));

      // 계정 형식 정규화 (이메일이 아닌 경우 @sejong.ac.kr 추가)
      final normalizedAccount = _normalizeStudentAccount(account);

      // ===== 실제 API 호출 시뮬레이션 =====
      // 향후 실제 세종대 API나 AuthController와 연동 예정

      // 테스트용 계정들 (실제 서비스에서는 제거)
      if (_isTestAccount(normalizedAccount, password)) {
        final user = AuthUser.student(
          id: 'student_${DateTime.now().millisecondsSinceEpoch}',
          name: '홍길동', // 실제로는 API에서 받아옴
          email: normalizedAccount,
          studentId: account.contains('@') ? account.split('@')[0] : account,
          department: '컴퓨터공학과', // 실제로는 API에서 받아옴
        );

        return AuthResult.success(user);
      }

      // 로그인 실패 (잘못된 계정 또는 비밀번호)
      return AuthResult.failure(
        '학번 또는 비밀번호가 올바르지 않습니다. 다시 확인해주세요.',
        errorCode: 'INVALID_CREDENTIALS',
      );
    } catch (e) {
      // 네트워크 오류나 기타 예외 처리
      return AuthResult.failure(
        '로그인 중 오류가 발생했습니다. 네트워크 연결을 확인해주세요.',
        errorCode: 'NETWORK_ERROR',
      );
    }
  }

  /// 세종대 계정 정규화
  /// 
  /// 이메일 형식이 아닌 경우 @sejong.ac.kr을 추가합니다.
  static String _normalizeStudentAccount(String account) {
    final trimmedAccount = account.trim();

    // 이미 이메일 형식인 경우 그대로 사용
    if (trimmedAccount.contains('@')) {
      return trimmedAccount;
    }

    // 학번이나 아이디인 경우 @sejong.ac.kr 추가
    return '$trimmedAccount@sejong.ac.kr';
  }

  /// 테스트 계정 확인 (개발용)
  /// 
  /// 실제 서비스에서는 이 부분을 제거하고 실제 API 호출로 대체해야 합니다.
  static bool _isTestAccount(String account, String password) {
    final testAccounts = {
      'test@sejong.ac.kr': 'test123',
      'student@sejong.ac.kr': 'password',
      '20210001@sejong.ac.kr': 'sejong123',
    };

    return testAccounts[account] == password;
  }

  // ===== 게스트 로그인 (SMS 인증) =====

  /// SMS 인증번호 발송
  /// 
  /// 게스트 로그인을 위해 전화번호로 SMS 인증번호를 발송합니다.
  /// 
  /// [phoneNumber] 전화번호 (010-0000-0000 형식)
  /// [name] 사용자 이름
  /// 
  /// 반환값: 발송 결과
  static Future<AuthResult<String>> sendSmsVerification(
    String phoneNumber,
    String name,
  ) async {
    try {
      // SMS 발송 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));

      // 실제로는 SMS API (예: NHN Toast, AWS SNS 등) 연동
      // 현재는 시뮬레이션으로 항상 성공

      // 발송된 인증번호 (실제로는 SMS로 전송됨)
      const verificationCode = '123456';

      // 개발 중에만 콘솔에 인증번호 출력
      if (kDebugMode) {
        print('📱 SMS 발송 시뮬레이션');
        print('전화번호: $phoneNumber');
        print('이름: $name');
        print('인증번호: $verificationCode');
      }

      return AuthResult.success('인증번호를 발송했습니다.');
    } catch (e) {
      return AuthResult.failure(
        'SMS 발송에 실패했습니다. 잠시 후 다시 시도해주세요.',
        errorCode: 'SMS_SEND_FAILED',
      );
    }
  }

  /// SMS 인증번호 확인
  /// 
  /// 사용자가 입력한 인증번호가 올바른지 확인합니다.
  /// 
  /// [phoneNumber] 전화번호
  /// [verificationCode] 입력된 인증번호
  /// [name] 사용자 이름
  /// 
  /// 반환값: 인증 결과 (성공 시 게스트 사용자 정보 포함)
  static Future<AuthResult<AuthUser>> verifyGuestLogin(
    String phoneNumber,
    String verificationCode,
    String name,
  ) async {
    try {
      // 인증 확인 시뮬레이션
      await Future.delayed(const Duration(seconds: 2));

      // 실제로는 서버에서 인증번호 검증
      // 현재는 시뮬레이션으로 '123456'만 성공
      if (verificationCode == '123456') {
        final user = AuthUser.guest(
          id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          phone: phoneNumber,
        );

        return AuthResult.success(user);
      }

      // 인증번호 불일치
      return AuthResult.failure(
        '인증번호가 올바르지 않습니다. 다시 확인해주세요.',
        errorCode: 'INVALID_VERIFICATION_CODE',
      );
    } catch (e) {
      return AuthResult.failure(
        '인증 처리 중 오류가 발생했습니다. 다시 시도해주세요.',
        errorCode: 'VERIFICATION_FAILED',
      );
    }
  }

  // ===== 로그아웃 및 세션 관리 =====

  /// 로그아웃 처리
  /// 
  /// 저장된 토큰 및 사용자 정보를 모두 삭제합니다.
  static Future<AuthResult<void>> logout() async {
    try {
      // 토큰 삭제, 세션 정리 등
      // 실제로는 SecureStorage에서 토큰 삭제, 서버에 로그아웃 통보 등
      await Future.delayed(const Duration(milliseconds: 500));

      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(
        '로그아웃 처리 중 오류가 발생했습니다.',
        errorCode: 'LOGOUT_FAILED',
      );
    }
  }

  // ===== 유틸리티 메서드 =====

  /// 계정 타입 판별
  /// 
  /// 입력된 계정이 학번인지, 이메일인지, 아이디인지 구분합니다.
  static AccountType getAccountType(String account) {
    final trimmedAccount = account.trim();

    // 이메일 형식
    if (trimmedAccount.contains('@')) {
      return AccountType.email;
    }

    // 8자리 숫자 (학번 형식)
    if (RegExp(r'^[0-9]{8}$').hasMatch(trimmedAccount)) {
      return AccountType.studentId;
    }

    // 그 외는 아이디로 간주
    return AccountType.username;
  }

  /// 에러 메시지 현지화
  /// 
  /// API에서 받은 에러 코드를 사용자 친화적인 메시지로 변환합니다.
  static String getLocalizedErrorMessage(String? errorCode) {
    switch (errorCode) {
      case 'INVALID_CREDENTIALS':
        return '학번 또는 비밀번호가 올바르지 않습니다';

      case 'ACCOUNT_LOCKED':
        return '계정이 잠겨 있습니다. 관리자에게 문의하세요';

      case 'NETWORK_ERROR':
        return '네트워크 연결을 확인해주세요';

      case 'SERVER_ERROR':
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요';

      case 'SMS_SEND_FAILED':
        return 'SMS 발송에 실패했습니다';

      case 'INVALID_VERIFICATION_CODE':
        return '인증번호가 올바르지 않습니다';

      case 'VERIFICATION_EXPIRED':
        return '인증 시간이 만료되었습니다. 재전송을 눌러주세요';

      case 'DAILY_LIMIT_EXCEEDED':
        return '일일 인증번호 발송 한도를 초과했습니다';

      default:
        return '알 수 없는 오류가 발생했습니다';
    }
  }

  /// 로그인 가능 시간 확인
  /// 
  /// 유지보수 시간이나 시스템 점검 시간에는 로그인을 제한할 수 있습니다.
  static bool isLoginAvailable() {
    final now = DateTime.now();
    final hour = now.hour;

    // 새벽 2시~4시는 유지보수 시간으로 로그인 제한 (예시)
    if (hour >= 2 && hour < 4) {
      return false;
    }

    return true;
  }

  /// 유지보수 안내 메시지
  static String getMaintenanceMessage() {
    return '시스템 유지보수 중입니다 (새벽 2시~4시)\n오전 4시 이후에 다시 이용해주세요.';
  }
}

/// 계정 타입 열거형
enum AccountType {
  /// 이메일 형식 (abc@sejong.ac.kr)
  email,

  /// 학번 형식 (8자리 숫자)
  studentId,

  /// 사용자 아이디 형식
  username,
}