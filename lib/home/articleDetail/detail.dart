import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:flutter_html/flutter_html.dart';

class DetailArticleApps extends StatelessWidget {
  wp.Post post;

  DetailArticleApps(this.post):super();

  _getPostImage() {
    if (post.featuredMedia == null) {
      return SizedBox(height: 10,);
    } else {
      return Image.network(post.featuredMedia.sourceUrl);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title.rendered.toString()),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Text(post.title.rendered.toString(),style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            )),
            SizedBox(height:10,),
            _getPostImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(post.date.replaceAll('T', ' ')),
                Text(post.author.name.toString())
              ],
            ),
            Html(
              data: post.content.rendered.toString().toString(),
              defaultTextStyle: TextStyle(
                fontSize: 16
              ),
            )
          ],
        ),
      ),
    );
  }
}