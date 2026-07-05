import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassChip extends StatelessWidget {
  final Widget child;

  const GlassChip({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary isolates this chip's raster layer so that parent
    // rebuilds (e.g. numberOfSeats change) don't force a GPU recomposite
    // of the liquid glass effect.
    return RepaintBoundary(
      child: LiquidGlassLayer(
        settings: LiquidGlassSettings(
          thickness: 20,
          blur: 20,
          glassColor: Colors.white.withValues(alpha: 0.08),
        ),
        child: FakeGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white24,
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
