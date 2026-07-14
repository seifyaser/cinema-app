# fcm_notification_kit

An internal Flutter package that delivers a complete, drop-in Firebase Cloud
Messaging (FCM) notification infrastructure. By moving the complex FCM wiring 
into a reusable package, you can drop this into any future project and 
eliminate ~600 lines of boilerplate forever.

## What it does

Handling push notifications in Flutter correctly requires handling many different states and streams. This package abstracts all of that away. Its capabilities include:

- **Permission Handling:** Automatically requests OS notification permissions on startup.
- **Token Management:** Retrieves the FCM device token, automatically listens for token refreshes, and syncs it with your backend API.
- **Lifecycle Streaming:** Wires up all three critical FCM streams:
  - `onMessage`: Handles notifications when the app is open in the foreground.
  - `onMessageOpenedApp`: Handles navigation when a user taps a notification while the app is in the background.
  - `getInitialMessage()`: Handles navigation when a user taps a notification that launches the app from a terminated state.
- **Local Notifications:** Automatically displays high-priority foreground notifications using `flutter_local_notifications` (since Firebase does not display them by default when the app is open).
- **Topic Subscription:** Allows subscribing users to global or specific FCM topics (e.g., `ALL_USERS`).
- **Decoupled Routing:** Exposes a clean `onNavigate` callback so the package remains completely agnostic of your app's specific UI, models, or router (like `GoRouter`).

---

## What it provides

| Class | Responsibility |
|---|---|
| `NotificationService` | Permission requests, token retrieval, FCM streams, topic subscriptions |
| `LocalNotificationService` | Foreground local notifications via `flutter_local_notifications` |
| `NotificationHandler` | Wires all FCM streams; calls your routing callback on tap |
| `NotificationInitializer` | Single entry-point — call once in `main` |
| `NotificationRepository` | Saves / removes FCM token on the backend |
| `FcmTokenDataSource` | Ready-made Dio HTTP implementation |
| `NotificationPayloadBase` | Abstract base — subclass to add app-specific fields |

---

## Setup Guide for Future Projects

When starting a new project, **you do not need any boilerplate files**. The package provides the entire `data` layer (repositories and datasources), initialization logic, and services out-of-the-box. 

> [!NOTE]
> **Migrating an older project?** If you are adding this package to an older app that already had push notifications, you might see files like `data/repositories/notification_repository.dart` or `notification_initializer.dart` left behind. Those are just empty 1-line "re-export" shortcuts left to avoid breaking hundreds of existing imports. **In a brand new project, you skip them completely.**

You only ever need to create **two** app-specific files inside your notifications folder:

### Files to CREATE

```text
lib/
└── core/
    └── notifications/
        ├── models/
        │   └── notification_payload.dart      [CREATE] your domain payload
        └── notification_router.dart           [CREATE] your route navigation
```

---

### Step 1 — Add the dependency

In your new project's `pubspec.yaml`:

```yaml
dependencies:
  fcm_notification_kit:
    path: packages/fcm_notification_kit   # local package path
```

Then run: `flutter pub get`

---

### Step 2 — Android Notification Channel

Declare the channel ID in `android/app/src/main/AndroidManifest.xml`
inside the `<application>` tag:

```xml
<meta-data
    android:name="com.google.firebase.messaging.default_notification_channel_id"
    android:value="your_channel_id" />
```

> **Important:** The value here must match the `channelId` you set in Step 5.

---

### Step 3 — Create your Payload Model

Create `lib/core/notifications/models/notification_payload.dart`.
Subclass `NotificationPayloadBase` and add whatever fields your backend sends in the FCM `data` block.

```dart
import 'package:fcm_notification_kit/fcm_notification_kit.dart';

class NotificationPayload extends NotificationPayloadBase {
  const NotificationPayload({
    required super.type,
    super.rawData,
    // Add your domain fields here:
    this.itemId,
  });

  final String? itemId;

  /// Parses the raw FCM data map into this payload.
  static NotificationPayload? fromMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return null;
    return NotificationPayload(
      type: data['type'] as String? ?? 'unknown',
      itemId: data['itemId'] as String?, // map your fields
      rawData: data,
    );
  }
}
```

---

### Step 4 — Create your Router

Create `lib/core/notifications/notification_router.dart`.
This class takes the FCM data map, converts it to your payload, and navigates.

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import your payload and app router here

class NotificationRouter {
  bool route(BuildContext context, Map<String, dynamic> data) {
    final payload = NotificationPayload.fromMap(data);
    if (payload == null) return false;

    switch (payload.type) {
      case 'NEW_ITEM': // ← match your backend's string types
        if (payload.itemId != null) {
          context.push('/item/${payload.itemId}');
          return true;
        }
        return false;

      default:
        return false;
    }
  }
}
```

---

### Step 5 — Wire Dependencies (GetIt)

In your `dependency_injection.dart`, import `package:fcm_notification_kit/fcm_notification_kit.dart` and register the 7 core services. 

*Pay attention to the comments marked with `←` below to customize it for your app.*

```dart
import 'package:fcm_notification_kit/fcm_notification_kit.dart';

// inside your init() function:

sl.registerLazySingleton<NotificationRemoteDataSource>(
  () => FcmTokenDataSource(
    dio: sl<ApiService>().dio,           // Your configured Dio instance
    tokenEndpoint: 'users/me/fcm-token', // ← Your backend's token endpoint
  ),
);

sl.registerLazySingleton<NotificationService>(() => NotificationService());

sl.registerLazySingleton<NotificationRepository>(
  () => NotificationRepositoryImpl(
    remoteDataSource: sl(),
    notificationService: sl(),
  ),
);

sl.registerLazySingleton<LocalNotificationService>(
  () => LocalNotificationService(
    channelId: 'your_channel_id',           // ← Must match AndroidManifest.xml
    channelName: 'Your App Notifications',  // ← Seen in Android settings
    channelDescription: 'App updates',      // ← Seen in Android settings
  ),
);

sl.registerLazySingleton<NotificationRouter>(() => NotificationRouter());

sl.registerLazySingleton<NotificationHandler>(
  () => NotificationHandler(
    notificationService: sl(),
    localNotificationService: sl(),
    // Connects the package to your app's router
    onNavigate: (context, data) =>
        sl<NotificationRouter>().route(context, data),
  ),
);

sl.registerLazySingleton<NotificationInitializer>(
  () => NotificationInitializer(
    notificationService: sl(),
    notificationHandler: sl(),
    notificationRepository: sl(),
  ),
);
```

---

### Step 6 — Initialise in `main.dart`

You need to add a top-level background handler and call the package's initializer.

```dart
import 'package:fcm_notification_kit/fcm_notification_kit.dart';

// 1. ADD: Top-level background handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[FCM] Background: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 2. ADD: Register the background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await di.init(navigatorKey: navigatorKey);
  runApp(const MyApp());
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 3. ADD: Initialise the system after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await di.sl<NotificationInitializer>().initialize(
        navigatorKey, // your global NavigatorState key
        topics: ['ALL_USERS'],   // ← your FCM topics (can be empty [])
      );
    });
  }
}
```

---

### Step 7 — Logout handling

Whenever the user signs out, unregister their device token **before** deleting your local authentication tokens, so they stop receiving personal notifications.

```dart
// e.g. inside ProfileCubit.logout()
await sl<NotificationRepository>().unregisterDeviceToken();
```
