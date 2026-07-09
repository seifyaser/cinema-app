class CheckoutDataModel {
  final String bookingId;
  final DateTime expiresAt;
  final String movieId;
  final String movieTitle;
  final String moviePoster;
  final String hallId;
  final String hallName;
  final String date;
  final String startTime;
  final String endTime;
  final List<CheckoutSeatModel> seats;
  final double ticketPrice;
  final int totalSeats;
  final double totalPrice;

  CheckoutDataModel({
    required this.bookingId,
    required this.expiresAt,
    required this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.hallId,
    required this.hallName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.seats,
    required this.ticketPrice,
    required this.totalSeats,
    required this.totalPrice,
  });

  factory CheckoutDataModel.fromJson(Map<String, dynamic> json) {
    final summary = json['summary'] ?? {};
    final movie = summary['movie'] ?? {};
    final hall = summary['hall'] ?? {};
    final seatsData = summary['seats'] as List<dynamic>? ?? [];

    return CheckoutDataModel(
      bookingId: json['bookingId'] ?? '',
      expiresAt:
          DateTime.tryParse(json['expiresAt'] ?? '')?.toLocal() ??
          DateTime.now(),
      movieId: movie['_id'] ?? '',
      movieTitle: movie['title'] ?? 'Unknown Movie',
      moviePoster: movie['poster'] ?? '',
      hallId: hall['_id'] ?? '',
      hallName: hall['screenType'] ?? 'Unknown Hall',
      date: summary['date'] ?? '',
      startTime: summary['startTime'] ?? '',
      endTime: summary['endTime'] ?? '',
      seats: seatsData
          .map((s) => CheckoutSeatModel.fromJson(s as Map<String, dynamic>))
          .toList(),
      ticketPrice: (summary['ticketPrice'] ?? 0.0).toDouble(),
      totalSeats: summary['totalSeats'] ?? 0,
      totalPrice: (summary['totalPrice'] ?? 0.0).toDouble(),
    );
  }
}

class CheckoutSeatModel {
  final String seatId;
  final String label;
  final String type;

  CheckoutSeatModel({
    required this.seatId,
    required this.label,
    required this.type,
  });

  factory CheckoutSeatModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSeatModel(
      seatId: json['seatId'] ?? '',
      label: json['label'] ?? '',
      type: json['type'] ?? 'standard',
    );
  }
}
