import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;

class wordPressArticleApi {
//  wp.WordPress wordPress;
  static var wordPress = wp.WordPress(
    baseUrl: 'http://www.luckyxiu.work',
    authenticator: wp.WordPressAuthenticator.ApplicationPasswords,
    adminName: 'luoxi',
    adminKey: 'zprO VJdQ G678 oWHq Ud8I 5ZIq',
  );


  static Future<wp.User> response = wordPress.authenticateUser(
    username: 'luoxi',
    password: '',
  );

  static Future publishPost(title,content){
    response.then((user) {
      createPost(user,title,content);
    }).catchError((err) {
      BotToast.showText(text: err);
      print('Failed to fetch user: $err');
    });
    return response;
  }
  //  7. Create Post #
  static void createPost(wp.User user,String title,String content) {
    final post = wordPress.createPost(
      post: new wp.Post(
        title: title,
        content: content,
        excerpt: content,
        authorID: user.id,
        commentStatus: wp.PostCommentStatus.open,
        pingStatus: wp.PostPingStatus.closed,
        status: wp.PostPageStatus.publish,
        format: wp.PostFormat.standard,
        sticky: true,
      ),
    );

    post.then((p) {
      print('Post created successfully with ID: ${p.id}');
//      postComment(user, p);
    }).catchError((err) {
      print('Failed to create post: $err');
    });
  }
//  8. Post Comment #
  static void postComment(wp.User user, wp.Post post) {
    final comment = wordPress.createComment(
      comment: new wp.Comment(
        author: user.id,
        post: post.id,
        content: "First!",
        parent: 0,
      ),
    );

    comment.then((c) {
      print('Comment successfully posted with ID: ${c.id}');
    }).catchError((err) {
      print('Failed to comment: $err');
    });
  }

//  4. Fetch Posts #
  static Future<List<wp.Post>> myfetchPosts(int num,int pagesize){
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
      postParams: wp.ParamsPostList(
        context: wp.WordPressContext.view,
        pageNum: num,
        perPage: pagesize,
        order: wp.Order.desc,
        orderBy: wp.PostOrderBy.date,
      ),
      fetchAuthor: true,
      fetchFeaturedMedia: true,
      fetchComments: true,
    );
    return posts;
  }

//  5. Fetch Users #
  static Future<List<wp.User>> getUsers(){
    Future<List<wp.User>> users = wordPress.fetchUsers(
      params: wp.ParamsUserList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 30,
        order: wp.Order.asc,
        orderBy: wp.UserOrderBy.name,
        role: wp.UserRole.subscriber,
      ),
    );
    return users;
  }
//  6. Fetch Comments #

  static Future<List<wp.Comment>> getComments(){
    Future<List<wp.Comment>> comments = wordPress.fetchComments(
      params: wp.ParamsCommentList(
        context: wp.WordPressContext.view,
        pageNum: 1,
        perPage: 30,
        includePostIDs: [1],
      ),
    );
    return comments;
  }

}
