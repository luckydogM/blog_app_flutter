import 'package:blogapp/model/movie.dart';
import 'package:blogapp/network/getmovies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

//main(){
//  runApp(MyNotifications());
//}

class MyNotifications extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return MyNotificationsState();
  }
}

class MyNotificationsState extends State<MyNotifications>{
  ScrollController _scrollController = ScrollController();
  int _Number = 0;
  final pageSize = 20;
  List<MovieItem> movieitems = [];
  bool isLoading = false;
  //加载更多
  Future _loadMore() async {
    if (!isLoading) {
      if(this.mounted) {
        setState(() {
          //通过setState去更新数据
          isLoading = true;
        });
      }
    }
    List<MovieItem> moreList = await MoviesRequest.getMovies(_Number, pageSize);
    if (this.mounted) {
      setState(() {
        movieitems.addAll(moreList);
        isLoading = false;
        _Number += pageSize;
      });
    }
  }

  @override
  void initState() {
    _loadMore();
    _scrollController.addListener(() {
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
    return Scaffold(
      appBar: AppBar(
          title: Text("消息通知"),
          centerTitle: true
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: movieitems.length,
          itemBuilder: (BuildContext context,int index){
            return Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
              child: ListTile(
                  leading: Image.network(movieitems[index].imageURL),
                  title: Text(movieitems[index].title)
              ),
            );
          },
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
        onRefresh: () async{
          await setState(() {
            _Number = 0;
          });
          return _loadMore();
        },
      ),
    );
  }
}