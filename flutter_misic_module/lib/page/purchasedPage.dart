import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_misic_module/main.dart';

import 'package:flutter_misic_module/page/myPage.dart';
import 'package:flutter_misic_module/util/Utils.dart';
import 'package:get/get.dart';
import '../bean/ShowSongSheet.dart';
import 'myPageController.dart';
//已购
class purchasedPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>purchasedPageState();
  
}
class purchasedPageState extends State<purchasedPage>{

  int lastSongId = 0;
  final FocusNode _focusNode = FocusNode();
  bool isContain =  false;
  late TextEditingController _textEditingController;
  var pageController = Get.find<PageControllers>();
  int songCounts = 0;
  final myPageController _myPageController = Get.find<myPageController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener((){
      setState(() {
       isContain = isContains();
       print("object----------------$isContain-------${isContains()}");
      });
    });

    getData();
  }
  @override
  void didUpdateWidget(covariant purchasedPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _myPageController.showSongs = null;
    getData();
  }
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
   return Scaffold(
     backgroundColor: Colors.white,
     appBar:AppBar(
      scrolledUnderElevation: 0.0 ,
       backgroundColor: Colors.white,
       title:  Text("已购单曲${_myPageController.showSongs!=null?"($songCounts)":""}"),
       centerTitle: true,
       bottom: PreferredSize(
           preferredSize: Size.fromHeight(50),
           child: Container(
             padding: EdgeInsets.only(bottom: 10),
             color: Colors.white,
             child: Container(
               width: MediaQuery.of(context).size.width-20,
               padding: EdgeInsets.only(left: 12,bottom: 6,right: 6,top: 6),
               decoration: BoxDecoration(
                   color: Colors.white,
                   border: Border.all(color: Colors.black12,width: 1),
                   borderRadius: BorderRadius.circular(25)),
               child:  TextField(
                 textInputAction: TextInputAction.done,
                 focusNode: _focusNode,
                 controller:_textEditingController,
                 maxLines: 1,
                 decoration: const InputDecoration(
                     hintText: "搜索歌曲",
                     isCollapsed: true,
                     hintStyle: TextStyle(color: Colors.grey),
                     border: InputBorder.none),
                 onSubmitted: (String value){

                 },
               ),
             ),
           )),
     ) ,
     body:PopScope(
       onPopInvoked: (isPop){
         var p= {"origin":"my_page"};
         channel.invokeMethod("back",p);
       },
       child: Padding(
         padding: EdgeInsets.all(10),
         child:
        NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification){
            if (scrollNotification is ScrollUpdateNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              // 列表滑动到了底部
              print('ListView is at the bottom');

              if( _myPageController.showSongs?.length!= songCounts) {
                if(!_myPageController.showSongsIsOk) addMoreList();
              };

              return true; // 阻止通知的进一步处理
            }
            return false;
          },
          child:  Stack(children: [
            Obx((){
              return _myPageController.showSongs.length!=0? CustomScrollView(

                slivers:
                [
                  SliverFixedExtentList.builder(
                      itemExtent: 150,
                      itemCount: _myPageController.showSongs.length,
                      itemBuilder: (context,index){
                        return _focusNode.hasFocus?
                        _myPageController.showSongs[index].name.contains(_textEditingController.text)||
                            _myPageController.showSongs[index].artistName.contains(_textEditingController.text)||
                            _myPageController.showSongs[index].albumName.contains(_textEditingController.text)&&_textEditingController.text.isNotEmpty?_SongListItem(index,mediaQuery)
                            :SizedBox()
                            :_SongListItem(index,mediaQuery);
                      }),
                  SliverToBoxAdapter(
                      child:
                      Obx((){
                        return
                          Container(
                              color: Colors.white,
                              width: 70,height: 70,
                              alignment: Alignment.center,
                              child:
                              _myPageController.showSongs.length!= songCounts?
                              CircularProgressIndicator(color: Colors.red,strokeWidth: 1,) :Container());
                      })

                  )
                ],
              )  :
              Utils.loadingView(Alignment.topCenter);
            }),
            Visibility(
                visible: _focusNode.hasFocus&&!isContain,
                child:  GestureDetector(
                  onTap: (){
                    _focusNode.unfocus();
                    setState(() {
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Text("无搜索结果",style: TextStyle(color: Colors.grey,fontSize: 16),),
                  ),
                ))

          ],))

       ),
     )
   );
  }
  _SongListItem(int index,MediaQueryData mediaQuery){
    return
      InkWell(

          onTap: (){
            if( pageController.lastId==_myPageController.showSongs[index].songId) return;
            List<Map<String, dynamic>> jsonList = _myPageController.showSongs.map((song) => song.toJson()).toList();

            channel.invokeMethod("sendSongList",{
              "title":"已购",
              "SongIndex":index,
              "SongList":jsonEncode(jsonList)
            });
            pageController.lastId =_myPageController.showSongs[index].songId;

          },
     child:  Row(
       children: [
         getSquareImg(Url: _myPageController.showSongs[index].picUrl, width: 125,height: 125,isRadius: true,),
         Container(
           width: mediaQuery.size.width-200,
           alignment: Alignment.centerLeft,
           padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(_myPageController.showSongs[index].name,maxLines: 1,style: const TextStyle(fontSize: 16,color: Colors.black,
                   overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),),
               Text("${_myPageController.showSongs[index].artistName}${_myPageController.showSongs[index].albumName!=""?
               " - ${_myPageController.showSongs[index].albumName}":""}",maxLines: 1,),
               Text("已购${_myPageController.showSongs[index].boughtCount}首",style: const TextStyle(fontSize: 12,color: Colors.grey,
                   overflow: TextOverflow.ellipsis),)

             ],),
         )

       ],
     ),
      );





  }
  void getData() {
    dioRequest.executeGet(url: "/song/purchased").then((value){
      if(value!="error"){
        _myPageController.showSongs =   (value['list'] as List<dynamic>).map((json)=>ShowSong.fromJson(json)).toList();
        songCounts = value['count'];
      setState(() {

      });
      }
    });
  }

  void addMoreList() async {
    _myPageController.showSongsIsOk = true;
    var SList =  await dioRequest.executeGet(url:"/song/purchased",params: {"limit":50,"offset": _myPageController.showSongs.length});

    _myPageController.addShowSongsSongList( (SList['list'] as List<dynamic>).map((json)=>ShowSong.fromJson(json)).toList());
    _myPageController.showSongsIsOk = false;
  }
  bool isContains(){
    if(_textEditingController.text.isEmpty) return false;
    bool isTrue = false;
    _myPageController.showSongs.any((value){

      isTrue = value.name.contains(_textEditingController.text)||
          value.artistName.contains(_textEditingController.text)||
          value.albumName.contains(_textEditingController.text);
      return isTrue;
    });
    print("----------------------------oooooooo");
    return isTrue;
  }
}