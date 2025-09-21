library;

/// 🎪 큐 생성 폼 데이터 모델
///
/// API 명세가 변경되어도 유연하게 대응 가능한 구조
/// Features:
/// ✅ 폼 데이터 캡슐화
/// ✅ 유효성 검증 로직 포함
/// ✅ API 요청 DTO 변환 메서드
/// ✅ 일반 Dart 클래스 (Freezed 없이)

import 'package:flutter/material.dart';

/// 큐 타입 열거형
enum QueueType {
  food('food', '🍗 음식', Icons.restaurant),
  drink('drink', '🥤 음료', Icons.local_drink),
  event('event', '🎤 공연', Icons.event),
  game('game', '🎮 게임', Icons.sports_esports),
  photo('photo', '📸 포토존', Icons.camera_alt),
  other('other', '📦 기타', Icons.category);

  const QueueType(this.value, this.label, this.icon);

  final String value;
  final String label;
  final IconData icon;

  static QueueType fromValue(String value) {
    return QueueType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => QueueType.other,
    );
  }
}

/// 큐 생성 폼 데이터
class QueueCreateForm {
  final String name;
  final String description;
  final QueueType type;
  final int maxCapacity;
  final int estimatedServiceTimeMinutes;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const QueueCreateForm({
    required this.name,
    required this.description,
    required this.type,
    required this.maxCapacity,
    required this.estimatedServiceTimeMinutes,
    required this.startTime,
    required this.endTime,
  });

  /// 빈 폼 생성 (초기값)
  factory QueueCreateForm.empty() {
    return const QueueCreateForm(
      name: '',
      description: '',
      type: QueueType.food,
      maxCapacity: 50,
      estimatedServiceTimeMinutes: 3,
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 18, minute: 0),
    );
  }

  /// 폼 데이터 복사 (copyWith)
  QueueCreateForm copyWith({
    String? name,
    String? description,
    QueueType? type,
    int? maxCapacity,
    int? estimatedServiceTimeMinutes,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return QueueCreateForm(
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      estimatedServiceTimeMinutes: estimatedServiceTimeMinutes ?? this.estimatedServiceTimeMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  /// 전체 폼 유효성 검증
  FormValidationResult validate() {
    final errors = <String, String>{};

    // 이름 검증
    if (name.trim().isEmpty) {
      errors['name'] = '큐 이름을 입력해주세요';
    } else if (name.trim().length < 2) {
      errors['name'] = '큐 이름은 2글자 이상 입력해주세요';
    }

    // 설명 검증
    if (description.trim().isEmpty) {
      errors['description'] = '큐 설명을 입력해주세요';
    }

    // 최대 인원 검증
    if (maxCapacity <= 0) {
      errors['maxCapacity'] = '최대 인원은 1명 이상이어야 합니다';
    } else if (maxCapacity > 500) {
      errors['maxCapacity'] = '최대 500명까지 가능합니다';
    }

    // 서비스 시간 검증
    if (estimatedServiceTimeMinutes <= 0) {
      errors['estimatedServiceTime'] = '서비스 시간은 1분 이상이어야 합니다';
    } else if (estimatedServiceTimeMinutes > 60) {
      errors['estimatedServiceTime'] = '최대 60분까지 가능합니다';
    }

    // 운영 시간 검증
    if (endTime.hour < startTime.hour ||
        (endTime.hour == startTime.hour && endTime.minute <= startTime.minute)) {
      errors['operatingHours'] = '종료 시간은 시작 시간보다 늦어야 해요';
    }

    return FormValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// API 요청용 Map 변환 (스펙이 바뀌면 여기만 수정!)
  Map<String, dynamic> toApiRequest() {
    return {
      'name': name.trim(),
      'description': description.trim(),
      'type': type.value,
      'maxCapacity': maxCapacity,
      'estimatedServiceTimeMinutes': estimatedServiceTimeMinutes,
      'operatingHours': {
        'startTime': '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
        'endTime': '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      },
      // 향후 추가될 수 있는 필드들
      'metadata': {
        'createdAt': DateTime.now().toIso8601String(),
        'version': '1.0',
      },
    };
  }

  /// JSON에서 폼 데이터 생성 (API 응답 변환용)
  factory QueueCreateForm.fromJson(Map<String, dynamic> json) {
    final startTimeParts = (json['operatingHours']?['startTime'] as String? ?? '09:00').split(':');
    final endTimeParts = (json['operatingHours']?['endTime'] as String? ?? '18:00').split(':');

    return QueueCreateForm(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: QueueType.fromValue(json['type'] as String? ?? 'food'),
      maxCapacity: json['maxCapacity'] as int? ?? 50,
      estimatedServiceTimeMinutes: json['estimatedServiceTimeMinutes'] as int? ?? 3,
      startTime: TimeOfDay(
        hour: int.tryParse(startTimeParts[0]) ?? 9,
        minute: int.tryParse(startTimeParts[1]) ?? 0,
      ),
      endTime: TimeOfDay(
        hour: int.tryParse(endTimeParts[0]) ?? 18,
        minute: int.tryParse(endTimeParts[1]) ?? 0,
      ),
    );
  }

  @override
  String toString() {
    return 'QueueCreateForm(name: $name, type: ${type.label}, capacity: $maxCapacity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QueueCreateForm &&
        other.name == name &&
        other.description == description &&
        other.type == type &&
        other.maxCapacity == maxCapacity &&
        other.estimatedServiceTimeMinutes == estimatedServiceTimeMinutes &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      description,
      type,
      maxCapacity,
      estimatedServiceTimeMinutes,
      startTime,
      endTime,
    );
  }
}

/// 폼 유효성 검증 결과
class FormValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const FormValidationResult({
    required this.isValid,
    required this.errors,
  });

  /// 특정 필드의 에러 메시지 가져오기
  String? getError(String field) => errors[field];

  /// 첫 번째 에러 메시지 가져오기
  String? get firstError => errors.values.isNotEmpty ? errors.values.first : null;
}