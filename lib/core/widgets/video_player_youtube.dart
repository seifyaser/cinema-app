import 'package:flutter/material.dart';
import 'package:inline_youtube_player/inline_youtube_player.dart';

/// A reusable "Watch Trailer" button that navigates to [YoutubePlayerScreen]
/// when tapped.
///
/// Pass any YouTube URL format — the player screen handles all ID extraction
/// and validation internally using the youtube_player_iframe library.
///
/// Usage:
/// ```dart
/// YoutubePlayButton(videoUrl: movie.trailerUrl)
/// ```
class YoutubePlayButton extends StatelessWidget {
  /// The raw YouTube URL from an API response (e.g. the `videoUrl` field).
  final String videoUrl;

  const YoutubePlayButton({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPlayer(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_circle_fill, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Watch Trailer',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPlayer(BuildContext context) {
    // rootNavigator: true → pushes above go_router's own navigator so our
    // pop() call only removes this screen, not go_router's declarative pages.
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => YoutubePlayerScreen(videoUrl: videoUrl),
      ),
    );
  }
}