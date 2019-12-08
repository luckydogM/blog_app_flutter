
import 'package:blogapp/model/movie.dart';
import 'package:blogapp/network/http_request.dart';

class MoviesRequest {
  static Future<List<MovieItem>> getMovies(int start, int count) async{

    final result = await HttpRequest.request('https://douban.uieee.com/v2/movie/top250',params: {'start':start,'count':count});
    final subjects = result["subjects"];
    List<MovieItem> movies = [];
    for (var sub in subjects) {
      movies.add(MovieItem.fromMap(sub));
    }
    return movies;
  }
}
