

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misic_module/bean/AlbumListBean.dart';

import 'package:get/get.dart';




import '../NetWork/DioRequest.dart';
import '../bean/SongSheetList.dart';
import '../bean/songListBean.dart';
import '../main.dart';

import '../util/Utils.dart';
import 'myPage.dart';
import 'myPageController.dart';
import 'songListController.dart';

class songListPage extends StatefulWidget{
  final Map data;

  songListPage({super.key,required this.data});

  @override
  State<StatefulWidget> createState() {

    return songListPageState();
  }

}
class songListPageState extends State<songListPage>{
  var ListController =  songListController();
  var pageController = Get.find<PageControllers>();



int lastId = 0;
int index = 0;

 double  expandedHeight = 0.0;
 late  MediaQueryData mediaQuery ;
 late  double width ;
 late  double height ;
late  double eHeight;
 static var  dioRequest;
var type ;



  @override
  void didUpdateWidget(covariant songListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    pageController.pageIsOk = false;
    type =widget.data['type'];
    print("1111111111111111111111111111111${type}");
    getData(widget.data['id']);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // _scrollController = ScrollController();
  //  _scrollController.addListener(_onScroll);
    getData(widget.data['id']);
    type =widget.data['type'];

  }

 // void _onScroll() {
 //  expandedHeight = _scrollController.offset;
 //  print("object${expandedHeight}");
 //  if(expandedHeight>eHeight/2){
 //    setState(() {
 //    });
 //  }else if(expandedHeight<=eHeight/2){
 //    setState(() {
 //    });
 //  }
 //
 //
 // }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

