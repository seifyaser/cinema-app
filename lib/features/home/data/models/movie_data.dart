class MovieData {
  const MovieData(
    this.title,
    this.director,
    this.year,
    this.gradientColors, {
    required this.duration,
    required this.type,
    required this.imageurl,
  });

  final String title;
  final String director;
  final String duration;
  final String type;
  final String imageurl;
  final int year;
  final List<int> gradientColors;

  static const List<MovieData> mockMovies = [
    MovieData(
      'The Dark Knight',
      'Christopher Nolan',
      2008,
      [0xFF141E30, 0xFF243B55],
      duration: '2h 32m',
      type: 'Action Thriller',
      imageurl:
          'https://cdn.moviefone.com/image-assets/1255833/wse4S4EuVHSNk9yzsjhdRLmipXk.jpg?d=360x540&q=20',
    ),
    MovieData(
      'Dune',
      'Denis Villeneuve',
      2021,
      [0xFF3E2723, 0xFF5D4037],
      duration: '2h 35m',
      type: 'Sci-Fi Adventure',
      imageurl:
          'https://assets.voxcinemas.com/posters/P_HO00013128_1778076059712.jpg',
    ),
    MovieData(
      'Blade Runner 2049',
      'Denis Villeneuve',
      2017,
      [0xFF1B1B2F, 0xFF1A1A40],
      duration: '2h 44m',
      type: 'Neo-Noir Sci-Fi',
      imageurl:
          'https://cdn.moviefone.com/image-assets/1275779/AnJ8IQJI23hNpYXVNaythu061Ru.jpg?d=360x540&q=30',
    ),
    MovieData(
      'Inception',
      'Christopher Nolan',
      2010,
      [0xFF2C3E50, 0xFF000000],
      duration: '2h 28m',
      type: 'Sci-Fi Thriller',
      imageurl:
          'https://cdn.moviefone.com/image-assets/561730/qJ2tW6WMUDux911r6m7haRef0WH.jpg?d=360x540&q=30',
    ),
    MovieData(
      'Interstellar',
      'Christopher Nolan',
      2014,
      [0xFF0F2027, 0xFF203A43],
      duration: '2h 49m',
      type: 'Sci-Fi Drama',
      imageurl:
          'https://cdn.moviefone.com/image-assets/586073/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg?d=360x540&q=30',
    ),
    MovieData(
      'Oppenheimer',
      'Christopher Nolan',
      2023,
      [0xFF4B1210, 0xFF000000],
      duration: '3h 00m',
      type: 'Biographical Thriller',
      imageurl:
          'https://cdn.moviefone.com/image-assets/8741362/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg?d=360x540&q=30',
    ),
  ];
}
