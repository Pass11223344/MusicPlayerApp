
import 'package:flutter/material.dart';
import 'package:wangyiyun_flutter_module/page/drawerPage.dart';
import 'package:wangyiyun_flutter_module/page/myPage.dart';

import '../page/msgListPage.dart';

Map route = {
  "main/msgList":(context,{arguments})=>msgListPage(),
  "main/myPage":(context)=> myPage(),
 "main/drawer":(context)=>drawerPage()
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