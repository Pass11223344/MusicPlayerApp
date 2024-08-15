import 'dart:async';

import 'package:flutter_misic_module/page/rankingListPage.dart';

import 'package:flutter_misic_module/util/Utils.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_misic_module/NetWork/DioRequest.dart';
import 'package:flutter_misic_module/page/WebPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_misic_module/page/commentPage.dart';

import 'package:flutter_misic_module/page/msgListPage.dart';
import 'package:flutter_misic_module/page/musicCloudDiskPage.dart';
import 'package:flutter_misic_module/page/myPage.dart';
import 'package:flutter_misic_module/page/myPageController.dart';
import 'package:flutter_misic_module/page/purchasedPage.dart';
import 'package:flutter_misic_module/page/recentlyPlayed.dart';
import 'package:flutter_misic_module/page/searchPage.dart';
import 'package:flutter_misic_module/page/songListPage.dart';
import 'package:flutter_misic_module/page/traceCommentPage.dart';
import 'package:flutter_misic_module/route/route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:get/get.dart';

@pragma('vm:entry-point')
void msgMain() {
  _initializeGlobalController();
  runZonedGuarded(() => runApp(const MyApp(pageTitle: "to_msgPage")),
      (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

@pragma("vm:entry-point")
MyPage() {
  _initializeGlobalController();
  Get.lazyPut(() => myPageController());

  runZonedGuarded(() => runApp(MyApp(pageTitle: "to_myPage")), (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

@pragma("vm:entry-point")
void CommentPage() {
  _initializeGlobalController();
  runZonedGuarded(() => runApp(const MyApp(pageTitle: "to_commentPage")),
      (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

@pragma("vm:entry-point")
void OtherPage() {
  _initializeGlobalController();
  runZonedGuarded(() => runApp(const MyApp(pageTitle: "to_other_page")),
      (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

@pragma("vm:entry-point")
void SearchPage() {
  _initializeGlobalController();
  runZonedGuarded(() => runApp(const MyApp(pageTitle: "to_search")),
      (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

final MethodChannel channel = MethodChannel("from_flutter");
final DioRequest dioRequest = DioRequest();
final ImagePicker picker = ImagePicker();
//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void _initializeGlobalController() {
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }
  if (!Get.isRegistered<PageControllers>()) {
    Get.lazyPut(() => PageControllers());
  }
}

void main() {
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;
  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }
  _initializeGlobalController();
  runZonedGuarded(() {
    runApp(const MyApp(
      pageTitle: "",
    ));
  }, (error, stack) {
    print("Error caught：$error");
    print("Stack trace：$stack");
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.pageTitle});

  final String pageTitle;
  static CancelToken cancelToken = CancelToken();

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var datas;

  static final GlobalKey<songListPageState> childKey =
      GlobalKey<songListPageState>();

  final PageControllers pageController = Get.find<PageControllers>();

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
    return GetMaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: getPage());
  }

  getPage() {
    switch (widget.pageTitle) {
      case "to_msgPage":
        return const msgListPage();
      case "to_myPage":
        return myPage();
      case "to_commentPage":
        return commentPage();
      case "to_other_page":
        // pageController.cookie = datas['token'];
        switch (datas['type']) {
          case "to_recommend_song_sheet":
          case "to_exclusive_scene_song_sheet":
          case "to_music_radar_song_sheet":
          case "to_sing_and_albums":
          case "to_recommend_song":
          case "to_sheet":
            return songListPage(data: datas, key: childKey);
          case "to_albums":
            return WebPage(url: datas['id']);
          case "to_ranking":
            return rankingListPage();
        }
      case "to_search":
        return searchPage();
      default:
        var params = {
          "avatarUrl":
              "http://p1.music.126.net/B7xVHm277qqxnYn2_A40Gg==/109951166258221220.jpg",
          "name": "aaa",
          "show_time&place": "oooo",
          "msg": "e.message!.msg",
          "img":
              "http://p1.music.126.net/B7xVHm277qqxnYn2_A40Gg==/109951166258221220.jpg",
          "title": "title",
          "creatorName": "creatorName",
          "id": "A_EV_2_29945262900_287870880",
          "commentCount": 2,
          "likedCount": 4
        };

      // _initializeGlobalController();
      //  return  rankingListPage();
      //return  Player_page();
      //  return  purchasedPage();
      //  return  ss();
      //return  PopupRoutePage();
      //return  traceCommentPage(params: params);
    }
  }

  void receiveDataFromAndroid() {
    channel.setMethodCallHandler((call) async {

      switch (call.method) {
        case "pressPage":
          bool isBack = true;
          isBack = await childKey.currentState?.isPop() ?? false;
          if (isBack) {
            return;
          }
          if (childKey.currentState == null) {
            var p = {"origin": "other_page"};
            await channel.invokeMethod("back", p);
            return;
          }
          if (pageController.pageIsOk) {
            channel.invokeMethod("loadComplete", true);
          } else {
            channel.invokeMethod("loadComplete", false);
            songListPageState.cancelRequest();
          }



          break;
        case "to_other_page":
          final data = call.arguments;
          if (data != null) {
            setState(() {
              datas = data;
            });
            pageController.cookie = datas['token'];
            pageController.userId = datas['userId'];
          }
          break;
        case "RequestResults":
          var info = call.arguments;
          if (info['isSuccess']) {
            switch (info['action']) {
              case "saveImg":
                pageController.path ??= info['path'];
                print(
                    "object-------xxxxx-----${info['action']}---------${info['info']}");
                Utils.downloadImage(info['info'], pageController.path)
                    .then((flag) {
                  childKey.currentState?.show(flag);
                });
                break;

                break;
            }
          }
          break;
        case "currentId":
          pageController.currentSongId = call.arguments;
          break;
      }
    });
  }
}

class MyInheritedWidget extends InheritedWidget {
  final BuildContext context;

  MyInheritedWidget({required this.context, required Widget child})
      : super(child: child);

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return context != oldWidget.context;
  }
}

class MyPageBindings extends Bindings {
  @override
  void dependencies() {
    // lazyPut用法示例
    Get.lazyPut(() => PageControllers());
    Get.lazyPut(() => myPageController());
    // Get.lazyPut(() => CounterController());
    // Get.lazyPut(() => CounterController());
  }
}
