import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:project/features/home/data/models/movie_data.dart';

class MovieDetailsBackground extends StatelessWidget {
  const MovieDetailsBackground({super.key, required this.movie});

  final MovieData movie;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 22,
              sigmaY: 22,
              tileMode: TileMode.decal,
            ),
            child: Image.network(
              movie.imageurl,
              fit: BoxFit.cover,
              cacheWidth: 300,
              cacheHeight: 400,
            ),
          ),
          Container(color: const Color(0xff080808).withValues(alpha: 0.5)),
        ],
      ),
    );
  }
}
