import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:wangyiyun_flutter_module/page/commentPage.dart';
import 'package:wangyiyun_flutter_module/page/fpaged.dart';

import 'package:wangyiyun_flutter_module/page/msgListPage.dart';
import 'package:wangyiyun_flutter_module/page/myPage.dart';
import 'package:wangyiyun_flutter_module/page/myPageController.dart';
import 'package:wangyiyun_flutter_module/page/searchPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wangyiyun_flutter_module/page/songListPage.dart';
import 'package:wangyiyun_flutter_module/route/route.dart';
@pragma('vm:entry-point')
void msgMain() =>
    runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_msgPage")), (error,stack){
      print("Error caught：$error");
      print("Stack trace：$stack");
    });
@pragma("vm:entry-point")
 MyPage() => runApp( MyApp(pageTitle: "to_myPage"));

@pragma("vm:entry-point")
void CommentPage() => runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_commentPage")), (error,stack){
  print("Error caught：$error");
  print("Stack trace：$stack");
});
@pragma("vm:entry-point")
void OtherPage() => runZonedGuarded(()=>runApp(const MyApp(pageTitle: "to_other_page")), (error,stack){
  print("Error caught：$error");
  print("Stack trace：$stack");
});

final pageController = Get.put(PageControllers());
//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {

  runZonedGuarded(() => runApp(const MyApp(pageTitle: "",)), (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.pageTitle});
  final String pageTitle;
  static const MethodChannel channel = MethodChannel("from_flutter");

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
var datas ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //与 Flutter 应用的生命周期状态交互的通道。
    //
    // setMessageHandler 方法用于注册一个回调函数，这个回调函数会在 Flutter 应用的生命周期状态发生变化时被调用
    SystemChannels.lifecycle.setMessageHandler((msg) async {
      if (msg == AppLifecycleState.resumed.toString()) {

      } else if (msg == AppLifecycleState.inactive.toString()) {

      } else if (msg == AppLifecycleState.paused.toString()) {

      } else if (msg == AppLifecycleState.detached.toString()) {

      }
      return '';
    });

    MyApp.channel.setMethodCallHandler((call) async {

      switch(call.method){
        case "pressPage":

            pageController.pageIsOk = false;
            //SongLstisOk = false;

          break;
        case "to_other_page":
          final data = call.arguments;
          if (data != null) {
            setState(() {
              datas = data;
            });
          }
          break;
      }});

  }

  @override
  Widget build(BuildContext context) {
    //_page(context);
    // TODO: implement build

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

      switch(datas['type']){
        case "to_recommend_song_sheet":
         return  songListPage(id: datas['id']);

        case "to_search":
           return  searchPage();

      }
    default:
    //  return  songListPage("3136952023");
      return  dd();
  }
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
    print("sssssssssssss${pageTitle != oldWidget.pageTitle}");
    return pageTitle != oldWidget.pageTitle;
  }

}