import 'package:flutter/material.dart';
import '../cubit/seat_status.dart';

class SeatGrid extends StatelessWidget {
  final List<List<SeatStatus>> seats;
  final void Function(int rowIndex, int colIndex) onSeatTap;

  const SeatGrid({super.key, required this.seats, required this.onSeatTap});

  Widget _buildColumnLabels() {
    if (seats.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Space for row label
          const SizedBox(width: 24),
          const SizedBox(width: 8),
          ...(() {
            final List<Widget> items = [];
            for (int colIndex = 0; colIndex < seats[0].length; colIndex++) {
              bool isAisleCol = true;
              for (var row in seats) {
                if (row[colIndex] != SeatStatus.aisle) {
                  isAisleCol = false;
                  break;
                }
              }

              if (isAisleCol) {
                items.add(const SizedBox(width: 20));
              } else {
                items.add(
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 24,
                    alignment: Alignment.center,
                    child: Text(
                      '${colIndex + 1}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }

              // Add a visual space between the 5th and 6th columns
              if (colIndex == 4) {
                items.add(const SizedBox(width: 32));
              }
            }
            return items;
          })(),
          // Balancing spacer on the right to keep seats perfectly centered
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildRow(int rowIndex) {
    final seatStates = seats[rowIndex];
    final String rowLabel = String.fromCharCode('A'.codeUnitAt(0) + rowIndex);

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row Label
            Container(
              width: 24,
              alignment: Alignment.center,
              child: Text(
                rowLabel,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Seats
            ...(() {
              final List<Widget> items = [];
              for (int colIndex = 0; colIndex < seatStates.length; colIndex++) {
                final state = seatStates[colIndex];
                if (state == SeatStatus.aisle) {
                  items.add(const SizedBox(width: 20)); // Aisle
                } else {
                  final bool isSelected = state == SeatStatus.selected;
                  final bool isOccupied = state == SeatStatus.occupied;

                  final Color borderColor;
                  final Color highlightColor;
                  final Color bgColor;

                  if (isSelected) {
                    borderColor = const Color(0xFFEAB308);
                    highlightColor = const Color(0xFFEAB308);
                    bgColor = const Color(0xFFEAB308).withValues(alpha: 0.1);
                  } else if (isOccupied) {
                    borderColor = Colors.white.withValues(alpha: 0.1);
                    highlightColor = Colors.white.withValues(alpha: 0.1);
                    bgColor = Colors.white.withValues(alpha: 0.05);
                  } else {
                    borderColor = Colors.white;
                    highlightColor = Colors.white;
                    bgColor = Colors.transparent;
                  }

                  items.add(
                    GestureDetector(
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
                    ),
                  );
                }

                // Add a visual space between the 5th and 6th columns
                if (colIndex == 4) {
                  items.add(const SizedBox(width: 32));
                }
              }
              return items;
            })(),
            // Balancing spacer on the right to keep seats perfectly centered
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildColumnLabels(),
        ...List.generate(seats.length, (index) {
          if (index == seats.length - 2 && seats.length > 2) {
            return Column(
              children: [const SizedBox(height: 8), _buildRow(index)],
            );
          }
          return _buildRow(index);
        }),
      ],
    );
  }
}
