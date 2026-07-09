import 'package:flutter/material.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/presentation/widgets/movieTag.dart';

class SearchResultCard extends StatelessWidget {
  final MovieEntity movie;

  const SearchResultCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(movie.imageurl, fit: BoxFit.cover),
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassMovieTag(text: movie.duration),
                const SizedBox(height: 8),
                GlassMovieTag(text: movie.type),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sora',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
