import 'package:flutter/material.dart';
import 'package:project/core/widgets/video_player_youtube.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';

class MoviePosterTrailer extends StatelessWidget {
  const MoviePosterTrailer({super.key, required this.movie});

  final MovieEntity movie;

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
          child: YoutubePlayButton(videoUrl: movie.trailerUrl),
        ),
      ],
    );
  }
}
