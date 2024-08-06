

import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misic_module/bean/AlbumListBean.dart';
import 'package:flutter_misic_module/bean/UserInfoBean.dart';
import 'package:flutter_misic_module/page/msgListPage.dart';

import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';




import '../NetWork/DioRequest.dart';
import '../bean/SongSheetList.dart';
import '../bean/SongListBean.dart';
import '../main.dart';

import '../util/Utils.dart';
import 'myPage.dart';
import 'myPageController.dart';
import 'songListController.dart';

class songListPage extends StatefulWidget{
  final Map data;

  songListPage({super.key,required this.data});

  @override
  songListPageState createState() => songListPageState();


}
class songListPageState extends State<songListPage>{
  final GlobalKey<songListPageState> _childKey = GlobalKey();
  var ListController =  songListController();
  var pageController = Get.find<PageControllers>();

  final FocusNode _focusNode = FocusNode();

  late TextEditingController _textEditingController;

int lastId = 0;
int index = 0;

 double  expandedHeight = 0.0;
 late  MediaQueryData mediaQuery  = MediaQueryData();
 late  double width = 0 ;
 late  double height  = 0;
late  double eHeight = 0;
late double statusHeight = 0;
 static var  dioRequest;
var type ;
  final ScrollController _scrollController = ScrollController();



 Future<bool> isPop() async{
 if (ListController.isSearch) {
      ListController.isSearch = false;
      return false;
    }
    if (ListController.isShow) {
      ListController.isShow = false;
      return false;
    }
 if(ListController.isOpenSheet){
   ListController.isOpenSheet = false;
   Navigator.pop(context);
   return false;
 }
 if(pageController.isOpenCommentPage){
   Navigator.pop(context);
   return false;
 }
 if (widget.data['type']=="to_ranking") {
   Navigator.pop(context);
   return false;
 }
 var p = {"origin":"other_page"};
 await channel.invokeMethod("back",p);
 pageController.pageIsOk =false;
 return true;
  }

