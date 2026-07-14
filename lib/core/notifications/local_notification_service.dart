import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Manages the display of local notifications while the app is in foreground.
///
/// Responsibilities:
/// - Initialise [FlutterLocalNotificationsPlugin].
/// - Create the Android notification channel.
/// - Show a local notification from a [RemoteMessage].
/// - Expose the tapped-notification payload via a callback.
///
/// **No Firebase code lives here.**
class LocalNotificationService {
  /// Creates a [LocalNotificationService].
  LocalNotificationService()
      : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// The Android notification channel ID. Must match the value declared in
  /// `AndroidManifest.xml` (`cinema_channel`).
  static const String _channelId = 'cinema_channel';
  static const String _channelName = 'Cinema Notifications';
  static const String _channelDescription =
      'Notifications for new movies, bookings, and updates.';

  // ---------------------------------------------------------------------------
  // Initialisation
  // ---------------------------------------------------------------------------

  /// Initialises the local notifications plugin and creates the Android channel.
  ///
  /// [onNotificationTap] is called with the raw notification payload string
  /// when the user taps a local notification while the app is running.
  Future<void> initialize({
    required void Function(String? payload) onNotificationTap,
  }) async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // Already handled by FirebaseMessaging
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
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

  /// Creates the high-importance Android notification channel.
  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
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
  ///
  /// The [RemoteMessage.data] map is serialised as the notification payload
  /// so it can be read when the user taps the notification.
  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    // Use the message's hashCode as a stable notification ID.
    final id = message.messageId?.hashCode ?? DateTime.now().millisecond;
    final payload = message.data.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    await _plugin.show(
      id,
      notification.title ?? '',
      notification.body ?? '',
      details,
      payload: payload,
    );

    debugPrint(
      '[LocalNotif] Shown — title: ${notification.title}, '
      'payload: $payload',
    );
  }
}
