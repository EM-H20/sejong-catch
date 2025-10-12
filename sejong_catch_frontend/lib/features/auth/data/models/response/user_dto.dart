// 👤 사용자 정보 DTO
//
// 참조: INTEGRATION_GUIDE.md - Node.js 서버 로그인 응답
// API 응답에서 받는 사용자 기본 정보
//
// CLAUDE.md 원칙:
// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
// ✅ JSON 수동 파싱 (fromJson, toJson)
// ✅ 불변 객체 (final 필드)
//
// Node.js 서버 응답 구조:
// ```json
// {
//   "id": "u_21011572",
//   "student_id": "21011572",
//   "role": "student",
//   "name": "홍길동",
//   "major": "컴퓨터공학과"
// }
// ```

/// 사용자 정보 DTO 모델
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

  /// JSON → UserDto 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final userDto = UserDto.fromJson(response.data['user']);
  /// print(userDto.role); // "student"
  /// ```
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      role: json['role'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
    );
  }

  /// UserDto → JSON 변환
  Map<String, dynamic> toJson() => {
        'id': id,
        'student_id': studentId,
        'role': role,
        'name': name,
        'major': major,
      };

  @override
  String toString() =>
      'UserDto(id: $id, studentId: $studentId, role: $role, name: $name, major: $major)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
