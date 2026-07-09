import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/booking/data/repositories/booking_repository_impl.dart';
import '../../domain/entities/showtime_entity.dart';
import '../../domain/entities/hall_entity.dart';
import 'booking_state.dart';
import 'seat_status.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;
  final String movieId;

  BookingCubit({
    required BookingRepository bookingRepository,
    required this.movieId,
  })  : _bookingRepository = bookingRepository,
        super(BookingInitial());
        
  static const int maxSelectedSeats = 10;

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
          availableHalls: const [],
          selectedHall: null,
          isLoadingHalls: dates.isNotEmpty,
          seats: const [],
          selectedSeatsCount: 0,
        ));
        
        if (dates.isNotEmpty) {
          fetchShowtimes(dates.first);
          fetchAvailableHalls(dates.first);
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
            final selectedShowtime = showtimes.isNotEmpty ? showtimes.first : null;
            emit(currentState.copyWith(
              isLoadingShowtimes: false,
              showtimes: showtimes,
              selectedShowtime: selectedShowtime,
            ));
            if (selectedShowtime != null) {
              fetchSeatMap(selectedShowtime.id);
            }
          }
      },
    );
  }

  Future<void> fetchAvailableHalls(String date) async {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(
        isLoadingHalls: true,
        availableHalls: const [],
        selectedHall: null,
      ));
    }

    final result = await _bookingRepository.getAvailableHalls(movieId, date);

    result.fold(
      (failure) {
        emit(BookingError(type: failure.type, message: failure.message));
      },
      (halls) {
        if (state is BookingLoaded) {
          final currentState = state as BookingLoaded;
          final selectedHall = halls.isNotEmpty ? halls.first : null;
          
          List<List<SeatStatus>> initialSeats = [];
          if (selectedHall != null) {
            initialSeats = List.generate(
              selectedHall.totalRows,
              (_) => List.generate(selectedHall.totalColumns, (_) => SeatStatus.aisle),
            );
          }
          
          emit(currentState.copyWith(
            isLoadingHalls: false,
            availableHalls: halls,
            selectedHall: selectedHall,
            seats: initialSeats,
            selectedSeatsCount: 0,
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
      fetchAvailableHalls(date);
    }
  }

  void selectShowtime(ShowtimeEntity showtime) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedShowtime: showtime));
      fetchSeatMap(showtime.id);
    }
  }

  void selectShowtimeByTime(String timeStr) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final showtime = currentState.showtimes.firstWhere(
        (s) => s.startTime == timeStr,
        orElse: () => currentState.showtimes.first,
      );
      emit(currentState.copyWith(selectedShowtime: showtime));
      fetchSeatMap(showtime.id);
    }
  }

  void selectHall(HallEntity hall) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      
      final initialSeats = List.generate(
        hall.totalRows,
        (_) => List.generate(hall.totalColumns, (_) => SeatStatus.aisle),
      );
      
      final validShowtimes = currentState.showtimes
          .where((s) => s.hallName == hall.displayName)
          .toList();
      
      final newSelectedShowtime = validShowtimes.isNotEmpty ? validShowtimes.first : null;

      emit(currentState.copyWith(
        selectedHall: hall,
        seats: initialSeats,
        selectedSeatsCount: 0,
        selectedShowtime: newSelectedShowtime,
      ));

      if (newSelectedShowtime != null) {
        fetchSeatMap(newSelectedShowtime.id);
      }
    }
  }

  Future<void> fetchSeatMap(String showtimeId) async {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(isLoadingSeats: true));
      
      final result = await _bookingRepository.getSeatMap(showtimeId);
      
      result.fold(
        (failure) {
          emit(BookingError(type: failure.type, message: failure.message));
        },
        (seatModels) {
          if (state is BookingLoaded) {
            final st = state as BookingLoaded;
            final currentHall = st.selectedHall;
            if (currentHall == null) return;
            
            // Re-initialize with aisles
            final newSeats = List.generate(
              currentHall.totalRows,
              (_) => List.generate(currentHall.totalColumns, (_) => SeatStatus.aisle),
            );
            
            for (final seat in seatModels) {
              if (seat.row.isEmpty) continue;
              final rowIdx = seat.row.codeUnitAt(0) - 'A'.codeUnitAt(0);
              final colIdx = seat.number - 1;
              
              if (rowIdx >= 0 && rowIdx < currentHall.totalRows && colIdx >= 0 && colIdx < currentHall.totalColumns) {
                newSeats[rowIdx][colIdx] = seat.status == 'available' 
                    ? SeatStatus.available 
                    : SeatStatus.occupied;
              }
            }
            
            emit(st.copyWith(
              seats: newSeats,
              isLoadingSeats: false,
              selectedSeatsCount: 0,
            ));
          }
        },
      );
    }
  }

  void toggleSeat(int row, int col) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      
      if (row < 0 || row >= currentState.seats.length ||
          col < 0 || col >= currentState.seats[row].length) {
        return;
      }
      
      final currentSeatStatus = currentState.seats[row][col];
      
      if (currentSeatStatus == SeatStatus.aisle || currentSeatStatus == SeatStatus.occupied) {
        return;
      }

      final isCurrentlySelected = currentSeatStatus == SeatStatus.selected;

      if (!isCurrentlySelected && currentState.selectedSeatsCount >= maxSelectedSeats) {
        // Can't select more, emit state with an error or just ignore. 
        // For simple UI response, we just ignore the tap if max reached.
        return;
      }

      final newSeats = List<List<SeatStatus>>.from(
        currentState.seats.map((r) => List<SeatStatus>.from(r)),
      );

      if (isCurrentlySelected) {
        newSeats[row][col] = SeatStatus.available;
        emit(currentState.copyWith(
          seats: newSeats,
          selectedSeatsCount: currentState.selectedSeatsCount - 1,
        ));
      } else {
        newSeats[row][col] = SeatStatus.selected;
        emit(currentState.copyWith(
          seats: newSeats,
          selectedSeatsCount: currentState.selectedSeatsCount + 1,
        ));
      }
    }
  }
}
