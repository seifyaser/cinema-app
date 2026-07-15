import 'package:flutter/material.dart';

class TicketTearLine extends StatelessWidget {
  const TicketTearLine({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => const SizedBox(
              width: dashWidth,
              height: 1.5,
              child: ColoredBox(color: Color(0x66FFFFFF)),
            ),
          ),
        );
      },
    );
  }
}
