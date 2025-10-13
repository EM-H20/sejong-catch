/// 로그인 API 응답 모델
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserDto user;
  final bool linked;
  final SsoDto sso;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.linked,
    required this.sso,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      linked: json['linked'] as bool,
      sso: SsoDto.fromJson(json['sso'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'linked': linked,
      'sso': sso.toJson(),
    };
  }
}

/// 사용자 정보 DTO
class UserDto {
  final String id;
  final String studentId;
  final String role;
  final String name;
  final String major;

  const UserDto({
    required this.id,
    required this.studentId,
    required this.role,
    required this.name,
    required this.major,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      role: json['role'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'role': role,
      'name': name,
      'major': major,
    };
  }
}

/// SSO 정보 DTO
class SsoDto {
  final bool success;
  final bool isAuth;
  final String code;
  final SsoBodyDto body;

  const SsoDto({
    required this.success,
    required this.isAuth,
    required this.code,
    required this.body,
  });

  factory SsoDto.fromJson(Map<String, dynamic> json) {
    return SsoDto(
      success: json['success'] as bool,
      isAuth: json['is_auth'] as bool,
      code: json['code'] as String,
      body: SsoBodyDto.fromJson(json['body'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'is_auth': isAuth,
      'code': code,
      'body': body.toJson(),
    };
  }
}

/// SSO Body DTO
class SsoBodyDto {
  final String name;
  final String major;

  const SsoBodyDto({
    required this.name,
    required this.major,
  });

  factory SsoBodyDto.fromJson(Map<String, dynamic> json) {
    return SsoBodyDto(
      name: json['name'] as String,
      major: json['major'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'major': major,
    };
  }
}
