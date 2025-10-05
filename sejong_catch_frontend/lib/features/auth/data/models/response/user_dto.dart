/// 👤 사용자 정보 DTO
///
/// 참조: claudedocs/AUTH_API_SPEC.md - User 객체 (로그인 응답 포함)
/// API 응답에서 받는 사용자 기본 정보
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ JSON 수동 파싱 (fromJson, toJson)
/// ✅ 불변 객체 (final 필드)

class UserDto {
  final String studentId;
  final String name;
  final String major;
  final int year;

  const UserDto({
    required this.studentId,
    required this.name,
    required this.major,
    required this.year,
  });

  /// JSON → UserDto 변환
  ///
  /// 사용 예시:
  /// ```dart
  /// final userDto = UserDto.fromJson(response.data['user']);
  /// ```
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      studentId: json['student_id'] as String,
      name: json['name'] as String,
      major: json['major'] as String,
      year: json['year'] as int,
    );
  }

  /// UserDto → JSON 변환
  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'name': name,
        'major': major,
        'year': year,
      };

  @override
  String toString() =>
      'UserDto(studentId: $studentId, name: $name, major: $major, year: $year)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          runtimeType == other.runtimeType &&
          studentId == other.studentId;

  @override
  int get hashCode => studentId.hashCode;
}
