import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project/core/widgets/failure_widget.dart';
import 'package:project/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:project/features/booking/presentation/cubit/booking_state.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/presentation/widgets/animated_movie_background.dart';

import '../widgets/booking_bottom_bar.dart';
import '../widgets/booking_date_seats_hall_selector.dart';
import '../widgets/screen_curve.dart';
import '../widgets/seat_grid.dart';
import '../widgets/time_slot_selector.dart';

class BookingScreen extends StatelessWidget {
  final MovieEntity movie;
  const BookingScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color.fromARGB(255, 0, 0, 0)),

          AnimatedMovieBackground(
            imageUrl: movie.imageurl,
            animationKey: movie.hashCode,
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Title
                Text(
                  movie.title.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),

                // Flexible spacer to leave the top ~30% for the animated background
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black, // Dark full-width container
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                        right: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                        bottom: BorderSide.none,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),

                          // Top Controls (Date, Seats, Hall)
                          BlocSelector<
                            BookingCubit,
                            BookingState,
                            BookingState
                          >(
                            selector: (state) {
                              if (state is BookingLoaded) {
                                return BookingLoaded(
                                  availableDates: state.availableDates,
                                  selectedDate: state.selectedDate,
                                  availableHalls: state.availableHalls,
                                  selectedHall: state.selectedHall,
                                  isLoadingHalls: state.isLoadingHalls,
                                  selectedSeatsCount: state.selectedSeatsCount,
                                  showtimes: const [],
                                  selectedShowtime: null,
                                  isLoadingShowtimes: false,
                                  seats: const [],
                                );
                              }
                              return state;
                            },
                            builder: (context, state) {
                              if (state is BookingLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is BookingError) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: FailureWidget(
                                    type: state.type,
                                    message: state.message,
                                    onRetry: () {
                                      context
                                          .read<BookingCubit>()
                                          .fetchAvailableDates();
                                    },
                                  ),
                                );
                              }

                              if (state is BookingLoaded) {
                                if (state.availableDates.isEmpty) {
                                  return const SizedBox(height: 80);
                                }

                                // Format dates
                                final formattedDates = state.availableDates.map(
                                  (dateStr) {
                                    try {
                                      final parsed = DateFormat(
                                        'yyyy-MM-dd',
                                      ).parse(dateStr);
                                      return DateFormat(
                                        'dd MMM',
                                      ).format(parsed);
                                    } catch (e) {
                                      return dateStr;
                                    }
                                  },
                                ).toList();

                                final selectedIndex = state.selectedDate != null
                                    ? state.availableDates.indexOf(
                                        state.selectedDate!,
                                      )
                                    : 0;

                                return BookingDateHallSelector(
                                  dates: formattedDates,
                                  rawDates: state.availableDates,
                                  selectedDateIndex: selectedIndex,
                                  numberOfSeats: state.selectedSeatsCount,
                                  halls: state.isLoadingHalls
                                      ? []
                                      : state.availableHalls,
                                  selectedHall: state.selectedHall,
                                  onDateSelected: (rawDate) {
                                    context.read<BookingCubit>().selectDate(
                                      rawDate,
                                    );
                                  },
                                  onHallSelected: (hall) {
                                    context.read<BookingCubit>().selectHall(
                                      hall,
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),

                          const SizedBox(height: 24),

                          // Seat Grid section
                          BlocSelector<
                            BookingCubit,
                            BookingState,
                            BookingState
                          >(
                            selector: (state) {
                              if (state is BookingLoaded) {
                                return BookingLoaded(
                                  seats: state.seats,
                                  selectedHall: state.selectedHall,
                                  availableDates: const [],
                                  selectedDate: null,
                                  availableHalls: const [],
                                  isLoadingHalls: false,
                                  selectedSeatsCount: 0,
                                  showtimes: const [],
                                  selectedShowtime: null,
                                  isLoadingShowtimes: false,
                                  isLoadingSeats: state.isLoadingSeats,
                                );
                              }
                              return state;
                            },
                            builder: (context, state) {
                              if (state is BookingLoaded) {
                                return Expanded(
                                  child: Column(
                                    children: [
                                      // Screen Image & Seats
                                      if (state.selectedHall != null)
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Column(
                                                children: [
                                                  ScreenCurve(
                                                    imageUrl: movie.imageurl,
                                                  ),
                                                  const SizedBox(height: 40),
                                                  if (state.isLoadingSeats)
                                                    const SizedBox(
                                                      height: 200,
                                                      child: Center(
                                                        child: CircularProgressIndicator(),
                                                      ),
                                                    )
                                                  else
                                                    SeatGrid(
                                                      seats: state.seats,
                                                      onSeatTap: (row, col) =>
                                                          context
                                                              .read<
                                                                BookingCubit
                                                              >()
                                                              .toggleSeat(
                                                                row,
                                                                col,
                                                              ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                        const Expanded(child: SizedBox()),
                                    ],
                                  ),
                                );
                              }
                              return const Expanded(child: SizedBox());
                            },
                          ),

                          // Time Slot section
                          BlocSelector<
                            BookingCubit,
                            BookingState,
                            BookingState
                          >(
                            selector: (state) {
                              if (state is BookingLoaded) {
                                return BookingLoaded(
                                  showtimes: state.showtimes,
                                  selectedShowtime: state.selectedShowtime,
                                  isLoadingShowtimes: state.isLoadingShowtimes,
                                  availableDates: const [],
                                  selectedDate: null,
                                  availableHalls: const [],
                                  selectedHall: null,
                                  isLoadingHalls: false,
                                  seats: const [],
                                  selectedSeatsCount: 0,
                                );
                              }
                              return state;
                            },
                            builder: (context, state) {
                              if (state is BookingLoaded) {
                                if (state.isLoadingShowtimes) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final times = state.showtimes
                                    .map((s) => s.startTime)
                                    .toList();

                                if (times.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      "No showtimes available",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }

                                return TimeSlotSelector(
                                  times: times,
                                  selectedTime:
                                      state.selectedShowtime?.startTime ??
                                      times.first,
                                  onTimeSelected: (timeStr) {
                                    context
                                        .read<BookingCubit>()
                                        .selectShowtimeByTime(timeStr);
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom bar
                BlocSelector<BookingCubit, BookingState, double>(
                  selector: (state) {
                    if (state is BookingLoaded) {
                      final basePrice = state.selectedShowtime?.ticketPrice ?? 0.0;
                      final count = state.selectedSeatsCount;
                      return count > 0 ? basePrice * count : basePrice;
                    }
                    return 0.0;
                  },
                  builder: (context, price) {
                    return BookingBottomBar(
                      price: price,
                      onBuyPressed: () {
                        context.push(AppRouter.checkoutRoute);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
