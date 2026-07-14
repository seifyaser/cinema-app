import 'package:project/core/notifications/utils/notification_types.dart';

/// Typed representation of the data payload that arrives inside an FCM message.
///
/// Example FCM data payloads:
/// ```json
/// { "type": "NEW_MOVIE",         "movieId":   "123" }
/// { "type": "BOOKING_CONFIRMED", "bookingId": "456" }
/// ```
class NotificationPayload {
  /// Creates a [NotificationPayload] from parsed values.
  const NotificationPayload({
    required this.type,
    this.movieId,
    this.bookingId,
    this.rawData,
  });

  /// The strongly-typed notification category.
  final NotificationType type;

  /// Present when [type] is [NotificationType.newMovie].
  final String? movieId;

  /// Present when [type] is [NotificationType.bookingConfirmed].
  final String? bookingId;

  /// The original, unmodified data map for forward-compatibility.
  final Map<String, dynamic>? rawData;

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  /// Parses a [NotificationPayload] from the raw `data` map of a
  /// [firebase_messaging.RemoteMessage].
  ///
  /// Returns `null` when [data] is null or empty.
  static NotificationPayload? fromMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return null;
    final typeString = data['type'] as String?;
    return NotificationPayload(
      type: typeString.toNotificationType(),
      movieId: data['movieId'] as String?,
      bookingId: data['bookingId'] as String?,
      rawData: data,
    );
  }

  @override
  String toString() =>
      'NotificationPayload(type: $type, movieId: $movieId, '
      'bookingId: $bookingId)';
}
