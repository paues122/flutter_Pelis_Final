import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tap2025/models/popular_model.dart';
import 'package:tap2025/models/actor_model.dart';

class ApiPopular {
  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = '5019e68de7bc112f4e4337a500b96c56'; 

  Future<List<PopularModel>> getPopularMovies() async {
    final url = '$baseUrl/movie/popular?api_key=$apiKey&language=es-MX&page=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List results = body['results'];
      return results.map((movie) => PopularModel.fromMap(movie)).toList();
    } else {
      throw Exception("Error al cargar películas populares");
    }
  }

  Future<String?> getTrailerKey(int movieId) async {
    final url = '$baseUrl/movie/$movieId/videos?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List results = body['results'];

      final trailer = results.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );

      return trailer != null ? trailer['key'] : null;
    } else {
      return null;
    }
  }

  Future<List<ActorModel>> getMovieCast(int movieId) async {
    final url = '$baseUrl/movie/$movieId/credits?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List cast = body['cast'];
      return cast.map((actor) => ActorModel.fromMap(actor)).toList();
    } else {
      throw Exception("Error con los actores de la película");
    }
  }
}