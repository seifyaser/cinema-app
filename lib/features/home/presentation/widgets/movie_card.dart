import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/movie_data.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, super.key});
  
  final MovieData movie;

  // 1. Immutable Layout Constants
  // Pre-allocating layout constraints avoids creating these objects on every build
  static const _padding = EdgeInsets.only(top: 22, left: 20);
  static const _gap = SizedBox(height: 8);
  static const _tagPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);

  // 2. Tag Style Constants
  // We replaced the expensive glass blur with a sleek semi-transparent black solid background
  static const _bgRadius = BorderRadius.all(Radius.circular(18));
  static const _tagBgColor = Color(0x99000000); // Semi-transparent black (60% opacity)
  static const _tagBorderColor = Color(0x33FFFFFF); // Subtle white border (20% opacity)
  
  static final _tagBorder = Border.all(color: _tagBorderColor, width: 1);

  // 3. TextStyle Cache
  // TextStyles are relatively heavy objects, especially when fetching GoogleFonts. 
  // We resolve and cache it once.
  static final _tagTextStyle = TextStyle(
    fontFamily: GoogleFonts.manrope().fontFamily,
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
  );

  @override
  Widget build(BuildContext context) {
    // 4. Memory-efficient list mapping
    // We use growable: false to tell the Dart VM to allocate the exact required contiguous memory
    final gradientColors = movie.gradientColors.map((c) => Color(c)).toList(growable: false);

    // 5. Replaced Container with DecoratedBox
    // Container creates nested internal padding/constraints widgets. DecoratedBox is structurally lighter.
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        image: DecorationImage(
          // NetworkImage is lightweight, but when combined with CinemaDeck's RepaintBoundary, 
          // this is extremely efficient because the image is rasterized only once per card.
          image: NetworkImage(movie.imageurl),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: _padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTag(movie.duration),
              _gap,
              _buildTag(movie.type),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    // 6. Solid Background Optimization
    // By removing BackdropFilter entirely, we save the GPU from running convolution shaders.
    // The sleek semi-transparent black looks premium while rendering instantaneously!
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _tagBgColor,
        borderRadius: _bgRadius,
        border: _tagBorder,
      ),
      child: Padding(
        padding: _tagPadding,
        child: Text(
          text,
          style: _tagTextStyle,
        ),
      ),
    );
  }
}


