/// 세종 캐치 앱에서 사용하는 모든 유효성 검증 함수들
///
/// 입력 데이터의 유효성을 체크하고, 사용자 친화적인
/// 한국어 에러 메시지를 제공합니다.
class AppValidators {
  // Private constructor - 인스턴스 생성 방지
  AppValidators._();

  // ============================================================================
  // 기본 유효성 검증 (Basic Validators)
  // ============================================================================

  /// 빈 값 검증
  /// null이거나 빈 문자열이면 에러 메시지 반환
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '필수 항목'}을 입력해주세요';
    }
    return null;
  }

  /// 최소 길이 검증
  static String? minLength(String? value, int min, [String? fieldName]) {
    if (value == null || value.length < min) {
      return '${fieldName ?? '입력값'}은 최소 $min자 이상이어야 합니다';
    }
    return null;
  }

  /// 최대 길이 검증
  static String? maxLength(String? value, int max, [String? fieldName]) {
    if (value != null && value.length > max) {
      return '${fieldName ?? '입력값'}은 최대 $max자까지 입력 가능합니다';
    }
    return null;
  }

  /// 길이 범위 검증
  static String? lengthRange(
    String? value,
    int min,
    int max, [
    String? fieldName,
  ]) {
    if (value == null || value.length < min || value.length > max) {
      return '${fieldName ?? '입력값'}은 $min-$max자 사이로 입력해주세요';
    }
    return null;
  }

  // ============================================================================
  // 이메일 & 연락처 검증 (Email & Contact Validators)
  // ============================================================================

  /// 이메일 형식 검증
  /// RFC 5322 표준을 따르는 간단한 이메일 패턴 사용
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이메일을 입력해주세요';
    }

    // 기본적인 이메일 패턴 (대부분의 실용적인 경우를 커버)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return '올바른 이메일 형식을 입력해주세요';
    }

    return null;
  }

  /// 세종대학교 이메일 검증
  /// @sejong.ac.kr 또는 @sju.ac.kr 도메인만 허용
  static String? sejongEmail(String? value) {
    final emailValidation = email(value);
    if (emailValidation != null) return emailValidation;

    final trimmedValue = value!.trim().toLowerCase();
    if (!trimmedValue.endsWith('@sejong.ac.kr') &&
        !trimmedValue.endsWith('@sju.ac.kr')) {
      return '세종대학교 이메일(@sejong.ac.kr 또는 @sju.ac.kr)을 입력해주세요';
    }

    return null;
  }

  /// 휴대폰 번호 검증
  /// 한국 휴대폰 번호 형식 (010-XXXX-XXXX 또는 01012345678)
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '휴대폰 번호를 입력해주세요';
    }

    // 숫자만 추출
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

    // 11자리 숫자이고 010, 011, 016, 017, 018, 019로 시작하는지 확인
    final phoneRegex = RegExp(r'^01[016789]\d{8}$');

    if (!phoneRegex.hasMatch(digitsOnly)) {
      return '올바른 휴대폰 번호를 입력해주세요 (예: 010-1234-5678)';
    }

    return null;
  }

  // ============================================================================
  // 비밀번호 검증 (Password Validators)
  // ============================================================================

  /// 기본 비밀번호 검증
  /// 최소 8자, 영문/숫자/특수문자 중 2종류 이상 조합
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다';
    }

    // 영문, 숫자, 특수문자 포함 여부 확인
    final hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
    final hasDigit = value.contains(RegExp(r'[0-9]'));
    final hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    final typesCount = [hasLetter, hasDigit, hasSpecial].where((x) => x).length;

    if (typesCount < 2) {
      return '영문, 숫자, 특수문자 중 2종류 이상 조합해주세요';
    }

    return null;
  }

  /// 비밀번호 확인 검증
  static String? passwordConfirm(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }

    if (value != originalPassword) {
      return '비밀번호가 일치하지 않습니다';
    }

    return null;
  }

  /// 강력한 비밀번호 검증
  /// 최소 10자, 영문 대소문자, 숫자, 특수문자 모두 포함
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }

    if (value.length < 10) {
      return '비밀번호는 최소 10자 이상이어야 합니다';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return '영문 소문자를 포함해주세요';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return '영문 대문자를 포함해주세요';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return '숫자를 포함해주세요';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return '특수문자를 포함해주세요';
    }

    return null;
  }

  // ============================================================================
  // 숫자 & 날짜 검증 (Number & Date Validators)
  // ============================================================================

  /// 정수 검증
  static String? integer(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '숫자'}를 입력해주세요';
    }

    if (int.tryParse(value.trim()) == null) {
      return '${fieldName ?? '입력값'}은 정수여야 합니다';
    }

    return null;
  }

  /// 양의 정수 검증
  static String? positiveInteger(String? value, [String? fieldName]) {
    final intValidation = integer(value, fieldName);
    if (intValidation != null) return intValidation;

    final intValue = int.parse(value!.trim());
    if (intValue <= 0) {
      return '${fieldName ?? '입력값'}은 0보다 큰 숫자여야 합니다';
    }

    return null;
  }

  /// 범위 내 정수 검증
  static String? integerRange(
    String? value,
    int min,
    int max, [
    String? fieldName,
  ]) {
    final intValidation = integer(value, fieldName);
    if (intValidation != null) return intValidation;

    final intValue = int.parse(value!.trim());
    if (intValue < min || intValue > max) {
      return '${fieldName ?? '입력값'}은 $min-$max 사이의 값이어야 합니다';
    }

    return null;
  }

  /// 실수 검증
  static String? decimal(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? '숫자'}를 입력해주세요';
    }

    if (double.tryParse(value.trim()) == null) {
      return '${fieldName ?? '입력값'}은 숫자여야 합니다';
    }

    return null;
  }

  // ============================================================================
  // 한국어 특화 검증 (Korean Specific Validators)
  // ============================================================================

  /// 한국어 이름 검증 (2-4자의 한글)
  static String? koreanName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이름을 입력해주세요';
    }

    final trimmedValue = value.trim();

    // 한글만 허용 (자음, 모음 단독 제외)
    final koreanNameRegex = RegExp(r'^[가-힣]{2,4}$');

    if (!koreanNameRegex.hasMatch(trimmedValue)) {
      return '이름은 2-4자의 한글로 입력해주세요';
    }

    return null;
  }

  /// 학번 검증 (세종대학교 학번 형식)
  /// 일반적으로 8자리 또는 9자리 숫자
  static String? studentId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '학번을 입력해주세요';
    }

    final trimmedValue = value.trim();

    // 8-9자리 숫자
    final studentIdRegex = RegExp(r'^\d{8,9}$');

    if (!studentIdRegex.hasMatch(trimmedValue)) {
      return '올바른 학번을 입력해주세요 (8-9자리 숫자)';
    }

    return null;
  }

  // ============================================================================
  // 검색 & 키워드 검증 (Search & Keyword Validators)
  // ============================================================================

  /// 검색어 검증
  /// 최소 1자, 최대 100자, 특수문자 일부 제한
  static String? searchKeyword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '검색어를 입력해주세요';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length > 100) {
      return '검색어는 100자 이하로 입력해주세요';
    }

    // 위험한 특수문자 제한 (SQL Injection 등 방지)
    final dangerousChars = RegExp(r'''[<>"';\\]''');
    if (dangerousChars.hasMatch(trimmedValue)) {
      return '검색어에 사용할 수 없는 문자가 포함되어 있습니다';
    }

    return null;
  }

  /// 태그 검증
  /// 영문/한글/숫자/하이픈/언더스코어만 허용, 2-20자
  static String? tag(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '태그를 입력해주세요';
    }

    final trimmedValue = value.trim();

    if (trimmedValue.length < 2 || trimmedValue.length > 20) {
      return '태그는 2-20자로 입력해주세요';
    }

    final tagRegex = RegExp(r'^[가-힣a-zA-Z0-9_-]+$');
    if (!tagRegex.hasMatch(trimmedValue)) {
      return '태그는 한글, 영문, 숫자, 하이픈, 언더스코어만 사용 가능합니다';
    }

    return null;
  }

  // ============================================================================
  // 복합 검증 함수 (Composite Validators)
  // ============================================================================

  /// 여러 검증 함수를 조합해서 실행
  /// 첫 번째 에러가 발생하면 즉시 반환
  static String? compose(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) return result;
    }
    return null;
  }

  /// 필수 + 이메일 검증 조합
  static String? requiredEmail(String? value) {
    return compose(value, [(v) => required(v, '이메일'), email]);
  }

  /// 필수 + 세종대 이메일 검증 조합
  static String? requiredSejongEmail(String? value) {
    return compose(value, [(v) => required(v, '세종대 이메일'), sejongEmail]);
  }

  /// 필수 + 비밀번호 검증 조합
  static String? requiredPassword(String? value) {
    return compose(value, [(v) => required(v, '비밀번호'), password]);
  }

  /// 필수 + 한국어 이름 검증 조합
  static String? requiredKoreanName(String? value) {
    return compose(value, [(v) => required(v, '이름'), koreanName]);
  }

  /// 필수 + 휴대폰 번호 검증 조합
  static String? requiredPhoneNumber(String? value) {
    return compose(value, [(v) => required(v, '휴대폰 번호'), phoneNumber]);
  }

  // ============================================================================
  // 유틸리티 함수들 (Utility Functions)
  // ============================================================================

  /// 폰 번호 포맷팅 (010-1234-5678 형태로 변환)
  static String formatPhoneNumber(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length == 11) {
      return '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
    }

    return phoneNumber; // 형식이 맞지 않으면 원본 반환
  }

  /// 이메일 도메인 추출
  static String? extractEmailDomain(String? email) {
    if (email == null || !email.contains('@')) return null;

    return email.split('@').last.toLowerCase();
  }

  /// 검증 결과 요약 (여러 필드 검증 시 사용)
  static Map<String, String> validateFields(
    Map<String, dynamic> fieldValidators,
  ) {
    final errors = <String, String>{};

    fieldValidators.forEach((fieldName, validator) {
      String? error;

      if (validator is Function) {
        error = validator();
      } else if (validator is String?) {
        error = validator;
      }

      if (error != null) {
        errors[fieldName] = error;
      }
    });

    return errors;
  }

  /// 디버그용: 모든 검증 함수 목록 출력
  static void printValidatorInfo() {
    // 개발 모드에서만 출력
    assert(() {
      // ignore: avoid_print
      print('''
🔍 세종 캐치 검증 함수 목록
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📧 이메일: email(), sejongEmail(), requiredEmail()
🔒 비밀번호: password(), strongPassword(), passwordConfirm()
📱 연락처: phoneNumber(), requiredPhoneNumber()
👤 개인정보: koreanName(), studentId()
🔢 숫자: integer(), positiveInteger(), decimal()
🏷️ 검색: searchKeyword(), tag()
📏 길이: minLength(), maxLength(), lengthRange()
✅ 기본: required(), compose()
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
''');
      return true;
    }());
  }
}
