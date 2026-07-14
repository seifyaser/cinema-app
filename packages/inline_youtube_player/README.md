# inline_youtube_player

A simple, robust, and standalone Flutter package that provides a drop-in YouTube player screen. Built on top of `youtube_player_iframe`, it abstracts away all the headaches of fullscreen orientation handling and invalid URL states.

## Features

- **Drop-in Screen:** Provides a ready-to-use `YoutubePlayerScreen` widget.
- **Native Fullscreen Handling:** Automatically forces landscape orientation when the user taps the YouTube fullscreen button, and gracefully restores portrait mode when exiting fullscreen.
- **URL Parsing:** Simply pass the raw YouTube URL (`videoUrl: 'https://youtu.be/...'`). The package handles extracting the video ID automatically.
- **Graceful Error Handling:** If an invalid URL is passed or an ID cannot be extracted, the package automatically displays a clean, themed "Invalid YouTube URL" fallback screen instead of crashing or showing a blank player.
- **Safe Initialization:** Defers video loading until the Webview/Pigeon channel is fully established, preventing race conditions.

## Installation

Add the package to your `pubspec.yaml` as a path dependency (or git dependency):

```yaml
dependencies:
  inline_youtube_player:
    path: ../packages/inline_youtube_player
```

Run `flutter pub get` to fetch the dependencies.

## Usage

Simply push the `YoutubePlayerScreen` passing the video URL.

> **CRITICAL:** If your app uses nested navigation (like a BottomNavigationBar with `go_router` or `StatefulShellRoute`), you **must** push this screen using `rootNavigator: true` so that it renders over the top of your bottom navigation bar, otherwise fullscreen mode will clip.

### Example (with standard Navigator)

```dart
import 'package:inline_youtube_player/inline_youtube_player.dart';

// ... inside a widget callback

Navigator.of(context, rootNavigator: true).push(
  MaterialPageRoute(
    builder: (_) => YoutubePlayerScreen(
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ),
);
```

### Example (with GoRouter)

If using `go_router`, you can either push it natively as shown above, or define a dedicated route at the root level of your router configuration:

```dart
// In your router config:
GoRoute(
  path: '/trailer',
  // Make sure this is outside your StatefulShellRoute
  parentNavigatorKey: rootNavigatorKey, 
  builder: (context, state) {
    final url = state.extra as String;
    return YoutubePlayerScreen(videoUrl: url);
  },
)

// To navigate:
context.push('/trailer', extra: 'https://youtu.be/dQw4w9WgXcQ');
```

## Dependencies

This package relies on:
- [`youtube_player_iframe`](https://pub.dev/packages/youtube_player_iframe) for the core web-based player.
