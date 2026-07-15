import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// YouTube player screen.
///
/// - Opens in portrait with a 16:9 player (no forced orientation).
/// - When the user taps YouTube's own fullscreen button the package handles
///   rotation natively — we do nothing.
/// - When the user exits the package's fullscreen the screen pops back to
///   MovieDetailsScreen (or wherever it was pushed from).
///
/// IMPORTANT: this screen must be pushed with [rootNavigator] = true so it
/// lives above go_router's navigator:
/// ```dart
/// Navigator.of(context, rootNavigator: true).push(
///   MaterialPageRoute(builder: (_) => YoutubePlayerScreen(videoUrl: url)),
/// );
/// ```
class YoutubePlayerScreen extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerScreen({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _valueSub;
  late final String? _videoId;

  bool _disposed = false;

  // ── Fullscreen transition tracking ─────────────────────────────────────────
  // We track the PREVIOUS state so we only react to genuine transitions:
  //   false → true  : user entered fullscreen (mark flag)
  //   true  → false : user exited fullscreen  (pop back)
  //
  // This prevents brief intermediate events (that fire during the
  // OverlayPortal animation) from triggering a spurious pop.
  bool _prevFullscreen = false;
  bool _hasEnteredFullscreen = false;
  // ───────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    _videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

    if (_videoId case final id?) {
      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
          loop: false,
          enableCaption: true,
          playsInline: false,
        ),
      );

      _valueSub = _controller!.stream.listen((value) {
        if (_disposed) return;

        final isFullscreen = value.fullScreenOption.enabled;

        if (!_prevFullscreen && isFullscreen) {
          // false → true : genuine fullscreen-enter
          _hasEnteredFullscreen = true;
          // Force landscape orientation
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else if (_prevFullscreen && !isFullscreen && _hasEnteredFullscreen) {
          // true → false : genuine fullscreen-exit
          // Restore portrait, but DO NOT pop the screen.
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }

        _prevFullscreen = isFullscreen;
      });

      // Load the video after the first frame so the Pigeon/WebView channel
      // is fully open before we send any commands.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_disposed) return;
        _controller?.loadVideoById(videoId: id);
      });
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _valueSub?.cancel();
    try {
      _controller?.close();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _controller == null) {
      return _InvalidUrlScreen(videoUrl: widget.videoUrl);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(controller: _controller!),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error screen for invalid / unrecognised YouTube URLs
// ---------------------------------------------------------------------------

class _InvalidUrlScreen extends StatelessWidget {
  final String videoUrl;

  const _InvalidUrlScreen({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: const Text(
          'Trailer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.link_off_rounded,
                  color: Colors.redAccent,
                  size: 52,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Invalid YouTube URL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Could not extract a video ID from the provided URL.\n\n$videoUrl',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'Go Back',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
