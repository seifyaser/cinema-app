/// Defines the supported notification types for the Cinema app.
///
/// Add new types here as the notification system grows.
/// The router reads this enum — never compare raw strings anywhere else.
enum NotificationType {
  /// A new movie has been published.
  newMovie,

  /// A booking has been confirmed.
  bookingConfirmed,

  /// Unrecognised / future-proofed type.
  unknown,
}

/// Extension that parses a raw [String] value from the FCM payload's `type`
/// field into a [NotificationType].
extension NotificationTypeParser on String? {
  /// Returns the matching [NotificationType] or [NotificationType.unknown].
  NotificationType toNotificationType() {
    switch (this) {
      case 'NEW_MOVIE':
        return NotificationType.newMovie;
      case 'BOOKING_CONFIRMED':
        return NotificationType.bookingConfirmed;
      default:
        return NotificationType.unknown;
    }
  }
}
