import 'package:equatable/equatable.dart';

class TicketEntity extends Equatable {
  final String id;
  final String movieId;
  final String movieTitle;
  final String? movieSubtitle;
  final String moviePoster;
  final String hallName;
  final String date;
  final String startTime;
  final String endTime;
  final int totalSeats;
  final double totalPrice;
  final String status;
  final DateTime? expiresAt;
  final List<String> selectedSeats;

  const TicketEntity({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    this.movieSubtitle,
    required this.moviePoster,
    required this.hallName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalSeats,
    required this.totalPrice,
    required this.status,
    this.expiresAt,
    this.selectedSeats = const [],
  });

  @override
  List<Object?> get props => [
        id,
        movieId,
        movieTitle,
        movieSubtitle,
        moviePoster,
        hallName,
        date,
        startTime,
        endTime,
        totalSeats,
        totalPrice,
        status,
        expiresAt,
        selectedSeats,
      ];
}
