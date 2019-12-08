
import 'package:blogapp/model/article.dart';
import 'package:blogapp/network/http_request.dart';

class ArticleRequest {
  static Future<List<Article>> getArticles(int start, int count) async{
    final results = await HttpRequest.request('http://www.luckyxiu.work/wp-json/wp/v2/posts');
    List<Article> articles = [];
    for (var sub in results) {
      articles.add(Article.withMap(sub));
    }
    return articles;
  }
}
