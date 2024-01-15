import 'dart:convert';

class ActorMovie {
  int id;
  String title;
  String posterPath;
  String releaseDate;

  ActorMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  factory ActorMovie.fromMap(Map<String, dynamic> map) {
    return ActorMovie(
      id: map['id'] as int,
      title: map['title'] ?? '',
      posterPath: map['poster_path'] ?? '',
      releaseDate: map['release_date'] ?? '',
    );
  }

  factory ActorMovie.fromJson(String source) =>
      ActorMovie.fromMap(json.decode(source));

  String getFoto() => posterPath == null
      ? 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg'
      : 'https://image.tmdb.org/t/p/w500/$posterPath';
}
