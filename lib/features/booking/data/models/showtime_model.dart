import 'package:intl/intl.dart';
import '../../domain/entities/showtime_entity.dart';

class ShowtimeModel {
  final String id;
  final String movie;
  final HallModel hall;
  final String date;
  final String startTime;
  final String endTime;
  final double ticketPrice;
  final bool isActive;

  ShowtimeModel({
    required this.id,
    required this.movie,
    required this.hall,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.ticketPrice,
    required this.isActive,
  });

  factory ShowtimeModel.fromJson(Map<String, dynamic> json) {
    return ShowtimeModel(
      id: json['_id'] as String,
      movie: json['movie'] as String,
      hall: HallModel.fromJson(json['hall'] as Map<String, dynamic>),
      date: json['date'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      ticketPrice: (json['ticketPrice'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}

class HallModel {
  final String id;
  final String name;
  final String screenType;
  final int totalRows;
  final int totalColumns;
  final int totalSeats;

  HallModel({
    required this.id,
    required this.name,
    required this.screenType,
    required this.totalRows,
    required this.totalColumns,
    required this.totalSeats,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      screenType: json['screenType'] as String,
      totalRows: json['totalRows'] as int,
      totalColumns: json['totalColumns'] as int,
      totalSeats: json['totalSeats'] as int,
    );
  }
}

extension ShowtimeModelMapper on ShowtimeModel {
  ShowtimeEntity toEntity() {
    String formattedStartTime = startTime;
    String formattedEndTime = endTime;
    
    try {
      // Parse HH:mm to 12-hour format "h:mm a"
      final parsedStartTime = DateFormat('HH:mm').parse(startTime);
      formattedStartTime = DateFormat('h:mm a').format(parsedStartTime);

      final parsedEndTime = DateFormat('HH:mm').parse(endTime);
      formattedEndTime = DateFormat('h:mm a').format(parsedEndTime);
    } catch (e) {
      // Fallback to original string on parsing error
    }

    return ShowtimeEntity(
      id: id,
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      ticketPrice: ticketPrice,
      hallName: hall.name,
      date: date,
    );
  }
}
