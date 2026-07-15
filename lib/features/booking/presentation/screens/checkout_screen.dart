import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project/core/network/api_service.dart';
import 'package:project/core/di/dependency_injection.dart';
import 'package:project/core/payment/paymob_service.dart';
import 'package:project/features/booking/presentation/widgets/liquid_glass_alert.dart';
import 'package:project/features/home/presentation/widgets/liquid_glass_back_button.dart';
import 'package:project/features/home/presentation/widgets/movie_details_background.dart';
import 'package:project/features/booking/data/models/checkout_data_model.dart';
import 'package:project/features/booking/data/models/paymob_intention_model.dart';

import '../widgets/booking_summary_card.dart';
import '../widgets/checkout_timer_display.dart';
import '../widgets/confirm_payment_button.dart';

class CheckoutScreen extends StatefulWidget {
  final CheckoutDataModel bookingData;

  const CheckoutScreen({super.key, required this.bookingData});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _remainingSeconds = 300; // Default 5 minutes
  Timer? _timer;
  bool _isProcessingPayment = false;

  final _paymobService = PaymobService();

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

  Future<void> _handlePayment() async {
    if (_isProcessingPayment) return;

    setState(() => _isProcessingPayment = true);

    try {
      // Step 1: Get clientSecret from backend
      final apiService = sl<ApiService>();
      final response = await apiService.post<Map<String, dynamic>>(
        'payments/intention',
        data: {'bookingId': widget.bookingData.bookingId},
      );

      final responseBody = response.data ?? {};
      final dataMap =
          responseBody['data'] as Map<String, dynamic>? ?? responseBody;
      final intention = PaymobIntentionModel.fromJson(dataMap);
      final clientSecret = intention.clientSecret;

      if (clientSecret.isEmpty) {
        throw Exception('Failed to get payment client secret from server.');
      }

      // Step 2: Launch Paymob SDK (showTransactionResult:false ensures
      // the SDK returns the correct status immediately, no native popup)
      final result = await _paymobService.pay(clientSecret: clientSecret);

      debugPrint('[Payment] SDK closed. Status: ${result.status}');

      if (!mounted) return;

      // Show a loading indicator while we wait for the webhook
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 16),
              Text('Verifying payment...'),
            ],
          ),
          backgroundColor: Colors.blueAccent,
          duration: Duration(minutes: 1), // Will be dismissed programmatically
        ),
      );

      // Step 3: Poll the backend for the REAL payment status (updated by the webhook)
      bool isConfirmed = false;
      int attempts = 0;
      const maxAttempts = 3; // 3 * 2 = 6 seconds max wait time

      debugPrint('[Payment] Starting to poll backend for webhook updates...');

      while (attempts < maxAttempts) {
        if (!mounted) return;

        try {
          final statusResponse = await apiService.get<Map<String, dynamic>>(
            'payments/booking/${widget.bookingData.bookingId}',
          );

          final statusBody = statusResponse.data ?? {};
          final statusData =
              statusBody['data'] as Map<String, dynamic>? ?? statusBody;
          final paymentStatus = statusData['status']?.toString() ?? '';

          debugPrint(
            '[Payment Poll attempt ${attempts + 1}] Backend returned status: $paymentStatus',
          );

          if (paymentStatus == 'paid') {
            debugPrint('[Payment] Webhook successfully confirmed payment!');
            isConfirmed = true;
            break;
          } else if (paymentStatus == 'failed') {
            debugPrint('[Payment] Webhook reported payment failure.');
            break; // Stop polling on definitive failure
          }
        } catch (e) {
          debugPrint('[Payment Poll Error]: $e');
        }

        await Future.delayed(const Duration(seconds: 2));
        attempts++;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Hide loading

      if (isConfirmed) {
        debugPrint('[Payment] Success Flow Triggered');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Payment successful & Verified! Enjoy the show!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        context.go('/tickets');
      } else {
        debugPrint('[Payment] Failure/Pending Flow Triggered');
        // If the webhook never arrived or the payment failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.isSuccessful
                  ? '⏳ Payment is processing. Please check your tickets shortly.'
                  : '❌ Payment failed or was cancelled.',
            ),
            backgroundColor: result.isSuccessful
                ? Colors.orange
                : Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('[Payment Exception]: ${e.toString()}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessingPayment = false);
    }
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

          MovieDetailsBackground(posterUrl: widget.bookingData.moviePoster),

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
                      onTap: _isProcessingPayment ? null : _handlePayment,
                      isLoading: _isProcessingPayment,
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
