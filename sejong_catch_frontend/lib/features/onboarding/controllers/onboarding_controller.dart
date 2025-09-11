import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 온보딩 진행 상태를 나타내는 열거형
enum OnboardingStep {
  /// 1단계: 앱 소개
  intro(0, '앱 소개', '세종인을 위한 단 하나의 정보 허브'),
  /// 2단계: 기능 설명
  features(1, '기능 소개', '자동 수집, 중복 제거, 신뢰도 반영'),
  /// 3단계: 역할 시스템
  roles(2, '역할 시스템', '게스트부터 관리자까지'),
  /// 4단계: 개인화 설정
  personalize(3, '개인화', '나만의 맞춤 설정');

  const OnboardingStep(this.stepIndex, this.title, this.subtitle);
  
  final int stepIndex;
  final String title;
  final String subtitle;
  
  /// 다음 단계 반환
  OnboardingStep? get next {
    if (stepIndex < OnboardingStep.values.length - 1) {
      return OnboardingStep.values[stepIndex + 1];
    }
    return null;
  }
  
  /// 이전 단계 반환
  OnboardingStep? get previous {
    if (stepIndex > 0) {
      return OnboardingStep.values[stepIndex - 1];
    }
    return null;
  }
  
  /// 마지막 단계인지 확인
  bool get isLast => stepIndex == OnboardingStep.values.length - 1;
  
  /// 첫 번째 단계인지 확인
  bool get isFirst => stepIndex == 0;
}

/// 사용자가 선택 가능한 학과 목록
class Department {
  final String code;
  final String name;
  final String category;
  
  const Department({
    required this.code,
    required this.name,
    required this.category,
  });
  
  @override
  String toString() => name;
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Department && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

/// 세종대학교 학과 목록 (실제 학과 기준)
class Departments {
  static const List<Department> all = [
    // 공과대학
    Department(code: 'CS', name: '컴퓨터공학과', category: '공과대학'),
    Department(code: 'EE', name: '전자정보통신공학과', category: '공과대학'),
    Department(code: 'ME', name: '기계공학과', category: '공과대학'),
    Department(code: 'CE', name: '건설환경공학과', category: '공과대학'),
    Department(code: 'CHE', name: '화학공학과', category: '공과대학'),
    Department(code: 'MSE', name: '신소재공학과', category: '공과대학'),
    Department(code: 'AE', name: '항공우주공학과', category: '공과대학'),
    
    // 경영경제대학
    Department(code: 'BIZ', name: '경영학부', category: '경영경제대학'),
    Department(code: 'ECON', name: '경제학과', category: '경영경제대학'),
    Department(code: 'FIN', name: '금융투자학과', category: '경영경제대학'),
    
    // 인문과학대학
    Department(code: 'KOR', name: '국어국문학과', category: '인문과학대학'),
    Department(code: 'ENG', name: '영어영문학과', category: '인문과학대학'),
    Department(code: 'HIS', name: '사학과', category: '인문과학대학'),
    Department(code: 'PHIL', name: '철학과', category: '인문과학대학'),
    
    // 사회과학대학
    Department(code: 'LAW', name: '법학과', category: '사회과학대학'),
    Department(code: 'POL', name: '정치외교학과', category: '사회과학대학'),
    Department(code: 'SOC', name: '사회학과', category: '사회과학대학'),
    Department(code: 'PSY', name: '심리학과', category: '사회과학대학'),
    
    // 자연과학대학
    Department(code: 'MATH', name: '수학통계학부', category: '자연과학대학'),
    Department(code: 'PHYS', name: '물리천문학과', category: '자연과학대학'),
    Department(code: 'CHEM', name: '화학과', category: '자연과학대학'),
    Department(code: 'BIO', name: '생명과학과', category: '자연과학대학'),
    
    // 예체능대학
    Department(code: 'ART', name: '회화과', category: '예체능대학'),
    Department(code: 'MUS', name: '음악과', category: '예체능대학'),
    Department(code: 'PE', name: '체육학과', category: '예체능대학'),
    
    // 기타
    Department(code: 'OTHER', name: '기타', category: '기타'),
  ];
  
  /// 카테고리별로 그룹화된 학과 목록
  static Map<String, List<Department>> get byCategory {
    final map = <String, List<Department>>{};
    for (final dept in all) {
      map.putIfAbsent(dept.category, () => []).add(dept);
    }
    return map;
  }
}

/// 미리 정의된 관심사 키워드
class InterestKeywords {
  static const List<String> popular = [
    '공모전', '취업', '인턴십', '장학금', 
    '논문', '세미나', '해외연수', '창업',
    '연구', '프로젝트', '스터디', '동아리',
    '봉사활동', '문화행사', '교육', '기술',
  ];
  
