import 'package:dio/dio.dart';
import 'package:fcm_notification_kit/fcm_notification_kit.dart';

/// Project-level data source.
///
/// Delegates to [FcmTokenDataSource] from [fcm_notification_kit], passing
/// this app's configured [Dio] instance (with auth headers already set) and
/// the correct endpoint path.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  NotificationRemoteDataSourceImpl({required Dio dio})
      : _inner = FcmTokenDataSource(
          dio: dio,
          tokenEndpoint: 'users/me/fcm-token',
        );

  final FcmTokenDataSource _inner;

  @override
  Future<void> registerDeviceToken(String token) =>
      _inner.registerDeviceToken(token);

  @override
  Future<void> unregisterDeviceToken(String token) =>
      _inner.unregisterDeviceToken(token);
}
