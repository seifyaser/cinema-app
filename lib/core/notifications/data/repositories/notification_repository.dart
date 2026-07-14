import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:project/core/error/failure.dart';
import 'package:project/core/error/failure_type.dart';
import 'package:project/core/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:project/core/notifications/notification_service.dart';

// ---------------------------------------------------------------------------
// Abstract interface
// ---------------------------------------------------------------------------

/// Repository contract for device-token management.
///
/// Provides the public API for registering and unregistering FCM device tokens.
abstract class NotificationRepository {
  /// Retrieves the current FCM token and sends it to the backend.
  ///
  /// Also wires the [NotificationService.onTokenRefresh] stream so that
  /// every token rotation is automatically forwarded to the backend.
  Future<Either<Failure, void>> registerDeviceToken();

  /// Removes the device token from the backend and deletes the local FCM token.
  Future<Either<Failure, void>> unregisterDeviceToken();
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

/// Concrete implementation of [NotificationRepository].
class NotificationRepositoryImpl implements NotificationRepository {
  /// Creates a [NotificationRepositoryImpl].
  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NotificationService notificationService,
  })  : _remoteDataSource = remoteDataSource,
        _notificationService = notificationService;

  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationService _notificationService;

  @override
  Future<Either<Failure, void>> registerDeviceToken() async {
    try {
      final token = await _notificationService.getToken();
      if (token == null) {
        debugPrint('[NotifRepo] No FCM token available — skipping registration.');
        return const Right(null);
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

      return const Right(null);
    } catch (e) {
      debugPrint('[NotifRepo] registerDeviceToken error: $e');
      return Left(
        Failure(
          type: FailureType.unknown,
          message: 'Failed to register device token: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> unregisterDeviceToken() async {
    try {
      final token = await _notificationService.getToken();
      if (token != null) {
        await _remoteDataSource.unregisterDeviceToken(token);
      }
      await _notificationService.deleteToken();
      return const Right(null);
    } catch (e) {
      debugPrint('[NotifRepo] unregisterDeviceToken error: $e');
      return Left(
        Failure(
          type: FailureType.unknown,
          message: 'Failed to unregister device token: $e',
        ),
      );
    }
  }
}
