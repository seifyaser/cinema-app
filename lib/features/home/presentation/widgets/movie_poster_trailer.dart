import 'package:flutter/material.dart';
import 'package:project/core/widgets/video_player_youtube.dart';
import 'package:project/features/home/data/models/movie_data.dart';

class MoviePosterTrailer extends StatelessWidget {
  const MoviePosterTrailer({super.key, required this.movie});

  final MovieData movie;

  // ── TEMPORARY ──────────────────────────────────────────────────────────────
  // Replace this with movie.trailerUrl (or however your API field is named)
  // once the backend returns it.  The player accepts any YouTube URL format.
  static const String _staticTrailerUrl =
      'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.network(
            movie.imageurl,
            height: 330,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 18,
          bottom: 18,
          // YoutubePlayButton handles navigation + URL parsing internally.
          // Swap _staticTrailerUrl for movie.trailerUrl when the API is ready.
          child: YoutubePlayButton(videoUrl: _staticTrailerUrl),
        ),
      ],
    );
  }
}
