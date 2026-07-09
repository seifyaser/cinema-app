class SeatModel {
  final String seatId;
  final String label;
  final String row;
  final int number;
  final String type;
  final String status;

  SeatModel({
    required this.seatId,
    required this.label,
    required this.row,
    required this.number,
    required this.type,
    required this.status,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      seatId: json['seatId'] ?? '',
      label: json['label'] ?? '',
      row: json['row'] ?? '',
      number: json['number'] ?? 0,
      type: json['type'] ?? '',
      status: json['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seatId': seatId,
      'label': label,
      'row': row,
      'number': number,
      'type': type,
      'status': status,
    };
  }
}
