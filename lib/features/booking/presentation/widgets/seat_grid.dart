import 'package:flutter/material.dart';

class SeatGrid extends StatelessWidget {
  final List<List<int>> seats;
  final void Function(int rowIndex, int colIndex) onSeatTap;

  const SeatGrid({super.key, required this.seats, required this.onSeatTap});

  Widget _buildRow(int rowIndex) {
    final seatStates = seats[rowIndex];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(seatStates.length, (colIndex) {
          final state = seatStates[colIndex];
          if (state == -1) return const SizedBox(width: 20); // Aisle

          bool isSelected = state == 1;
          bool isOccupied = state == 2;

          Color borderColor;
          Color highlightColor;
          Color bgColor;

          if (isSelected) {
            borderColor = const Color(0xFFEAB308);
            highlightColor = const Color(0xFFEAB308);
            bgColor = const Color(0xFFEAB308).withValues(alpha: 0.1);
          } else if (isOccupied) {
            borderColor = Colors.white.withValues(alpha: 0.1);
            highlightColor = Colors.white.withValues(alpha: 0.1);
            bgColor = Colors.white.withValues(alpha: 0.05);
          } else {
            // Available
            borderColor = Colors.white;
            highlightColor = Colors.white;
            bgColor = Colors.transparent;
          }

          return GestureDetector(
            onTap: () => onSeatTap(rowIndex, colIndex),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: borderColor,
                  width: isSelected ? 2 : 1.5,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                color: bgColor,
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: highlightColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(0),
        _buildRow(1),
        _buildRow(2),
        _buildRow(3),
        _buildRow(4),
        const SizedBox(height: 8),
        _buildRow(5),
        _buildRow(6),
      ],
    );
  }
}
