import 'package:flutter/material.dart';
import 'package:project/core/notifications/notification_handler.dart';
import 'package:project/core/notifications/notification_service.dart';

/// Single public entry-point for the notification system.
///
/// Called once from [main] after the app widget tree is mounted.
///
/// Responsibilities:
/// - Request OS notification permission.
/// - Configure foreground presentation options (iOS).
/// - Wire [NotificationHandler] listeners.
///
/// Token registration with the backend is handled separately via
/// [NotificationRepository.registerDeviceToken] — call that method after a
/// successful login once the backend is ready.
class NotificationInitializer {
  /// Creates a [NotificationInitializer].
  NotificationInitializer({
    required NotificationService notificationService,
    required NotificationHandler notificationHandler,
  }) : _notificationService = notificationService,
       _notificationHandler = notificationHandler;

  final NotificationService _notificationService;
  final NotificationHandler _notificationHandler;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Initialises the full notification infrastructure.
  ///
  /// [navigatorKey] must be the same [GlobalKey<NavigatorState>] that is passed
  /// to [MaterialApp.router] (or similar) so that navigation from notification
  /// taps can access a valid [BuildContext].
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    // 1. Request permission
    await _notificationService.requestPermission();

    // 2. Get device token
    await _notificationService.getToken();

    // 3. iOS foreground presentation options
    await _notificationService.setForegroundNotificationPresentationOptions();

    // 3. Wire all listeners (foreground, background-open, terminated)
    await _notificationHandler.initialize(navigatorKey);

    debugPrint('[NotifInitializer] Notification system ready.');
  }
}
