import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/models/response/crawler_result.dart';

part 'selected_category_controller.g.dart';

/// 선택된 카테고리 상태 관리
///
/// **용도**: 카테고리 필터링 UI 상태 제어
/// **기본값**: '전체' (모든 카테고리 표시)
@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => '전체';

  /// 카테고리 선택
  void select(String category) {
    state = category;
  }

  /// 전체 선택
  void selectAll() {
    state = '전체';
  }
}

/// 카테고리 목록 Provider
///
/// **반환**:
/// - Mock 모드: ['전체', '공모전', '취업', '논문', '학교공지', '축제']
/// - Real 모드: ['전체', '일반공지', '입학공지', '학사공지', ...]
@riverpod
List<String> categoryList(Ref ref) {
  final useMock = dotenv.get('USE_MOCK_AUTH', fallback: 'true') == 'true';

  if (useMock) {
    // Mock 모드 (개발): 기존 카테고리
    return ['전체', '공모전', '취업', '논문', '학교공지', '축제'];
  } else {
    // Real 모드 (프로덕션): 크롤러 카테고리 (10개)
    return ['전체', ...CrawlerCategory.allCategories];
  }
}
