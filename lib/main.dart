import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project/core/notifications/notification_initializer.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/core/di/dependency_injection.dart' as di;
import 'package:device_preview/device_preview.dart';
import 'package:project/firebase_options.dart';

// ---------------------------------------------------------------------------
// FCM Background handler (must be a top-level function)
// ---------------------------------------------------------------------------

/// Handles FCM messages that arrive while the app is **terminated or in
/// background**. This function is run in a separate Dart isolate — keep it
/// light and avoid UI calls.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase must be initialised in the background isolate as well.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('[FCM] Background message received: ${message.messageId}');
  // No local notification here — the OS shows the system notification
  // automatically for data-only messages with notification payload.
}

// ---------------------------------------------------------------------------
// Navigator key (shared between the router and the notification handler)
// ---------------------------------------------------------------------------

/// A global [NavigatorState] key used to navigate from notification taps
/// without requiring a [BuildContext].
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// ---------------------------------------------------------------------------
// Entry point
// ---------------------------------------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Register the background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 3. Initialise GetIt dependency graph (pass navigatorKey for notifications)
  await di.init(navigatorKey: navigatorKey);

  // 4. System UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 5. Initialise the notification infrastructure after the first frame.
    // every user enters the app subscribe by default to all_users topic
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await di.sl<NotificationInitializer>().initialize(
        navigatorKey,
        topics: ['ALL_USERS'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Cinematic Immersive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF131313),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF131313),
          onSurface: Color(0xFFE5E2E1),
          onSurfaceVariant: Color(0xFFD3C5AC),
          primary: Color(0xFFFFD165),
          onPrimary: Color(0xFF3F2E00),
          outline: Color(0xFF9B8F79),
          outlineVariant: Color(0xFF4F4633),
          error: Color(0xFFFFB4AB),
        ),
      ),
      routerConfig: AppRouter.router(navigatorKey),
    );
  }
}
