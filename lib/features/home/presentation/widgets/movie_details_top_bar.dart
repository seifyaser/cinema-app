import 'package:flutter/material.dart';
import 'package:project/features/home/data/models/movie_data.dart';
import 'package:project/features/home/presentation/widgets/movieTag.dart';
import 'package:project/features/home/presentation/widgets/liquid_glass_back_button.dart';

class MovieDetailsTopBar extends StatelessWidget {
  const MovieDetailsTopBar({super.key, required this.movie});

  final MovieData movie;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Row(
            children: [
              const LiquidGlassBackButton(
                icon: Icons.arrow_back_ios_new,
                text: "Back",
              ),
              const Spacer(),
              GlassMovieTag(text: movie.type),
              const SizedBox(width: 10),
              GlassMovieTag(text: movie.duration),
            ],
          ),
        ),
      ),
    );
  }
}
