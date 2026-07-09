import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/booking/presentation/widgets/liquid_glass_alert.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/features/home/presentation/widgets/liquid_glass_back_button.dart';
import 'package:project/features/home/presentation/widgets/movie_details_background.dart';
import 'package:project/features/booking/data/models/checkout_data_model.dart';

import '../widgets/booking_summary_card.dart';
import '../widgets/checkout_timer_display.dart';
import '../widgets/confirm_payment_button.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutDataModel bookingData;

  const CheckoutScreen({
    super.key,
    required this.bookingData,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _remainingSeconds = 300; // Default 5 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLiquidGlassAlert(
        context: context,
        title: "Pending Payment",
        content:
            "These tickets are held for you. You have ${_remainingSeconds ~/ 60} minutes to complete the payment process or reservation will be canceled",
      );
    });
  }

  void _initializeTimer() {
    final expiresAt = widget.bookingData.expiresAt;
    final now = DateTime.now();
    final diff = expiresAt.difference(now).inSeconds;
    _remainingSeconds = diff > 0 ? diff : 0;

    _startTimer();
  }

  void _startTimer() {
    if (_remainingSeconds <= 0) {
      _onTimeExpired();
      return;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        _onTimeExpired();
      }
    });
  }

  void _onTimeExpired() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout session expired!'),
        backgroundColor: Colors.redAccent,
      ),
    );
    context.pop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = _remainingSeconds < 60;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      extendBodyBehindAppBar: true,

      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color.fromARGB(255, 0, 0, 0)),

          MovieDetailsBackground(
            movie: MovieEntity(
              id: widget.bookingData.movieId,
              title: widget.bookingData.movieTitle,
              director: 'Unknown',
              year: 2026,
              gradientColors: const [0xFF000000, 0xFF000000],
              duration: '120m',
              type: 'Action',
              imageurl: widget.bookingData.moviePoster,
              trailerUrl: '',
              description: '',
              actors: const [],
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Custom App Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LiquidGlassBackButton(
                          icon: Icons.arrow_back_ios_new,
                          text: "Back",
                        ),
                        CheckoutTimerDisplay(
                          formattedTime: _formattedTime,
                          isUrgent: isUrgent,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    BookingSummaryCard(bookingData: widget.bookingData),

                    const SizedBox(height: 40),

                    ConfirmPaymentButton(
                      onTap: () {
                        // Confirm Payment Logic Here
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