  static const Map<String, List<String>> byCategory = {
    '학업': ['논문', '연구', '학회', '세미나', '프로젝트', '스터디'],
    '취업': ['인턴십', '취업', '채용', '면접', '자격증', '포트폴리오'],
    '공모전': ['공모전', '경진대회', '창업', '아이디어', '해커톤'],
    '장학금': ['장학금', '지원금', '펀딩', '후원'],
    '활동': ['동아리', '봉사활동', '문화행사', '교육', '워크샵'],
    '국제': ['해외연수', '교환학생', '어학', '글로벌'],
  };
}

/// 온보딩 플로우의 상태와 진행을 관리하는 컨트롤러
/// 
/// 4단계 온보딩 과정에서 사용자의 선택을 수집하고,
/// 최종적으로 AppController에 설정을 반영합니다.
class OnboardingController extends ChangeNotifier {
  // PageView 컨트롤러
  late final PageController _pageController;
  
  // 현재 상태
  OnboardingStep _currentStep = OnboardingStep.intro;
  bool _isAnimating = false;
  
  // 사용자 설정 수집
  Department? _selectedDepartment;
  List<String> _selectedInterests = [];
  bool _allowNotifications = true;
  bool _allowDataCollection = true;
  
  // 저장소 키
  static const String _keyTempSettings = 'onboarding_temp_settings';
  
  // Constructor
  OnboardingController() {
    _pageController = PageController(initialPage: 0);
  }
  
  // Getters
  PageController get pageController => _pageController;
  OnboardingStep get currentStep => _currentStep;
  int get currentIndex => _currentStep.stepIndex;
  bool get isAnimating => _isAnimating;
  bool get canGoNext => !_isAnimating && (!_currentStep.isLast || _isSettingsValid);
  bool get canGoPrevious => !_isAnimating && !_currentStep.isFirst;
  bool get isLastStep => _currentStep.isLast;
  double get progress => (_currentStep.stepIndex + 1) / OnboardingStep.values.length;
  
  // 설정 관련 getters
  Department? get selectedDepartment => _selectedDepartment;
  List<String> get selectedInterests => List.unmodifiable(_selectedInterests);
  bool get allowNotifications => _allowNotifications;
  bool get allowDataCollection => _allowDataCollection;
  
  /// 마지막 단계에서 필수 설정이 완료되었는지 확인
  bool get _isSettingsValid {
    if (!_currentStep.isLast) return true;
    // 마지막 단계에서는 학과 선택이 필수
    return _selectedDepartment != null;
  }
  
  /// 다음 페이지로 이동
  Future<void> goToNext() async {
    if (!canGoNext) return;
    
    final nextStep = _currentStep.next;
    if (nextStep != null) {
      await _animateToStep(nextStep);
    } else {
      // 마지막 페이지에서 완료 처리
      await completeOnboarding();
    }
  }
  
  /// 이전 페이지로 이동
  Future<void> goToPrevious() async {
    if (!canGoPrevious) return;
    
    final previousStep = _currentStep.previous;
    if (previousStep != null) {
      await _animateToStep(previousStep);
    }
  }
  
  /// 특정 단계로 직접 이동
  Future<void> goToStep(OnboardingStep step) async {
    if (_isAnimating || step == _currentStep) return;
    await _animateToStep(step);
  }
  
  /// 특정 페이지 인덱스로 이동
  Future<void> goToPage(int pageIndex) async {
    if (pageIndex < 0 || pageIndex >= OnboardingStep.values.length) return;
    await goToStep(OnboardingStep.values[pageIndex]);
  }
  
  /// 페이지 애니메이션 처리
  Future<void> _animateToStep(OnboardingStep step) async {
    if (_isAnimating) return;
    
    _isAnimating = true;
    notifyListeners();
    
    try {
      await _pageController.animateToPage(
        step.stepIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      
      _currentStep = step;
      await _saveTempSettings(); // 진행 상황 임시 저장
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ 페이지 이동 애니메이션 실패: $e');
      }
    } finally {
      _isAnimating = false;
      notifyListeners();
    }
  }
  
  /// PageView에서 페이지가 변경되었을 때 호출
  void onPageChanged(int pageIndex) {
    if (pageIndex >= 0 && pageIndex < OnboardingStep.values.length) {
      _currentStep = OnboardingStep.values[pageIndex];
      notifyListeners();
    }
  }
  
  /// 학과 선택
  void selectDepartment(Department? department) {
    if (_selectedDepartment == department) return;
    
    _selectedDepartment = department;
    notifyListeners();
    _saveTempSettings();
    
    if (kDebugMode) {
      print('🏫 학과 선택: ${department?.name ?? '없음'}');
    }
  }
  
  /// 관심사 추가/제거
  void toggleInterest(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      // 최대 5개까지만 선택 가능
      if (_selectedInterests.length < 5) {
        _selectedInterests.add(interest);
      }
    }
    
