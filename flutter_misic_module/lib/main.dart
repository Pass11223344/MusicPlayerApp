import 'dart:async';


import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_misic_module/NetWork/DioRequest.dart';
import 'package:flutter_misic_module/page/WebPage.dart';
import 'package:flutter_misic_module/page/chatPage.dart';
import 'package:flutter_misic_module/page/commentPage.dart';
import 'package:flutter_misic_module/page/fpaged.dart';
import 'package:flutter_misic_module/page/msgListPage.dart';
import 'package:flutter_misic_module/page/myPage.dart';
import 'package:flutter_misic_module/page/myPageController.dart';
import 'package:flutter_misic_module/page/searchPage.dart';
import 'package:flutter_misic_module/page/songListPage.dart';
import 'package:flutter_misic_module/route/route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';

import 'page/eg.dart';

@pragma('vm:entry-point')
void msgMain() {
  _initializeGlobalController();
  runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_msgPage")), (error,stack){
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}


@pragma("vm:entry-point")
 MyPage() {
  _initializeGlobalController();
  runZonedGuarded(()=>runApp( MyApp(pageTitle: "to_myPage")), (error,stack){
    print("Error caught：$error");
    print("Stack trace：$stack");});
}

@pragma("vm:entry-point")
void CommentPage() {
 _initializeGlobalController();
  runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_commentPage")), (error,stack){
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}
@pragma("vm:entry-point")
void OtherPage() {
 _initializeGlobalController();
  runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_other_page")), (error,stack){
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}
@pragma("vm:entry-point")
void SearchPage() {
  _initializeGlobalController();
  runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_search")), (error,stack){
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}
 final MethodChannel channel = MethodChannel("from_flutter");
final DioRequest dioRequest = DioRequest();
//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void _initializeGlobalController() {
  if (!Get.isRegistered<PageControllers>()) {
    Get.lazyPut(() => PageControllers());
  }
}


void main() {
  _initializeGlobalController();
  runZonedGuarded(() {

    runApp(const MyApp(pageTitle: "",));} , (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

class MyApp extends StatefulWidget {

  const MyApp({super.key, required this.pageTitle});
  final String pageTitle;
  static CancelToken cancelToken =CancelToken();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
var datas ;
final PageControllers pageController = Get.find();
@override
  void didUpdateWidget(covariant MyApp oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    receiveDataFromAndroid();
    //与 Flutter 应用的生命周期状态交互的通道。
    //
    // setMessageHandler 方法用于注册一个回调函数，这个回调函数会在 Flutter 应用的生命周期状态发生变化时被调用
    // SystemChannels.lifecycle.setMessageHandler((msg) async {
    //   if (msg == AppLifecycleState.resumed.toString()) {
    //
    //   } else if (msg == AppLifecycleState.inactive.toString()) {
    //
    //   } else if (msg == AppLifecycleState.paused.toString()) {
    //
    //   } else if (msg == AppLifecycleState.detached.toString()) {
    //
    //   }
    //   return '';
    // });
  }


  @override
  Widget build(BuildContext context) {


    return  GetMaterialApp(

          localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: onGenerateRoute,
            theme: ThemeData(primarySwatch: Colors.deepOrange),
            home:    getPage()

        );

  }

getPage() {


  switch(widget.pageTitle){
    case "to_msgPage":
      return const msgListPage();
    case "to_myPage":
      return myPage();
    case "to_commentPage":
      return commentPage();
    case "to_other_page":
  // pageController.cookie = datas['token'];
      switch(datas['type']){
        case "to_recommend_song_sheet":
        case "to_exclusive_scene_song_sheet":
        case "to_music_radar_song_sheet":
        case "to_sing_and_albums":
        case"to_recommend_song":
        case "to_sheet":
         return  songListPage(data: datas);
        case "to_albums":
          return WebPage(url: datas['id']);
      }
    case "to_search":
      return  searchPage();
    default:

      return  myPage();
  }
}

  void receiveDataFromAndroid() {
channel.setMethodCallHandler((call) async {

      switch(call.method){
        case "pressPage":

          if( pageController.pageIsOk){

            channel.invokeMethod("loadComplete",true);

          }else{
            channel.invokeMethod("loadComplete",false);
            songListPageState.cancelRequest();
          }
          pageController.pageIsOk = false;
          break;
        case "to_other_page":

          final data = call.arguments;
          if (data != null) {
            setState(() {
              datas = data;
            });
            pageController.cookie = datas['token'];
            print("object1111111111111111111122222222222222${pageController.cookie}");
          }
          break;


      }});
  }







}




class PageTitleProvider extends InheritedWidget {
  final String pageTitle;

  PageTitleProvider({required this.pageTitle, required Widget child}) : super(child: child);

  static PageTitleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PageTitleProvider>();
  }

  @override
  bool updateShouldNotify(PageTitleProvider oldWidget) {

    return pageTitle != oldWidget.pageTitle;
  }

}