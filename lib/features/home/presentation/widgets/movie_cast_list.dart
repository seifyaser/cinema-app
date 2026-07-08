import 'package:flutter/material.dart';

import 'package:project/features/home/domain/entities/movie_entity.dart';

class MovieCastList extends StatelessWidget {
  const MovieCastList({super.key, required this.movie});
  final MovieEntity movie;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 205,
      child: RepaintBoundary(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: movie.actors.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (_, index) {
            final actor = movie.actors[index];

            return SizedBox(
              width: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      child: Image.network(
                        actor.imageUrl,
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
                        FittedBox(
                          child: Text(
                            actor.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
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
