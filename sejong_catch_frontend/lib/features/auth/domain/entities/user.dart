/// 👤 사용자 엔티티 (Domain Layer)
///
/// 참조: claudedocs/AUTH_API_SPEC.md - Domain Entity 예시
/// 비즈니스 로직에서 사용하는 순수 사용자 모델
///
/// CLAUDE.md 원칙:
/// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
/// ✅ DTO와 분리 (Data ↔ Domain 변환)
/// ✅ copyWith 수동 구현
/// ✅ 불변 객체 (final 필드)

import '../../data/models/response/user_dto.dart';

class User {
  final String studentId;
  final String name;
  final String major;
  final int year;

  const User({
    required this.studentId,
    required this.name,
    required this.major,
    required this.year,
  });

  /// DTO → Entity 변환
  ///
  /// Data Layer에서 받은 DTO를 Domain Entity로 변환
  /// ```dart
  /// final user = User.fromDto(userDto);
  /// ```
  factory User.fromDto(UserDto dto) {
    return User(
      studentId: dto.studentId,
      name: dto.name,
      major: dto.major,
      year: dto.year,
    );
  }

  /// copyWith (불변 업데이트용)
  ///
  /// 사용 예시:
  /// ```dart
  /// final updatedUser = user.copyWith(year: 4);
  /// ```
  User copyWith({
    String? studentId,
    String? name,
    String? major,
    int? year,
  }) {
    return User(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      major: major ?? this.major,
      year: year ?? this.year,
    );
  }

  @override
  String toString() =>
      'User(studentId: $studentId, name: $name, major: $major, year: $year)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          studentId == other.studentId;

  @override
  int get hashCode => studentId.hashCode;
}
