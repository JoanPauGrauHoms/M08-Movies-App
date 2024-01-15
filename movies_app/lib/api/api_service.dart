import 'dart:convert';
import 'package:movies_app/api/api.dart';
import 'package:movies_app/models/actorMovie.dart';
import 'package:movies_app/models/biography.dart';
import 'package:movies_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/review.dart';

class ApiService {

  // MOVIES DATA
  static Future<List<Movie>?> searchedMovies(String query) async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/search/person?include_adult=false&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (m) => movies.add(
          Movie.fromMap(m),
        ),
      );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Review>?> movieReviews(int movieId) async {
    List<Review> reviews = [];
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].forEach(
        (r) {
          reviews.add(
            Review(
                author: r['author'],
                comment: r['content'],
                rating: r['author_details']['rating']),
          );
        },
      );
      return reviews;
    } catch (e) {
      return null;
    }
  }

  // ACTORS DATA
  static Future<List<Movie>?> trendingActors() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}trending/person/day?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<Movie>?> popularActors() async {
    List<Movie> movies = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));
      var res = jsonDecode(response.body);
      res['results'].take(6).forEach(
            (m) => movies.add(
              Movie.fromMap(m),
            ),
          );
      return movies;
    } catch (e) {
      return null;
    }
  }

  static Future<List<ActorMovie>> actorMovies(String actorName) async {
    List<ActorMovie> cast = [];
    try {
      http.Response response = await http.get(Uri.parse(
          '${Api.baseUrl}person/popular?api_key=${Api.apiKey}&language=en-US&page=1'));

      var castData = jsonDecode(response.body)['results'];

      var actor = castData.firstWhere(
        (personData) => personData['name']
            .toString()
            .toLowerCase()
            .contains(actorName.toLowerCase()),
        orElse: () => null,
      );

      if (actor != null) {
        var knownFor = actor['known_for'] as List<dynamic>;

        for (var movieData in knownFor) {
          if (movieData['media_type'] == 'movie') {
            cast.add(
              ActorMovie(
                id: movieData['id'] as int,
                title: movieData['title'] ?? '',
                posterPath: movieData['poster_path'] ?? '',
                releaseDate: movieData['release_date'] ?? '',
              ),
            );
          }
        }
      }
      return cast;
    } catch (e) {
      return [];
    }
  }

  static Future<ActorBiography?> actorBiography(int actorId) async {
    try {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/person/$actorId?api_key=${Api.apiKey}&language=en-US&page=1'));

      var res = jsonDecode(response.body);

      return ActorBiography(
        id: res['id'],
        biography: res['biography'],
      );
    } catch (e) {
      return null;
    }
  }
}
