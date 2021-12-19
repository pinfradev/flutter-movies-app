import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '3ea8eb86ebb56ccb2c13285041c83483';
  String _language = 'en-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;
  bool isGettinPopular = false;

  Map<int, List<Cast>> movieCast = {}; // el int va a ser el id de la pelicula

  MoviesProvider() {
    print('Movies provider incializado');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);

    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) {
      return movieCast[movieId]!;
    }

    final jsonData = await _getJsonData('/3/movie/$movieId/credits');

    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  void getPopularMovies() async {
    _popularPage++;
    isGettinPopular = true;
    notifyListeners();
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularMovies = PopularResponse.fromJson(jsonData);
    isGettinPopular = false;
    //voy a desestructurar con [...]
    this.popularMovies = [...this.popularMovies, ...popularMovies.results];

    notifyListeners();
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final SearchResponse searchResponse =
        SearchResponse.fromJson(response.body);

    final movies = searchResponse.results;

    return movies;
  }
}
