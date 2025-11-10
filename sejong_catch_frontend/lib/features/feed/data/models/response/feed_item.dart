import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_item.freezed.dart';
part 'feed_item.g.dart';

/// 📰 피드 아이템 모델
///
/// 사용처:
/// - 피드 목록 (FeedPage)
/// - 상세보기 (FeedDetailPage)
/// - 검색 결과 (SearchPage)
///
/// CLAUDE.md 원칙:
/// - @freezed로 불변 클래스 자동 생성
/// - @JsonSerializable로 JSON 직렬화
/// - @Default()로 기본값 설정
@freezed
class FeedItem with _$FeedItem {
  const factory FeedItem({
    /// 고유 ID
    required String id,

    /// 제목
    required String title,

    /// 짧은 설명 (리스트용)
    required String description,

    /// 카테고리 (공모전, 취업, 논문, 학교공지, 축제)
    required String category,

    /// 썸네일 이미지 URL (선택사항)
    String? thumbnailUrl,

    /// D-Day (마감일까지 남은 일수)
    required int dDay,

    /// 조회수
    @Default(0) int viewCount,

    /// 우선순위 (high, mid, low)
    @Default('low') String priority,

    /// 북마크 여부
    @Default(false) bool isBookmarked,

    // --- 상세보기 전용 필드 ---

    /// 본문 내용 (Markdown 또는 일반 텍스트)
    String? content,

    /// 주최 기관/단체
    String? organizerName,

    /// 문의 이메일
    String? contactEmail,

    /// 문의 전화번호
    String? contactPhone,

    /// 마감일 (DateTime)
    DateTime? deadline,

    /// 외부 링크 (공식 사이트, 지원 페이지 등)
    String? externalUrl,

    /// 첨부파일 URL 목록
    @Default([]) List<String> attachmentUrls,

    /// 태그 목록
    @Default([]) List<String> tags,

    /// 생성일
    DateTime? createdAt,

    /// 수정일
    DateTime? updatedAt,
  }) = _FeedItem;

  /// JSON → FeedItem 변환 (API 응답 파싱용)
  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);

  /// 더미 데이터 생성 팩토리 (테스트/개발용)
  factory FeedItem.dummy({
    required String id,
    required String title,
    required String description,
    required String category,
    required int dDay,
    String priority = 'low',
  }) {
    return FeedItem(
      id: id,
      title: title,
      description: description,
      category: category,
      thumbnailUrl: 'https://via.placeholder.com/150',
      dDay: dDay,
      viewCount: 1234,
      priority: priority,
      isBookmarked: false,
      content: '''
# $title

## 개요
$description

## 상세 내용
이것은 더미 데이터입니다. 실제 API 연동 시 백엔드에서 받은 데이터로 대체됩니다.

## 지원 자격
- 세종대학교 재학생
- 관련 분야 전공자

## 혜택
- 상금 및 포상
- 창업 지원
- 우수작 전시 기회

## 문의처
아래 연락처로 문의해주세요.
''',
      organizerName: '세종대학교',
      contactEmail: 'sejong@example.com',
      contactPhone: '02-1234-5678',
      deadline: DateTime.now().add(Duration(days: dDay)),
      externalUrl: 'https://www.sejong.ac.kr',
      attachmentUrls: [],
      tags: ['세종대', category],
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now(),
    );
  }
}
