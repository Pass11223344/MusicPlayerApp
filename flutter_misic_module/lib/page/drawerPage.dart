import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import 'createSheet.dart';
import 'myPageController.dart';

class drawerPage extends StatefulWidget{
  const drawerPage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return drawerPageState();
  }




}

final pageController = Get.put(PageControllers());
class drawerPageState extends State<drawerPage>{
  // 创建一个FocusNode
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 250,
        title: Image.asset("images/img.png",fit: BoxFit.cover,),
      ),
      body: Container(
          color: Colors.blueGrey,
          child:
          Stack(
            children: [
              ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.dashboard, color: Colors.white),
                    title: Text('Dashboard', style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    leading: Icon(Icons.inbox, color: Colors.white),
                    title: Text('Inbox', style: TextStyle(color: Colors.white)),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text('Settings', style: TextStyle(color: Colors.white)),
                    onTap: (){
                      pageController.isOverlayVisible = ! pageController.isOverlayVisible;

                      print("isOverlayVisible${pageController.isOverlayVisible}");
                    },
                  ),
                  Obx(()=> Visibility(
                      visible: pageController.isOverlayVisible,
                      child:  BottomPopupInput(context: context))

                  ),

                  // ... 更多Drawer内容
                ],
              ),

            ],
          )

      ),
    );
  }



}