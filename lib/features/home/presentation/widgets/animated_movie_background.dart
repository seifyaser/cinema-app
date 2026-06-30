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
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.network(
              imageUrl,
              key: ValueKey(animationKey),
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.white.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
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
    );
  }
}
