import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/models/movie_data.dart';
import 'cinema_deck.dart';
import 'movie_card.dart';

class NowPlayingView extends StatefulWidget {
  final Function(int) onIndexChanged;

  const NowPlayingView({super.key, required this.onIndexChanged});

  @override
  State<NowPlayingView> createState() => _NowPlayingViewState();
}

class _NowPlayingViewState extends State<NowPlayingView> {
  @override
  Widget build(BuildContext context) {
    final today = DateFormat('dd MMM').format(DateTime.now()).toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),

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

        const SizedBox(height: 10),

        Expanded(
          child: CinemaDeck(
            itemCount: MovieData.mockMovies.length,
            borderRadius: 24.0,
            viewportFraction: 0.82,
            onIndexChanged: widget.onIndexChanged,
            itemBuilder: (context, index) {
              final movie = MovieData.mockMovies[index];
              return MovieCard(key: ValueKey(movie.title), movie: movie);
            },
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
