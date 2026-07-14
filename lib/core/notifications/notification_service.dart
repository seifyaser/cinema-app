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
  ///
  /// Returns the resulting [AuthorizationStatus].
  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    debugPrint(
      '[FCM] Permission status: ${settings.authorizationStatus}',
    );
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
  ///
  /// Subscribe to this to automatically re-register the device with the backend.
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  // ---------------------------------------------------------------------------
  // Message streams
  // ---------------------------------------------------------------------------

  /// Stream of [RemoteMessage] objects received while the app is **in foreground**.
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  /// Stream of [RemoteMessage] objects that caused the app to open from
  /// **background** state (notification tap).
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  /// Returns the [RemoteMessage] that launched the app from **terminated** state,
  /// or `null` if the app was opened normally.
  Future<RemoteMessage?> getInitialMessage() =>
      _messaging.getInitialMessage();

  // ---------------------------------------------------------------------------
  // Foreground presentation options (iOS / macOS)
  // ---------------------------------------------------------------------------

  /// Configures how notifications are presented when the app is in foreground
  /// on iOS / macOS.
  Future<void> setForegroundNotificationPresentationOptions() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Logout
  // ---------------------------------------------------------------------------

  /// Deletes the local FCM token.
  ///
  /// Call this **after** the backend has been notified (via the repository).
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    debugPrint('[FCM] Token deleted.');
  }
}
