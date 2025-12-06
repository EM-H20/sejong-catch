/// 🔐 사용자 역할 Enum
///
/// **역할 계층**:
/// - `student`: 일반 학생 (기본값)
/// - `boothManager`: 부스 관리자 (부스 생성/관리 가능)
/// - `admin`: 관리자 (모든 권한)
///
/// **백엔드 DB**:
/// `role` enum('student','booth_manager','admin')
///
/// **사용 예시**:
/// ```dart
/// final role = UserRole.fromString(user.role);
/// if (role.canCreateQueue) {
///   // 부스 생성 버튼 표시
/// }
/// ```
enum UserRole {
  student('student'),
  boothManager('booth_manager'),
  admin('admin');

  final String value;
  const UserRole(this.value);

  /// String → UserRole 변환
  ///
  /// **동작**:
  /// - 일치하는 역할 반환
  /// - 일치 없으면 기본값 `student` 반환 (안전!)
  static UserRole fromString(String? value) {
    if (value == null) return UserRole.student;

    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.student,
    );
  }

  /// 🎫 부스 생성/관리 권한 확인
  ///
  /// **허용 역할**: boothManager, admin
  bool get canCreateQueue => this == boothManager || this == admin;

  /// 🛡️ 관리자 권한 확인
  ///
  /// **허용 역할**: admin만
  bool get isAdmin => this == admin;

  /// 📋 표시용 한글 이름
  String get displayName {
    switch (this) {
      case UserRole.student:
        return '학생';
      case UserRole.boothManager:
        return '부스 관리자';
      case UserRole.admin:
        return '관리자';
    }
  }
}
