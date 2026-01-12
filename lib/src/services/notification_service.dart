import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Service untuk mengelola Firebase Cloud Messaging dan Local Notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  String? _fcmToken;

  /// Stream controller untuk handle notification taps
  final StreamController<Map<String, dynamic>> _notificationTapController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get onNotificationTap =>
      _notificationTapController.stream;

  /// Get FCM token
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Request permission
      await _requestPermission();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token
      _fcmToken = await _fcm.getToken();
      if (kDebugMode) {
        print('FCM Token: $_fcmToken');
      }

      // Listen to token refresh
      _fcm.onTokenRefresh.listen((token) {
        _fcmToken = token;
        if (kDebugMode) {
          print('FCM Token refreshed: $token');
        }
      });

      // Setup message handlers
      _setupMessageHandlers();

      _initialized = true;
      if (kDebugMode) {
        print('NotificationService initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize NotificationService: $e');
      }
      rethrow;
    }
  }

  /// Request notification permission
  Future<void> _requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    if (kDebugMode) {
      print('Notification permission: ${settings.authorizationStatus}');
    }
  }

  /// Initialize local notifications
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Foreground message received: ${message.messageId}');
      }
      _showLocalNotification(message);
    });

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Message opened from background: ${message.messageId}');
      }
      _handleNotificationTap(message.data);
    });

    // Handle terminated app message tap
    _fcm.getInitialMessage().then((message) {
      if (message != null) {
        if (kDebugMode) {
          print('Message opened from terminated: ${message.messageId}');
        }
        _handleNotificationTap(message.data);
      }
    });
  }

  /// Show local notification for foreground messages
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification == null) return;

    // Determine priority from data
    final priority = data['priority'] ?? 'medium';
    AndroidNotificationPriority androidPriority;
    Priority notificationPriority;

    switch (priority) {
      case 'high':
        androidPriority = AndroidNotificationPriority.high;
        notificationPriority = Priority.high;
        break;
      case 'low':
        androidPriority = AndroidNotificationPriority.low;
        notificationPriority = Priority.low;
        break;
      default:
        androidPriority = AndroidNotificationPriority.defaultPriority;
        notificationPriority = Priority.defaultPriority;
    }

    final androidDetails = AndroidNotificationDetails(
      'belajarbareng_channel',
      'BelajarBareng Notifications',
      channelDescription: 'Notifications for BelajarBareng app',
      importance: Importance.high,
      priority: notificationPriority,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: _encodePayload(data),
    );
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    final payload = _decodePayload(response.payload);
    if (payload != null) {
      _handleNotificationTap(payload);
    }
  }

  /// Handle notification tap with routing
  void _handleNotificationTap(Map<String, dynamic> data) {
    _notificationTapController.add(data);
  }

  /// Encode payload to string
  String _encodePayload(Map<String, dynamic> data) {
    return data.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  /// Decode payload from string
  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;

    final map = <String, dynamic>{};
    for (final pair in payload.split('&')) {
      final parts = pair.split('=');
      if (parts.length == 2) {
        map[parts[0]] = parts[1];
      }
    }
    return map;
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to subscribe to topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to unsubscribe from topic: $e');
      }
    }
  }

  /// Dispose
  void dispose() {
    _notificationTapController.close();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('Background message received: ${message.messageId}');
  }
}
