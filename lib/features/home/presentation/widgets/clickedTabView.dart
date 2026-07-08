import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:project/core/router/app_router.dart';
import '../../domain/entities/movie_entity.dart';
import 'cinema_deck.dart';
import 'movie_card.dart';

class ClickedTabView extends StatefulWidget {
  final Function(int) onIndexChanged;
  final List<MovieEntity> movies;
  final bool showDate;

  const ClickedTabView({
    super.key,
    required this.onIndexChanged,
    required this.movies,
    this.showDate = false,
  });

  @override
  State<ClickedTabView> createState() => _ClickedTabViewState();
}

class _ClickedTabViewState extends State<ClickedTabView> {
  @override
  Widget build(BuildContext context) {
    final today = DateFormat('dd MMM').format(DateTime.now()).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        
        if (widget.showDate)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF5A5A5A), Color(0xFFBDBDBD), Colors.white],
                  stops: [0.0, 0.55, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                today,
                style: TextStyle(
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        if (widget.showDate)
          const SizedBox(height: 10),

        Expanded(
          child: CinemaDeck(
            itemCount: widget.movies.length,
            borderRadius: 24.0,
            viewportFraction: 0.82,
            onIndexChanged: widget.onIndexChanged,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return GestureDetector(
                onTap: () {
                  context.push(AppRouter.movieDetailsRoute, extra: movie);
                },
                child: MovieCard(key: ValueKey(movie.title), movie: movie),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
