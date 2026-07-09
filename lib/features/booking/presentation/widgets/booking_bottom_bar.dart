import 'package:flutter/material.dart';

class BookingBottomBar extends StatelessWidget {
  final double price;
  final VoidCallback onBuyPressed;
  final bool isLoading;

  const BookingBottomBar({
    super.key,
    required this.price,
    required this.onBuyPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFEAB308), width: 1.5),
          color: Colors.black,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: GestureDetector(
                onTap: isLoading ? null : onBuyPressed,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB308),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Buy Tickets",
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: Text(
                  "\$${price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
