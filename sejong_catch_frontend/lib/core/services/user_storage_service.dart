import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/models/response/login_response.dart';

part 'user_storage_service.g.dart';

/// 사용자 정보 로컬 저장소 서비스
///
/// **역할**:
/// - UserDto를 SharedPreferences에 JSON 형태로 저장
/// - 앱 재시작 시 사용자 정보 복원
/// - 로그아웃 시 사용자 정보 삭제
///
/// **사용처**:
/// - AuthStateController: 앱 시작 시 사용자 정보 불러오기
/// - LoginController: 로그인 성공 시 사용자 정보 저장
@riverpod
class UserStorageService extends _$UserStorageService {
  static const String _userKey = 'current_user';

  @override
  FutureOr<void> build() {}

  /// 사용자 정보 저장
  ///
  /// **동작**:
  /// - UserDto를 JSON으로 직렬화
  /// - SharedPreferences에 'current_user' 키로 저장
  ///
  /// **사용 예시**:
  /// ```dart
  /// final userStorage = ref.read(userStorageServiceProvider.notifier);
  /// await userStorage.saveUser(response.user);
  /// ```
  Future<void> saveUser(UserDto user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(user.toJson());
      await prefs.setString(_userKey, jsonString);
    } catch (e) {
      // 저장 실패 시 에러 던지기
      throw Exception('사용자 정보 저장 실패: $e');
    }
  }

  /// 사용자 정보 불러오기
  ///
  /// **동작**:
  /// - SharedPreferences에서 'current_user' 읽기
  /// - JSON을 UserDto로 역직렬화
  /// - 데이터 없으면 null 반환
  ///
  /// **반환**: UserDto 또는 null
  ///
  /// **사용 예시**:
  /// ```dart
  /// final userStorage = ref.read(userStorageServiceProvider.notifier);
  /// final user = await userStorage.getUser();
  /// if (user != null) {
  ///   print('로그인됨: ${user.name}');
  /// }
  /// ```
  Future<UserDto?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_userKey);

      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserDto.fromJson(json);
    } catch (e) {
      // JSON 파싱 실패 시 null 반환 (로그아웃 상태로 간주)
      return null;
    }
  }

  /// 사용자 정보 삭제
  ///
  /// **동작**:
  /// - SharedPreferences에서 'current_user' 키 삭제
  ///
  /// **사용처**:
  /// - 로그아웃 시 호출
  ///
  /// **사용 예시**:
  /// ```dart
  /// final userStorage = ref.read(userStorageServiceProvider.notifier);
  /// await userStorage.clearUser();
  /// ```
  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
    } catch (e) {
      // 삭제 실패해도 무시 (이미 없을 수 있음)
    }
  }

  /// 사용자 정보 존재 여부 확인
  ///
  /// **반환**: 저장된 사용자 정보가 있으면 true
  ///
  /// **사용 예시**:
  /// ```dart
  /// final userStorage = ref.read(userStorageServiceProvider.notifier);
  /// final hasUser = await userStorage.hasUser();
  /// if (hasUser) {
  ///   print('로그인 상태 유지 중');
  /// }
  /// ```
  Future<bool> hasUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }
}
