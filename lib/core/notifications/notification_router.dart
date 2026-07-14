import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/notifications/models/notification_payload.dart';
import 'package:project/core/router/app_router.dart';

/// App-specific routing logic for notification taps.
///
/// This class is intentionally NOT in the package — routing is always
/// project-specific. The package's [NotificationHandler] invokes the
/// [route] callback with the raw FCM data map; this class converts it to
/// a [NotificationPayload] and navigates using GoRouter.
class NotificationRouter {
  /// Routes to the correct screen based on the FCM [data] map.
  ///
  /// Returns `false` if the type is unknown.
  bool route(BuildContext context, Map<String, dynamic> data) {
    final payload = NotificationPayload.fromMap(data);
    if (payload == null) return false;

    debugPrint('[NotifRouter] Routing payload: $payload');

    switch (payload.type) {
      case 'NEW_MOVIE':
        if (payload.movieId != null) {
          context.push('${AppRouter.movieDetailsRoute}/${payload.movieId}');
          debugPrint(
              '[NotifRouter] → /movieDetails (movieId: ${payload.movieId})');
          return true;
        }
        return false;

      case 'BOOKING_CONFIRMED':
        if (payload.bookingId != null) {
          context.go(AppRouter.ticketsRoute);
          debugPrint(
              '[NotifRouter] → /tickets (bookingId: ${payload.bookingId})');
          return true;
        }
        return false;

      default:
        debugPrint(
            '[NotifRouter] Unknown notification type: ${payload.type} — no navigation.');
        return false;
    }
  }
}
