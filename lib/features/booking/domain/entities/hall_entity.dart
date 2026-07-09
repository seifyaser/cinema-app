import 'package:equatable/equatable.dart';

class ScreenTypeEntity extends Equatable {
  final String key;
  final String displayName;
  final String icon;
  final String description;

  const ScreenTypeEntity({
    required this.key,
    required this.displayName,
    required this.icon,
    required this.description,
  });

  @override
  List<Object?> get props => [key, displayName, icon, description];
}

class HallEntity extends Equatable {
  final String id;
  final String displayName;
  final ScreenTypeEntity screenType;
  final int totalRows;
  final int totalColumns;
  final int totalSeats;

  const HallEntity({
    required this.id,
    required this.displayName,
    required this.screenType,
    required this.totalRows,
    required this.totalColumns,
    required this.totalSeats,
  });

  @override
  List<Object?> get props => [
        id,
        displayName,
        screenType,
        totalRows,
        totalColumns,
        totalSeats,
      ];
}
