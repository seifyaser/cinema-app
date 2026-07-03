import 'package:flutter/material.dart';
import 'package:project/features/home/data/models/cast_model.dart';

class MovieCastList extends StatelessWidget {
  const MovieCastList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      child: RepaintBoundary(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: mockCast.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, index) {
            final actor = mockCast[index];

            return SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      child: Image.network(
                        actor.image,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          actor.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
