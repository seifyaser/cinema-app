import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Manages the display of local notifications while the app is in foreground.
///
/// Pass [channelId], [channelName], and [channelDescription] to configure
/// the Android notification channel for your app.
class LocalNotificationService {
  LocalNotificationService({
    required this.channelId,
    required this.channelName,
    this.channelDescription = '',
    this.iconName = '@mipmap/ic_launcher',
  }) : _plugin = FlutterLocalNotificationsPlugin();

  final String channelId;
  final String channelName;
  final String channelDescription;
  final String iconName;

  final FlutterLocalNotificationsPlugin _plugin;

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Initialises the plugin and creates the Android notification channel.
  ///
  /// [onNotificationTap] receives the raw payload string when the user taps
  /// a local notification while the app is running.
  Future<void> initialize({
    required void Function(String? payload) onNotificationTap,
  }) async {
    final androidSettings = AndroidInitializationSettings(iconName);

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('[LocalNotif] Tapped: ${details.payload}');
        onNotificationTap(details.payload);
      },
    );

    await _createAndroidChannel();
    debugPrint('[LocalNotif] Initialised.');
  }

  Future<void> _createAndroidChannel() async {
    final channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  /// Shows a local notification built from a [RemoteMessage].
  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    debugPrint('[FCM DATA] ${message.data}');

    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: iconName,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    final id = message.messageId?.hashCode ?? DateTime.now().millisecond;
    final payload =
        message.data.entries.map((e) => '${e.key}=${e.value}').join('&');

    await _plugin.show(
      id,
      notification.title ?? '',
      notification.body ?? '',
      details,
      payload: payload,
    );

    debugPrint(
      '[LocalNotif] Shown — title: ${notification.title}, payload: $payload',
    );
  }
}
