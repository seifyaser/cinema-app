import 'package:flutter/material.dart';
import 'glass_chip.dart';

class BookingDateSelector extends StatelessWidget {
  final List<String> dates;
  final List<String> rawDates;
  final int selectedDateIndex;
  final int numberOfSeats;
  final ValueChanged<String>? onDateSelected;

  const BookingDateSelector({
    super.key,
    required this.dates,
    required this.rawDates,
    required this.selectedDateIndex,
    required this.numberOfSeats,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Date Picker Chip
        PopupMenuButton<String>(
          offset: const Offset(0, 40),
          color: const Color(0xFF131313),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
          onSelected: onDateSelected,
          itemBuilder: (context) {
            return List.generate(dates.length, (index) {
              return PopupMenuItem<String>(
                value: rawDates[index],
                child: Text(
                  dates[index],
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: index == selectedDateIndex
                        ? Color(0xFFEAB308)
                        : Colors.white,
                    fontWeight: index == selectedDateIndex
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              );
            });
          },
          child: GlassChip(
            child: Row(
              children: [
                Text(
                  dates.isNotEmpty ? dates[selectedDateIndex] : "Select",
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Seats Chip
        GlassChip(
          child: Row(
            children: [
              const Icon(
                Icons.event_seat_outlined,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "$numberOfSeats Seats",
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
