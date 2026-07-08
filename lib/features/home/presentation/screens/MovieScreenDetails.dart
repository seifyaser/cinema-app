import 'package:flutter/material.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/presentation/widgets/Expandable_description.dart';
import 'package:project/features/home/presentation/widgets/movie_details_background.dart';
import 'package:project/features/home/presentation/widgets/movie_details_top_bar.dart';
import 'package:project/features/home/presentation/widgets/movie_poster_trailer.dart';
import 'package:project/features/home/presentation/widgets/movie_cast_list.dart';
import 'package:project/features/home/presentation/widgets/book_now_button.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movie});
  final MovieEntity movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff080808),
      body: Stack(
        children: [
          MovieDetailsBackground(movie: movie),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 85, 20, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoviePosterTrailer(movie: movie),
                  const SizedBox(height: 28),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ExpandableDescription(description: movie.description),
                  const SizedBox(height: 35),
                  const Text(
                    "Cast",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 18),
                  MovieCastList(movie: movie),
                ],
              ),
            ),
          ),
          MovieDetailsTopBar(movie: movie),
          BookNowButton(movie: movie),
        ],
      ),
    );
  }
}
