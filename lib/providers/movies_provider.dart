import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _baseUrl = 'api.themoviedb.org';
  String _apiKey = '3ea8eb86ebb56ccb2c13285041c83483';
  String _language = 'en-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  int _popularPage = 0;
  bool isGettinPopular = false;

  MoviesProvider() {
    print('Movies provider incializado');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    Uri url = Uri.https(_baseUrl, endpoint,
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

  void getPopularMovies() async {
    print("obteniendo populars");
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
}
