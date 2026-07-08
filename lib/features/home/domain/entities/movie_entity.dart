import '../../data/models/movie_model.dart';

class ActorEntity {
  final String id;
  final String name;
  final String imageUrl;

  ActorEntity({required this.id, required this.name, required this.imageUrl});
}

class MovieEntity {
  final String id;
  final String title;
  final String director;
  final String duration;
  final String type;
  final String imageurl;
  final String trailerUrl;
  final int year;
  final List<int> gradientColors;
  final List<ActorEntity> actors;
  final String description;

  MovieEntity({
    required this.id,
    required this.title,
    required this.director,
    required this.duration,
    required this.type,
    required this.imageurl,
    required this.trailerUrl,
    required this.year,
    required this.gradientColors,
    required this.actors,
    required this.description,
  });
}

extension MovieModelMapper on MovieModel {
  MovieEntity toEntity() {
    // Safely parse duration from integer to string like "2h 00m"
    String durationStr = "0h 0m";
    if (duration != null) {
      final hours = duration! ~/ 60;
      final minutes = duration! % 60;
      durationStr = '${hours}h ${minutes}m';
    }

    // Default gradient colors if not present
    final List<int> fallbackGradient = [0xFF141E30, 0xFF243B55];

    // Safely get first genre
    String typeStr = "Unknown";
    if (genre != null && genre!.isNotEmpty) {
      typeStr = genre!.first.toString();
    }

    // Safely parse year
    int parsedYear = DateTime.now().year;
    if (releaseDate != null) {
      try {
        parsedYear = DateTime.parse(releaseDate!).year;
      } catch (_) {}
    }

    // We don't have director from backend, just use the first actor or empty
    String directorStr = "";
    if (actors != null && actors!.isNotEmpty) {
      directorStr = actors!.first.name ?? "";
    }

    return MovieEntity(
      id: id ?? '',
      title: title ?? 'Unknown Title',
      director: directorStr,
      duration: durationStr,
      type: typeStr,
      imageurl: poster ?? '',
      trailerUrl: trailerUrl ?? '',
      year: parsedYear,
      gradientColors: fallbackGradient,
      description: description ?? '',
      actors:
          actors
              ?.map(
                (e) => ActorEntity(
                  id: e.id ?? '',
                  name: e.name ?? 'Unknown',
                  imageUrl:
                      e.image ??
                      'https://thumbs.dreamstime.com/b/photo-not-available-icon-isolated-white-background-simple-vector-logo-432626000.jpg',
                ),
              )
              .toList() ??
          [],
    );
  }
}
