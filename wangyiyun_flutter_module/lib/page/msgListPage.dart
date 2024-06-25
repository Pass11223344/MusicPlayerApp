

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import '../bean/notificationListBean.dart';
import '../main.dart';


class msgListPage extends StatefulWidget{
  const msgListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return msgListState();

  }
}
class msgListState extends State<msgListPage>{
  static const  channel =  MyApp.channel ;
List<notificationListBean> notificationList =[] ;
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
      body: MediaQuery.removePadding(context: context,
        removeTop: true,//解决listView顶部留白问题
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 70),

            itemExtent: 75,

            itemCount: notificationList.length,

            itemBuilder:(context,index){
              return   _listItem(index);
            }))
    );

  }

  void receiveDataFromAndroid()  {
  channel.setMethodCallHandler((call) async {
    var method = call.method;
    if (method == "to_msgPage") {
      var json = call.arguments;
      var list = jsonDecode(json) as List<dynamic>;
      notificationList= list.map((json)=>notificationListBean.fromJson(json)).toList();
      for(notificationListBean bean in notificationList){
        print(bean.sendUserAvatarUrl);
      }
      setState(() {});
    }
  });}
Widget _listItem(int index){

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
          onTap: ()=>{
          },
        ),
        Padding(padding: EdgeInsets.only(left: 40,right: 40),
          child: Divider(height: 1,color: Colors.black12,))
      ],
    ),
  );
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