import 'package:flutter/material.dart';
import 'package:project/core/error/failure_type.dart';

class FailureWidget extends StatelessWidget {
  final FailureType type;
  final String message;
  final VoidCallback onRetry;
  final String? buttonText;
  final IconData? buttonIcon;

  const FailureWidget({
    super.key,
    required this.type,
    required this.message,
    required this.onRetry,
    this.buttonText,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.error_outline;
    if (type == FailureType.noInternet) {
      icon = Icons.wifi_off;
    } else if (type == FailureType.timeout ||
        type == FailureType.serverDown ||
        type == FailureType.serverError) {
      icon = Icons.cloud_off;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(buttonIcon ?? Icons.refresh),
              label: Text(buttonText ?? 'Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE51937),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
