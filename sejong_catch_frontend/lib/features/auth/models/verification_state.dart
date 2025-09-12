/// 전화번호 인증 상태 관리를 위한 모델
/// 
/// 게스트 로그인에서 SMS 인증 과정을 추적하고 관리합니다.
/// 타이머, 재전송 로직, 인증 상태 등을 체계적으로 관리해요! 📱
library;

/// 인증 상태 정보를 담는 불변 클래스
/// 
/// Freezed를 사용하지 않고 간단하게 구현한 상태 클래스입니다.
/// 인증 시간, 남은 시간, 재전송 가능 여부 등을 관리합니다.
class VerificationState {
  /// 인증 제한 시간 (기본 3분 = 180초)
  final int totalSeconds;
  
  /// 현재 남은 시간 (초)
  final int remainingSeconds;
  
  /// 인증번호 발송 여부
  final bool isSent;
  
  /// 인증 완료 여부
  final bool isVerified;
  
  /// 재전송 가능 여부
  final bool canResend;
  
  /// 발송된 전화번호
  final String? phoneNumber;
  
  /// 현재 입력된 인증번호
  final String? currentCode;
  
  const VerificationState({
    this.totalSeconds = 180, // 기본 3분
    this.remainingSeconds = 180,
    this.isSent = false,
    this.isVerified = false,
    this.canResend = false,
    this.phoneNumber,
    this.currentCode,
  });
  
  /// 초기 상태 (아직 발송하지 않음)
  static const initial = VerificationState();
  
  /// 발송 완료 상태로 전환
  VerificationState sent({required String phoneNumber}) {
    return VerificationState(
      totalSeconds: totalSeconds,
      remainingSeconds: totalSeconds, // 타이머 리셋
      isSent: true,
      isVerified: false,
      canResend: false,
      phoneNumber: phoneNumber,
      currentCode: null,
    );
  }
  
  /// 시간 감소 (1초씩)
  VerificationState tick() {
    if (remainingSeconds <= 0) {
      // 시간 만료 - 재전송 가능
      return copyWith(
        remainingSeconds: 0,
        canResend: true,
      );
    }
    
    return copyWith(
      remainingSeconds: remainingSeconds - 1,
    );
  }
  
  /// 인증번호 입력 상태 업데이트
  VerificationState updateCode(String code) {
    return copyWith(currentCode: code);
  }
  
  /// 인증 완료 상태로 전환
  VerificationState verified() {
    return copyWith(
      isVerified: true,
      canResend: false,
    );
  }
  
  /// 재전송으로 상태 리셋
  VerificationState resend() {
    return VerificationState(
      totalSeconds: totalSeconds,
      remainingSeconds: totalSeconds, // 타이머 다시 시작
      isSent: true,
      isVerified: false,
      canResend: false,
      phoneNumber: phoneNumber, // 기존 전화번호 유지
      currentCode: null, // 기존 입력 코드 초기화
    );
  }
  
  /// 상태 복사 (copyWith 패턴)
  VerificationState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isSent,
    bool? isVerified,
    bool? canResend,
    String? phoneNumber,
    String? currentCode,
  }) {
    return VerificationState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isSent: isSent ?? this.isSent,
      isVerified: isVerified ?? this.isVerified,
      canResend: canResend ?? this.canResend,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currentCode: currentCode ?? this.currentCode,
    );
  }
  
  /// 시간 포맷팅 (MM:SS 형식)
  /// 
  /// 예: 120초 → "02:00", 65초 → "01:05"
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// 시간 만료 여부
  bool get isExpired => remainingSeconds <= 0 && isSent;
  
  /// 인증번호 입력 가능 여부
  bool get canInputCode => isSent && !isExpired && !isVerified;
  
  /// 인증번호가 6자리인지 확인
  bool get isValidCodeLength => currentCode?.length == 6;
  
  /// 재전송 버튼 표시 여부
  bool get shouldShowResend => isSent && (isExpired || canResend);
  
  /// 타이머 표시 여부
  bool get shouldShowTimer => isSent && !isExpired && !isVerified;
  
  /// 진행 상황을 나타내는 메시지
  String get statusMessage {
    if (!isSent) {
      return '인증번호를 발송해드릴게요';
    }
    
    if (isVerified) {
      return '인증이 완료되었습니다! 🎉';
    }
    
    if (isExpired) {
      return '인증 시간이 만료되었습니다. 재전송을 눌러주세요';
    }
    
    return '인증번호를 입력해주세요 (남은 시간: $formattedTime)';
  }
  
  @override
  String toString() {
    return 'VerificationState('
        'remainingSeconds: $remainingSeconds, '
        'isSent: $isSent, '
        'isVerified: $isVerified, '
        'canResend: $canResend, '
        'phoneNumber: $phoneNumber'
        ')';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is VerificationState &&
        other.totalSeconds == totalSeconds &&
        other.remainingSeconds == remainingSeconds &&
        other.isSent == isSent &&
        other.isVerified == isVerified &&
        other.canResend == canResend &&
        other.phoneNumber == phoneNumber &&
        other.currentCode == currentCode;
  }
  
  @override
  int get hashCode {
    return totalSeconds.hashCode ^
        remainingSeconds.hashCode ^
        isSent.hashCode ^
        isVerified.hashCode ^
        canResend.hashCode ^
        phoneNumber.hashCode ^
        currentCode.hashCode;
  }
}

/// 인증 결과를 나타내는 enum
/// 
/// API 호출 결과나 검증 결과를 명확하게 구분합니다.
enum VerificationResult {
  /// 성공
  success,
  
  /// 잘못된 인증번호
  invalidCode,
  
  /// 시간 만료
  expired,
  
  /// 네트워크 오류
  networkError,
  
  /// 서버 오류
  serverError,
  
  /// 일일 발송 한도 초과
  dailyLimitExceeded,
  
  /// 알 수 없는 오류
  unknown,
}

/// VerificationResult 확장 메서드
extension VerificationResultExtension on VerificationResult {
  /// 사용자에게 보여줄 오류 메시지
  String get message {
    switch (this) {
      case VerificationResult.success:
        return '인증이 완료되었습니다!';
      
      case VerificationResult.invalidCode:
        return '인증번호가 올바르지 않습니다. 다시 확인해주세요';
      
      case VerificationResult.expired:
        return '인증 시간이 만료되었습니다. 재전송을 눌러주세요';
      
      case VerificationResult.networkError:
        return '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요';
      
      case VerificationResult.serverError:
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요';
      
      case VerificationResult.dailyLimitExceeded:
        return '일일 인증번호 발송 한도를 초과했습니다. 내일 다시 시도해주세요';
      
      case VerificationResult.unknown:
        return '알 수 없는 오류가 발생했습니다. 고객센터로 문의해주세요';
    }
  }
  
  /// 성공 여부
  bool get isSuccess => this == VerificationResult.success;
  
  /// 재시도 가능 여부
  bool get canRetry {
    switch (this) {
      case VerificationResult.networkError:
      case VerificationResult.serverError:
      case VerificationResult.invalidCode:
        return true;
      
      default:
        return false;
    }
  }
}