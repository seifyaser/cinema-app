import 'dart:ui';
import 'package:flutter/material.dart';

class AnimatedMovieBackground extends StatelessWidget {
  final String imageUrl;
  final int animationKey;

  const AnimatedMovieBackground({
    super.key,
    required this.imageUrl,
    required this.animationKey,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned.fill(
      bottom: screenHeight * 0.45,
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: ImageFiltered(
                key: ValueKey(animationKey),
                imageFilter: ImageFilter.blur(
                  sigmaX: 8,
                  sigmaY: 8,
                  tileMode: TileMode.decal,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  width: double.infinity,
                  cacheWidth: 720,
                  filterQuality: FilterQuality.low,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const ColoredBox(color: Colors.black);
                  },
                  errorBuilder: (_, __, ___) =>
                      const ColoredBox(color: Colors.black),
                ),
              ),
            ),

            // White tint
            const ColoredBox(color: Color(0x15FFFFFF)),

            // Bottom fade
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 180,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Theme.of(context).colorScheme.surface,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
