import 'package:equatable/equatable.dart';
import 'package:project/core/error/failure_type.dart';
import '../../domain/entities/showtime_entity.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<String> availableDates;
  final String? selectedDate;
  final List<ShowtimeEntity> showtimes;
  final ShowtimeEntity? selectedShowtime;
  final bool isLoadingShowtimes;

  const BookingLoaded({
    required this.availableDates,
    required this.selectedDate,
    required this.showtimes,
    required this.selectedShowtime,
    this.isLoadingShowtimes = false,
  });

  BookingLoaded copyWith({
    List<String>? availableDates,
    String? selectedDate,
    List<ShowtimeEntity>? showtimes,
    ShowtimeEntity? selectedShowtime,
    bool? isLoadingShowtimes,
  }) {
    return BookingLoaded(
      availableDates: availableDates ?? this.availableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      showtimes: showtimes ?? this.showtimes,
      selectedShowtime: selectedShowtime ?? this.selectedShowtime,
      isLoadingShowtimes: isLoadingShowtimes ?? this.isLoadingShowtimes,
    );
  }

  @override
  List<Object?> get props => [
        availableDates,
        selectedDate,
        showtimes,
        selectedShowtime,
        isLoadingShowtimes,
      ];
}

class BookingError extends BookingState {
  final FailureType type;
  final String message;

  const BookingError({required this.type, required this.message});

  @override
  List<Object?> get props => [type, message];
}