    notifyListeners();
    _saveTempSettings();
    
    if (kDebugMode) {
      print('💡 관심사 업데이트: $_selectedInterests');
    }
  }
  
  /// 커스텀 관심사 추가
  void addCustomInterest(String interest) {
    final trimmed = interest.trim();
    if (trimmed.isEmpty || _selectedInterests.contains(trimmed)) return;
    
    if (_selectedInterests.length < 5) {
      _selectedInterests.add(trimmed);
      notifyListeners();
      _saveTempSettings();
      
      if (kDebugMode) {
        print('➕ 커스텀 관심사 추가: $trimmed');
      }
    }
  }
  
  /// 알림 허용 설정
  void setAllowNotifications(bool allow) {
    if (_allowNotifications == allow) return;
    
    _allowNotifications = allow;
    notifyListeners();
    _saveTempSettings();
  }
  
  /// 데이터 수집 허용 설정
  void setAllowDataCollection(bool allow) {
    if (_allowDataCollection == allow) return;
    
    _allowDataCollection = allow;
    notifyListeners();
    _saveTempSettings();
  }
  
  /// 온보딩 완료 처리
  Future<void> completeOnboarding() async {
    if (!_isSettingsValid) {
      if (kDebugMode) {
        print('❌ 온보딩 완료 불가: 필수 설정 미완료');
      }
      return;
    }
    
    try {
      // 임시 설정을 실제 앱 설정에 반영하는 로직은
      // OnboardingFlowPage에서 AppController를 통해 처리됩니다.
      
      // 임시 저장된 설정 삭제
      await _clearTempSettings();
      
      if (kDebugMode) {
        print('🎉 온보딩 완료!');
        print('   - 학과: ${_selectedDepartment?.name}');
        print('   - 관심사: $_selectedInterests');
        print('   - 알림: $_allowNotifications');
        print('   - 데이터수집: $_allowDataCollection');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ 온보딩 완료 처리 실패: $e');
      }
    }
  }
  
  /// 온보딩 건너뛰기
  Future<void> skipOnboarding() async {
    try {
      // 최소한의 기본 설정으로 완료 처리
      _selectedDepartment = null; // 나중에 설정 가능
      _selectedInterests = [];
      _allowNotifications = true;
      _allowDataCollection = true;
      
      await _clearTempSettings();
      
      if (kDebugMode) {
        print('⏭️ 온보딩 건너뛰기');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ 온보딩 건너뛰기 실패: $e');
      }
    }
  }
  
  /// 임시 설정 저장 (진행 중 앱이 종료되어도 복원 가능)
  Future<void> _saveTempSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settings = {
        'current_step': _currentStep.stepIndex,
        'selected_department': _selectedDepartment?.code,
        'selected_interests': _selectedInterests,
        'allow_notifications': _allowNotifications,
        'allow_data_collection': _allowDataCollection,
      };
      
      await prefs.setString(_keyTempSettings, settings.toString());
    } catch (e) {
      if (kDebugMode) {
        print('❌ 임시 설정 저장 실패: $e');
      }
    }
  }
  
  /// 임시 설정 불러오기
  Future<void> loadTempSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsString = prefs.getString(_keyTempSettings);
      
      if (settingsString != null) {
        // TODO: 실제로는 JSON 파싱 사용
        // 여기서는 간단하게 기본값 사용
        
        if (kDebugMode) {
          print('📂 임시 설정 복원됨');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 임시 설정 불러오기 실패: $e');
      }
    }
  }
  
  /// 임시 설정 삭제
  Future<void> _clearTempSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyTempSettings);
    } catch (e) {
      if (kDebugMode) {
        print('❌ 임시 설정 삭제 실패: $e');
      }
    }
  }
  
  /// 설정 초기화 (다시 시작하기)
  void resetSettings() {
    _selectedDepartment = null;
    _selectedInterests.clear();
    _allowNotifications = true;
    _allowDataCollection = true;
    notifyListeners();
    _clearTempSettings();
    
    if (kDebugMode) {
      print('🔄 온보딩 설정 초기화');
    }
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  /// 디버그 정보 출력
  void printDebugInfo() {
    if (kDebugMode) {
      print('🔍 OnboardingController 디버그 정보');
      print('   - 현재 단계: ${_currentStep.title} (${_currentStep.stepIndex + 1}/4)');
      print('   - 애니메이션 중: $_isAnimating');
      print('   - 다음 가능: $canGoNext');
      print('   - 이전 가능: $canGoPrevious');
      print('   - 설정 유효: $_isSettingsValid');
      print('   - 선택된 학과: ${_selectedDepartment?.name ?? '없음'}');
      print('   - 관심사 (${_selectedInterests.length}개): $_selectedInterests');
    }
  }
}