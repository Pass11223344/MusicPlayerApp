
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../main.dart';
import '../page/myPageController.dart';

class DioRequest {
  static DioRequest? _instance;
  var pageController = Get.find<PageControllers>();
  factory DioRequest() => _instance  = DioRequest._init();
    late Dio _dio;
  CancelToken token = CancelToken();
   DioRequest._init() {

     final options = BaseOptions(
         baseUrl: "https://www.consistent.top",
         responseType: ResponseType.json,
       // headers: {"Cookie": "__remember_me=true;  MUSIC_U=${pageController.cookie}"},
       // headers: {
       //     "Cookie":
       //  "__remember_me=true; __csrf=1ef8cbd67c83a431b52fad48029b52ed; NMTID=00OGtLNGR169BbPiULOi70La71LDX"
       //      "gAAAGQfgoH9A; MUSIC_U=00B31BC82F9D723A96A6CEF36D18B3C5B4EE8C10C969773253469B3441EA4E5597EE7F"
       //      "38EAD49AD192ED6620747C0FFC572AA22B22C5BE0327A7359919105BD70F85F85E9D058B3A4F23A925DF52B5AA55"
       //      "0BFCC1C7638C663198D7BF0E0CCD7BBE59C5B411B6D68A74D85395723A5DCBDA3CA74AF40381B13150FF1B96509D"
       //      "F56074E80050CC7E17AE7B5BA6B61488C1EC7BF9C055A9D215DDD80607C9D7ED8E87C21ABB93FB5EDE17F36F787A1"
       //      "45FBFDDB63F5166545E03387B0C07C53D4DCD652FEC69EE936265BA61FA8D00D1174E73907123BFFFBAC4F7931F007"
       //      "1B61E2342EA47C30960390048F3D25637BAE20F511C16A0E21F42F3763F8542FB4B89DD8699F861370BAF5E0255050"
       //      "E7081A0B0A16C7AC43FDE1469A0CA4371912C1094169F150C9E7BB"
       //      "6F8AA38806332719455F2A644EC6C2A987D9FC9C0964B98F7363DECA88CD730726BE0B310C04B67BFBC2E"},
         connectTimeout: const Duration(seconds: 30),
         sendTimeout: const Duration(seconds: 30),
         receiveTimeout: const Duration(seconds: 30),

         validateStatus: (code) {

           if (code == 200 ) {
             return true;
           } else {
             return false;
           }
         });

     _dio = Dio(options);

     _dio.transformer = BackgroundTransformer(); //Json后台线程处理优化（可选）

  }
  executeGet({required String url,Map<String,dynamic>? params  }) async {
     print("object开始请求---------------------------------");
try {
  final response  =  await  _dio.get(url,queryParameters: params,cancelToken: token);
  print("String类型${response.data }");
  if (response.statusCode == 200) {

    var json;
    // 读取响应体
    if  (response.data is String){
      print("String类型");
      json = jsonDecode(response.data);
    }else if (response.data is Map<String,dynamic>){

      print("Map类型${response.data}");
      json = response.data;
    }
    if (json["code"]==200) {

      if (json["data"]!=null) {
        var data = response.data["data"];
       if( json["size"]!=null&&json["maxSize"]!=null){
          return json;
       }
        return data;
      }else if(json["playlist"]!=null){

        var data = response.data["playlist"];
        return data;
      }
      else if(json["songs"]!=null){

        return json;
      }else if(json['msgs']!=null){

        var data = json['msgs'];

        return data;
      }else if(json['result']!=null){
        var data = json['result'];
        if(data['allMatch']!=null){
          return  data['allMatch'];
        }
        return  data;
      }else{
        return json;
      }

    } else {

      return 'error';
    }

  }else{
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}on DioException catch(e){
  handleDioError(e);
  return "error";
}




}
  cancelToken() {
    token.cancel('响应太慢了，取消了请求');
  }
  void handleDioError(DioException exception ) {
    // 根据错误类型处理
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        print("连接超时");

      case DioExceptionType.sendTimeout:
        print("请求超时");

      case DioExceptionType.receiveTimeout:
        print("响应超时");

      case DioExceptionType.cancel:
        print("请求取消");

      case DioExceptionType.badResponse:
        int? errorCode = exception.response?.statusCode;
        switch (errorCode) {
          case 400:
            print("请求语法错误");

          case 401:
            print("没有权限");

          case 403:
            print("服务器拒绝执行");

          case 404:
            print("请求资源不存在");

          case 405:
            print("请求方法被禁止");

          case 500:
            print("服务器内部错误");

          case 502:
            print("错误网关");

          case 503:
            print("服务器异常");

          case 504:
            print("网关超时");

          case 505:
            print("不支持HTTP协议请求");

          default:
            print("未知错误");
        }
      case DioExceptionType.connectionError:
        if (exception.error is SocketException) {
          print("网络未连接");

        } else {
          print("连接错误");

        }
      case DioExceptionType.badCertificate:
        print("证书错误");

      case DioExceptionType.unknown:
        print("未知错误");
    }


   }
}