  @override
  void didUpdateWidget(covariant songListPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    pageController.pageIsOk = false;
    type =widget.data['type'];
    getData(widget.data['id']);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      mediaQuery = MediaQuery.of(context);

      width = mediaQuery.size.width;
      height = mediaQuery.size.height;
      eHeight =  height/2-120;
      statusHeight  = mediaQuery.padding.top + kToolbarHeight;
      setState(() {

      });
    });
    getData(widget.data['id']);
    type =widget.data['type'];
    _textEditingController = TextEditingController();
    _textEditingController.addListener((){
      ListController.text = _textEditingController.text;
        ListController.isContain = isContains();

    });
    _scrollController.addListener(_scrollListener);
  }
  void _scrollListener() {

    ListController.expandedHeight = _scrollController.offset;

  }


 @override
  void dispose() {
    // TODO: implement dispose
   _scrollController.removeListener(_scrollListener);
   _scrollController.dispose();
   ListController.albumInfo=null;
   ListController.songSheet = null;
   ListController.songList = [];
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {


    // TODO: implement build
   return Stack(
     key: _childKey,
     children: [
       Obx((){
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
                     Container(
                             alignment: Alignment.centerLeft,
                             child:
                             TextButton.icon(onPressed: (){
                                var p;
                                if( ListController.isSearch) {
                                  ListController.isSearch = false;
                                  return;
                                }
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
                                  label:Obx((){
                                    return ListController.isSearch?const Text(""):
                                    Text("${type=="to_recommend_song"?"每日推荐":widget.data['title']!=null?expandedHeight>eHeight/2?widget.data['title']:"歌单":ListController.albumInfo!=null?(expandedHeight>eHeight/2?ListController.albumInfo?.album.name:"专辑")
                                        :( ListController.songSheet?.detailPageTitle==null?expandedHeight>eHeight/2? ListController.songSheet?.name:"歌单":
                                    expandedHeight>eHeight/2? ListController.songSheet?.name:"官方歌单")}",
                                      style: TextStyle(fontSize: 16,color: Colors.black),);
                                  }),
                                  icon:const Icon(Icons.arrow_back, color: Colors.black) )
                         ),
                     Visibility(
                         visible: ListController.isSearch,
                         child: Expanded(
                           flex: 6,
                           child:  Container(

                             padding:  EdgeInsets.all(6),
                             decoration: const BoxDecoration(
                                 border: Border(bottom:BorderSide(color: Colors.black,width: 2) )
                             ),
                             child:  TextField(
                                 maxLines: 1,
                                 focusNode: _focusNode,
                                 controller: _textEditingController,
                                 textInputAction: TextInputAction.search,
                                 onSubmitted: (value){

                                 },
                                 decoration: const InputDecoration(
                                   hintText: "搜索歌单内歌曲",
                                   isCollapsed: true,
                                   hintStyle: TextStyle(color: Colors.grey),
                                   contentPadding: EdgeInsets.symmetric(vertical: -4),
                                   border:InputBorder.none, )
                             ),
                           ),
                         )),
                    type=="to_recommend_song" ?const SizedBox():Visibility(
                         visible:ListController.albumInfo==null&&!ListController.isSearch ,
                         child:   GestureDetector(
                           onTap: (){
                             ListController.isSearch = true;
                             _focusNode.requestFocus();
                           },
                           child: Image.asset("images/search.png",fit: BoxFit.cover,width: 45,height: 45,),
                         ))

                   ],
                 ),
               ),


             ),
             body:
                 PopScope(
                  onPopInvoked: (_){
                    if (type =="to_ranking") {

                      return;
                    }
                    pageController.pageIsOk =false;
                  },
                   child: Stack(
                     children: [
                       NestedScrollView(
                         controller: _scrollController,
                         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
                           return [
                             SliverOverlapAbsorber(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                               sliver: SliverAppBar(
                                 backgroundColor: type=="to_recommend_song"?Colors.white: ListController.imgColor,
                                 pinned: true,
                                 scrolledUnderElevation: 0.0,
                                 forceElevated: innerBoxIsScrolled,
                                 toolbarHeight: 0,
                                 expandedHeight: height/2-100,
                                 flexibleSpace: FlexibleSpaceBar(
                                   // collapseMode: CollapseMode.pin,
                                   background:
                                   type=="to_recommend_song"?
                                   Container(child: getSquareImg(Url: ListController.songList[0].al.picUrl,height:height/2-100 ,width: double.infinity,),):
                                   Stack(
                                     children: <Widget>[
                                       Positioned.fill(
                                         child: Container(color: ListController.imgColor,),
                                       ),
                                       Container(
                                         alignment: Alignment.center,
                                         margin: EdgeInsets.only(top: statusHeight+16,left: 20,right: 20),
                                         child:  Column(children: [
                                           Row(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Container(
                                                 width: 100,height:  110,
                                                 child:
                                                 GestureDetector(
                                                   onTap: (){
                                                     ListController.isShow = true;
                                                   },
                                                   child: Stack(
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
                                                             child: getSquareImg(Url:ListController.albumInfo!=null ? ListController.albumInfo!.album.blurPicUrl :  ListController.songSheet!.coverImgUrl,width:110 ,height: 100 ,)
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
                                                                 Text("${Utils.formatNumber(ListController.albumInfo==null? ListController.songSheet!.playCount:0,"")}",style: TextStyle(fontSize: 10,color: Colors.white,))
                                                               ],
                                                             ),
                                                           ) )

                                                     ],
                                                   ),
                                                 )
                                                 ,
                                               ),
                                               Container(
                                                 height: 110,
                                                 width: width-140,
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
                                                             child: InkWell(
                                                               onTap: (){
                                                                 showCreator();
                                                               },
                                                               child: Text("歌手:${ListController.albumInfo!=null?Utils.getSubTitle(ListController.albumInfo?.album.artists):""}>",
                                                                 style: const TextStyle(fontSize:12,color: Colors.black )
                                                                 ,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                             ))],
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
                                                         ListController.albumInfo!=null?const SizedBox():  Obx((){
                                                           List<Widget> list=[];
                                                           if( ListController.songSheet!.sharedUsers.length!=0){
                                                             list=  ListController.songSheet!.sharedUsers.asMap().entries.map((entry){
                                                               int index = entry.key;
                                                               UserInfoBean user = entry.value;
                                                               if(index>=2)return SizedBox();
                                                               return Positioned(
                                                                   right: ListController.songSheet!.sharedUsers.length>=2?(index+1)*10:index*15,
                                                                   child:  Container(
                                                                     //  margin: EdgeInsets.only(right: ListController.songSheet!.sharedUsers.length>=2?20:0),
                                                                     width: 30,height: 30,
                                                                     alignment: Alignment.topCenter,
                                                                     decoration: BoxDecoration(
                                                                       border: Border.all(color:Colors.white,width: 1),
                                                                       borderRadius: BorderRadius.circular(100),

                                                                     ),
                                                                     child: getCircularImg(url: user.avatarUrl,size: 30,),
                                                                   ));
                                                             }).toList();

                                                             list.add(Container(
                                                               width: 30,height: 30,
                                                               decoration: BoxDecoration(

                                                                   border: Border.all(color: Colors.white,width: 1),
                                                                   borderRadius: BorderRadius.circular(100)
                                                               ),
                                                               child:getCircularImg(url: ListController.songSheet!.creator.avatarUrl),
                                                             ));

                                                           }

                                                           return ListController.albumInfo!=null?SizedBox():
                                                           GestureDetector(
                                                               onTap: ()  {
                                                                 channel.invokeMethod("hideOrShowView",true).then((_){
                                                                   ListController.isOpenSheet = true;
                                                                   showCreator();
                                                                 });

                                                               },
                                                               child:
                                                               Row(
                                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                                 children: [
                                                                   Container(
                                                                     width:ListController.songSheet!.sharedUsers.length==0?null:60 ,
                                                                     child: Stack(
                                                                         children:
                                                                         ListController.songSheet!.sharedUsers.length==0?[Container(
                                                                           width: 30,height: 30,
                                                                           decoration: BoxDecoration(

                                                                               border: Border.all(color: Colors.white,width: 1),
                                                                               borderRadius: BorderRadius.circular(100)
                                                                           ),
                                                                           child:getCircularImg(url: ListController.songSheet!.creator.avatarUrl,size: 30,),
                                                                         )]:
                                                                         list
                                                                     ),
                                                                   ),
                                                                   Flexible(
                                                                       child:
                                                                       Container(
                                                                         //width: double.infinity,

                                                                           child: Text("  ${ListController.songSheet!.sharedUsers.length==0?ListController.songSheet!.creator.nickname:
                                                                           "${ListController.songSheet!.creator.nickname}等${ListController.songSheet!.sharedUsers.length+1}人"}>",style: TextStyle(fontSize:12,color: Colors.black ),overflow: TextOverflow.ellipsis,maxLines: 1,)
                                                                       )
                                                                   )


                                                                 ],));
                                                         })
                                                       ],
                                                     ),


                                                   ],
                                                 ),
                                               ),
                                             ],
                                           ),
                                           Visibility(
                                               visible:ListController.albumInfo==null ,
                                               child: InkWell(
                                                 onTap: (){
                                                   ListController.isShow = true;
                                                 },
                                                 child:  Container(
                                                   margin: const EdgeInsets.only(top: 10),
                                                   width: double.infinity,
                                                   alignment: Alignment.centerLeft,
                                                   child:Visibility(
                                                       visible:   ListController.songSheet?.description!="",
                                                       child: Text(" ${  ListController.songSheet?.description }>",style: TextStyle(fontSize:12,color: Colors.black ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                 ),
                                               )),
                                           Padding(padding: EdgeInsets.only(top: 10),
                                             child: Row(
                                               children: [
                                                 Expanded(
                                                   flex: 1,
                                                   child: TextButton.icon(
                                                     style: TextButton.styleFrom(
                                                         padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
                                                         backgroundColor: Colors.white70
                                                     ),
                                                     onPressed: (){
                                                       var p ;
                                                       if (ListController.albumInfo!=null) {
                                                         p =  {"id":ListController.albumInfo!.album.id,"type":"album",
                                                           "img":ListController.albumInfo!.album.blurPicUrl,
                                                           "title":ListController.albumInfo!.album.name,
                                                           "subTitle":"歌手:${Utils.getSubTitle(ListController.albumInfo?.album.artists)}"};
                                                       }else{
                                                         p =  {"id":ListController.songSheet!.id,"type":"playlist",
                                                           "img": ListController.songSheet!.coverImgUrl,"title":ListController.songSheet!.name,
                                                           "subTitle":"创建者:${ListController.songSheet!.creator.nickname}"};
                                                       }
                                                       ListController.isOpenSheet = true;
                                                       channel.invokeMethod("hideOrShowView",true);
                                                       Navigator.pushNamed(context, "main/sendPage",arguments: p);

                                                     }, label: Text(maxLines: 1,style: TextStyle(fontSize: 14,color: Colors.black),
                                                       Utils.formatNumber(ListController.albumInfo!=null?ListController.albumInfo!.album.info.shareCount:ListController.songSheet!.shareCount,"分享")
                                                   ),icon: Icon(Icons.telegram,color:Colors.white,size:24),),
                                                 ),
                                                 const SizedBox(width: 8),
                                                 Expanded(
                                                   flex: 1,
                                                   child:  TextButton.icon(
                                                     style: TextButton.styleFrom(

                                                         padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                                         backgroundColor: Colors.white70
                                                     ),
                                                     onPressed: (){
                                                       var p ;
                                                       if (ListController.albumInfo!=null) {
                                                         p={"Id":ListController.albumInfo!.album.id,"commentType":3,
                                                           "userId":pageController.userId,"imgUrl":ListController.albumInfo!.album.blurPicUrl,
                                                           "songName":ListController.albumInfo!.album.name,
                                                           "singerName":Utils.getSubTitle(ListController.albumInfo?.album.artists)};
                                                       }else{
                                                         p ={"Id":ListController.songSheet!.id,
                                                           "commentType":2,"userId":pageController.userId,
                                                           "imgUrl":ListController.songSheet!.coverImgUrl,
                                                           "songName":ListController.songSheet!.name,
                                                           "singerName":ListController.songSheet!.creator.nickname};
                                                       }
                                                       pageController.isOpenCommentPage = true;
                                                       Navigator.pushNamed(context, "main/CommentPage",arguments: p);
                                                       channel.invokeMethod("hideOrShowView",true);

                                                     }, label: Text(
                                                       maxLines: 1,style:  TextStyle(fontSize: 14,color: Colors.black),
                                                       Utils.formatNumber(
                                                           ListController.albumInfo!=null?
                                                           ListController.albumInfo!.album.info.commentCount:ListController.songSheet!.commentCount,"评论")
                                                   ),icon: const Icon(Icons.question_answer_rounded,color:Colors.white,size:24),),
                                                 ),
                                                 const SizedBox(width: 8),
                                                 Expanded(
                                                   flex: 1,
                                                   child: TextButton.icon(

                                                       style: TextButton.styleFrom(
                                                           padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                                                           backgroundColor: Colors.white70
                                                       ),
                                                       onPressed: (){
                                                         //必选参数：歌单
                                                         //t ：类型，1：收藏，2：取消收藏
                                                         ListController.isOpenSheet =  true;
                                                         if(ListController.albumInfo!=null){
                                                           if (ListController.albumInfo!.album.info.liked) {
                                                             _showAlertDialog( "album");
                                                           }else{
                                                             ListController.setLiked(true);
                                                             dioRequest.executeGet(url: '/album/sub',params: {'t':1,'id':ListController.albumInfo!.album.id});
                                                           }
                                                         }else{
                                                           if (ListController.songSheet!.subscribed) {

                                                             _showAlertDialog( "sheet");
                                                           }else{
                                                             ListController.setLiked(true);
                                                             //ListController.songSheet!.subscribed = true;
                                                             dioRequest.executeGet(url: '/playlist/subscribe',params: {'t':1,'id':ListController.songSheet!.id});

                                                           }
                                                         }

                                                         ///playlist/subscribe?t=1&id=196697785
                                                         //专辑：
                                                         ///album/sub?t=1&id=

                                                       }, label: Text(
                                                       maxLines: 1,style:  TextStyle(fontSize: 14,color: Colors.black),
                                                       Utils.formatNumber(
                                                           ListController.albumInfo!=null?
                                                           ListController.albumInfo!.album.info.likedCount:ListController.songSheet!.subscribedCount,"收藏")
                                                   ),icon:Obx((){
                                                     return ListController.albumInfo!=null?
                                                     ListController.albumInfo!.album.info.liked?  Icon(Icons.library_add_check,color: Colors.redAccent,size: 24,)
                                                         :Icon(Icons.add_box,color:Colors.white,size:24,)
                                                         : ListController.songSheet!.subscribed?Icon(Icons.library_add_check,color: Colors.redAccent,size: 24,)
                                                         :Icon(Icons.add_box,color:Colors.white,size:24,);
                                                   })),
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
                                     if( ListController.songList.length!= ListController.songSheet?.trackCount) {
                                       if(!ListController.showSongsIsOk)  addMoreList();
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
                                                   leading:type=="to_recommend_song"?getSquareImg(Url: ListController.songList[index].al.picUrl,height:55 ,width: 55): Text("${index+1}"),
                                                   title: Text(ListController.songList[index].name,maxLines: 1,),
                                                   titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                                       overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                                                   subtitle:Text(
                                                     "${Utils.getSubTitle(ListController.songList[index].ar)}-${ListController.songList[index].al.name!=""?ListController.songList[index].al.name:""}",maxLines: 1,) ,
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
                                                 width: 70,height: ListController.songList.length== ListController.songSheet?.trackCount||
                                                 ListController.songList.length==ListController.albumInfo?.album.size?100:70,
                                                 alignment: Alignment.center,
                                                 child:
                                                 ( ListController.songSheet!=null?
                                                 ListController.songList.length!= ListController.songSheet!.cloudTrackCount+ ListController.songSheet!.trackCount:ListController.albumInfo!.songs.length!=ListController.albumInfo?.album.size)?
                                                 CircularProgressIndicator(color: Colors.red,strokeWidth: 1,)
                                                     :Container());
                                         })

                                     )
                                   ],
                                 ),
                               );
                           }),
                         ) ,
                       ),

                       Visibility(
                           visible: ListController.isSearch,
                           child:  Obx((){
                             return ListController.text!=""? Container(color: Colors.white,
                               child:
                               ListView.builder(
                                   itemCount:ListController.songList.length,

                                   itemBuilder: (context,index){
                                     return ListController.albumInfo==null?
                                     _focusNode.hasFocus&&_textEditingController.text.isNotEmpty ?
                                     ListController.songList[index].name.contains( _textEditingController.text)
                                         || ListController.songList[index].ar.any((u) => u.name.contains( _textEditingController.text))
                                         || ListController.songList[index].al.name.contains( _textEditingController.text)?
                                     Container(
                                       height:   type=="to_recommend_song"?70:55,
                                       color: Colors.white,
                                       child:  ListTile(
                                         leading:type=="to_recommend_song"?getSquareImg(Url: ListController.songList[index].al.picUrl,height:55 ,width: 55): Text("${index+1}"),
                                         title: Text(ListController.songList[index].name,maxLines: 1,),
                                         titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                             overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                                         subtitle:Text(
                                           "${Utils.getSubTitle(ListController.songList[index].ar)}${ListController.songList[index].al.name!=""?"-${ListController.songList[index].al.name}":""}",maxLines: 1,) ,
                                         subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
                                             overflow: TextOverflow.ellipsis),
                                         trailing: Image.asset("images/more.png",width: 20,height: 20,),
                                         onTap: (){
                                           if(lastId==ListController.songList[index].id) return;
                                           lastId = ListController.songList[index].id;

                                           channel.invokeMethod("sendSongList",{
                                             "title":type=="to_recommend_song"?"每日推荐":widget.data['title']!=""?widget.data['title']: ListController.songSheet?.name,
                                             "SongIndex":index,
                                             "SongList":jsonEncode(ListController.songList)
                                           });
                                         },
                                       ),
                                     ): const SizedBox(): const SizedBox()
                                         :

                                     Container(
                                       color: Colors.white,
                                       child:  ListTile(
                                         leading: Text("${index+1}"),
                                         title: Text(ListController.albumInfo!.songs[index].name,maxLines: 1,),
                                         titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
                                             overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
                                         subtitle:Text("${Utils.getSubTitle(ListController.albumInfo?.songs[index].ar)}${ListController.albumInfo?.songs[index].al.name!=""?"-${ListController.albumInfo?.songs[index].al.name}":""}",maxLines: 1,) ,
                                         subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
                                             overflow: TextOverflow.ellipsis),
                                         trailing: Image.asset("images/more.png",width: 20,height: 20,),
                                         onTap: (){

                                           if( lastId==ListController.albumInfo!.songs[index].id) {
                                             return;
                                           }

                                           lastId = ListController.albumInfo!.songs[index].id;
                                           channel.invokeMethod("sendAlbum",{
                                             "title":widget.data['title']!=""?widget.data['title']:ListController.albumInfo!.album.name,
                                             "SongIndex":index,
                                             "SongList":jsonEncode(ListController.albumInfo?.songs)
                                           });
                                         },
                                       ),
                                     );
                                     //:!ListController.isContain?Center(child: Text("暂无搜索结果"),): const SizedBox();
                                   }),
                             ):Container(color: Colors.white,);
                           })),
                       Obx((){
                         return !ListController.isContain&&ListController.text!=""?Center(child: Text("暂无搜索结果"))
                             :SizedBox();
                       })


                     ],
                   ),
                 )



         )
             :Container(color: Colors.white,
             alignment: Alignment.center,
             child: CircularProgressIndicator(color: Colors.red,strokeWidth: 1));
       }),
      type=="to_recommend_song"?const SizedBox(): Obx((){
      return pageController.pageIsOk?  Visibility(
        visible: ListController.isShow,
           child: Scaffold(
             backgroundColor: ListController.imgColor,
             appBar: AppBar(
               scrolledUnderElevation:0.0,
               backgroundColor: ListController.imgColor,
               actions: [IconButton(onPressed: (){
                 ListController.isShow = false;
               }, icon:const Icon( Icons.dangerous_outlined))],),
             body:
               Stack(
                 children: [
                   Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: SingleChildScrollView(
                     child: Column(children: [
                       Center(
                         child:  getSquareImg(Url:ListController.albumInfo!=null ?
                         ListController.albumInfo!.album.blurPicUrl :
                         ListController.songSheet!.coverImgUrl, width: width-80, height: height/2-100),
                       ),
                       ListTile(title:  Text(textAlign: TextAlign.center,
                         "${widget.data['title']!=null?widget.data['title']:ListController.albumInfo!=null?ListController.albumInfo?.album.name :  ListController.songSheet?.name}",
                         style: TextStyle(fontWeight: FontWeight.bold,fontSize:16 ),
                       ),),
                       Text(
                           style: TextStyle(fontSize: 12,color: Colors.black),
                           " ${ListController.albumInfo!=null?
                           ListController.albumInfo!.album.description==""?"暂无描述":ListController.albumInfo!.album.description
                               :ListController.songSheet?.description==""?"暂无描述":ListController.songSheet?.description}")

                     ],),
                   ) ,),
                   Align(
                     alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        width: width,
                        color: Colors.black45,
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: TextButton(
                            onPressed: () async {
                              var url = ListController.albumInfo!=null ?
                              ListController.albumInfo!.album.blurPicUrl :
                              ListController.songSheet!.coverImgUrl;
                              // 按钮点击事件
                             if(await Utils.requestPermission({"info":url})){
                               pageController.path ??= await channel.invokeMethod("getPath");
                               Utils.downloadImage(url,pageController.path).then((flag){
                                 Utils.showTopSnackBar(context, "下载${flag?"成功":"失败"}");
                               });
                             }

                            },
                            child: Text('保存封面',style: TextStyle(color: Colors.white),),
                            style: TextButton.styleFrom(

                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              backgroundColor: Colors.transparent, // 设置背景颜色为透明
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(20), // 设置圆角半径
                              ),
                            ),
                          ),
                        ),
                      ),
                   )
                 ],
               ),

           ),
         ):SizedBox();
       })
     ],
   );

  }
  _showAlertDialog(String type) async{
    await  showDialog(context: context, builder: (context){
      return  AlertDialog(
        actionsAlignment: MainAxisAlignment.end,

        title: Text("确定要取消收藏？",style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            child: Text("是",style: TextStyle(color: Colors.red)),
            onPressed: () {
              switch(type){
                case"album":

                  ListController.setLiked(false);
                  dioRequest.executeGet(url: '/album/sub',params: {'t':2,'id':ListController.albumInfo!.album.id});
                  break;
                case"sheet":
                  ListController.setLiked(false);
                  dioRequest.executeGet(url: '/playlist/subscribe',params: {'t':2,'id':ListController.songSheet!.id});
                  break;
              }
              Navigator.of(context).pop();

            },
          ),
          // “否”按钮
          TextButton(
            child: Text("否",style: TextStyle(color: Colors.black)),
            onPressed: () {

              Navigator.of(context).pop();


            },
          ),
        ],

      );
    });

  }
 show(bool flag){

  Utils.showTopSnackBar(context, "下载${flag?"成功":"失败"}");
}
   getData(String id)  async {

      dioRequest = DioRequest();
    switch (widget.data['type']) {
      case"to_recommend_song_sheet":
    case "to_exclusive_scene_song_sheet":
    case "to_music_radar_song_sheet":
      case"to_my_page_song_list":
      case "to_sheet":
      case"to_ranking":
      var SongSheet = await dioRequest.executeGet(url: "/playlist/detail",params: {"id":id});
      var SList =  await dioRequest.executeGet(url: "/playlist/track/all",params: {"id":id,"limit":20});

      Future.microtask(() async {
        print("object----------${SongSheet}");

        if(SongSheet!="error"&&SList!="error"){

          if(  ListController.albumInfo!=null)ListController.albumInfo=null;
             ListController.songSheet = SongSheetList.fromJson(SongSheet);
          ListController.imgColor = await _getPaletteGenerator(ListController.songSheet!.coverImgUrl);

          ListController.songList = (SList['songs'] as List<dynamic>).map((json)=>SongListBean.fromJson(json)).toList();
          pageController.pageIsOk = true;
        }
        
      });

      break;
      case "to_sing_and_albums":
        var album =   await dioRequest.executeGet(url: "/album",params: {"id":widget.data['id']});

          if( ListController.songSheet!=null) {
             ListController.songSheet = null;
          }
          
          ListController.remove();
          ListController.albumInfo = AlbumListBean.fromJson(album);
        if (album!="error") {
          ListController.imgColor = await _getPaletteGenerator(ListController.albumInfo!.album.blurPicUrl);
          pageController.pageIsOk = true;
        }

        break;
      case "to_recommend_song":
        var SList =  await dioRequest.executeGet(url: "/recommend/songs");

        if( ListController.songSheet!=null) {
          ListController.songSheet = null;
        }
        if(  ListController.albumInfo!=null)ListController.albumInfo=null;
        if (SList!="error") {
          ListController.songList = (SList['dailySongs'] as List<dynamic>).map((json)=>SongListBean.fromJson(json)).toList();
          pageController.pageIsOk = true;
        }


        break;
    }


  }
  Future<Color> _getPaletteGenerator(String image) async {

      final PaletteGenerator generator =
      await PaletteGenerator.fromImageProvider(
          NetworkImage(image,headers: { 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 SLBrowser/9.0.3.5211 SLBChan/103',
          }),
          size: const Size(200, 200),
          maximumColorCount: 20);

      if (generator.lightMutedColor!=null) {
        return generator.lightMutedColor!.color;
      }else{
        return const Color(0xFF9E9E9E);
      }
  }

