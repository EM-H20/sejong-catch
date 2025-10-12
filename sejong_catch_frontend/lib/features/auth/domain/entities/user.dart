// 👤 사용자 엔티티 (Domain Layer)
//
// 참조: INTEGRATION_GUIDE.md - Node.js 서버 User 객체
// 비즈니스 로직에서 사용하는 순수 사용자 모델
//
// CLAUDE.md 원칙:
// ✅ Freezed 미사용 - 일반 Dart 클래스로 구현
// ✅ DTO와 분리 (Data ↔ Domain 변환)
// ✅ copyWith 수동 구현
// ✅ 불변 객체 (final 필드)
//
// RBAC 시스템 활성화:
// - role 필드로 권한 체크 (Guest < Student < Operator < Admin)
// - GoRouter guard에서 권한 검증

import '../../data/models/response/user_dto.dart';

/// 사용자 엔티티 모델
class User {
  final String id;
  final String studentId;
  final String role;
  final String name;
  final String major;

  const User({
    required this.id,
    required this.studentId,
    required this.role,
    required this.name,
    required this.major,
  });

  /// DTO → Entity 변환
  ///
  /// Data Layer에서 받은 DTO를 Domain Entity로 변환
  /// ```dart
  /// final user = User.fromDto(userDto);
  /// print(user.role); // "student"
  /// ```
  factory User.fromDto(UserDto dto) {
    return User(
      id: dto.id,
      studentId: dto.studentId,
      role: dto.role,
      name: dto.name,
      major: dto.major,
    );
  }

  /// 권한 레벨 체크 (RBAC)
  ///
  /// Guest(0) < Student(1) < Operator(2) < Admin(3)
  int get roleLevel {
    switch (role.toLowerCase()) {
      case 'admin':
        return 3;
      case 'operator':
        return 2;
      case 'student':
        return 1;
      default:
        return 0; // guest
    }
  }

  /// 최소 권한 레벨 확인
  ///
  /// 사용 예시:
  /// ```dart
  /// if (user.hasMinRole('student')) {
  ///   // 줄서기 기능 활성화
  /// }
  /// ```
  bool hasMinRole(String minRole) {
    final minLevel = _getRoleLevel(minRole);
    return roleLevel >= minLevel;
  }

  int _getRoleLevel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 3;
      case 'operator':
        return 2;
      case 'student':
        return 1;
      default:
        return 0;
    }
  }

  /// copyWith (불변 업데이트용)
  ///
  /// 사용 예시:
  /// ```dart
  /// final updatedUser = user.copyWith(role: 'operator');
  /// ```
  User copyWith({
    String? id,
    String? studentId,
    String? role,
    String? name,
    String? major,
  }) {
    return User(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      role: role ?? this.role,
      name: name ?? this.name,
      major: major ?? this.major,
    );
  }

  @override
  String toString() =>
      'User(id: $id, studentId: $studentId, role: $role, name: $name, major: $major)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
