

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:wangyiyun_flutter_module/NetWork/DioRequest.dart';


import '../bean/SongSheetList.dart';
import '../bean/songListBean.dart';
import '../main.dart';

import '../util/Utils.dart';
import 'myPage.dart';

class songListPage extends StatefulWidget{
  final String id;

  songListPage({super.key,required this.id});

  @override
  State<StatefulWidget> createState() {

    return songListPageState();
  }

}
class songListPageState extends State<songListPage>{

 late SongSheetList SongSheetInfo;
 late List<songListBean>  SongList;
 late ScrollController _scrollController;
 double  expandedHeight = 0.0;
 late  MediaQueryData mediaQuery ;
 late  double width ;
 late  double height ;
late  double eHeight;




 @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    getData(widget.id);

  }
  @override
  void didUpdateWidget(covariant songListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    pageController.pageIsOk = false;
    setState(() {

      //isOk = false;
      getData(widget.id);
    });
    print("object The data iqqqqs ${widget.id}------");
  }


 void _onScroll() {
  expandedHeight = _scrollController.offset;
  print("object${expandedHeight}");
  if(expandedHeight>eHeight/2){
    setState(() {
    });
  }else if(expandedHeight<=eHeight/2){
    setState(() {
    });
  }


 }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
   _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    eHeight =  height/2-120;
    var statusHeight = mediaQuery.padding.top + kToolbarHeight;
    // TODO: implement build
    return pageController.pageIsOk?  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,//使收缩时不改变appBar的颜色
        toolbarHeight: 38,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
          titleSpacing: 0,
          title:Container(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child:
                        TextButton.icon(onPressed: (){},
                          label: Text("${SongSheetInfo.detailPageTitle==null?expandedHeight>eHeight/2?SongSheetInfo.name:"歌单":
                          expandedHeight>eHeight/2?SongSheetInfo.name:"官方歌单"}",
                            style: TextStyle(fontSize: 20,color: Colors.black),),
                          icon:const Icon(Icons.arrow_back, color: Colors.black) )


                        )),
              Visibility(
                  visible: false,
                  child: Expanded(
                    flex: 7,
                    child:  Container(

                      width: width-120,
                      padding: EdgeInsets.all(6),
                      child: const TextField(
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: "搜索歌单内歌曲",
                            isCollapsed: true,
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: -4),
                            border:InputBorder.none, )
                      ),
                      decoration: BoxDecoration(
                          border: Border(bottom:BorderSide(color: Colors.black,width: 2) )
                      ),
                    ),
                  )),
                  GestureDetector(
                      child: Image.asset("images/search.png",fit: BoxFit.cover,width: 45,height: 45,),
                    )
              ],
            ),
          ),


      ),
      body:  NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
          return [
            SliverOverlapAbsorber(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                backgroundColor: Colors.white,
                pinned: true,
                scrolledUnderElevation: 0.0,
                forceElevated: innerBoxIsScrolled,
                toolbarHeight: 0,
                expandedHeight: height/2-100,
                flexibleSpace: FlexibleSpaceBar(
                  // collapseMode: CollapseMode.pin,
                  background:
                  Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Container(color: Colors.blue,),
                      ),
                      Container(

                        margin: EdgeInsets.only(top: statusHeight+16,left: 20,right: 20),
                        child:  Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,height:  110,
                                child:  Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(width:85 ,height: 100 ,
                                      decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                    ),
                                    Container(

                                      alignment: Alignment.bottomCenter,
                                      //
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(8)
                                      // ),
                                      child: ClipRRect(
                                        borderRadius:  BorderRadius.circular(8.0),
                                        child: getSquareImg(Url: SongSheetInfo.coverImgUrl,width:100 ,height: 110 ,)
                                        //Image.asset("images/img.png",fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10,right: 10),
                                      alignment: Alignment.topRight,
                                      width: 100,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.play_arrow,color: Colors.white,size: 20,),
                                          Text("213万",style: TextStyle(fontSize: 10,color: Colors.white,))
                                        ],
                                      ),
                                    )
                                  ],
                                ) ,
                              ),
                              Container(
                                height: 110,
                                width: width-200,
                                padding: EdgeInsets.only(left: 10,right: 10),
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(width: double.infinity,height: 60,child:   Text(
                                      "${SongSheetInfo.name}",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize:16 ),
                                      maxLines: 2,overflow: TextOverflow.ellipsis,),),
                                    Row(
                                      children: [
                                        Container(
                                        width: 30,height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child:ClipOval(
                                          child: Image.asset("images/img.png",fit: BoxFit.cover,),
                                        ),


                                      ),
                                        Container(
                                          width: 30,height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              border: Border.all(color: Colors.white,width: 1),
                                              borderRadius: BorderRadius.circular(100)
                                          ),
                                          child:ClipOval(
                                            child: Image.asset("images/img.png",fit: BoxFit.cover),
                                          ),


                                        ),
                                        Expanded(child:   Container(
                                            width:  double.infinity,
                                            child: Text("  88dddddd88>",style: TextStyle(fontSize:14,color: Colors.grey ),overflow: TextOverflow.ellipsis,maxLines: 1,)
                                        ))

                                      ],)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                                margin: EdgeInsets.only(top: 10,bottom: 10),
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                child:Visibility(
                                  visible:  SongSheetInfo.description==null&&SongSheetInfo.userId!=SongSheetInfo.creator.userId,
                                  child: Text(" ${SongSheetInfo.userId==SongSheetInfo.creator.userId&&SongSheetInfo.description==null ?"编辑信息":SongSheetInfo.description }>",style: TextStyle(fontSize:14,color: Colors.black ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                              ) ,
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child:Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child:  TextButton.icon(
                                      onPressed: (){}, label: Text(Utils.formatNumber(SongSheetInfo.shareCount)),icon: Icon(Icons.telegram,color:Colors.white,size:25),),
                                  )),
                              SizedBox(width: 10),
                              Expanded(
                                  flex: 1,
                                  child:Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child:  TextButton.icon(

                                      onPressed: (){}, label: Text(Utils.formatNumber(SongSheetInfo.commentCount)),icon: Icon(Icons.question_answer_rounded,color:Colors.white,size:25),),
                                  )),
                              SizedBox(width: 10),
                              Expanded(
                                  flex: 1,
                                  child:Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        borderRadius: BorderRadius.circular(50)
                                    ),
                                    child:  TextButton.icon(

                                      onPressed: (){}, label: Text(Utils.formatNumber(SongSheetInfo.subscribedCount)),icon: Icon(Icons.add_box,color:Colors.white,size:25,),),
                                  )),
                            ],
                          )

                        ],),
                      ),
                    ],
                  ),


                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: Container(
                    height: 56,
                    alignment: Alignment.bottomLeft,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(16),topLeft: Radius.circular(16)),
                        color: Colors.white
                    ),
                    child:TextButton.icon(
                      onPressed: (){},
                      label: Text("播放全部(${SongSheetInfo.cloudTrackCount+SongSheetInfo.trackCount})",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black),),
                      icon: Icon(Icons.play_circle,color:Colors.red,size:25 ))
                  ),
                ),
              ),
            ),

          ];
        },
        body:
        SafeArea(
          bottom: false,
          top: false,
          child: Builder(builder: (context){
            return  CustomScrollView(
              slivers: [
                SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),),
                SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: SongList.length,
                          (context,index){
                        return
                          Container(
                            color: Colors.white,
                            child:  ListTile(
                              leading: Text("${index+1}"),
                              title: Text(SongList[index].name,maxLines: 1,),
                              titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                  overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                              subtitle:Text("${getSubTitle(SongList[index].ar)}-${SongList[index].al.name!=null?SongList[index].al.name:""}" ,maxLines: 1,) ,
                              subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
                                  overflow: TextOverflow.ellipsis),
                              trailing: Image.asset("images/more.png",width: 20,height: 20,),
                              onTap: (){
                                print("object${SongList.length}+++++${index}");
                                MyApp.channel.invokeMethod("sendSongList",{
                                  "SongIndex":index,
                                  "SongList":jsonEncode(SongList)

                                });
                              },
                            ),
                          );


                      }
                  ),
                  itemExtent: 55,
                ),
                 SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 70,
                  )
                )
              ],

            );
          }),
        ),
      )


    ):Container(color: Colors.white,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: Colors.red,strokeWidth: 1));
  }

   getData(String id) async {
     var SongSheet = await DioRequest().executeGet(url: "/playlist/detail",params: {"id":id});
  var SList =  await DioRequest().executeGet(url: "/playlist/track/all",params: {"id":id,"limit":100,"offset":0});
 Future.microtask((){

   setState(() {
     SongSheetInfo = SongSheetList.fromJson(SongSheet);
     SongList = (SList as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList();
     pageController.pageIsOk = true;
   });
   print("SongSheetInfo:${SongSheetInfo.userId}---SongList:${SongList.length}");
 });
  }

String getSubTitle(List<Ar> info){
   String str = "";
   for (int i = 0; i < info.length; i++) {
  if(i==info.length-1){
    str = str+info[i].name;
  }else{
    str = "$str${info[i].name}/";
  }
}
   return str;
}

}

