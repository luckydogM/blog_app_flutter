import 'package:blogapp/Publish/index.dart';
import 'package:blogapp/admin/index.dart';
import 'package:blogapp/home/index.dart';
import 'package:blogapp/notification/index.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BotToastInit(
      child: MaterialApp(
        navigatorObservers: [BotToastNavigatorObserver()],
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent
        ),
        home: bottomBarWidget(),
      ),
    );
  }
}


class bottomBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return bottomBarState();
  }
}

class bottomBarState extends State<bottomBarWidget> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          Home(),
          Publish(),
          MyNotifications(),
          Admin()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 26,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('发布')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('通知')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('个人中心')
          )
        ],
        onTap: (int index){
          setState(() {
            _currentIndex = index;
          });
        },
      )
    );
  }
}
