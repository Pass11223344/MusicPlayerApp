
import 'package:flutter/material.dart';
import 'package:flutter_misic_module/page/chatPage.dart';
import 'package:flutter_misic_module/page/mySongListPage.dart';


import '../page/drawerPage.dart';
import '../page/msgListPage.dart';
import '../page/myPage.dart';
import '../page/songListPage.dart';

Map route = {
  "main/msgList":(context,{arguments})=>msgListPage(),
  "main/myPage":(context)=> myPage(),
 "main/drawer":(context)=>drawerPage(),
  "main/songListPage":(context,{arguments})=>mySongListPage(data: arguments,),
  "main/chatPage":(context,{arguments})=>chatPage(data: arguments),
};


var onGenerateRoute = (RouteSettings settings){
final String? name = settings.name;
final Function? FunctionPage = route[name];
    if (FunctionPage!=null) {
      if (settings.arguments!=null) {
        final Route materialPageRoute = MaterialPageRoute(builder: (BuildContext context) =>
          FunctionPage(context,arguments:settings.arguments));
          return materialPageRoute;
    }else{
        final  Route materialPageRoute = MaterialPageRoute(builder: (BuildContext context) =>
          FunctionPage(context));
          return materialPageRoute;
  }
}
return null;
};