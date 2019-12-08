import 'package:blogapp/main.dart';
import 'package:blogapp/network/wordpress_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

main(){
  runApp(Publish());
}

class Publish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新建文章"),
        centerTitle: true
      ),
      body: articleWidget()
    );
  }
}

class articleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return articleState();
  }
}

class articleState extends State<articleWidget> {
  final formkey = GlobalKey<FormState>();
  String title;
  String content;

  void formSave() {
    formkey.currentState.save(); //统一保存 state状态  即调用setstate
    formkey.currentState.validate();
    print('uname:$title,pwd:$content');
    wordPressArticleApi.publishPost(title,content);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 15, 30, 0),
        child: Form(
          key: formkey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    hintText: '请输入文章标题',
                    icon: Icon(Icons.text_format)
                ),
                onSaved: (value){
                  this.title = value.trim();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return '用户名不能为空';
                  }
                  return null;
                },
              ),
              TextFormField(
                maxLines: 18,
                minLines: 14,
                decoration: InputDecoration(
                    hintText: '请输入文章内容',
                    icon: Icon(Icons.text_fields)
                ),
                onSaved: (value){
                  this.content = value;

                },
                validator: (value){
                  if (value.isEmpty) {
                    return '文章内容不能为空';
                  }
                  return null;
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(40, 40, 0, 10),
                height: 100,
                width: double.infinity,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  child: Text('发布文章',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      )),
                  color: Colors.purple,
                  onPressed: formSave,
                ),
              )
            ],
          ),
        )
    );
  }
//wordPressArticleApi.publishPost('标题','内容');
}