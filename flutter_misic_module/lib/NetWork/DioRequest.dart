
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
print("objec11111111111111111111111111t${pageController.cookie}");
     final options = BaseOptions(
         baseUrl: "https://www.consistent.top",
         responseType: ResponseType.json,
        headers: {"Cookie": "__remember_me=true; MUSIC_U=${pageController.cookie}"},
       // headers: {"Cookie":"__remember_me=true; MUSIC_U=0010D987C6EA87E71F2FC4CB632B6F81A3B666EF6409A6B73324870403B8A36F17A3BDD1868B085BD82D1343C58E8871D19EB4D49A02E8046B6FC86F88454D29D10FE204F6AE0483DAEBBE4546077552C7EEEDBEEFB7CD8AEDF96717CE68F1EB6CE87E2CA42B5D37519D3B1CDE2D660EAB4616AE0F3671A290DA863CAD010848C9B6E29D6DE1EA99484072F24D3B9D0DE5069830BF31132CEFD61B788454BC4A5283AD1E537C36D120FF0A306579E6F4DD71A341E4C4BCE578C745E7DD0CC77991C42F3A1ADDEF4390C989F26945983EA4C07DD55EF2976231B0A0F139938CA22E1540FBA4B07D5FB164A1570519E664B6A09E6A6570A9624B448FC7B0B1C2A4F3F131E188FA4AF28F447501B7B450BD3AA5ED480AA30BD295E964E278BCC4A63FF6DBE056BCFD90B0ECFD3C3A05A072ACC0FBC182C714D0894B2DE9A190ADF69E4DBC2C740D62DEC21181DEB25B4CB34C; NMTID=00O-irHkzTj47ox_UC7n4YEQlNj0joAAAGPMjvLxQ"},
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

        return data;
      }else if(json["playlist"]!=null){

        var data = response.data["playlist"];
        return data;
      }
      else if(json["songs"]!=null){

        return json;
      }else if(json['msgs']!=null){

        var data = json['msgs'];
        print("objec5555555555555555555555t$data");
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