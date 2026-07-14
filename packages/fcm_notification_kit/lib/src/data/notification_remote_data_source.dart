import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Contract for the remote notification data source.
///
/// Implement this interface in your project using whatever HTTP client you use.
/// The package also ships [FcmTokenDataSource] — a ready-made Dio implementation.
abstract class NotificationRemoteDataSource {
  /// Sends the FCM [token] to the backend for storage.
  Future<void> registerDeviceToken(String token);

  /// Notifies the backend to remove the FCM [token].
  Future<void> unregisterDeviceToken(String token);
}

// ---------------------------------------------------------------------------
// Ready-made Dio implementation
// ---------------------------------------------------------------------------

/// Dio-based implementation of [NotificationRemoteDataSource].
///
/// Works with any backend that exposes:
/// - `PUT  <tokenEndpoint>` — body `{ token, platform }`
/// - `DELETE <tokenEndpoint>` — body `{ token }`
///
/// Pass your own [Dio] instance (already configured with base URL and auth
/// headers) and optionally override [tokenEndpoint].
class FcmTokenDataSource implements NotificationRemoteDataSource {
  FcmTokenDataSource({
    required Dio dio,
    this.tokenEndpoint = 'users/me/fcm-token',
  }) : _dio = dio;

  final Dio _dio;

  /// The path appended to the Dio base URL. Defaults to `users/me/fcm-token`.
  final String tokenEndpoint;

  @override
  Future<void> registerDeviceToken(String token) async {
    try {
      await _dio.put(
        tokenEndpoint,
        data: {
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
        },
      );
      debugPrint('[FcmTokenDataSource] registerDeviceToken success');
    } catch (e) {
      debugPrint('[FcmTokenDataSource] registerDeviceToken error: $e');
    }
  }

  @override
  Future<void> unregisterDeviceToken(String token) async {
    try {
      await _dio.delete(
        tokenEndpoint,
        data: {'token': token},
      );
      debugPrint('[FcmTokenDataSource] unregisterDeviceToken success');
    } catch (e) {
      debugPrint('[FcmTokenDataSource] unregisterDeviceToken error: $e');
    }
  }
}
