import 'package:intl/intl.dart';

class ShowtimeModel {
  final String id;
  final String movie;
  final String hallName;
  final String date;
  final String startTime;
  final String endTime;
  final double ticketPrice;
  final bool isActive;

  ShowtimeModel({
    required this.id,
    required this.movie,
    required this.hallName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.ticketPrice,
    required this.isActive,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) {
    final hall = json['hall'] as Map<String, dynamic>? ?? {};
    String startTime = json['startTime'] as String? ?? '';
    String endTime = json['endTime'] as String? ?? '';

    try {
      startTime = DateFormat('h:mm a').format(DateFormat('HH:mm').parse(startTime));
      endTime = DateFormat('h:mm a').format(DateFormat('HH:mm').parse(endTime));
    } catch (_) {
      // Keep originals on parse failure
    }

    return ShowtimeModel(
      id: json['_id'] as String,
      movie: json['movie'] as String,
      hallName: hall['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: startTime,
      endTime: endTime,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
