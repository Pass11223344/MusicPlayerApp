
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';


class Utils {
 static final options = BaseOptions(

      headers: {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 SLBrowser/9.0.3.5211 SLBChan/103'},
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
 static Dio dio = Dio(options);
 // static  Dio dio = Dio();

  static  formatNumber(int number,String tag) {
    if (number==0) {
      return tag;
    }
    if (number < 10000) {
      return number.toString();
    } else if (number < 100000000) {
      double result = (number/1000) as double;
      var result1 =( (number/10000) as double).floor();

      var d = (result%10).floor();

      if(d!=0){
        return"${result1}.$d万";
      }else{
        return "$result1万";
      }

    }else{
      double result = (number/10000000) as double;
      var result1 =( (number/100000000) as double).floor();

      var d = (result%10).floor();

      if(d!=0){
        return"${result1}.$d亿";
      }else{
        return "$result1亿";
      }
    }
  }

static int customStringLength(String input) {
   int length = 0;
   for (int i = 0; i < input.length; i++) {
     int codeUnit = input.codeUnitAt(i);
     // 检查是否为中文字符范围
     if ((codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) || // 基本汉字
         (codeUnit >= 0x3400 && codeUnit <= 0x4DBF) || // 扩展A
         (codeUnit >= 0x20000 && codeUnit <= 0x2A6DF) || // 扩展B
         (codeUnit >= 0x2A700 && codeUnit <= 0x2B73F) || // 扩展C
         (codeUnit >= 0x2B740 && codeUnit <= 0x2B81F) || // 扩展D
         (codeUnit >= 0x2B820 && codeUnit <= 0x2CEAF) || // 扩展E
         (codeUnit >= 0xF900 && codeUnit <= 0xFAFF) || // 兼容汉字
         (codeUnit >= 0x2F800 && codeUnit <= 0x2FA1F)) { // 兼容扩展
       length += 2; // 中文字符长度为2
     } else {
       length += 1; // 英文字符长度为1
     }
   }
   return length;
 }
  static Widget  loadingView(Alignment a){
    return Container(
      padding: EdgeInsets.only(top: 10),
      color: Colors.white,
      alignment: a,child: CircularProgressIndicator(strokeWidth: 1,color: Colors.red,),);
  }
static String formatDate(int timestamp ){
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);

  // 定义日期格式
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');

  // 格式化日期
  String formattedDate = dateFormat.format(date);
  return formattedDate;
}
  static String getSubTitle(dynamic info){
    String str = "";
    if (info.length==1) {
      return info[0].name;
    }
    for (int i = 0; i < info.length; i++) {
      if(i==info.length-1){
        str = str+info[i].name;
      }else{
        str = "$str${info[i].name}/";
      }
    }
    return str;
  }
  static Future<void> copyTextToClipboard(String str,BuildContext context) async {
    // 获取剪贴板服务
    await Clipboard.setData(ClipboardData(text: str));
    print('Text copied to clipboard: $str');
    // 提示用户文本已复制
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text copied to clipboard')),
    );
  }
  static void showTopSnackBar(BuildContext context,String text) {
    // 创建一个OverlayEntry
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0, // 从顶部50像素的位置开始显示
        left: 50.0,
        right: 50.0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              maxLines: 1,
             textAlign: TextAlign.center,
             text,
              style: TextStyle(color: Colors.black),
              textWidthBasis: TextWidthBasis.parent,
            ),
          ),
        ),
      ),
    );

    // 插入OverlayEntry到Overlay中显示
    Overlay.of(context).insert(overlayEntry);

    // 等待1秒后移除OverlayEntry
    Future.delayed(Duration(seconds: 1), () {
      overlayEntry.remove();
    });
  }
 static Future<bool> requestPermission( Map<String,dynamic> arguments) async {
   // var status = await [ Permission.photos.status, Permission.videos.status, Permission.audio.status];
   int sdk =  await  _getAndroidVersionCode() as int;
   PermissionStatus status ;
   if (sdk>=33) {
     if(await Permission.photos.status.isGranted&&
         await  Permission.videos.status.isGranted&& await Permission.audio.status.isGranted){
       print("object---已获取");
       return true;
     }else{
       await channel.invokeMethod("requestPermission",arguments);
       return false;
     }
   }else{
     status = await Permission.storage.status;
     if(!status.isGranted){
       await channel.invokeMethod("requestPermission",arguments);
       return false;
     }
     return true;

   }


  }
 static Future<int> _getAndroidVersionCode() async {
   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
   // print("object--------------${androidInfo.version.previewSdkInt}-----${androidInfo.version.sdkInt}");
    return androidInfo.version.sdkInt;
  }
  static String formatTime(int milliseconds){
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    seconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
  static Future<bool> downloadImage(String url,String path) async {
    final imgPath = '$path/yinYunApp/imgs';

    print("object-----------------------${path}--------------${ImageSource.gallery.toString()}");

    if (!Directory(imgPath).existsSync()) {
      Directory(imgPath).createSync(recursive: true);
    }
    var fileName  = url.split('/').last;
    print('Image downloaded and saved to$imgPath/$fileName');
    //if(await requestPermission({"saveImg":url})){

      File file = File('$imgPath/$fileName');
      if(file.existsSync()) {
        return true;
      }
      try {
        var  response = await dio.download(url, "$imgPath/$fileName",
            onReceiveProgress: (count, total) {
              print("已经下载: $count/$total");
            });
        print('Image downloaded and saved to$imgPath/$fileName');
        channel.invokeMethod("upDataImage","$imgPath/$fileName");
        return true;
      } catch (e) {
        // final headers = response.headers;
        // print("响应头部:aaaaaa ${headers.map((key, value) => "$key: $value")}");
        print(e);
        return false;
      }
   // }
  //  return false;

      // 创建存储图片的目录

  }
  static Future<String> chooseImage() async {

      var image =   await picker.pickImage(source: ImageSource.gallery);
      if (image?.path==null) {
        return "未选择";
      }else{
        return image!.path;
      }


  }




  static void handleDioError(DioException exception ) {
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





class CustomPageRoute<T> extends MaterialPageRoute<T> {
  CustomPageRoute({required WidgetBuilder builder, required RouteSettings settings})
      : super(builder: builder, settings: settings);
  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 200);
    @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
      return FadeTransition(
  opacity: Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ),
  ),
  child: SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, 0.8), // 80% of the screen height
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.decelerate,
      ),
    ),
    child: child,
  ),
);
  }
}




