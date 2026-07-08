import 'package:equatable/equatable.dart';

class ShowtimeEntity extends Equatable {
  final String id;
  final String startTime;
  final String endTime;
  final double ticketPrice;
  final String hallName;
  final String date;

  const ShowtimeEntity({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.ticketPrice,
    required this.hallName,
    required this.date,
  });

  @override
  List<Object?> get props => [id, startTime, endTime, ticketPrice, hallName, date];
}
