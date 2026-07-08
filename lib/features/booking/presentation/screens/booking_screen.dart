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
import '../widgets/booking_date_selector.dart';
import '../widgets/screen_curve.dart';
import '../widgets/seat_grid.dart';
import '../widgets/time_slot_selector.dart';

class BookingScreen extends StatefulWidget {
  final MovieEntity movie;
  const BookingScreen({super.key, required this.movie});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _numberOfSeats = 0;
  late List<List<int>> _seats;

  @override
  void initState() {
    super.initState();
    // 0 = Available, 1 = Selected, 2 = Occupied, -1 = Aisle
    _seats = [
      [2, 2, 0, 0, 0, 0, 2, 2],
      [2, 2, 0, 0, -1, 0, 0, 2, 2, 2],
      [0, 0, 0, 2, 2, -1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, -1, 2, 2, 2, 0, 0],
      [0, 0, 0, 0, 0, -1, 0, 0, 2, 0, 0],
      [0, 0, 2, 2, 0, -1, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, -1, 0, 2, 2, 2, 0],
    ];
  }

  void _handleSeatTap(int rowIndex, int colIndex) {
    final state = _seats[rowIndex][colIndex];
    if (state == -1 || state == 2) return; // Aisle or occupied

    final bool isSelected = state == 1;

    if (!isSelected && _numberOfSeats >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only select up to 10 seats.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _seats[rowIndex][colIndex] = isSelected ? 0 : 1;
      // Recount inline — no nested setState call
      int count = 0;
      for (final row in _seats) {
        for (final s in row) {
          if (s == 1) count++;
        }
      }
      _numberOfSeats = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color.fromARGB(255, 0, 0, 0)),

          AnimatedMovieBackground(
            imageUrl: widget.movie.imageurl,
            animationKey: widget.movie.hashCode,
          ),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Title
                Text(
                  widget.movie.title.toUpperCase(),
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
                          
                          BlocBuilder<BookingCubit, BookingState>(
                            builder: (context, state) {
                              if (state is BookingLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (state is BookingError) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: FailureWidget(
                                    type: state.type,
                                    message: state.message,
                                    onRetry: () {
                                      context.read<BookingCubit>().fetchAvailableDates();
                                    },
                                  ),
                                );
                              }
                              
                              if (state is BookingLoaded) {
                                if (state.availableDates.isEmpty) {
                                  return const SizedBox(height: 80);
                                }
                                
                                // Format dates
                                final formattedDates = state.availableDates.map((dateStr) {
                                  try {
                                    final parsed = DateFormat('yyyy-MM-dd').parse(dateStr);
                                    return DateFormat('dd MMM').format(parsed);
                                  } catch (e) {
                                    return dateStr;
                                  }
                                }).toList();
                                
                                final selectedIndex = state.selectedDate != null 
                                    ? state.availableDates.indexOf(state.selectedDate!) 
                                    : 0;

                                return BookingDateSelector(
                                  dates: formattedDates,
                                  rawDates: state.availableDates,
                                  selectedDateIndex: selectedIndex,
                                  numberOfSeats: _numberOfSeats,
                                  onDateSelected: (rawDate) {
                                    context.read<BookingCubit>().selectDate(rawDate);
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                          
                          const SizedBox(height: 24),

                          // Screen Image & Seats
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 20,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  children: [
                                    ScreenCurve(imageUrl: widget.movie.imageurl),
                                    const SizedBox(height: 40),
                                    SeatGrid(
                                      seats: _seats,
                                      onSeatTap: _handleSeatTap,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          BlocBuilder<BookingCubit, BookingState>(
                            builder: (context, state) {
                              if (state is BookingLoaded) {
                                if (state.isLoadingShowtimes) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                
                                final times = state.showtimes.map((s) => s.startTime).toList();
                                
                                if (times.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text("No showtimes available", style: TextStyle(color: Colors.white)),
                                  );
                                }

                                return TimeSlotSelector(
                                  times: times,
                                  selectedTime: state.selectedShowtime?.startTime ?? times.first,
                                  onTimeSelected: (timeStr) {
                                    final showtime = state.showtimes.firstWhere((s) => s.startTime == timeStr);
                                    context.read<BookingCubit>().selectShowtime(showtime);
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

                BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    double price = 0.0;
                    if (state is BookingLoaded) {
                      price = state.selectedShowtime?.ticketPrice ?? 0.0;
                    }
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

