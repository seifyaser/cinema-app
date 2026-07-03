import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassBackButton extends StatelessWidget {
  const LiquidGlassBackButton({
    super.key,
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: LiquidGlassLayer(
        settings: LiquidGlassSettings(
          thickness: 20,
          blur: 20,
          glassColor: Colors.white.withValues(alpha: 0.08),
        ),
        child: FakeGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 35),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.white24),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 17),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
