import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_misic_module/bean/SongListBean.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../util/Utils.dart';
import 'myPageController.dart';
//云盘

class musicCloudDiskPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => musicCloudDiskPageState();

}
class musicCloudDiskPageState extends State<musicCloudDiskPage>{
 MusicCloudDiskBean? musicCloudDiskBean ;
int lastSongId = 0;
 var pageController = Get.find<PageControllers>();
 bool addMoreListIsOk = false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  void didUpdateWidget(covariant musicCloudDiskPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    musicCloudDiskBean = null;
    getData();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("音乐云盘"),
          Text(musicCloudDiskBean==null?"":"  ${musicCloudDiskBean!.size} / ${musicCloudDiskBean!.maxSize}",
            style: const TextStyle(color: Colors.grey,fontSize: 12))
        ],
      ),
    ),
    body:PopScope(
      onPopInvoked: (isPop){
       var p= {"origin":"my_page"};
        channel.invokeMethod("back",p);
      },
      child: musicCloudDiskBean!=null?
      Padding(padding: const EdgeInsets.only(bottom: 50),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification){
            if(scrollNotification is ScrollUpdateNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent){
              if( musicCloudDiskBean!.simpleSong.length!= musicCloudDiskBean!.count) {
                if(!addMoreListIsOk) addMoreList();
              };
              return true;
            }
            return false;
          },
          child:  ListView.builder(
              itemExtent: 60,
              itemCount: musicCloudDiskBean!.simpleSong.length+1,
              itemBuilder: (context,index){
                return _SongListItem(index);
              }),),
      )
          : Utils.loadingView(Alignment.topCenter))
    ,
  );
  }

  void getData() {
        dioRequest.executeGet(url: "/user/cloud").then((value){
         if( value!="error"){
           var list = (value['data'] as List<dynamic>).map((json)=>SongListBean.fromJson(json)).toList();
           var size = _bytesToGb(int.parse(value['size']));
           var maxSize = _bytesToGb(int.parse(value['maxSize']) );
           musicCloudDiskBean = MusicCloudDiskBean(list,size , maxSize,value['count']);
           for (int i = 0; i < musicCloudDiskBean!.simpleSong.length; i++) {
             print("object--${musicCloudDiskBean!.simpleSong[i].name}");
           }
           setState(() {

           });
         }
        });
  }
 void addMoreList() async {
   addMoreListIsOk = true;
   setState(() {

   });
  var SList =  await dioRequest.executeGet(url: "/user/cloud",params: {"limit":100,"offset": musicCloudDiskBean!.simpleSong.length});

  musicCloudDiskBean!.simpleSong.addAll((SList['data'] as List<dynamic>).map((json)=>SongListBean.fromJson(json)).toList());
   addMoreListIsOk = false;
   setState(() {

   });
}
_SongListItem(int index){
  return
    index==musicCloudDiskBean!.simpleSong.length?
    Container(
        color: Colors.white,
        width: 70,height: 70,
        alignment: Alignment.center,
        child:
        musicCloudDiskBean!.simpleSong.length!= musicCloudDiskBean!.count?
        CircularProgressIndicator(color: Colors.red,strokeWidth: 1,) :Container())
        : ListTile(
    leading: Text("${index+1}"),
    title: Text(musicCloudDiskBean!.simpleSong[index].name,maxLines: 1,),
    titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
        overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
    subtitle:Text("${ musicCloudDiskBean!.simpleSong[index].singerName}${musicCloudDiskBean!.simpleSong[index].al.name!=""?"-${musicCloudDiskBean!.simpleSong[index].al.name}":""}",maxLines: 1,) ,
    subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
        overflow: TextOverflow.ellipsis),
    trailing: Image.asset("images/more.png",width: 20,height: 20,),
    onTap: (){

      if( pageController.lastAlbumId==musicCloudDiskBean!.simpleSong[index].id) {
        return;
      }
      pageController.lastAlbumId = musicCloudDiskBean!.simpleSong[index].id;
      channel.invokeMethod("sendSongList",{
        "title":"云盘",
        "SongIndex":index,
        "SongList":jsonEncode(musicCloudDiskBean!.simpleSong)
      });
    },
  );
}
String _bytesToGb(int bytes) {
  const double gb = 1073741824; // 1 GB in bytes
  double gbValue = bytes / gb;
  if (gbValue>=0.1){
    return "${gbValue.truncateToDouble() == gbValue ? gbValue.toStringAsFixed(0) : gbValue.toStringAsFixed(1)}G";

  }else{
    return "0.1G";
  }
}
}

class MusicCloudDiskBean{
  List<SongListBean> simpleSong;
  String size,maxSize;
  int count;

  MusicCloudDiskBean(this.simpleSong, this.size, this.maxSize,this.count);
}