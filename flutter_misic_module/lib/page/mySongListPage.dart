

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misic_module/bean/AlbumListBean.dart';
import 'package:flutter_misic_module/page/searchPage.dart';

import 'package:get/get.dart';




import '../NetWork/DioRequest.dart';
import '../bean/SongSheetList.dart';
import '../bean/SongListBean.dart';
import '../main.dart';

import '../util/Utils.dart';
import 'myPage.dart';
import 'myPageController.dart';
import 'songListController.dart';

class mySongListPage extends StatefulWidget{
  final Map data;

  mySongListPage({super.key,required this.data});

  @override
  State<StatefulWidget> createState() {

    return mySongListPageState();
  }

}
class mySongListPageState extends State<mySongListPage>{
  var ListController =  songListController();
  var pageController = Get.find<PageControllers>();
  SongSheetList? SongSheetInfo;
  List<songListBean>?  SongList;
  AlbumListBean?  AlbumInfo;
  int lastId = 0;
  int index = 0;
  //late ScrollController _scrollController;
  double  expandedHeight = 0.0;
  late  MediaQueryData mediaQuery ;
  late  double width ;
  late  double height ;
  late  double eHeight;
  static var  dioRequest;




  @override
  void didUpdateWidget(covariant mySongListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    pageController.pageIsOk = false;

    getData(widget.data['id']);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("object--------------eeeeeeeeeeeeeee--------------${pageController.userId}");
    // _scrollController = ScrollController();
    //  _scrollController.addListener(_onScroll);

    pageController.pageIsOk = false;

    getData(widget.data['id']);


  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    eHeight =  height/2-120;
    var statusHeight = mediaQuery.padding.top + kToolbarHeight;
    // TODO: implement build
    return  pageController.pageIsOk?
    Scaffold(
      backgroundColor: Colors.white,
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
                      TextButton.icon(onPressed: (){
                        pageController.pageIsOk = false;
                        var p;

                        if(widget.data['type']=="to_my_page_song_list"||widget.data['type']=="to_sing_and_albums"){
                          Navigator.pop(context);
                          p= {"origin":"my_page"};
                          channel.invokeMethod("back",p);
                        }else if(widget.data['type']=="to_page_song_list"||widget.data['type']=="to_albums")
                          Navigator.pop(context);
                       // channel.invokeMethod("back",{"origin":"search"});

                      },
                          label: Text("${widget.data['title']!=null?expandedHeight>eHeight/2?widget.data['title']:"歌单":AlbumInfo!=null?(expandedHeight>eHeight/2?AlbumInfo?.album.name:"专辑")
                              :(SongSheetInfo?.detailPageTitle==null?expandedHeight>eHeight/2?SongSheetInfo?.name:"歌单":
                          expandedHeight>eHeight/2?SongSheetInfo?.name:"官方歌单")}",
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
              Visibility(
                  visible:AlbumInfo==null ,
                  child:   GestureDetector(
                    child: Image.asset("images/search.png",fit: BoxFit.cover,width: 45,height: 45,),
                  ))

            ],
          ),
        )),
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),

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
                                      child: ClipRRect(
                                          borderRadius:  BorderRadius.circular(8.0),
                                          child: getSquareImg(Url:AlbumInfo!=null ? AlbumInfo!.album.blurPicUrl : SongSheetInfo!.coverImgUrl,width:100 ,height: 110 ,)
                                        //Image.asset("images/img.png",fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Visibility(
                                        visible: AlbumInfo==null,
                                        child: Container(
                                          padding: EdgeInsets.only(top: 10,right: 10),
                                          alignment: Alignment.topRight,
                                          width: 100,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Icon(Icons.play_arrow,color: Colors.white,size: 20,),
                                              Text("${Utils.formatNumber(AlbumInfo==null?SongSheetInfo!.playCount:0)}",style: TextStyle(fontSize: 10,color: Colors.white,))
                                            ],
                                          ),
                                        ) )

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

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(width: double.infinity,
                                            child:   Text(
                                                "${widget.data['title']!=null?widget.data['title']:AlbumInfo!=null?AlbumInfo?.album.name : SongSheetInfo?.name}",
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize:14 ),
                                                maxLines: 2,overflow: TextOverflow.ellipsis)),
                                        Visibility(
                                            visible: AlbumInfo  !=null,
                                            child: Text("歌手:${AlbumInfo!=null?Utils.getSubTitle(AlbumInfo?.album.artists):""}>",
                                              style: const TextStyle(fontSize:12,color: Colors.black )
                                              ,overflow: TextOverflow.ellipsis,maxLines: 1,))],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible:AlbumInfo!=null ,
                                          child:  Text("发行时间:${AlbumInfo!=null?Utils.formatDate(AlbumInfo!.album.publishTime):""}",style: TextStyle(fontSize:12,color: Colors.grey )),
                                        ),
                                        Visibility(
                                            visible:AlbumInfo!=null  ,
                                            child: GestureDetector(
                                              child: Text("${AlbumInfo!=null?AlbumInfo?.album.description:""}>",style: TextStyle(fontSize:12,color: Colors.grey ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                            ))
                                        ,
                                        Visibility(
                                            visible: AlbumInfo==null,
                                            child: Row(
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
                                                    child: Text("  88dddddd88>",style: TextStyle(fontSize:12,color: Colors.grey ),overflow: TextOverflow.ellipsis,maxLines: 1,)
                                                ))

                                              ],) )
                                      ],
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child:Visibility(
                                visible:  SongSheetInfo?.description!=null||SongSheetInfo?.userId==SongSheetInfo?.creator.userId,
                                child: Text(" ${SongSheetInfo?.userId==SongSheetInfo?.creator.userId&&SongSheetInfo?.description=="" ?"编辑信息":SongSheetInfo?.description }>",style: TextStyle(fontSize:12,color: Colors.black ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                          )
                          ,
                          Padding(padding: EdgeInsets.only(top: 10),
                            child: Row(
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
                                        onPressed: (){}, label: Text(Utils.formatNumber(AlbumInfo!=null?AlbumInfo!.album.info.shareCount:SongSheetInfo!.shareCount)),icon: Icon(Icons.telegram,color:Colors.white,size:24),),
                                    )),
                                const SizedBox(width: 8),
                                Expanded(
                                    flex: 1,
                                    child:Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child:  TextButton.icon(

                                        onPressed: (){}, label: Text(Utils.formatNumber(AlbumInfo!=null?AlbumInfo!.album.info.commentCount:SongSheetInfo!.commentCount)),icon: const Icon(Icons.question_answer_rounded,color:Colors.white,size:24),),
                                    )),
                                const SizedBox(width: 8),
                                Expanded(
                                    flex: 1,
                                    child:Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.circular(50)
                                      ),
                                      child:  TextButton.icon(

                                        onPressed: (){}, label: Text(Utils.formatNumber(AlbumInfo!=null?AlbumInfo!.album.info.likedCount:SongSheetInfo!.subscribedCount)),icon: const Icon(Icons.add_box,color:Colors.white,size:24,),),
                                    )),
                              ],
                            ) ,)


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
                          label: Text("播放全部(${AlbumInfo!=null?AlbumInfo!.songs.length:SongSheetInfo!.cloudTrackCount+SongSheetInfo!.trackCount})",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black),),
                          icon: const Icon(Icons.play_circle,color:Colors.red,size:24 ))
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
            return
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification){

                  expandedHeight = scrollNotification.metrics.pixels;
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.metrics.pixels ==
                          scrollNotification.metrics.maxScrollExtent) {
                    // 列表滑动到了底部
                    print('ListView is at thesssss bottom${ListController.songList?.length}');
                    if( ListController.songList?.length!=SongSheetInfo?.trackCount) {
                      addMoreList();
                    };

                    return true; // 阻止通知的进一步处理
                  }
                  return false; // 允许通知的进一步处理
                },
                child:

                CustomScrollView(
                  slivers: [
                    SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),),

                  Obx((){
                    return  SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: AlbumInfo!=null?AlbumInfo!.songs.length:ListController.songList?.length,
                              (context,index){
                            if(AlbumInfo!=null){
                              AlbumInfo?.songs[index].al.pic(AlbumInfo!.album.picUrl);
                            }

                            return AlbumInfo==null?
                            Container(
                              color: Colors.white,
                              child:  ListTile(
                                leading: Text("${index+1}"),
                                title: Text(ListController.songList![index].name,maxLines: 1,),
                                titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                    overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                                subtitle:Text(
                                  "${Utils.getSubTitle(ListController.songList![index].ar)}-${ListController.songList![index].al.name!=null?ListController.songList![index].al.name:""}",maxLines: 1,) ,
                                subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
                                    overflow: TextOverflow.ellipsis),
                                trailing: Image.asset("images/more.png",width: 20,height: 20,),
                                onTap: (){
                                  if(lastId==ListController.songList?[index].id) return;
                                  lastId = ListController.songList![index].id;

                                  channel.invokeMethod("sendSongList",{
                                    "title":widget.data['title']!=null?widget.data['title']:SongSheetInfo?.name,
                                    "SongIndex":index,
                                    "SongList":jsonEncode(ListController.songList)
                                  });
                                },
                              ),
                            )
                                :
                            Container(
                              color: Colors.white,
                              child:  ListTile(
                                leading: Text("${index+1}"),
                                title: Text(AlbumInfo!.songs[index].name,maxLines: 1,),
                                titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                    overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                                subtitle:Text(Utils.getSubTitle(AlbumInfo?.songs[index].ar),maxLines: 1,) ,
                                subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
                                    overflow: TextOverflow.ellipsis),
                                trailing: Image.asset("images/more.png",width: 20,height: 20,),
                                onTap: (){

                                  if( lastId==AlbumInfo!.songs[index].id) {
                                    return;
                                  }

                                  lastId = AlbumInfo!.songs[index].id;
                                  channel.invokeMethod("sendAlbum",{
                                    "title":widget.data['title']!=null?widget.data['title']:AlbumInfo!.album.name,
                                    "SongIndex":index,
                                    "SongList":jsonEncode(AlbumInfo?.songs)
                                  });
                                },
                              ),
                            ) ;


                          }
                      ),
                      itemExtent: 55,
                    );
                  })
                   ,


                    SliverToBoxAdapter(
                        child:
                        Obx((){
                          print("object${ListController.songList.length}----${AlbumInfo?.album.size}----${SongSheetInfo?.trackCount}");
                          return  Container(
                              color: Colors.white,
                              width: 70,height: (SongSheetInfo!=null?
                          ListController.songList?.length==SongSheetInfo?.trackCount:
                          AlbumInfo!.songs.length==AlbumInfo?.album.size) ?100:70,
                              alignment: Alignment.center,
                              child:
                              (SongSheetInfo!=null?
                              ListController.songList?.length!=SongSheetInfo!.cloudTrackCount+SongSheetInfo!.trackCount:AlbumInfo!.songs.length!=AlbumInfo?.album.size)?
                              CircularProgressIndicator(color: Colors.red,strokeWidth: 1,)
                                  :Container());
                        })

                    )
                  ],
                ),
              );
          }),
        ) ,
      ) ) :Container(color: Colors.white,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: Colors.red,strokeWidth: 1));
  }

  getData(String id)  async {
    dioRequest = DioRequest();
    switch (widget.data['type']) {
      case"to_recommend_song_sheet":
      case"to_my_page_song_list":
      case"to_page_song_list":
        var SongSheet = await dioRequest.executeGet(url: "/playlist/detail",params: {"id":id});
        var SList =  await dioRequest.executeGet(url: "/playlist/track/all",params: {"id":id,"limit":20,"offset":0});

        Future.microtask((){
          if(SongSheet!=null&&SList!=null){
            pageController.pageIsOk = true;

            setState(() {
              if(  AlbumInfo!=null)AlbumInfo=null;
              SongSheetInfo = SongSheetList.fromJson(SongSheet);

            });
            ListController.SongList = (SList['songs'] as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList();
          }

        });
        break;
      case "to_sing_and_albums":
      case "to_albums":
        var album =   await dioRequest.executeGet(url: "/album",params: {"id":widget.data['id']});
        setState(() {
          if(SongSheetInfo!=null) {
            SongSheetInfo = null;
            SongList = null;
          }
          AlbumInfo = AlbumListBean.fromJson(album);
        });
        pageController.pageIsOk = true;
        break;
    }


  }


  static  cancelRequest() {
    dioRequest.cancelToken();
  }



  void addMoreList() async {
    var SList =  await dioRequest.executeGet(url: "/playlist/track/all",params: {"id":widget.data['id'],"limit":100,"offset": ListController.songList?.length});
    ListController.addSongList( (SList['songs'] as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList());
    // setState(() {
    //
    // });
  }

}

