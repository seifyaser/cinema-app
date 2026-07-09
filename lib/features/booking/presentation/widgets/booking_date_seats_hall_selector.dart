import 'package:flutter/material.dart';
import '../../domain/entities/hall_entity.dart';
import 'glass_chip.dart';

class BookingDateHallSelector extends StatelessWidget {
  final List<String> dates;
  final List<String> rawDates;
  final int selectedDateIndex;
  final int numberOfSeats;
  final ValueChanged<String>? onDateSelected;
  final List<HallEntity> halls;
  final HallEntity? selectedHall;
  final ValueChanged<HallEntity>? onHallSelected;

  const BookingDateHallSelector({
    super.key,
    required this.dates,
    required this.rawDates,
    required this.selectedDateIndex,
    required this.numberOfSeats,
    this.onDateSelected,
    this.halls = const [],
    this.selectedHall,
    this.onHallSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FittedBox(
        child: Row(
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
            if (halls.isNotEmpty) ...[
              const SizedBox(width: 16),
              // Hall Picker Chip
              PopupMenuButton<HallEntity>(
                offset: const Offset(0, 40),
                color: const Color(0xFF131313),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                onSelected: onHallSelected,
                itemBuilder: (context) {
                  return halls.map((hall) {
                    final isSelected = selectedHall?.id == hall.id;
                    return PopupMenuItem<HallEntity>(
                      value: hall,
                      child: Row(
                        children: [
                          if (hall.screenType.icon.isNotEmpty) ...[
                            Text(
                              hall.screenType.icon,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            hall.screenType.displayName,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              color: isSelected
                                  ? const Color(0xFFEAB308)
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: GlassChip(
                  child: Row(
                    children: [
                      Text(
                        selectedHall?.screenType.displayName ?? "Hall",
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
