class HoldSeatsRequest {
  final String showtimeId;
  final List<String> seatIds;

  HoldSeatsRequest({
    required this.showtimeId,
    required this.seatIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'showtimeId': showtimeId,
      'seatIds': seatIds,
    };
  }
}
