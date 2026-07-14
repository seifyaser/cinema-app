// Re-export from fcm_notification_kit so existing project imports keep working.
//
// The project calls initialize() with the app-specific topic list:
//
//   await sl<NotificationInitializer>().initialize(
//     navigatorKey,
//     topics: ['ALL_USERS'],
//   );
export 'package:fcm_notification_kit/src/notification_initializer.dart';
