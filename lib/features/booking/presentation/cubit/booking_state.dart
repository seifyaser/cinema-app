import 'package:equatable/equatable.dart';
import 'package:project/core/error/failure_type.dart';
import '../../domain/entities/showtime_entity.dart';
import '../../domain/entities/hall_entity.dart';
import 'seat_status.dart';

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
  
  final List<HallEntity> availableHalls;
  final HallEntity? selectedHall;
  final bool isLoadingHalls;

  final List<List<SeatStatus>> seats;
  final int selectedSeatsCount;
  final bool isLoadingSeats;

  const BookingLoaded({
    required this.availableDates,
    required this.selectedDate,
    required this.showtimes,
    required this.selectedShowtime,
    this.isLoadingShowtimes = false,
    required this.availableHalls,
    required this.selectedHall,
    this.isLoadingHalls = false,
    required this.seats,
    required this.selectedSeatsCount,
    this.isLoadingSeats = false,
  });

  BookingLoaded copyWith({
    List<String>? availableDates,
    String? selectedDate,
    List<ShowtimeEntity>? showtimes,
    ShowtimeEntity? selectedShowtime,
    bool? isLoadingShowtimes,
    List<HallEntity>? availableHalls,
    HallEntity? selectedHall,
    bool? isLoadingHalls,
    List<List<SeatStatus>>? seats,
    int? selectedSeatsCount,
    bool? isLoadingSeats,
  }) {
    return BookingLoaded(
      availableDates: availableDates ?? this.availableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      showtimes: showtimes ?? this.showtimes,
      selectedShowtime: selectedShowtime ?? this.selectedShowtime,
      isLoadingShowtimes: isLoadingShowtimes ?? this.isLoadingShowtimes,
      availableHalls: availableHalls ?? this.availableHalls,
      selectedHall: selectedHall ?? this.selectedHall,
      isLoadingHalls: isLoadingHalls ?? this.isLoadingHalls,
      seats: seats ?? this.seats,
      selectedSeatsCount: selectedSeatsCount ?? this.selectedSeatsCount,
      isLoadingSeats: isLoadingSeats ?? this.isLoadingSeats,
    );
  }

  @override
  List<Object?> get props => [
        availableDates,
        selectedDate,
        showtimes,
        selectedShowtime,
        isLoadingShowtimes,
        availableHalls,
        selectedHall,
        isLoadingHalls,
        seats,
        selectedSeatsCount,
        isLoadingSeats,
      ];
}

class BookingError extends BookingState {
  final FailureType type;
  final String message;

  const BookingError({required this.type, required this.message});

  @override
  List<Object?> get props => [type, message];
}
