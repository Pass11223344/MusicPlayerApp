
import 'dart:convert';

import 'package:dio/dio.dart';

class DioRequest {
  static DioRequest? _instance;
  factory DioRequest() => _instance  = DioRequest._init();
    late Dio _dio;
   DioRequest._init() {
     final options = BaseOptions(
         baseUrl: "https://www.consistent.top",
         responseType: ResponseType.json,
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
 Future<dynamic> executeGet({required String url,Map<String,dynamic>? params  }) async {

      final response  =  await  _dio.get(url,queryParameters: params);

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
            print("Mapssss类型${data}");
            return data;
          }else if(json["playlist"]!=null){

              var data = response.data["playlist"];
              return data;
        }else if(json["songs"]!=null){
            var data = response.data["songs"];
            return data;
          }

      } else {
        return 'error';
      }

  }

}}