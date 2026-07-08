import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:project/core/router/app_router.dart';
import 'package:project/features/home/domain/entities/movie_entity.dart';
import 'package:project/core/utils/auth_guard.dart';

class BookNowButton extends StatelessWidget {
  final MovieEntity movie;
  const BookNowButton({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 32,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: LiquidGlassLayer(
            settings: LiquidGlassSettings(
              thickness: 20,
              blur: 20,
              glassColor: Colors.white.withValues(alpha: 0.1),
            ),
            child: LiquidGlass(
              shape: LiquidRoundedSuperellipse(borderRadius: 40),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white24),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () {
                      AuthGuard.execute(context, () {
                        context.push(AppRouter.bookingRoute, extra: movie);
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Book Now",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
