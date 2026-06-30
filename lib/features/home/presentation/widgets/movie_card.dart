import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/movie_data.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, super.key});
  final MovieData movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: movie.gradientColors.map((c) => Color(c)).toList(),
        ),
        image: DecorationImage(
          image: NetworkImage(movie.imageurl),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 22, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGlassTag(movie.duration),
              const SizedBox(height: 8),
              _buildGlassTag(movie.type),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTag(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: GoogleFonts.manrope().fontFamily,
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
