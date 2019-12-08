import 'package:blogapp/home/articleDetail/detail.dart';
import 'package:blogapp/network/wordpress_article.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:flutter_html/flutter_html.dart';

main(){
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("首页"),
          centerTitle: true
      ),
      body: articleList(),
    );
  }
}


class articleList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return articleListState();
  }
}

class articleListState extends State<articleList> {
  ScrollController _scrollController = ScrollController();
  int _Number = 1;
  final pageSize = 10;

  List<wp.Post> posts = [];
  bool isLoading = false;

  Future _loadMore({bool refresh}) async {
    BotToast.showLoading(align:Alignment.center,backgroundColor:Colors.transparent);
    if (!isLoading) {
      if (this.mounted) {
        setState(() {
          //通过setState去更新数据
          isLoading = true;
        });
      }
    }
    wordPressArticleApi.myfetchPosts(_Number,pageSize).then((result){
      if (this.mounted) {
        setState(() {
          if (refresh == true) {
            posts = result;
          } else {
            posts.addAll(result);
          }
          _Number ++;
        });
        BotToast.closeAllLoading();
      }
    }).catchError((err){
      print(err);
      setState(() {
        isLoading = false;
      });
      BotToast.closeAllLoading();
      BotToast.showText(text: '无更多数据');
    });

  }

  @override
  void initState() {
//    BotToast.showLoading(align:Alignment.center,backgroundColor:Colors.transparent);
//    wordPressArticleApi.myfetchPosts(_Number,pageSize).then((res){
//      BotToast.closeAllLoading();
//      setState(() {
//        posts = res;
//        _Number++;
//      });
//    });
    _loadMore();
    _scrollController.addListener((){
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //滚动到最后请求更多
        _loadMore();
      }
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 8.0),
            child: GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context){
                        return new DetailArticleApps(
                            posts[index]
                        );
                      }
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    posts[index].title.rendered.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: 10),
                  Html(
                      data: posts[index].excerpt.rendered.toString(),
                      defaultTextStyle: TextStyle(
                          fontSize: 16
                      ),
                      onLinkTap:(link){
                        print(link);
                      }
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('作者：${posts[index].author.name}',style: TextStyle(
                          color: Colors.black38
                      )),
                      Text('发布时间：${posts[index].date.replaceAll('T', ' ')}',style: TextStyle(
                          color: Colors.black38
                      )),
                    ],
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 10,color: Color.fromRGBO(220, 220, 220, .5)),
                )
            ),
          );
        },
      ),
      onRefresh: () async{
        await setState(() {
          _Number = 1;
        });
        return _loadMore(refresh: true);
      },
    );
  }
}
