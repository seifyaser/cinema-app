import '../../domain/entities/hall_entity.dart';

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
      key: json['key'] ?? '',
      displayName: json['displayName'] ?? '',
      icon: json['icon'] ?? '',
      description: json['description'] ?? '',
    );
  }

  ScreenTypeEntity toEntity() {
    return ScreenTypeEntity(
      key: key,
      displayName: displayName,
      icon: icon,
      description: description,
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
      id: json['id'] ?? json['_id'] ?? '',
      displayName: json['displayName'] ?? '',
      screenType: ScreenTypeModel.fromJson(json['screenType'] ?? {}),
      totalRows: json['totalRows'] ?? 0,
      totalColumns: json['totalColumns'] ?? 0,
      totalSeats: json['totalSeats'] ?? 0,
    );
  }

  HallEntity toEntity() {
    return HallEntity(
      id: id,
      displayName: displayName,
      screenType: screenType.toEntity(),
      totalRows: totalRows,
      totalColumns: totalColumns,
      totalSeats: totalSeats,
    );
  }
}
