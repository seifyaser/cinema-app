import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project/core/notifications/local_notification_service.dart';
import 'package:project/core/notifications/models/notification_payload.dart';
import 'package:project/core/notifications/notification_router.dart';
import 'package:project/core/notifications/notification_service.dart';

/// Orchestrates the entire notification lifecycle.
///
/// Responsibilities:
/// - Subscribe to all FCM message streams (foreground, background-open, terminated).
/// - Show local notifications when the app is in foreground.
/// - Delegate navigation to [NotificationRouter].
///
/// **No Firebase code lives here (it is injected via [NotificationService]).**
/// **No UI/widget code lives here.**
class NotificationHandler {
  /// Creates a [NotificationHandler].
  NotificationHandler({
    required NotificationService notificationService,
    required LocalNotificationService localNotificationService,
    required NotificationRouter notificationRouter,
  })  : _notificationService = notificationService,
        _localNotificationService = localNotificationService,
        _notificationRouter = notificationRouter;

  final NotificationService _notificationService;
  final LocalNotificationService _localNotificationService;
  final NotificationRouter _notificationRouter;

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Wires all listeners. Call this once after services are initialised.
  ///
  /// [navigatorKey] is used to access [BuildContext] for navigation when
  /// there is no widget-level context available (terminated / background tap).
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    await _localNotificationService.initialize(
      onNotificationTap: (payload) {
        final context = navigatorKey.currentContext;
        if (context != null) {
          _notificationRouter.routeFromRawPayload(context, payload);
        }
      },
    );

    _listenForeground(navigatorKey);
    _listenBackgroundOpen(navigatorKey);
    await _handleTerminatedLaunch(navigatorKey);
  }

  // ---------------------------------------------------------------------------
  // Stream listeners
  // ---------------------------------------------------------------------------

  /// Handles messages that arrive while the app is **in foreground**.
  void _listenForeground(GlobalKey<NavigatorState> navigatorKey) {
    final sub = _notificationService.onMessage.listen((message) async {
      debugPrint('[NotifHandler] Foreground message: ${message.messageId}');
      await _localNotificationService.showNotification(message);
      // We intentionally do NOT auto-navigate on foreground messages;
      // the user should tap the notification to trigger navigation.
    });
    _subscriptions.add(sub);
  }

  /// Handles notification taps that resume the app from **background**.
  void _listenBackgroundOpen(GlobalKey<NavigatorState> navigatorKey) {
    final sub = _notificationService.onMessageOpenedApp.listen((message) {
      debugPrint(
        '[NotifHandler] Background-open message: ${message.messageId}',
      );
      _navigate(navigatorKey, message);
    });
    _subscriptions.add(sub);
  }

  /// Handles the notification that launched the app from **terminated** state.
  Future<void> _handleTerminatedLaunch(
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final message = await _notificationService.getInitialMessage();
    if (message != null) {
      debugPrint(
        '[NotifHandler] Terminated-launch message: ${message.messageId}',
      );
      // Delay navigation until the first frame is rendered.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigate(navigatorKey, message);
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation helper
  // ---------------------------------------------------------------------------

  void _navigate(
    GlobalKey<NavigatorState> navigatorKey,
    RemoteMessage message,
  ) {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint('[NotifHandler] No context available for navigation.');
      return;
    }
    final payload = NotificationPayload.fromMap(message.data);
    if (payload != null) {
      _notificationRouter.routeFromPayload(context, payload);
    }
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  /// Cancels all active stream subscriptions.
  ///
  /// Call this if the notification system is torn down (e.g. in tests).
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
  }
}
