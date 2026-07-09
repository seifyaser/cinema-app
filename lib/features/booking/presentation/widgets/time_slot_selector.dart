import 'package:flutter/material.dart';

class TimeSlotSelector extends StatelessWidget {
  final List<String> times;
  final String selectedTime;
  final ValueChanged<String> onTimeSelected;

  const TimeSlotSelector({
    super.key,
    required this.times,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Slot",
            style: TextStyle(
              fontFamily: 'Sora',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: times.map((time) {
                final isSelected = selectedTime == time;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () => onTimeSelected(time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFEAB308)
                              : Colors.white.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        color: isSelected
                            ? const Color(0xFFEAB308).withValues(alpha: 0.1)
                            : Colors.transparent,
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          color: isSelected
                              ? const Color(0xFFEAB308)
                              : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
