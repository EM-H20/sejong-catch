/// 👤 사용자 프로필 DTO (상세 정보 포함)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - GET /api/users/me 응답
/// UserDto + 계정 생성일, 마지막 로그인 정보 포함
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)
/// ✅ DateTime ISO 8601 파싱

class UserProfileDto {
  final String studentId;
  final String name;
  final String major;
  final int year;
  final DateTime createdAt;
  final DateTime lastLogin;

  const UserProfileDto({
    required this.studentId,
    required this.name,
    required this.major,
    required this.year,
    required this.createdAt,
    required this.lastLogin,
  });

  /// JSON → UserProfileDto 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final profile = UserProfileDto.fromJson(response.data['user']);
  /// print('가입일: ${profile.createdAt}'); // 2025-01-15T10:30:00.000Z
  /// ```
  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      studentId: json['student_id'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
      year: json['year'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: DateTime.parse(json['last_login'] as String),
    );
  }

  /// UserProfileDto → JSON 변환
  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'name': name,
        'major': major,
        'year': year,
        'created_at': createdAt.toIso8601String(),
        'last_login': lastLogin.toIso8601String(),
      };

  @override
  String toString() =>
      'UserProfileDto(studentId: $studentId, name: $name, major: $major, year: $year, createdAt: $createdAt, lastLogin: $lastLogin)';
}
