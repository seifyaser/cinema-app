import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/notifications/models/notification_payload.dart';
import 'package:project/core/notifications/utils/notification_types.dart';
import 'package:project/core/router/app_router.dart';

/// Maps a [NotificationPayload] to a GoRouter navigation call.
///
/// Responsibilities:
/// - Interpret notification payloads.
/// - Navigate to the correct screen via [GoRouter].
///
/// **No Firebase code lives here.**
/// **No notification display logic lives here.**
class NotificationRouter {
  /// Routes to the correct screen based on the [NotificationPayload].
  ///
  /// [context] must be a valid [BuildContext] with a GoRouter ancestor.
  /// Returns `false` if the type is unknown or navigation was not performed.
  bool routeFromPayload(
    BuildContext context,
    NotificationPayload payload,
  ) {
    debugPrint('[NotifRouter] Routing payload: $payload');

    switch (payload.type) {
      case NotificationType.newMovie:
        if (payload.movieId != null) {
          // Navigate to the home screen; the movie details deep-link will be
          // supported once the movie-by-ID fetch is wired from the backend.
          // For now we land on home so the user can find the movie.
          context.go(AppRouter.homeRoute);
          debugPrint(
            '[NotifRouter] → /home (movieId: ${payload.movieId})',
          );
          return true;
        }
        return false;

      case NotificationType.bookingConfirmed:
        if (payload.bookingId != null) {
          context.go(AppRouter.ticketsRoute);
          debugPrint(
            '[NotifRouter] → /tickets (bookingId: ${payload.bookingId})',
          );
          return true;
        }
        return false;

      case NotificationType.unknown:
        debugPrint('[NotifRouter] Unknown notification type — no navigation.');
        return false;
    }
  }

  /// Convenience: parse a query-string payload emitted by [LocalNotificationService]
  /// and delegate to [routeFromPayload].
  ///
  /// The payload format is `key=value&key=value`.
  bool routeFromRawPayload(BuildContext context, String? rawPayload) {
    if (rawPayload == null || rawPayload.isEmpty) return false;

    final map = Map.fromEntries(
      rawPayload.split('&').map((pair) {
        final parts = pair.split('=');
        return MapEntry(
          parts.first,
          parts.length > 1 ? parts.last : '',
        );
      }),
    );

    final payload = NotificationPayload.fromMap(map);
    if (payload == null) return false;

    return routeFromPayload(context, payload);
  }
}
