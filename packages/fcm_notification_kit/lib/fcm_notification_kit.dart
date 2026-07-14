/// FCM Notification Kit — public API barrel.
///
/// Import this single file in your project:
/// ```dart
/// import 'package:fcm_notification_kit/fcm_notification_kit.dart';
/// ```
library fcm_notification_kit;

// Core services
export 'src/notification_service.dart';
export 'src/local_notification_service.dart';
export 'src/notification_handler.dart';
export 'src/notification_initializer.dart';

// Data layer
export 'src/data/notification_remote_data_source.dart';
export 'src/data/notification_repository.dart';

// Models & types
export 'src/models/notification_payload_base.dart';

// Error types
export 'src/error/kit_failure.dart';
