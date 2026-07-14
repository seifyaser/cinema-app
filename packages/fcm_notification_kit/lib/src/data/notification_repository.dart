import 'package:flutter/foundation.dart';
import 'package:fcm_notification_kit/src/data/notification_remote_data_source.dart';
import 'package:fcm_notification_kit/src/error/kit_failure.dart';
import 'package:fcm_notification_kit/src/notification_service.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

/// Repository contract for device-token management.
abstract class NotificationRepository {
  /// Retrieves the current FCM token and sends it to the backend.
  ///
  /// Also wires the token-refresh stream so every rotation is forwarded
  /// to the backend automatically.
  Future<({KitFailure? failure})> registerDeviceToken();

  /// Removes the device token from the backend and deletes the local FCM token.
  Future<({KitFailure? failure})> unregisterDeviceToken();
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

/// Concrete implementation of [NotificationRepository].
class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NotificationService notificationService,
  })  : _remoteDataSource = remoteDataSource,
        _notificationService = notificationService;

  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationService _notificationService;

  @override
  Future<({KitFailure? failure})> registerDeviceToken() async {
    try {
      final token = await _notificationService.getToken();
      if (token == null) {
        debugPrint(
            '[NotifRepo] No FCM token available — skipping registration.');
        return (failure: null);
      }
      await _remoteDataSource.registerDeviceToken(token);

      // Auto-refresh: whenever Firebase rotates the token, re-register.
      _notificationService.onTokenRefresh.listen((newToken) async {
        debugPrint('[NotifRepo] Token refreshed — re-registering.');
        try {
          await _remoteDataSource.registerDeviceToken(newToken);
        } catch (e) {
          debugPrint('[NotifRepo] Token refresh re-registration failed: $e');
        }
      });

      return (failure: null);
    } catch (e) {
      debugPrint('[NotifRepo] registerDeviceToken error: $e');
      return (failure: KitFailure(message: 'Failed to register token: $e'));
    }
  }

  @override
  Future<({KitFailure? failure})> unregisterDeviceToken() async {
    try {
      final token = await _notificationService.getToken();
      if (token != null) {
        await _remoteDataSource.unregisterDeviceToken(token);
      }
      await _notificationService.deleteToken();
      return (failure: null);
    } catch (e) {
      debugPrint('[NotifRepo] unregisterDeviceToken error: $e');
      return (failure: KitFailure(message: 'Failed to unregister token: $e'));
    }
  }
}
