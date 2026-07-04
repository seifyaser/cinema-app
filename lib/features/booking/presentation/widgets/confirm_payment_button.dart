import 'package:flutter/material.dart';

class ConfirmPaymentButton extends StatelessWidget {
  final VoidCallback onTap;

  const ConfirmPaymentButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFEAB308),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEAB308).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          "Confirm Payment",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
