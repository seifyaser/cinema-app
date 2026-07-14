import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fcm_notification_kit/src/local_notification_service.dart';
import 'package:fcm_notification_kit/src/notification_service.dart';

/// Orchestrates the entire notification lifecycle.
///
/// Responsibilities:
/// - Subscribe to all FCM message streams (foreground, background-open, terminated).
/// - Show local notifications when the app is in foreground.
/// - Delegate navigation via the [onNavigate] callback — the package never
///   knows about your routes.
///
/// **No Firebase code lives here (it is injected via [NotificationService]).**
/// **No route-specific code lives here.**
class NotificationHandler {
  NotificationHandler({
    required NotificationService notificationService,
    required LocalNotificationService localNotificationService,
    required void Function(BuildContext context, Map<String, dynamic> data)
        onNavigate,
  })  : _notificationService = notificationService,
        _localNotificationService = localNotificationService,
        _onNavigate = onNavigate;

  final NotificationService _notificationService;
  final LocalNotificationService _localNotificationService;
  final void Function(BuildContext context, Map<String, dynamic> data)
      _onNavigate;

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Wires all listeners. Call once after services are initialised.
  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    await _localNotificationService.initialize(
      onNotificationTap: (payload) {
        final context = navigatorKey.currentContext;
        if (context != null && payload != null && payload.isNotEmpty) {
          final map = _parseQueryPayload(payload);
          _onNavigate(context, map);
        }
      },
    );

    _listenForeground();
    _listenBackgroundOpen(navigatorKey);
    await _handleTerminatedLaunch(navigatorKey);
  }

  // ---------------------------------------------------------------------------
  // Stream listeners
  // ---------------------------------------------------------------------------

  void _listenForeground() {
    final sub = _notificationService.onMessage.listen((message) async {
      debugPrint('[NotifHandler] Foreground message: ${message.messageId}');
      await _localNotificationService.showNotification(message);
    });
    _subscriptions.add(sub);
  }

  void _listenBackgroundOpen(GlobalKey<NavigatorState> navigatorKey) {
    final sub = _notificationService.onMessageOpenedApp.listen((message) {
      debugPrint(
          '[NotifHandler] Background-open message: ${message.messageId}');
      _navigate(navigatorKey, message);
    });
    _subscriptions.add(sub);
  }

  Future<void> _handleTerminatedLaunch(
      GlobalKey<NavigatorState> navigatorKey) async {
    final message = await _notificationService.getInitialMessage();
    if (message != null) {
      debugPrint(
          '[NotifHandler] Terminated-launch message: ${message.messageId}');
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
    if (message.data.isNotEmpty) {
      _onNavigate(context, message.data);
    }
  }

  /// Parses a query-string payload (`key=value&key=value`) into a map.
  Map<String, dynamic> _parseQueryPayload(String payload) {
    return Map.fromEntries(
      payload.split('&').map((pair) {
        final parts = pair.split('=');
        return MapEntry(
          parts.first,
          parts.length > 1 ? parts.last : '',
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  /// Cancels all active stream subscriptions (useful in tests).
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
  }
}
