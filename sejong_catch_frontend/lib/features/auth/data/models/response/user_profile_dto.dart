// 👤 사용자 프로필 DTO (상세 정보 포함)
//
// 참조: INTEGRATION_GUIDE.md - Node.js 서버 GET /api/users/me 응답
// UserDto + 계정 생성일, 마지막 로그인 정보 포함
//
// CLAUDE.md 원칙:
// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
// ✅ JSON 수동 파싱 (fromJson, toJson)
// ✅ DateTime ISO 8601 파싱

/// 사용자 프로필 DTO 모델
class UserProfileDto {
  final String id;
  final String studentId;
  final String role;
  final String name;
  final String major;
  final DateTime createdAt;
  final DateTime lastLogin;

  const UserProfileDto({
    required this.id,
    required this.studentId,
    required this.role,
    required this.name,
    required this.major,
    required this.createdAt,
    required this.lastLogin,
  });

  /// JSON → UserProfileDto 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final profile = UserProfileDto.fromJson(response.data);
  /// print('역할: ${profile.role}'); // "student"
  /// print('가입일: ${profile.createdAt}'); // 2025-01-15T10:30:00.000Z
  /// ```
  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    return UserProfileDto(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      role: json['role'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLogin: DateTime.parse(json['last_login'] as String),
    );
  }

  /// UserProfileDto → JSON 변환
  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'role': role,
        'name': name,
        'major': major,
        'created_at': createdAt.toIso8601String(),
        'last_login': lastLogin.toIso8601String(),
      };

  @override
  String toString() =>
      'UserProfileDto(id: $id, studentId: $studentId, role: $role, name: $name, major: $major, createdAt: $createdAt, lastLogin: $lastLogin)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileDto &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
