import 'package:blogapp/util.dart';

class Article {
  String title;
  String desc;
  dynamic author;
  String date;
  String content;

  Article(this.title,this.desc,this.author,this.date);

  Article.withMap(Map<String,dynamic> list){
    this.title = ParseHtmlString(list['title']['rendered']);
    this.desc = ParseHtmlString(list['excerpt']['rendered']);
    this.author = list['author'];
    this.content = list['content']['rendered'];
    this.date = list['modified'];
  }
}

