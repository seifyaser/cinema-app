import '../../domain/entities/ticket_entity.dart';

class TicketModel extends TicketEntity {
  const TicketModel({
    required super.id,
    required super.movieId,
    required super.movieTitle,
    required super.moviePoster,
    required super.hallName,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.totalSeats,
    required super.totalPrice,
    required super.status,
    super.expiresAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final showtime = json['showtime'] ?? {};
    final movie = showtime['movie'] ?? {};
    final hall = showtime['hall'] ?? {};

    DateTime? parsedExpiresAt;
    if (json['expiresAt'] != null) {
      parsedExpiresAt = DateTime.tryParse(json['expiresAt'])?.toLocal();
    }

    return TicketModel(
      id: json['_id'] ?? '',
      movieId: movie['_id'] ?? '',
      movieTitle: movie['title'] ?? 'Unknown Movie',
      moviePoster: movie['poster'] ?? '',
      hallName: hall['screenType'] ?? 'Unknown Hall',
      date: showtime['date'] ?? '',
      startTime: showtime['startTime'] ?? '',
      endTime: showtime['endTime'] ?? '',
      totalSeats: json['totalSeats'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'unknown',
      expiresAt: parsedExpiresAt,
    );
  }

  TicketEntity toEntity() {
    return TicketEntity(
      id: id,
      movieId: movieId,
      movieTitle: movieTitle,
      moviePoster: moviePoster,
      hallName: hallName,
      date: date,
      startTime: startTime,
      endTime: endTime,
      totalSeats: totalSeats,
      totalPrice: totalPrice,
      status: status,
      expiresAt: expiresAt,
    );
  }
}
