import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/MovieDetails.dart';

class MovieService {
  List<String> ids = List.empty(growable: true);
  Map<String, dynamic> resDate = {};
  Future<Map<String, dynamic>> fetchData({int page = 1}) async {
    final url = Uri.parse(
        'https://moviesdatabase.p.rapidapi.com/titles/x/upcoming?page=$page');
    final headers = {
      'X-RapidAPI-Host': 'moviesdatabase.p.rapidapi.com',
      'X-RapidAPI-Key': '314047f58fmshc0787b6d60ebfd9p1cdf4cjsne8e528fafa88',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        resDate = jsonDecode(response.body);
        return jsonDecode(response.body)!;
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
    return {};
  }

   List<MovieDetails>  fetchMovieDetails() {
    final movieData = GetIt.I<Map<String, dynamic>>(instanceName: 'movieData');
    return  (movieData['results'] as List<dynamic>).map((e) {
      final title = e['titleText']['text'];
      final String? imageLink = e['primaryImage']?['url'];
      final movieType = e['titleType']['text'];
      final releaseYear = e['releaseYear']['year'];
      return MovieDetails(title, imageLink, movieType, releaseYear);
    }).toList();
  }
}
