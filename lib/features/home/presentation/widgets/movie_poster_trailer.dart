import 'package:flutter/material.dart';
import 'package:project/features/home/data/models/movie_data.dart';

class MoviePosterTrailer extends StatelessWidget {
  const MoviePosterTrailer({super.key, required this.movie});

  final MovieData movie;

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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Row(
              children: [
                Icon(Icons.play_circle_fill, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Watch Trailer",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