static  cancelRequest() {
   dioRequest.cancelToken();
 }


  void addMoreList() async {
    ListController.showSongsIsOk = true;
    var SList =  await dioRequest.executeGet(url: "/playlist/track/all",params: {"id":widget.data['id'],"limit":100,"offset": ListController.songList?.length});
    ListController.addSongList( (SList['songs'] as List<dynamic>).map((json)=>SongListBean.fromJson(json)).toList());
    ListController.showSongsIsOk = false;
  }
  bool isContains(){
    if(_textEditingController.text.isEmpty) return false;
    if (ListController.albumInfo==null) {
      return ListController.songList.any((bean) {
        return bean.name.contains(_textEditingController.text)
            || bean.ar.any((u) => u.name.contains(_textEditingController.text))
            || bean.al.name.contains(_textEditingController.text);
      });
    }
    return false;
    }

  Future<void> showCreator() async {
    List<UserInfoBean> list = [];
    if (ListController.songSheet!=null) {

      list = ListController.songSheet!.sharedUsers;
      if (list.length>0) {
        if( list[0].userId!=ListController.songSheet!.creator.userId)list.insert(0, ListController.songSheet!.creator);
      }else{
        list.insert(0, ListController.songSheet!.creator);
      }
    }
    await showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: false,
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(

          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.only(top: 10),

              child: ListView.builder(
                controller: scrollController,
                itemCount:ListController.albumInfo!=null? ListController.albumInfo?.album.artists.length:ListController.songSheet!.sharedUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading:ListController.songSheet!=null?
                    getCircularImg(url: ListController.songSheet!.sharedUsers[index].avatarUrl,size: 50,):null,
                    title: Text(ListController.albumInfo!=null? ListController.albumInfo!.album.artists[index].name
                        :ListController.songSheet!.sharedUsers[index].nickname),
                  );
                },
              ),
            );
          },
        );
      },
    );

    channel.invokeMethod("hideOrShowView",false);
  }
}

