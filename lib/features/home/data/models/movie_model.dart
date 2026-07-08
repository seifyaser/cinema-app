class ActorModel {
  final String? id;
  final String? name;
  final String? image;

  ActorModel({
    this.id,
    this.name,
    this.image,
  });

  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );
  }
}

class MovieModel {
  final String? id;
  final String? title;
  final String? description;
  final String? poster;
  final List<dynamic>? gallery;
  final String? trailerUrl;
  final List<dynamic>? genre;
  final int? duration;
  final String? ageRating;
  final String? releaseDate;
  final List<ActorModel>? actors;
  final String? status;
  final bool? isActive;

  MovieModel({
    this.id,
    this.title,
    this.description,
    this.poster,
    this.gallery,
    this.trailerUrl,
    this.genre,
    this.duration,
    this.ageRating,
    this.releaseDate,
    this.actors,
    this.status,
    this.isActive,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      poster: json['poster'] as String?,
      gallery: json['gallery'] as List<dynamic>?,
      trailerUrl: json['trailerUrl'] as String?,
      genre: json['genre'] as List<dynamic>?,
      duration: json['duration'] as int?,
      ageRating: json['ageRating'] as String?,
      releaseDate: json['releaseDate'] as String?,
      actors: json['actors'] != null
          ? (json['actors'] as List)
              .map((e) => ActorModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      status: json['status'] as String?,
      isActive: json['isActive'] as bool?,
    );
  }
}
