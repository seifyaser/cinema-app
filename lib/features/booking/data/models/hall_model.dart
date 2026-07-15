class ScreenTypeModel {
  final String key;
  final String displayName;
  final String icon;
  final String description;

  const ScreenTypeModel({
    required this.key,
    required this.displayName,
    required this.icon,
    required this.description,
  });

  factory ScreenTypeModel.fromJson(Map<String, dynamic> json) {
    return ScreenTypeModel(
      key: json['key'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

class HallModel {
  final String id;
  final String displayName;
  final ScreenTypeModel screenType;
  final int totalRows;
  final int totalColumns;
  final int totalSeats;

  const HallModel({
    required this.id,
    required this.displayName,
    required this.screenType,
    required this.totalRows,
    required this.totalColumns,
    required this.totalSeats,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      screenType: ScreenTypeModel.fromJson(
        json['screenType'] as Map<String, dynamic>? ?? {},
      ),
      totalRows: json['totalRows'] as int? ?? 0,
      totalColumns: json['totalColumns'] as int? ?? 0,
      totalSeats: json['totalSeats'] as int? ?? 0,
    );
  }
}
