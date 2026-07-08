import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/movie_entity.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, super.key});

  final MovieEntity movie;

  static const _padding = EdgeInsets.only(top: 22, left: 20);
  static const _gap = SizedBox(height: 8);
  static const _tagPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 6);

  static const _bgRadius = BorderRadius.all(Radius.circular(18));
  static const _tagBgColor = Color(0x99000000);
  static const _tagBorderColor = Color(0x33FFFFFF);

  static final _tagBorder = Border.all(color: _tagBorderColor, width: 1);

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
    final gradientColors = movie.gradientColors
        .map((c) => Color(c))
        .toList(growable: false);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        image: DecorationImage(
          image: NetworkImage(movie.imageurl),
          fit: BoxFit.fitHeight,
          filterQuality: FilterQuality.high,
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: _padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTag(movie.duration), _gap, _buildTag(movie.type)],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _tagBgColor,
        borderRadius: _bgRadius,
        border: _tagBorder,
      ),
      child: Padding(
        padding: _tagPadding,
        child: Text(text, style: _tagTextStyle),
      ),
    );
  }
}
