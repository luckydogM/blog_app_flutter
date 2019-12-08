import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//main(){
//  runApp(Admin());
//}

class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人中心"),
        centerTitle: true
      ),
      body: Text('个人中心页面'),
    );
  }
}