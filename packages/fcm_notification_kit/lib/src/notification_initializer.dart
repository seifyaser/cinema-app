import 'package:flutter/material.dart';
import 'package:fcm_notification_kit/src/notification_handler.dart';
import 'package:fcm_notification_kit/src/notification_service.dart';
import 'package:fcm_notification_kit/src/data/notification_repository.dart';

/// Single public entry-point for the notification system.
///
/// Called once from [main] after the app widget tree is mounted.
///
/// Responsibilities:
/// - Request OS notification permission.
/// - Register the device token with the backend.
/// - Subscribe to FCM topics.
/// - Configure foreground presentation options (iOS).
/// - Wire [NotificationHandler] listeners.
class NotificationInitializer {
  NotificationInitializer({
    required NotificationService notificationService,
    required NotificationHandler notificationHandler,
    required NotificationRepository notificationRepository,
  })  : _notificationService = notificationService,
        _notificationHandler = notificationHandler,
        _notificationRepository = notificationRepository;

  final NotificationService _notificationService;
  final NotificationHandler _notificationHandler;
  final NotificationRepository _notificationRepository;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Initialises the full notification infrastructure.
  ///
  /// - [navigatorKey] — the same key passed to `MaterialApp.router`.
  /// - [topics] — list of FCM topics to subscribe to (e.g. `['ALL_USERS']`).
  Future<void> initialize(
    GlobalKey<NavigatorState> navigatorKey, {
    List<String> topics = const [],
  }) async {
    // 1. Request OS permission
    await _notificationService.requestPermission();

    // 2. Get token and register with backend
    await _notificationService.getToken();
    await _notificationRepository.registerDeviceToken();

    // 3. Subscribe to FCM topics
    for (final topic in topics) {
      await _notificationService.subscribeToTopic(topic);
      debugPrint('[NotifInitializer] Subscribed to topic: $topic');
    }

    // 4. iOS foreground presentation options
    await _notificationService.setForegroundNotificationPresentationOptions();

    // 5. Wire all listeners (foreground, background-open, terminated)
    await _notificationHandler.initialize(navigatorKey);

    debugPrint('[NotifInitializer] Notification system ready.');
  }
}
