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
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * 0.55,
      child: RepaintBoundary(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ImageFiltered wraps the crossfade so the blur is applied at the
            // compositing stage. Duration reduced to 300ms (was 500ms) to shorten
            // the window where two blurred images are composited simultaneously.
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 8,
                sigmaY: 8,
                tileMode: TileMode.decal,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Image.network(
                  imageUrl,
                  key: ValueKey(animationKey),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  // Constrain decoded texture size — avoids uploading a
                  // full-res image to the GPU for a blurred background.
                  cacheWidth: 480,
                  cacheHeight: 400,
                ),
              ),
            ),
            // Plain tint — no BackdropFilter.
            const ColoredBox(color: Color(0x1FFFFFFF)),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 150,
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
          ],
        ),
      ),
    );
  }
}
