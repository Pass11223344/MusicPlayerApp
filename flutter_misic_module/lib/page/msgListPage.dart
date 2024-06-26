

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



import '../bean/notificationListBean.dart';
import '../main.dart';
import 'myPageController.dart';


class msgListPage extends StatefulWidget{
  const msgListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return msgListState();

  }
}
class msgListState extends State<msgListPage>{
 // static const  channel =  MyApp.channel ;
List<notificationListBean> notificationList =[] ;
var pageController = Get.find<PageControllers>();


@override
  void didUpdateWidget(covariant msgListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

  }
@override
  void initState() {

    // TODO: implement initState
    super.initState();
receiveDataFromAndroid();


}

  @override
  Widget build(BuildContext context) {
  var size = MediaQuery.of(context).size;

  // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        toolbarHeight: 38,
        centerTitle:true,title:const Text("消息"),backgroundColor: Colors.white,),
      body: Column(
        children: [

          const SizedBox(height: 16,),
          Expanded(child:  MediaQuery.removePadding(context: context,
              removeTop: true,
              child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemExtent: 75,
                  itemCount: notificationList.length,

                  itemBuilder:(context,index){
                    return _listItem(index);
                  })))

        ],
      )


    );

  }

  void receiveDataFromAndroid()  {
  channel.setMethodCallHandler((call) async {
    var method = call.method;
    if (method == "to_msgPage") {
      var data = call.arguments;
      var json = data['json'];
      pageController.cookie = data['token'];
      pageController.userId = data['userId'];

      var list = jsonDecode(json) as List<dynamic>;
      notificationList= list.map((json)=>notificationListBean.fromJson(json)).toList();

      setState(() {});
    }
  });}
Widget _listItem(int index){
//receiveUserId = toUser为自己
//sendUserUserId = fromUser为对方
  return Container(
    width: double.infinity,
    child: Column(
      children: [
        ListTile(
          leading:getImg(url: notificationList[index].sendUserAvatarUrl),
          title: Text("${notificationList[index].sendUserNickname}"),
          subtitle: Container(
            width: 100,
            height: 20,
            child: Text("${notificationList[index].msg}",style: TextStyle(fontSize: 12,color: Colors.black,),overflow:TextOverflow.ellipsis ,softWrap: false,maxLines: 1,),
          ),
          trailing: Text("${notificationList[index].lastMsgTime}",style: TextStyle(fontSize: 8,color: Colors.black)),
          onTap: () async {
            channel.invokeMethod("addPage","");
            final result = await Navigator.pushNamed(context, "main/chatPage",arguments: {
              "name":notificationList[index].sendUserNickname,
              "id":notificationList[index].sendUserUserId});
          },
        ),
        Padding(padding: EdgeInsets.only(left: 40,right: 40),
          child: Divider(height: 1,color: Colors.black12,))
      ],
    ),
  );
}
ImgModule(IconData data,Color color,String str){
   return
     Container(
       padding: EdgeInsets.only(top: 10),
       height: 100,child:  Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Icon(data,color: color,size: 60,),
         Text(str,style: TextStyle(color: Colors.black,fontSize: 16),)
       ],
     ),);
}

}
class getImg extends StatefulWidget{
   final String url;
  final double? size ;

   getImg({super.key, required this.url,this.size=50} );
  @override
  State<StatefulWidget> createState() => getImgState();

}
class getImgState extends State<getImg>{
  //getImgState(String url);

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
   return ClipOval(
     child: CachedNetworkImage(
      width: widget.size,
       height: widget.size,
       imageUrl:widget.url ,
        placeholder: (context, url) => Container(
          width: widget.size,
          height: widget.size,
          color: Colors.grey,
          child: const CircularProgressIndicator(color: Colors.red,strokeWidth: 1,),
        ),
       errorWidget: (context, url, error) => Container(
          width: widget.size,
          height: widget.size,
          color: Colors.grey,
        ) ,
     )


   );
  }

}