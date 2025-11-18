import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/request/login_request.dart';
import '../models/response/login_response.dart';

part 'auth_api.g.dart';

/// 인증 API 인터페이스 (Retrofit)
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  /// 로그인 (백엔드 API 스펙: POST /auth/login)
  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  /// 토큰 갱신 (백엔드 API 스펙: POST /auth/refresh)
  @POST('/auth/refresh')
  Future<HttpResponse<dynamic>> refresh(@Body() Map<String, String> body);

  /// 로그아웃 (백엔드 API 스펙: POST /auth/logout)
  @POST('/auth/logout')
  Future<HttpResponse<dynamic>> logout();

  /// 내 정보 조회 (백엔드 API 스펙: GET /users/me)
  @GET('/users/me')
  Future<HttpResponse<dynamic>> getMe();
}
