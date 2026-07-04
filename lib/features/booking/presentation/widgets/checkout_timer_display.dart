import 'dart:ui';
import 'package:flutter/material.dart';

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
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isUrgent
              ? Colors.red.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isUrgent
                ? Colors.redAccent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              color: isUrgent ? Colors.redAccent : const Color(0xFFEAB308),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              formattedTime,
              style: TextStyle(
                color: isUrgent ? Colors.redAccent : Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
