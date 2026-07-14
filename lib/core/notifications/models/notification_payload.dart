import 'package:fcm_notification_kit/fcm_notification_kit.dart';

/// App-specific notification payload.
///
/// Extends [NotificationPayloadBase] from [fcm_notification_kit] with the
/// domain fields this project needs.
class NotificationPayload extends NotificationPayloadBase {
  const NotificationPayload({
    required super.type,
    super.rawData,
    this.movieId,
    this.bookingId,
  });

  /// Present when type is `NEW_MOVIE`.
  final String? movieId;

  /// Present when type is `BOOKING_CONFIRMED`.
  final String? bookingId;

  /// Parses a [NotificationPayload] from the raw FCM `data` map.
  ///
  /// Returns `null` when [data] is null or empty.
  static NotificationPayload? fromMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return null;
    return NotificationPayload(
      type: data['type'] as String? ?? 'unknown',
      movieId: data['movieId'] as String?,
      bookingId: data['bookingId'] as String?,
      rawData: data,
    );
  }

  @override
  String toString() =>
      'NotificationPayload(type: $type, movieId: $movieId, bookingId: $bookingId)';
}
