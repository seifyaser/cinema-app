import 'package:flutter/material.dart';

class TicketBarcode extends StatelessWidget {
  const TicketBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate a fixed pattern of widths for a realistic barcode look
    final List<double> barWidths = [
      2, 1, 3, 1, 1, 2, 4, 1, 2, 1, 1, 3, 2, 1, 4, 1, 1, 2, 3, 1,
      1, 4, 2, 1, 1, 2, 1, 3, 1, 4, 1, 1, 2, 3, 1, 2, 1, 1, 4, 2,
    ];

    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: barWidths
            .map(
              (w) => SizedBox(
                width: w * 1.2,
                height: double.infinity,
                child: const ColoredBox(color: Color(0xE6FFFFFF)),
              ),
            )
            .toList(),
      ),
    );
  }
}
