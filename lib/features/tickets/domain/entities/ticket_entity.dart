import 'package:equatable/equatable.dart';

class TicketEntity extends Equatable {
  final String id;
  final String movieId;
  final String movieTitle;
  final String moviePoster;
  final String hallName;
  final String date;
  final String startTime;
  final String endTime;
  final int totalSeats;
  final double totalPrice;
  final String status;
  final DateTime? expiresAt;

  const TicketEntity({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.hallName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalSeats,
    required this.totalPrice,
    required this.status,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
        id,
        movieId,
        movieTitle,
        moviePoster,
        hallName,
        date,
        startTime,
        endTime,
        totalSeats,
        totalPrice,
        status,
        expiresAt,
      ];
}
