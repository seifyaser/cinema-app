/// Abstract base for every notification payload in a consuming project.
///
/// Subclass this and add your own domain-specific fields:
/// ```dart
/// class AppNotificationPayload extends NotificationPayloadBase {
///   AppNotificationPayload({
///     required super.type,
///     super.rawData,
///     this.movieId,
///   });
///   final String? movieId;
/// }
/// ```
abstract class NotificationPayloadBase {
  const NotificationPayloadBase({
    required this.type,
    this.rawData,
  });

  /// Raw string type from the FCM data map (e.g. `"NEW_MOVIE"`).
  final String type;

  /// The original, unmodified data map for forward-compatibility.
  final Map<String, dynamic>? rawData;

  @override
  String toString() => 'NotificationPayloadBase(type: $type)';
}
