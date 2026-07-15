import 'package:equatable/equatable.dart';
import 'package:project/core/error/failure_type.dart';
import '../../data/models/showtime_model.dart';
import '../../data/models/hall_model.dart';
import '../../data/models/seat_model.dart';
import '../../data/models/checkout_data_model.dart';
import 'seat_status.dart';

enum ActionStatus { idle, holding, holdSuccess, holdFailure }

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
  final List<ShowtimeModel> showtimes;
  final ShowtimeModel? selectedShowtime;
  final bool isLoadingShowtimes;

  final List<HallModel> availableHalls;
  final HallModel? selectedHall;
  final bool isLoadingHalls;

  final List<List<SeatStatus>> seats;
  final List<SeatModel> seatModels;
  final int selectedSeatsCount;
  final bool isLoadingSeats;

  final ActionStatus actionStatus;
  final String? holdFailureMessage;
  final CheckoutDataModel? holdResponseData;

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
    this.seatModels = const [],
    required this.selectedSeatsCount,
    this.isLoadingSeats = false,
    this.actionStatus = ActionStatus.idle,
    this.holdFailureMessage,
    this.holdResponseData,
  });

  BookingLoaded copyWith({
    List<String>? availableDates,
    String? selectedDate,
    List<ShowtimeModel>? showtimes,
    ShowtimeModel? selectedShowtime,
    bool? isLoadingShowtimes,
    List<HallModel>? availableHalls,
    HallModel? selectedHall,
    bool? isLoadingHalls,
    List<List<SeatStatus>>? seats,
    List<SeatModel>? seatModels,
    int? selectedSeatsCount,
    bool? isLoadingSeats,
    ActionStatus? actionStatus,
    String? holdFailureMessage,
    CheckoutDataModel? holdResponseData,
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
      seatModels: seatModels ?? this.seatModels,
      selectedSeatsCount: selectedSeatsCount ?? this.selectedSeatsCount,
      isLoadingSeats: isLoadingSeats ?? this.isLoadingSeats,
      actionStatus: actionStatus ?? this.actionStatus,
      holdFailureMessage: holdFailureMessage ?? this.holdFailureMessage,
      holdResponseData: holdResponseData ?? this.holdResponseData,
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
    seatModels,
    selectedSeatsCount,
    isLoadingSeats,
    actionStatus,
    holdFailureMessage,
    holdResponseData,
  ];
}

class BookingError extends BookingState {
  final FailureType type;
  final String message;

  const BookingError({required this.type, required this.message});

  @override
  @override
  List<Object?> get props => [type, message];
}
