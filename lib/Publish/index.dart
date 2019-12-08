import 'package:blogapp/network/wordpress_article.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as prefix0;
import 'package:blogapp/eventbus/eventBus.dart';


class Publish extends prefix1.StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PublishState();
  }
}

class PublishState extends State<Publish> {
  bool isFront = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新建文章"),
        centerTitle: true,
        actions: <Widget>[
          new IconButton( // action button
            icon: new Icon(isFront ? Icons.view_carousel :  Icons.edit ),
            onPressed: () {
              setState(() {
                this.isFront=!this.isFront;
                eventBus.fire(MyEvent(this.isFront));
                FocusScope.of(context).requestFocus(FocusNode());
              });
            },
          ),
        ],
      ),
      body: articleWidget(),
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
  String html_data = '';
//  是否预览
  bool isFront = true;
  @override
  void initState() {
    eventBus.on<MyEvent>().listen((MyEvent data) =>
        setState(() {
          this.isFront = data.isFront;
          try{
            this.html_data = prefix0.markdownToHtml(this.content);
          }catch(e){
            BotToast.showText(text: '文章为空');
          }
        })
    );
    super.initState();
  }
  void formSave() {
    formkey.currentState.save(); //统一保存 state状态  即调用setstate
    if (formkey.currentState.validate()){
      wordPressArticleApi.publishPost(title,content);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
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
                      return '文章标题不能为空';
                    }
                    return null;
                  },
                ),
                Transform(
                  transform: Matrix4.identity(),
                  child: IndexedStack(
                    index: isFront ? 0: 1,
                    children: <Widget>[
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
                        onChanged: (value){
                          this.content = value;
                        },
                        validator: (value){
                          if (value.isEmpty) {
                            return '文章内容不能为空';
                          }
                          return null;
                        },
                      ),
                      Html(
                        padding: EdgeInsets.fromLTRB(35, 10, 15, 10),
                        data: html_data,
                      )
                    ],
                  ),
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
                ),
              ],
            ),
          )
      ),
    );
  }
}