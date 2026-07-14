import 'package:flutter/foundation.dart';

/// Contract for the remote notification data source.
///
/// The stub implementation logs to console only.
/// Swap in a real [ApiService]-based implementation when the backend is ready.
abstract class NotificationRemoteDataSource {
  /// Sends the FCM [token] to the backend for storage.
  Future<void> registerDeviceToken(String token);

  /// Notifies the backend to remove the FCM [token].
  Future<void> unregisterDeviceToken(String token);
}

// ---------------------------------------------------------------------------
// Stub implementation (backend not ready yet)
// ---------------------------------------------------------------------------

/// Stub implementation that prints the token to the debug console.
///
/// **Replace this with a real HTTP implementation once the backend endpoint
/// `POST /api/v1/notifications/device-token` is available.**
class NotificationRemoteDataSourceStub
    implements NotificationRemoteDataSource {
  @override
  Future<void> registerDeviceToken(String token) async {
    // TODO: Replace with real API call:
    // await _apiService.post(
    //   'notifications/device-token',
    //   data: {'token': token, 'platform': Platform.isAndroid ? 'android' : 'ios'},
    // );
    debugPrint('[NotifDataSource] STUB — registerDeviceToken: $token');
  }

  @override
  Future<void> unregisterDeviceToken(String token) async {
    // TODO: Replace with real API call:
    // await _apiService.delete(
    //   'notifications/device-token',
    //   data: {'token': token},
    // );
    debugPrint('[NotifDataSource] STUB — unregisterDeviceToken: $token');
  }
}
