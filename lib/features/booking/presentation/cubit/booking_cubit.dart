import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/booking/data/repositories/booking_repository_impl.dart';
import '../../domain/entities/showtime_entity.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;
  final String movieId;

  BookingCubit({
    required BookingRepository bookingRepository,
    required this.movieId,
  })  : _bookingRepository = bookingRepository,
        super(BookingInitial());

  Future<void> fetchAvailableDates() async {
    emit(BookingLoading());

    final result = await _bookingRepository.getAvailableDates(movieId);

    result.fold(
      (failure) => emit(BookingError(type: failure.type, message: failure.message)),
      (dates) {
        emit(BookingLoaded(
          availableDates: dates,
          selectedDate: dates.isNotEmpty ? dates.first : null,
          showtimes: const [],
          selectedShowtime: null,
          isLoadingShowtimes: dates.isNotEmpty,
        ));
        
        if (dates.isNotEmpty) {
          fetchShowtimes(dates.first);
        }
      },
    );
  }

  Future<void> fetchShowtimes(String date) async {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(
        isLoadingShowtimes: true,
        showtimes: const [],
        selectedShowtime: null,
      ));
    }

    final result = await _bookingRepository.getShowtimes(movieId, date);

    result.fold(
      (failure) {
        emit(BookingError(type: failure.type, message: failure.message));
      },
      (showtimes) {
        if (state is BookingLoaded) {
          final currentState = state as BookingLoaded;
          emit(currentState.copyWith(
            isLoadingShowtimes: false,
            showtimes: showtimes,
            selectedShowtime: showtimes.isNotEmpty ? showtimes.first : null,
          ));
        }
      },
    );
  }

  void selectDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      if (currentState.selectedDate == date) return;
      emit(currentState.copyWith(selectedDate: date));
      fetchShowtimes(date);
    }
  }

  void selectShowtime(ShowtimeEntity showtime) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedShowtime: showtime));
    }
  }
}
