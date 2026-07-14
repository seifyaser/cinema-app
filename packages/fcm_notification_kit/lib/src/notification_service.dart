import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around [FirebaseMessaging].
///
/// Responsibilities:
/// - Request notification permission from the OS.
/// - Retrieve / refresh the FCM device token.
/// - Expose foreground, background-opened, and initial-message streams.
/// - Delete the token on logout.
///
/// **No navigation, no UI, no business logic lives here.**
class NotificationService {
  /// Creates a [NotificationService] backed by [FirebaseMessaging.instance].
  NotificationService() : _messaging = FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  // ---------------------------------------------------------------------------
  // Permission
  // ---------------------------------------------------------------------------

  /// Requests notification permission from the OS.
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint('[FCM] Permission status: ${settings.authorizationStatus}');
    return settings.authorizationStatus;
  }

  // ---------------------------------------------------------------------------
  // Token
  // ---------------------------------------------------------------------------

  /// Returns the current FCM registration token, or `null` if unavailable.
  Future<String?> getToken() async {
    final token = await _messaging.getToken();
    debugPrint('[FCM] Token: $token');
    return token;
  }

  /// Stream that fires whenever the FCM token is refreshed.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  // ---------------------------------------------------------------------------
  // Message streams
  // ---------------------------------------------------------------------------

  /// Stream of [RemoteMessage] objects received while the app is in foreground.
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Stream of [RemoteMessage] objects that caused the app to open from background.
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Returns the [RemoteMessage] that launched the app from terminated state.
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  // ---------------------------------------------------------------------------
  // Foreground presentation options (iOS / macOS)
  // ---------------------------------------------------------------------------

  /// Configures how notifications are presented when the app is in foreground.
  Future<void> setForegroundNotificationPresentationOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Topic subscriptions
  // ---------------------------------------------------------------------------

  /// Subscribes the device to an FCM topic.
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  /// Unsubscribes the device from an FCM topic.
  Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  /// Deletes the local FCM token. Call this after the backend has been notified.
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    debugPrint('[FCM] Token deleted.');
  }
}
