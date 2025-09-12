/// 입력값 검증을 담당하는 서비스 클래스
/// 
/// 로그인 과정에서 필요한 모든 검증 로직을 중앙화하여 관리합니다.
/// 재사용 가능하고 테스트하기 쉬운 순수 함수들로 구성되어 있어요! ✅
library;

/// 입력값 검증을 위한 서비스 클래스
/// 
/// 모든 메서드는 static으로 구현되어 인스턴스 생성 없이 사용 가능합니다.
/// 검증 실패 시 String 메시지를 반환하고, 성공 시 null을 반환해요.
class ValidationService {
  // private 생성자 - 인스턴스 생성 방지
  ValidationService._();

  // ===== 세종대 계정 검증 =====

  /// 세종대 계정 입력값 검증
  /// 
  /// 학번, 이메일, 아이디 등 다양한 형식을 모두 허용하는 유연한 검증입니다.
  /// 실제 인증은 서버에서 처리하므로, 여기서는 기본적인 형식만 확인해요.
  /// 
  /// [value] 입력된 계정 정보
  /// 
  /// 반환값: 오류 메시지 (String) 또는 null (검증 성공)
  static String? validateStudentAccount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '세종대 계정을 입력해주세요! 🎓';
    }

    final cleanValue = value.trim();

    // 최소 길이 확인 (너무 짧으면 의미 없음)
    if (cleanValue.length < 2) {
      return '계정이 너무 짧습니다';
    }

    // 최대 길이 확인 (너무 길면 오타 가능성)
    if (cleanValue.length > 50) {
      return '계정이 너무 깁니다';
    }

    // 특수문자 제한 (기본적인 문자만 허용)
    // 영문, 숫자, @, ., _, - 만 허용
    final validPattern = RegExp(r'^[a-zA-Z0-9@._-]+$');
    if (!validPattern.hasMatch(cleanValue)) {
      return '올바르지 않은 문자가 포함되어 있습니다';
    }

    // 이메일 형식인 경우 기본 검증
    if (cleanValue.contains('@')) {
      return _validateEmailFormat(cleanValue);
    }

    // 모든 검증 통과
    return null;
  }

  /// 이메일 형식 검증 (기본적인 형식만)
  static String? _validateEmailFormat(String email) {
    // 매우 기본적인 이메일 형식 검증
    // 완벽한 RFC 규격보다는 실용적인 검증을 우선시
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );

    if (!emailRegex.hasMatch(email)) {
      return '올바른 이메일 형식을 입력해주세요';
    }

    return null;
  }

  // ===== 비밀번호 검증 =====

  /// 비밀번호 검증
  /// 
  /// 세종대 시스템의 비밀번호 정책을 따릅니다.
  /// 
  /// [value] 입력된 비밀번호
  /// 
  /// 반환값: 오류 메시지 (String) 또는 null (검증 성공)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요! 🔐';
    }

    // 최소 길이 확인
    if (value.length < 4) {
      return '비밀번호가 너무 짧습니다';
    }

    // 최대 길이 확인 (보안상 너무 길면 문제될 수 있음)
    if (value.length > 50) {
      return '비밀번호가 너무 깁니다';
    }

    // 공백 확인 (비밀번호에 공백이 있으면 문제)
    if (value.contains(' ')) {
      return '비밀번호에는 공백을 사용할 수 없습니다';
    }

    // 모든 검증 통과
    return null;
  }

  // ===== 전화번호 검증 =====

  /// 전화번호 검증 - 한국 형식 (010-0000-0000)
  /// 
  /// 한국의 010 번호 체계를 기준으로 검증합니다.
  /// 하이픈은 있어도 되고 없어도 됩니다.
  /// 
  /// [value] 입력된 전화번호
  /// 
  /// 반환값: 오류 메시지 (String) 또는 null (검증 성공)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '전화번호를 입력해주세요 📱';
    }

    // 하이픈과 공백 제거 후 검증
    final cleanPhone = value.trim()
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // 숫자만 남았는지 확인
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
      return '숫자만 입력 가능합니다';
    }

    // 한국 휴대폰 번호 형식 (010으로 시작하는 11자리)
    if (!RegExp(r'^010[0-9]{8}$').hasMatch(cleanPhone)) {
      return '올바른 전화번호 형식을 입력해주세요 (010-0000-0000)';
    }

    // 모든 검증 통과
    return null;
  }

  /// 전화번호를 표준 형식으로 포맷팅
  /// 
  /// 예: "01012345678" → "010-1234-5678"
  /// 
  /// [phoneNumber] 포맷팅할 전화번호
  /// 
  /// 반환값: 포맷팅된 전화번호 또는 원본 (포맷팅 실패 시)
  static String formatPhoneNumber(String phoneNumber) {
    final cleanPhone = phoneNumber
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '');

    // 010으로 시작하는 11자리인 경우만 포맷팅
    if (RegExp(r'^010[0-9]{8}$').hasMatch(cleanPhone)) {
      return '${cleanPhone.substring(0, 3)}-${cleanPhone.substring(3, 7)}-${cleanPhone.substring(7, 11)}';
    }

    // 포맷팅할 수 없으면 원본 반환
    return phoneNumber;
  }

  // ===== 한글 이름 검증 =====

  /// 한글 이름 검증 (2~4글자)
  /// 
  /// 한국인의 일반적인 이름 패턴을 기준으로 검증합니다.
  /// 
  /// [value] 입력된 이름
  /// 
  /// 반환값: 오류 메시지 (String) 또는 null (검증 성공)
  static String? validateKoreanName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이름을 입력해주세요 😊';
    }

    final cleanName = value.trim();

    // 길이 확인 (2~4글자)
    if (cleanName.length < 2) {
      return '이름이 너무 짧습니다 (최소 2글자)';
    }

    if (cleanName.length > 4) {
      return '이름이 너무 깁니다 (최대 4글자)';
    }

    // 한글만 허용
    if (!RegExp(r'^[가-힣]+$').hasMatch(cleanName)) {
      return '한글 이름만 입력 가능합니다';
    }

    // 의미없는 반복 문자 체크 (예: "ㄱㄱㄱ", "아아아")
    if (_hasRepeatingPattern(cleanName)) {
      return '올바른 이름을 입력해주세요';
    }

    // 모든 검증 통과
    return null;
  }

  /// 반복 패턴 감지 (같은 글자가 3번 이상 반복)
  static bool _hasRepeatingPattern(String text) {
    if (text.length < 3) return false;

    for (int i = 0; i <= text.length - 3; i++) {
      final char = text[i];
      if (text[i + 1] == char && text[i + 2] == char) {
        return true; // 3글자 연속 반복 발견
      }
    }

    return false;
  }

  // ===== 인증번호 검증 =====

  /// 인증번호 검증 (6자리 숫자)
  /// 
  /// SMS로 발송된 6자리 숫자 인증번호를 검증합니다.
  /// 
  /// [value] 입력된 인증번호
  /// 
  /// 반환값: 오류 메시지 (String) 또는 null (검증 성공)
  static String? validateVerificationCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '인증번호를 입력해주세요 🔢';
    }

    final cleanCode = value.trim();

    // 길이 확인 (정확히 6자리)
    if (cleanCode.length != 6) {
      return '6자리 인증번호를 입력해주세요';
    }

    // 숫자만 허용
    if (!RegExp(r'^[0-9]{6}$').hasMatch(cleanCode)) {
      return '숫자만 입력 가능합니다';
    }

    // 너무 단순한 패턴 체크 (예: 000000, 123456, 111111)
    if (_isTooSimpleCode(cleanCode)) {
      return '올바른 인증번호를 입력해주세요';
    }

    // 모든 검증 통과
    return null;
  }

  /// 단순한 인증번호 패턴 감지
  /// 
  /// 보안상 너무 단순한 패턴은 거부합니다.
  static bool _isTooSimpleCode(String code) {
    // 모든 자리가 같은 숫자 (000000, 111111 등)
    if (code.split('').toSet().length == 1) {
      return true;
    }

    // 연속된 숫자 (123456, 654321 등)
    bool isAscending = true;
    bool isDescending = true;

    for (int i = 0; i < code.length - 1; i++) {
      final current = int.parse(code[i]);
      final next = int.parse(code[i + 1]);

      if (next != current + 1) {
        isAscending = false;
      }
      if (next != current - 1) {
        isDescending = false;
      }
    }

    return isAscending || isDescending;
  }

  // ===== 종합 검증 메서드 =====

  /// 여러 필드를 한 번에 검증하는 헬퍼 메서드
  /// 
  /// Form 전체의 유효성을 확인할 때 사용합니다.
  /// 
  /// [fields] 검증할 필드들의 Map (필드명 -> 값)
  /// 
  /// 반환값: 검증 실패한 필드들의 Map (필드명 -> 오류 메시지)
  static Map<String, String> validateMultipleFields(Map<String, dynamic> fields) {
    final errors = <String, String>{};

    fields.forEach((fieldName, value) {
      String? error;

      switch (fieldName) {
        case 'studentId':
        case 'account':
          error = validateStudentAccount(value?.toString());
          break;

        case 'password':
          error = validatePassword(value?.toString());
          break;

        case 'phone':
        case 'phoneNumber':
          error = validatePhoneNumber(value?.toString());
          break;

        case 'name':
        case 'userName':
          error = validateKoreanName(value?.toString());
          break;

        case 'verificationCode':
        case 'code':
          error = validateVerificationCode(value?.toString());
          break;

        default:
          // 알 수 없는 필드는 무시
          break;
      }

      if (error != null) {
        errors[fieldName] = error;
      }
    });

    return errors;
  }

  /// 검증 결과가 모두 통과했는지 확인
  /// 
  /// [validationResults] validateMultipleFields의 결과
  /// 
  /// 반환값: 모든 검증 통과 여부
  static bool isAllValid(Map<String, String> validationResults) {
    return validationResults.isEmpty;
  }

  /// 특정 필드의 검증 결과 확인
  /// 
  /// [validationResults] validateMultipleFields의 결과
  /// [fieldName] 확인할 필드명
  /// 
  /// 반환값: 해당 필드의 검증 통과 여부
  static bool isFieldValid(Map<String, String> validationResults, String fieldName) {
    return !validationResults.containsKey(fieldName);
  }
}