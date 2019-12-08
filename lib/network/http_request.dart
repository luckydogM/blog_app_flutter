import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'http_config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'dart:convert';

//拦截器 mock服务
class MyAdapter extends HttpClientAdapter {

  DefaultHttpClientAdapter _adapter =
  DefaultHttpClientAdapter();

  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<List<int>> requestStream, Future cancelFuture) async {
    Uri uri = options.uri;
    if (uri.path.contains('/mock')) {
      String filePath = options.uri.path;
      filePath = filePath.substring(1);
      //读取对应文件目录下的json文件
      String jsonString = '';
      print(filePath);
      try {
        jsonString = await rootBundle.loadString('$filePath.json');
      } catch(e){
        jsonString = "{code:-1,msg:'接口不存在'}";
      }
      return ResponseBody.fromString(jsonString, 200);
    }
    return _adapter.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }
}

class HttpRequest {
  // 1.创建实例对象
  static BaseOptions baseOptions = BaseOptions(connectTimeout: timeOut);
  static Dio dio = Dio(baseOptions);
  static Future<T> request<T>(String url, {String method = "get",Map<String, dynamic> params,Function handError}) async {
    // 1.单独相关的设置
    Options options = Options();
    options.method = method;
    dio.httpClientAdapter = MyAdapter();

    // 2.发送网络请求
    try {
      Response response = await dio.request<T>(url, queryParameters: params, options: options);
      dynamic result = response.data;
      if (result.runtimeType == String) {
        result = json.decode(result);
      }
      return result;
    } on DioError catch (e) {
      BotToast.showText(text: e.error);
      handError(e, '数据请求错误：'+e.toString());
      throw e;
    }
  }
}