   //_scrollController.removeListener(_onScroll);
   // _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    eHeight =  height/2-120;
    var statusHeight = mediaQuery.padding.top + kToolbarHeight;
    // TODO: implement build
   return Obx((){
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
                         var p;

                         if(widget.data['type']=="to_sheet"){
                           Navigator.pop(context);
                           // channel.invokeMethod("back",{"origin":"to_sheet"});
                           // pageController.pageIsOk = false;return;
                         }
                         pageController.pageIsOk = false;


                         // if(widget.data['type']=="to_my_page_song_list"){
                         //   Navigator.pop(context);
                         //   p= {"origin":"my_page"};
                         // }else
                         p = {"origin":"other_page"};
                         channel.invokeMethod("back",p);
                       },
                           label: Text("${type=="to_recommend_song"?"每日推荐":widget.data['title']!=null?expandedHeight>eHeight/2?widget.data['title']:"歌单":ListController.albumInfo!=null?(expandedHeight>eHeight/2?ListController.albumInfo?.album.name:"专辑")
                               :( ListController.songSheet?.detailPageTitle==null?expandedHeight>eHeight/2? ListController.songSheet?.name:"歌单":
                           expandedHeight>eHeight/2? ListController.songSheet?.name:"官方歌单")}",
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
                   visible:ListController.albumInfo==null ,
                   child:   GestureDetector(
                     child: Image.asset("images/search.png",fit: BoxFit.cover,width: 45,height: 45,),
                   ))

             ],
           ),
         ),


       ),
       body:
       NestedScrollView(
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
                   type=="to_recommend_song"?Container(child: getSquareImg(Url: ListController.songList![0].al.picUrl,height:height/2-100 ,width: double.infinity,),):
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
                                           child: getSquareImg(Url:ListController.albumInfo!=null ? ListController.albumInfo!.album.blurPicUrl :  ListController.songSheet!.coverImgUrl,width:100 ,height: 110 ,)
                                         //Image.asset("images/img.png",fit: BoxFit.cover,),
                                       ),
                                     ),
                                     Visibility(
                                         visible: ListController.albumInfo==null,
                                         child: Container(
                                           padding: EdgeInsets.only(top: 10,right: 10),
                                           alignment: Alignment.topRight,
                                           width: 100,
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.end,
                                             children: [
                                               Icon(Icons.play_arrow,color: Colors.white,size: 20,),
                                               Text("${Utils.formatNumber(ListController.albumInfo==null? ListController.songSheet!.playCount:0)}",style: TextStyle(fontSize: 10,color: Colors.white,))
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
                                                 "${widget.data['title']!=null?widget.data['title']:ListController.albumInfo!=null?ListController.albumInfo?.album.name :  ListController.songSheet?.name}",
                                                 style: TextStyle(fontWeight: FontWeight.bold,fontSize:14 ),
                                                 maxLines: 2,overflow: TextOverflow.ellipsis)),
                                         Visibility(
                                             visible: ListController.albumInfo  !=null,
                                             child: Text("歌手:${ListController.albumInfo!=null?Utils.getSubTitle(ListController.albumInfo?.album.artists):""}>",
                                               style: const TextStyle(fontSize:12,color: Colors.black )
                                               ,overflow: TextOverflow.ellipsis,maxLines: 1,))],
                                     ),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Visibility(
                                           visible:ListController.albumInfo!=null ,
                                           child:  Text("发行时间:${ListController.albumInfo!=null?Utils.formatDate(ListController.albumInfo!.album.publishTime):""}",style: TextStyle(fontSize:12,color: Colors.grey )),
                                         ),
                                         Visibility(
                                             visible:ListController.albumInfo!=null  ,
                                             child: GestureDetector(
                                               child: Text("${ListController.albumInfo!=null?ListController.albumInfo?.album.description:""}>",style: TextStyle(fontSize:12,color: Colors.grey ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                             ))
                                         ,
                                         Visibility(
                                             visible: ListController.albumInfo==null,
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
                                 visible:   ListController.songSheet?.description!=null|| ListController.songSheet?.userId== ListController.songSheet?.creator.userId,
                                 child: Text(" ${ ListController.songSheet?.userId== ListController.songSheet?.creator.userId&& ListController.songSheet?.description=="" ?"编辑信息": ListController.songSheet?.description }>",style: TextStyle(fontSize:12,color: Colors.black ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                           )
                           ,
                           Padding(padding: EdgeInsets.only(top: 10),
                             child: Row(
                               children: [
                                 Expanded(
                                     flex: 1,
                                     child: TextButton.icon(
                                       style: TextButton.styleFrom(
                                         backgroundColor: Colors.white70
                                       ),
                                         onPressed: (){}, label: Text(Utils.formatNumber(ListController.albumInfo!=null?ListController.albumInfo!.album.info.shareCount: ListController.songSheet!.shareCount)),icon: Icon(Icons.telegram,color:Colors.white,size:24),),
                                     ),
                                 const SizedBox(width: 8),
                                 Expanded(
                                     flex: 1,
                                     child:  TextButton.icon(
                                       style: TextButton.styleFrom(
                                           backgroundColor: Colors.white70
                                       ),
                                         onPressed: (){}, label: Text(Utils.formatNumber(ListController.albumInfo!=null?ListController.albumInfo!.album.info.commentCount: ListController.songSheet!.commentCount)),icon: const Icon(Icons.question_answer_rounded,color:Colors.white,size:24),),
                                     ),
                                 const SizedBox(width: 8),
                                 Expanded(
                                     flex: 1,
                                     child: TextButton.icon(
                                       style: TextButton.styleFrom(
                                           backgroundColor: Colors.white70
                                       ),
                                         onPressed: (){}, label: Text(Utils.formatNumber(ListController.albumInfo!=null?ListController.albumInfo!.album.info.likedCount: ListController.songSheet!.subscribedCount)),icon: const Icon(Icons.add_box,color:Colors.white,size:24,),),
                                     ),
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
                           label: Text("播放全部(${type=="to_recommend_song"?ListController.songList.length:ListController.albumInfo!=null?ListController.albumInfo!.songs.length: ListController.songSheet!.cloudTrackCount+ ListController.songSheet!.trackCount})",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color:Colors.black),),
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
                     print('ListView is at the bottom');
                    if (type=="to_recommend_song")return true;
                     if( ListController.songList?.length!= ListController.songSheet?.trackCount) {
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
                              childCount:type=="to_recommend_song"?ListController.songList.length: ListController.albumInfo!=null?ListController.albumInfo!.songs.length:ListController.songList?.length,
                                  (context,index){
                                if(ListController.albumInfo!=null){
                                  ListController.albumInfo?.songs[index].al.pic(ListController.albumInfo!.album.picUrl);
                                }

                                return ListController.albumInfo==null?
                                Container(
                                  color: Colors.white,
                                  child:  ListTile(
                                    leading:type=="to_recommend_song"?getSquareImg(Url: ListController.songList![index].al.picUrl,height:55 ,width: 55): Text("${index+1}"),
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
                                        "title":type=="to_recommend_song"?"每日推荐":widget.data['title']!=null?widget.data['title']: ListController.songSheet?.name,
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
                                    title: Text(ListController.albumInfo!.songs[index].name,maxLines: 1,),
                                    titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                        overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                                    subtitle:Text(Utils.getSubTitle(ListController.albumInfo?.songs[index].ar),maxLines: 1,) ,
                                    subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
                                        overflow: TextOverflow.ellipsis),
                                    trailing: Image.asset("images/more.png",width: 20,height: 20,),
                                    onTap: (){

                                      if( lastId==ListController.albumInfo!.songs[index].id) {
                                        return;
                                      }

                                      lastId = ListController.albumInfo!.songs[index].id;
                                      channel.invokeMethod("sendAlbum",{
                                        "title":widget.data['title']!=null?widget.data['title']:ListController.albumInfo!.album.name,
                                        "SongIndex":index,
                                        "SongList":jsonEncode(ListController.albumInfo?.songs)
                                      });
                                    },
                                  ),
                                ) ;


                              }
                          ),
                          itemExtent: type=="to_recommend_song"?70:55,
                        );
                      }),




                     SliverToBoxAdapter(
                         child:
                         type=="to_recommend_song"?SizedBox(height: 100,):  Obx((){
                           return
                             Container(
                                 color: Colors.white,
                                 width: 70,height: ListController.songList?.length== ListController.songSheet?.trackCount||
                                 ListController.songList.length==ListController.albumInfo?.album.size?100:70,
                                 alignment: Alignment.center,
                                 child:
                                 ( ListController.songSheet!=null?
                                 ListController.songList?.length!= ListController.songSheet!.cloudTrackCount+ ListController.songSheet!.trackCount:ListController.albumInfo!.songs.length!=ListController.albumInfo?.album.size)?
                                 CircularProgressIndicator(color: Colors.red,strokeWidth: 1,)
                                     :Container());
                         })

                     )
                   ],
                 ),
               );
           }),
         ) ,
       ) )
         :Container(color: Colors.white,
         alignment: Alignment.center,
         child: CircularProgressIndicator(color: Colors.red,strokeWidth: 1));
    });

  }

   getData(String id)  async {
      dioRequest = DioRequest();
    switch (widget.data['type']) {
      case"to_recommend_song_sheet":
    case "to_exclusive_scene_song_sheet":
    case "to_music_radar_song_sheet":
      case"to_my_page_song_list":
      case "to_sheet":
      var SongSheet = await dioRequest.executeGet(url: "/playlist/detail",params: {"id":id});
      var SList =  await dioRequest.executeGet(url: "/playlist/track/all",params: {"id":id,"limit":20});

      Future.microtask((){
        pageController.pageIsOk = true;
        if(SongSheet!=null&&SList!=null){
          setState(() {
          if(  ListController.albumInfo!=null)ListController.AlbumInfo=null;
             ListController.SongSheet = SongSheetList.fromJson(SongSheet);
          });
          ListController.SongList = (SList['songs'] as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList();
        }
        
      });
      break;
      case "to_sing_and_albums":
        var album =   await dioRequest.executeGet(url: "/album",params: {"id":widget.data['id']});
        setState(() {
          if( ListController.songSheet!=null) {
             ListController.SongSheet = null;
          }
          
          ListController.remove();
          ListController.AlbumInfo = AlbumListBean.fromJson(album);
        });
        pageController.pageIsOk = true;
        break;
      case "to_recommend_song":
        var SList =  await dioRequest.executeGet(url: "/recommend/songs");
        print(SList);
        ListController.SongList = (SList['dailySongs'] as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList();
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

  }

}

