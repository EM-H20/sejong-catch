import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/response/feed_item.dart';

part 'feed_api.g.dart';

/// 피드 API 인터페이스 (Retrofit)
///
/// **USE_MOCK_AUTH=false 일 때만 실제 API 호출**
@RestApi()
abstract class FeedApi {
  factory FeedApi(Dio dio, {String baseUrl}) = _FeedApi;

  /// 피드 목록 조회 (백엔드 API 스펙: GET /feed)
  ///
  /// **Query Parameters**:
  /// - `category`: 카테고리 필터 ('전체', '공모전', '취업', '논문', '학교공지', '축제')
  /// - `page`: 페이지 번호 (기본값: 1)
  /// - `limit`: 페이지당 아이템 수 (기본값: 20)
  @GET('/feed')
  Future<List<FeedItem>> getFeedList({
    @Query('category') String? category,
    @Query('page') int page = 1,
    @Query('limit') int limit = 20,
  });

  /// 피드 상세 조회 (백엔드 API 스펙: GET /feed/{id})
  @GET('/feed/{id}')
  Future<FeedItem> getFeedDetail(@Path('id') String id);

  /// 북마크 토글 (백엔드 API 스펙: POST /feed/{id}/bookmark)
  @POST('/feed/{id}/bookmark')
  Future<HttpResponse<dynamic>> toggleBookmark(@Path('id') String id);
}
