import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/config/constants.dart';

/// 세종 캐치 앱의 전체 상태를 관리하는 컨트롤러
/// 
/// 첫 실행 여부, 온보딩 완료 상태, 앱 설정 등을 담당합니다.
/// SharedPreferences를 통해 앱 상태를 영구적으로 저장해요.
class AppController extends ChangeNotifier {
  // 상태 변수들
  bool _isFirstRun = true;
  bool _isOnboardingCompleted = false;
  bool _isInitialized = false;
  String? _selectedDepartment;
  List<String> _interests = [];
  
  // SharedPreferences 키 상수들
  static const String _keyFirstRun = 'is_first_run';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keySelectedDepartment = 'selected_department';
  static const String _keyInterests = 'user_interests';
  
  // Getters - 외부에서 상태를 읽을 수 있도록
  bool get isFirstRun => _isFirstRun;
  
  /// 온보딩 완료 상태
  /// 개발 모드에서는 forceOnboardingInDev 설정에 따라 강제로 false를 반환할 수 있어요
  bool get isOnboardingCompleted {
    // 개발 모드에서 강제 온보딩이 활성화된 경우
    if (AppConstants.isDevelopmentMode && AppConstants.forceOnboardingInDev) {
      return false; // 항상 온보딩을 보여줌
    }
    return _isOnboardingCompleted;
  }
  
  bool get isInitialized => _isInitialized;
  String? get selectedDepartment => _selectedDepartment;
  List<String> get interests => List.unmodifiable(_interests);
  
  /// 앱 초기화 - 저장된 설정을 불러옵니다
  /// 
  /// 앱 시작 시 main.dart에서 호출해야 합니다.
  /// SharedPreferences에서 사용자 설정을 복원해요.
  Future<void> initialize() async {
    if (_isInitialized) return; // 중복 초기화 방지
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 저장된 설정들을 불러오기
      _isFirstRun = prefs.getBool(_keyFirstRun) ?? true;
      _isOnboardingCompleted = prefs.getBool(_keyOnboardingCompleted) ?? false;
      _selectedDepartment = prefs.getString(_keySelectedDepartment);
      _interests = prefs.getStringList(_keyInterests) ?? [];
      
      _isInitialized = true;
      
      if (kDebugMode) {
        print('📱 AppController 초기화 완료');
        print('   - 첫 실행: $_isFirstRun');
        print('   - 온보딩 완료 (저장됨): $_isOnboardingCompleted');
        print('   - 온보딩 완료 (실제): $isOnboardingCompleted');
        print('   - 개발 모드: ${AppConstants.isDevelopmentMode}');
        print('   - 강제 온보딩: ${AppConstants.forceOnboardingInDev}');
        print('   - 선택된 학과: $_selectedDepartment');
        print('   - 관심사: $_interests');
        
        if (AppConstants.isDevelopmentMode && AppConstants.forceOnboardingInDev) {
          print('🚀 개발 모드: 온보딩이 강제로 활성화됨');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ AppController 초기화 실패: $e');
      }
      _isInitialized = true; // 에러가 나도 초기화된 것으로 처리
    }
    
    notifyListeners();
  }
  
  /// 첫 실행 상태 업데이트
  /// 
  /// 앱이 처음 실행되고 나면 false로 설정됩니다.
  Future<void> setFirstRunCompleted() async {
    if (!_isFirstRun) return; // 이미 완료된 경우 무시
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFirstRun, false);
      
      _isFirstRun = false;
      notifyListeners();
      
