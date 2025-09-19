import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';

// 백그라운드 메시지 핸들러 (반드시 top-level 함수여야 함)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 백그라운드 메시지 수신: ${message.messageId}');
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isFlutterLocalNotificationsInitialized = false;
  String? _fcmToken;

  // GoRouter 인스턴스 (전역 접근용)
  static GoRouter? _router;

  /// GoRouter 인스턴스 설정 (앱 시작 시 호출)
  static void setRouter(GoRouter router) {
    _router = router;
    debugPrint('✅ NotificationService에 GoRouter 설정 완료');
  }

  // 알림 채널 정보 (세종 캐치 전용)
  static const String _channelId = 'sejong_catch_notifications';
  static const String _channelName = '세종 캐치 알림';
  static const String _channelDescription = '공모전, 취업, 논문 정보 알림';

  /// NotificationService 초기화
  /// 앱 시작 시 한 번만 호출하면 됩니다
  ///
  /// 사용법:
  /// ```dart
  /// // main.dart에서
  /// await NotificationService.instance.initialize();
  /// NotificationService.setRouter(appRouter); // GoRouter 설정
  /// ```
  Future<bool> initialize() async {
    try {
      debugPrint('🚀 NotificationService 초기화 시작');

      // 1. Firebase Messaging 초기화
      await _initializeFirebaseMessaging();

      // 2. Local Notifications 초기화
      await _initializeLocalNotifications();

      // 3. 백그라운드 메시지 핸들러 등록
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      debugPrint('✅ NotificationService 초기화 완료!');
      return true;
    } catch (e) {
      debugPrint('❌ NotificationService 초기화 실패: $e');
      return false;
    }
  }

  /// Firebase Messaging 초기화 및 설정
  Future<void> _initializeFirebaseMessaging() async {
    // FCM 토큰 획득
    _fcmToken = await _messaging.getToken();
    debugPrint('📱 FCM Token: $_fcmToken');

    // 토큰 새로고침 리스너
    _messaging.onTokenRefresh.listen((token) async {
      _fcmToken = token;
      debugPrint('🔄 FCM Token 갱신됨: $token');
      // 서버에 새 토큰 전송
      await _sendTokenToServer(token);
    });

    // Foreground 메시지 리스너
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 알림 클릭 리스너 (앱이 백그라운드에서 열릴 때)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 앱이 완전히 종료된 상태에서 알림을 통해 열렸는지 확인
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// 알림 권한 요청
  /// 사용자에게 친화적인 방식으로 권한을 요청합니다
  Future<bool> requestPermissions() async {
    try {
      debugPrint('🔐 알림 권한 요청 시작');

      // iOS/Android 권한 요청
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint('📋 알림 권한 상태: ${settings.authorizationStatus}');

      // 권한이 허용되었는지 확인
      final bool isAuthorized =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      if (isAuthorized) {
        debugPrint('✅ 알림 권한 허용됨!');
        // 기본 세종 캐치 토픽 구독
        await subscribeToTopic('sejong_catch_general');
      } else {
        debugPrint('❌ 알림 권한 거부됨');
      }

      return isAuthorized;
    } catch (e) {
      debugPrint('⚠️ 알림 권한 요청 중 오류: $e');
      return false;
    }
  }

  /// 현재 알림 권한 상태 확인
  Future<NotificationSettings> getPermissionStatus() async {
    return await _messaging.getNotificationSettings();
  }

  /// FCM 토큰 반환
  /// 서버에 사용자 식별을 위해 전송할 때 사용
  String? get fcmToken => _fcmToken;

  /// 특정 토픽 구독
  /// 예: 학과별, 관심사별 알림
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('✅ 토픽 구독 완료: $topic');
    } catch (e) {
      debugPrint('❌ 토픽 구독 실패 ($topic): $e');
    }
  }

  /// 토픽 구독 해제
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('✅ 토픽 구독 해제 완료: $topic');
    } catch (e) {
      debugPrint('❌ 토픽 구독 해제 실패 ($topic): $e');
    }
  }

  /// Local Notifications 초기화
  /// 세종 캐치 브랜드에 맞는 알림 채널 설정
  Future<void> _initializeLocalNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) {
      return;
    }

    // Android 설정
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: false, // Firebase에서 이미 요청했으므로 false
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    // 초기화 설정 조합
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Local Notifications 초기화
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android 알림 채널 생성 (세종 캐치 전용)
    await _createNotificationChannel();

    _isFlutterLocalNotificationsInitialized = true;
    debugPrint('✅ Local Notifications 초기화 완료');
  }

  /// 세종 캐치 전용 알림 채널 생성 (Android)
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      ledColor: AppColors.brandCrimson, // 세종 캐치 크림슨 레드!
      showBadge: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    debugPrint('✅ 알림 채널 생성 완료: $_channelName');
  }

  /// 로컬 알림 표시 (앱 실행 중일 때)
  /// 세종 캐치 브랜딩 적용된 알림을 보여줍니다
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    try {
      // Android 알림 스타일 설정
      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            enableLights: true,
            ledColor: AppColors.brandCrimson, // 크림슨 레드
            icon: '@mipmap/ic_launcher',
            largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            styleInformation: BigTextStyleInformation(
              body,
              contentTitle: title,
              htmlFormatContent: true,
              htmlFormatContentTitle: true,
            ),
          );

      // iOS 알림 스타일 설정
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1,
      );

      // 플랫폼별 설정 조합
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // 알림 표시
      await _localNotifications.show(
        DateTime.now().millisecond, // 고유한 ID
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      debugPrint('✅ 로컬 알림 표시 완료: $title');
    } catch (e) {
      debugPrint('❌ 로컬 알림 표시 실패: $e');
    }
  }

  /// 알림 클릭 시 처리 (Local Notifications)
  void _onNotificationTapped(NotificationResponse response) {
    final String? payload = response.payload;
    debugPrint('👆 로컬 알림 클릭됨 - Payload: $payload');

    if (payload != null) {
      _handleNotificationPayload(payload);
    }
  }

  /// Foreground 메시지 처리 (앱 실행 중)
  /// 사용자가 앱을 사용 중일 때 받은 알림을 예쁘게 표시
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('🔔 Foreground 메시지 수신: ${message.messageId}');
    debugPrint('📱 제목: ${message.notification?.title}');
    debugPrint('📝 내용: ${message.notification?.body}');
    debugPrint('📋 데이터: ${message.data}');

    // Local Notification으로 예쁘게 표시
    final notification = message.notification;
    if (notification != null) {
      showLocalNotification(
        title: notification.title ?? '세종 캐치',
        body: notification.body ?? '세종 캐치에서 새로운 정보를 확인하세요!',
        payload: _buildPayload(message.data),
      );
    }
  }

  /// Background/Terminated 상태에서 알림 클릭 처리
  /// Firebase 메시지로부터 받은 알림 클릭
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 Firebase 알림 클릭됨: ${message.messageId}');
    debugPrint('📋 데이터: ${message.data}');

    final String payload = _buildPayload(message.data);
    _handleNotificationPayload(payload);
  }

  /// 알림 데이터를 Payload 문자열로 변환
  String _buildPayload(Map<String, dynamic> data) {
    // JSON 형태로 직렬화 (향후 파싱용)
    return data.entries.map((entry) => '${entry.key}=${entry.value}').join('&');
  }

  /// FCM 토큰을 서버로 전송
  /// 사용자 식별 및 푸시 알림 발송을 위해 서버에 토큰 등록
  Future<void> _sendTokenToServer(String token) async {
    try {
      debugPrint('📤 서버에 FCM 토큰 전송 중...');

      // TODO: 실제 API 호출로 교체 필요
      // 예시: POST /api/v1/users/fcm-token
      // await apiClient.post('/users/fcm-token', {'token': token});

      debugPrint('✅ FCM 토큰 서버 전송 완료');
    } catch (e) {
      debugPrint('❌ FCM 토큰 서버 전송 실패: $e');
    }
  }

  /// Payload 해석 및 라우팅 처리
  /// 알림 클릭 시 적절한 화면으로 이동
  void _handleNotificationPayload(String payload) {
    try {
      debugPrint('🧭 알림 Payload 처리: $payload');

      // Payload를 Map으로 파싱
      final Map<String, String> data = {};
      for (final pair in payload.split('&')) {
        final keyValue = pair.split('=');
        if (keyValue.length == 2) {
          data[keyValue[0]] = keyValue[1];
        }
      }

      // 알림 타입에 따른 라우팅
      final String? type = data['type'];
      final String? id = data['id'];

      switch (type) {
        case 'competition':
          debugPrint('🏆 공모전 알림 - ID: $id');
          if (id != null && _router != null) {
            _router!.push('/detail/$id?type=competition');
          } else {
            _router?.go('/feed');
          }
          break;

        case 'job':
          debugPrint('💼 취업 정보 알림 - ID: $id');
          if (id != null && _router != null) {
            _router!.push('/detail/$id?type=job');
          } else {
            _router?.go('/feed');
          }
          break;

        case 'research':
          debugPrint('📚 논문/연구 알림 - ID: $id');
          if (id != null && _router != null) {
            _router!.push('/detail/$id?type=research');
          } else {
            _router?.go('/feed');
          }
          break;

        case 'notice':
          debugPrint('📢 학교 공지 알림 - ID: $id');
          if (id != null && _router != null) {
            _router!.push('/detail/$id?type=notice');
          } else {
            _router?.go('/feed');
          }
          break;

        case 'queue':
          debugPrint('🕐 대기열 알림 - 대기열 페이지로 이동');
          _router?.go('/queue');
          break;

        default:
          debugPrint('🏠 기본 피드 페이지로 이동');
          _router?.go('/feed');
      }
    } catch (e) {
      debugPrint('❌ Payload 처리 중 오류: $e');
      // 오류 시 기본 피드 페이지로 이동
      _router?.go('/feed');
    }
  }

  /// 세종 캐치 특화 알림 표시 (타입별 스타일링)
  /// 공모전, 취업, 논문, 공지사항 등에 맞는 알림 스타일
  /// AppColors 시스템을 활용한 일관된 브랜딩 적용
  Future<void> showTypedNotification({
    required String type,
    required String title,
    required String body,
    String? itemId,
    Map<String, String>? additionalData,
  }) async {
    // 타입별 이모지와 컬러 설정 (AppColors 시스템 활용)
    String emoji;
    Color ledColor;

    switch (type) {
      case 'competition':
        emoji = '🏆';
        ledColor = AppColors.brandCrimson; // 메인 브랜드 - 공모전이 핵심!
        break;
      case 'job':
        emoji = '💼';
        ledColor = AppColors.trustAcademic; // 학술적 신뢰도 - 취업 정보
        break;
      case 'research':
        emoji = '📚';
        ledColor = AppColors.success; // 성공 색상 - 논문/연구 성취
        break;
      case 'notice':
        emoji = '📢';
        ledColor = AppColors.warning; // 경고 색상 - 중요한 공지
        break;
      case 'queue':
        emoji = '🕐';
        ledColor = AppColors.trustPress; // 언론 신뢰도 - 정보성 알림
        break;
      default:
        emoji = '📱';
        ledColor = AppColors.textSecondary; // 보조 텍스트 색상
    }

    // Payload 데이터 구성
    final Map<String, String> payloadData = {
      'type': type,
      if (itemId != null) 'id': itemId,
      ...?additionalData,
    };

    // Android 알림 스타일 (타입별 커스터마이징)
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          enableLights: true,
          ledColor: ledColor,
          icon: '@mipmap/ic_launcher',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: '$emoji $title',
            htmlFormatContent: true,
            htmlFormatContentTitle: true,
          ),
        );

    // iOS 알림 스타일
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      badgeNumber: 1,
    );

    // 알림 표시
    await _localNotifications.show(
      DateTime.now().millisecond,
      '$emoji $title',
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: _buildPayload(payloadData),
    );

    debugPrint('✅ $type 타입 알림 표시 완료: $title');
  }

  /// 서비스 정리
  /// 앱 종료 시 리소스 정리
  void dispose() {
    debugPrint('🧹 NotificationService 리소스 정리');
    // Firebase listeners는 자동으로 정리됨
  }
}
