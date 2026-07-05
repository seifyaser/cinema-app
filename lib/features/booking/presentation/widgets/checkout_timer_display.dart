import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class CheckoutTimerDisplay extends StatelessWidget {
  final String formattedTime;
  final bool isUrgent;

  const CheckoutTimerDisplay({
    super.key,
    required this.formattedTime,
    required this.isUrgent,
  });

  @override
  Widget build(BuildContext context) {
    // LiquidGlassLayer is OUTSIDE AnimatedContainer so the glass shell
    // is a static composited layer. Only the inner border color animates —
    // the GPU does not recomposite the full glass effect every tick.
    return LiquidGlassLayer(
      settings: LiquidGlassSettings(
        thickness: 20,
        blur: 20,
        glassColor: isUrgent
            ? Colors.red.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.08),
      ),
      child: FakeGlass(
        shape: LiquidRoundedSuperellipse(borderRadius: 30),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isUrgent
                  ? Colors.redAccent.withValues(alpha: 0.5)
                  : Colors.white24,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: isUrgent ? Colors.redAccent : const Color(0xFFEAB308),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                formattedTime,
                style: TextStyle(
                  color: isUrgent ? Colors.redAccent : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