      if (kDebugMode) {
        print('✅ 첫 실행 완료 처리됨');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 첫 실행 완료 처리 실패: $e');
      }
    }
  }
  
  /// 온보딩 완료 상태 업데이트
  /// 
  /// 온보딩 플로우를 모두 완료했을 때 호출됩니다.
  /// 이후 앱 시작 시 메인 화면으로 바로 이동해요.
  Future<void> setOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyOnboardingCompleted, true);
      
      _isOnboardingCompleted = true;
      await setFirstRunCompleted(); // 첫 실행도 함께 완료 처리
      
      if (kDebugMode) {
        print('🎉 온보딩 완료 처리됨');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 온보딩 완료 처리 실패: $e');
      }
    }
  }
  
  /// 사용자가 선택한 학과 설정
  /// 
  /// 온보딩 마지막 단계에서 설정되며, 이후 추천 알고리즘에 사용됩니다.
  Future<void> setSelectedDepartment(String? department) async {
    if (_selectedDepartment == department) return; // 동일한 값이면 무시
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (department != null) {
        await prefs.setString(_keySelectedDepartment, department);
      } else {
        await prefs.remove(_keySelectedDepartment);
      }
      
      _selectedDepartment = department;
      notifyListeners();
      
      if (kDebugMode) {
        print('🏫 학과 설정 업데이트: $department');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 학과 설정 실패: $e');
      }
    }
  }
  
  /// 사용자 관심사 목록 설정
  /// 
  /// 온보딩 또는 설정에서 관심 키워드를 설정할 때 사용됩니다.
  /// 추천 알고리즘과 필터링에 활용돼요.
  Future<void> setInterests(List<String> newInterests) async {
    // 중복 제거 및 공백 정리
    final cleanedInterests = newInterests
        .map((interest) => interest.trim())
        .where((interest) => interest.isNotEmpty)
        .toSet()
        .toList();
    
    if (listEquals(_interests, cleanedInterests)) return; // 동일하면 무시
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_keyInterests, cleanedInterests);
      
      _interests = cleanedInterests;
      notifyListeners();
      
      if (kDebugMode) {
        print('💡 관심사 설정 업데이트: $cleanedInterests');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 관심사 설정 실패: $e');
      }
    }
  }
  
  /// 관심사 추가
  /// 
  /// 기존 관심사 목록에 새로운 관심사를 추가합니다.
  /// 최대 10개까지 제한해요.
  Future<void> addInterest(String interest) async {
    final trimmedInterest = interest.trim();
    if (trimmedInterest.isEmpty || _interests.contains(trimmedInterest)) {
      return; // 빈 문자열이거나 이미 존재하면 무시
    }
    
    final updatedInterests = List<String>.from(_interests);
    updatedInterests.add(trimmedInterest);
    
    // 최대 10개로 제한
    if (updatedInterests.length > 10) {
      updatedInterests.removeAt(0); // 가장 오래된 것 제거
    }
    
    await setInterests(updatedInterests);
  }
  
  /// 관심사 제거
  /// 
  /// 기존 관심사 목록에서 특정 관심사를 제거합니다.
  Future<void> removeInterest(String interest) async {
    if (!_interests.contains(interest)) return; // 존재하지 않으면 무시
    
    final updatedInterests = List<String>.from(_interests);
    updatedInterests.remove(interest);
    await setInterests(updatedInterests);
  }
  
  /// 앱 설정 초기화 (개발/테스트용)
  /// 
  /// 주의: 이 메서드는 모든 사용자 설정을 삭제합니다!
  /// 개발 중이나 테스트에서만 사용하세요.
  Future<void> resetAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // 관련된 모든 키 삭제
      await prefs.remove(_keyFirstRun);
      await prefs.remove(_keyOnboardingCompleted);
      await prefs.remove(_keySelectedDepartment);
      await prefs.remove(_keyInterests);
      
      // 상태 초기화
      _isFirstRun = true;
      _isOnboardingCompleted = false;
      _selectedDepartment = null;
      _interests = [];
      
      notifyListeners();
      
      if (kDebugMode) {
        print('🔄 앱 설정이 초기화되었습니다');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 앱 설정 초기화 실패: $e');
      }
    }
  }
  
  /// 디버그 정보 출력 (개발용)
  void printDebugInfo() {
    if (kDebugMode) {
      print('🔍 AppController 디버그 정보');
      print('   - 초기화됨: $_isInitialized');
      print('   - 첫 실행: $_isFirstRun');
      print('   - 온보딩 완료 (저장됨): $_isOnboardingCompleted');
      print('   - 온보딩 완료 (실제): $isOnboardingCompleted');
      print('   - 개발 모드: ${AppConstants.isDevelopmentMode}');
      print('   - 강제 온보딩: ${AppConstants.forceOnboardingInDev}');
      print('   - 선택된 학과: $_selectedDepartment');
      print('   - 관심사 (${_interests.length}개): $_interests');
      
      if (AppConstants.isDevelopmentMode && AppConstants.forceOnboardingInDev) {
        print('🚀 현재 개발 모드로 온보딩이 강제 활성화되어 있습니다!');
        print('   운영 모드로 전환하려면 constants.dart에서');
        print('   forceOnboardingInDev = false 로 변경하세요.');
      }
    }
  }
}