import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class NavBarItem {
  final IconData icon;
  final String label;

  NavBarItem({required this.icon, required this.label});
}

class LiquidGlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavBarItem> items;

  const LiquidGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0, vertical: 24.0),
      child: LiquidGlassLayer(
        settings: LiquidGlassSettings(
          thickness: 20,
          blur: 20,
          glassColor: Colors.white.withValues(alpha: 0.08),
        ),
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 40),
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(items.length, (index) {
                final isSelected = currentIndex == index;
                final item = items[index];

                return GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 12 : 10,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          scale: isSelected ? 1.2 : 1.0,
                          child: Icon(
                            item.icon,
                            color: isSelected
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          child: SizedBox(
                            width: isSelected ? null : 0,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: isSelected ? 8.0 : 0,
                              ),
                              child: isSelected
                                  ? Text(
                                      item.label,
                                      style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.manrope().fontFamily,
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      maxLines: 1,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
