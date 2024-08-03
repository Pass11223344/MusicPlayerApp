
import 'package:flutter/material.dart';
import 'package:flutter_misic_module/page/chatPage.dart';
import 'package:flutter_misic_module/page/commentPage.dart';
import 'package:flutter_misic_module/page/mySongListPage.dart';
import 'package:flutter_misic_module/page/traceCommentPage.dart';


import '../page/VideoPage.dart';
import '../page/drawerPage.dart';
import '../page/msgListPage.dart';
import '../page/musicCloudDiskPage.dart';
import '../page/myPage.dart';
import '../page/purchasedPage.dart';
import '../page/recentlyPlayed.dart';
import '../page/sendPage.dart';
import '../page/songListPage.dart';
import '../util/Utils.dart';

Map route = {
  "main/msgList":(context,{arguments})=>msgListPage(),
  "main/myPage":(context)=> myPage(),
 "main/drawer":(context)=>drawerPage(),
  "main/songListPage":(context,{arguments})=>mySongListPage(data: arguments,key: myPageState.childKey,),
  "main/chatPage":(context,{arguments})=>chatPage(data: arguments),
  "main/traceCommentPage":(context,{arguments})=>  traceCommentPage(params: arguments,),
  "main/recentlyPlayedPage":(context)=>recentlyPlayed(),
  "main/musicCloudDiskPage":(context)=>musicCloudDiskPage(),
  "main/purchasedPage":(context)=>purchasedPage(),
  "main/sendPage":(context,{arguments})=>sengPage(data: arguments,),
  "main/CommentPage":(context,{arguments})=>commentPage(data: arguments,),
  "main/VideoPage":(context,{arguments})=>VideoPage(index: arguments,)

};


var onGenerateRoute = (RouteSettings settings){
final String? name = settings.name;
final Function? FunctionPage = route[name];
    if (FunctionPage!=null) {
      if (settings.arguments!=null) {

        final Route materialPageRoute = CustomPageRoute(builder:(context)=> FunctionPage(context,arguments:settings.arguments), settings: settings);
          return materialPageRoute;
    }else{
        final  Route materialPageRoute = CustomPageRoute(builder:(context)=> FunctionPage(context), settings: settings);
          return materialPageRoute;
  }
}
return null;
};