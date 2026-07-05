import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/booking/presentation/widgets/liquid_glass_alert.dart';
import 'package:project/features/home/data/models/movie_data.dart';
import 'package:project/features/home/presentation/widgets/liquid_glass_back_button.dart';
import 'package:project/features/home/presentation/widgets/movie_details_background.dart';

import '../widgets/booking_summary_card.dart';
import '../widgets/checkout_timer_display.dart';
import '../widgets/confirm_payment_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const int _checkoutDurationSeconds = 300; // 5 minutes
  int _remainingSeconds = _checkoutDurationSeconds;
  Timer? _timer;

  final Map<String, dynamic> _mockData = {
    "bookingId": "665f1a2b3c4d5e6f70000050",
    "status": "pending",
    "movie": {
      "_id": "665f1a2b3c4d5e6f70000010",
      "title": "The Dark Knight",
      "poster":
          "https://cdn.moviefone.com/image-assets/1255833/wse4S4EuVHSNk9yzsjhdRLmipXk.jpg?d=360x540&q=20",
    },
    "hall": {
      "_id": "665f1a2b3c4d5e6f70000020",
      "name": "Hall 1",
      "screenType": "imax",
    },
    "date": "2026-07-01T00:00:00.000Z",
    "startTime": "14:30",
    "endTime": "16:45",
    "seats": [
      {"label": "A1", "type": "standard"},
      {"label": "A2", "type": "standard"},
    ],
    "ticketPrice": 120,
    "totalSeats": 2,
    "totalPrice": 240,
  };

  @override
  void initState() {
    super.initState();
    _startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLiquidGlassAlert(
        context: context,
        title: "Pending Payment",
        content:
            "These tickets are held for you. You have 5 minutes to complete the payment process or reservation will be canceled",
      );
    });
  }

  void _startTimer() {
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
            movie: MovieData(
              _mockData['movie']['title'],
              'Unknown',
              2026,
              [0xFF000000, 0xFF000000],
              duration: '120m',
              type: 'Unknown',
              imageurl: _mockData['movie']['poster'],
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

                    BookingSummaryCard(bookingData: _mockData),

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
