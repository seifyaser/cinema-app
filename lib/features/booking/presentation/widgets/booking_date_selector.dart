import 'package:flutter/material.dart';
import 'glass_chip.dart';

class BookingDateSelector extends StatelessWidget {
  final String selectedDate;
  final int numberOfSeats;

  const BookingDateSelector({
    super.key,
    required this.selectedDate,
    required this.numberOfSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Date Picker Chip
        GlassChip(
          child: Row(
            children: [
              Text(
                selectedDate,
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
