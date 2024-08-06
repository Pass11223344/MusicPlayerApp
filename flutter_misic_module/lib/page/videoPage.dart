import 'package:cached_network_image/cached_network_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misic_module/bean/CommentInfoBean.dart';
import 'package:flutter_misic_module/bean/VideoInfoBean.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/page/msgListPage.dart';
import 'package:flutter_misic_module/util/Utils.dart';
import 'package:get/get.dart';
import 'package:player/favorite.dart';
import 'package:player/player.dart';
import 'package:player/videoView.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'myPageController.dart';
class VideoPage extends StatefulWidget{

  final int index;
  const VideoPage({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => VideoPageState();

}


class VideoPageState extends State<VideoPage>{

 // double paddingH = 0.0;
  //double paddingW = 0.0;
  final myPageController _myPageController = Get.find<myPageController>();
//  ScrollPhysics scrollType = NeverScrollableScrollPhysics();
 // double? descriptionH = 0.0 ;
 Size? screenSize = Size(0, 0) ;
  late PageController _pageController ;
  ScrollController _scrollController = ScrollController();
// late List<Player> _players;
  int _currentPage = 0;



  final List<String> Mp4List = [];
@override
  void didUpdateWidget(covariant VideoPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _currentPage=widget.index;
  //  player.setCommonDataSource("assets/video/v3.mp4",autoPlay:true,type: SourceType.asset);
 // player.setLoop(0);

    getData(widget.index,true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      _myPageController.descriptionH = screenSize!.height*0.08;
      setState(() {});
    });


    _pageController.addListener(()  async {

      // 当前页面索引
      if (!_pageController.page!.isNaN && _pageController.page == _pageController.page!.floorToDouble()) {
        int currentPage = _pageController.page!.toInt();
        Player? player ;
        if (currentPage != _currentPage) {
          if (_myPageController.videoInfoBean[_currentPage]!=null) {
             player =    _myPageController.getPlayer(_myPageController.videoInfoBean[_currentPage]!.url);

            // 停止上一个页面的视频播放
            if (player!.value.duration.inMinutes>=3) {

              player.pause();

            }else{
              player.seekTo(0);
              player.pause();
            }

          }
          setState(() {
            if (player!=null) {
              player.isShowCover = true;
            }
            _currentPage = currentPage;
          });
          }

        if (_myPageController.videoInfoBean[currentPage]==null) {
          print("object---------2");
         await getData(currentPage, false);
        }else{

          if ( _myPageController.getPlayer(_myPageController.videoInfoBean[currentPage]!.url)==null) {
            _myPageController.createPlayer(_myPageController.videoInfoBean[currentPage]!.url, true, SourceType.nte);
          }else{
            print("object---------1");
            _myPageController.getPlayer(_myPageController.videoInfoBean[currentPage]!.url)!.start();
          }



        }

        // _players[_currentPage].pause();

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
   // player.stop();
   // player.release();


  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body:PopScope(
          onPopInvoked: (_){
            _myPageController.disposePlayer();
            channel.invokeMethod("FoldOrUnfold",false);
          },
          child:  PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: _myPageController.videoList.length,
            itemBuilder: (BuildContext context, int index){
              return
                Obx((){
                  print("object---------此视频格式为：${_myPageController.videoList[index].resourceType!="MV"}");
                  return
                    _myPageController.videoList[index].resourceType=="MV"||_myPageController.videoList[index].resourceType=="MLOG"?
                    index>_myPageController.videoInfoBean.length||_myPageController.videoInfoBean[index]==null?
                    Container(color: Colors.black,child: const Center(child: Text("加载中......",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),),)
                        :
                    item(_myPageController.getPlayer(_myPageController.videoInfoBean[index]!.url),index)

                        :Container(color: Colors.black,child: const Center(child: Text("此视频无法播放......",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),),)

                 ;
                });
            }),)


      );
  }
item(Player? player,int index){
    print("object---dssdsdsdsdsdsdsds---${player==null}");
    return Stack(
      children: [
        Obx((){return AnimatedPadding(padding: EdgeInsets.only(bottom: _myPageController.paddingH,right: _myPageController.paddingW,left: _myPageController.paddingW), duration: Duration(milliseconds: 350),child:
        Container(
          constraints: BoxConstraints(maxWidth: screenSize!.width,maxHeight: screenSize!.height),
          child: favorite(
              onDouble: (){

              _myPageController.onDoubleFavorite(index);

              },
              child:  player==null?Center(child:
              AspectRatio(
                  aspectRatio:  _myPageController.videoInfoBean[index]?.videoAspectRatio ?? 16 / 9, // 默认宽高比
                  child: _myPageController.videoList[index].data.coverUrl==""?
                  Container(
                    color: Colors.black,):getCover(_myPageController.videoList[index].data.coverUrl))
              ):    videoView(cover: _myPageController.videoList[index].data.coverUrl,player: player,
                changeProgress: (type){
                  switch(type){
                    case 'HideControl':

                      _myPageController.needHide = true;

                      break;
                    case 'startOrPause':

                      break;
                    case 'ShowControl':

                      _myPageController.needHide = false;

                      break;

                  }

                }, AspectRatio: (double videoAspectRatio) {
                  _myPageController.videoInfoBean[index]?.videoAspectRatio = videoAspectRatio;
                },)),),);})
        ,
        Obx((){
          return _myPageController.needHide ?const SizedBox()
          :Stack(children: [
            Container(),
            Positioned(
                top: 10,
                left: 10,
                child: IconButton(onPressed: (){
                  _myPageController.myPageIsShow = true;
                  channel.invokeMethod("FoldOrUnfold",false);
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back_ios_new),)),
            Positioned(
                right: 10,
                top:screenSize!.height / 2.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getCircularImg(url: _myPageController.videoInfoBean[index]!.avatarUrl),
                    SizedBox(height: 20,),
                    Column(children: [
                      Obx((){
                        return  IconButton(onPressed: (){
                        _myPageController.onClickFavorite(index);
                        }, icon: _myPageController.videoInfoBean[index]!.liked?Icon(Icons.favorite,size: 40,color: Colors.red,):Icon(Icons.favorite_border_outlined,size: 40,));

                      }),
                      Obx((){
                        return   Text("${_myPageController.videoInfoBean[index]!.likedCount}");

                      })
                    ],),
                    SizedBox(height: 20,),
                    Column(children: [
                      IconButton(onPressed: (){

                        _myPageController.paddingH =screenSize!.height*(2/3)-20;
                        _myPageController.paddingW = 80.0;
                          _myPageController.myPageIsShow = false;
                        if (_myPageController.viewPageComment![_myPageController.videoInfoBean[index]!.id]==null) {
                          getCommentDate(_myPageController.videoList[index].resourceType,_myPageController.videoInfoBean[index]!.id);
                        }
                          showSheet(index,_myPageController.videoInfoBean[index]!.id,_myPageController.videoList[index].resourceType);

                      }, icon: Icon(Icons.mark_unread_chat_alt,size: 40,)),
                      Obx((){
                        return Text("${_myPageController.videoInfoBean[index]!.commentCount}");

                      })
                    ],),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){},
                      child: Icon(Icons.more_horiz,size: 40,),),
                    SizedBox(height: 25,),
                    //   Container(width: 50,height: 50,color: Colors.blue,),
                  ],
                )),
            Positioned(
                left: 10,
                bottom: 55,
                child: Obx((){
                  return Container(

                      constraints:_myPageController.descriptionH==screenSize!.height*0.5?
                      BoxConstraints(maxHeight: _myPageController.descriptionH!):null,
                      height: _myPageController.descriptionH==screenSize!.height*0.5?null:_myPageController.descriptionH,//0.5//0.08
                      width:screenSize!.width*0.8,
                      child:_myPageController.descriptionH != screenSize!.height*0.5?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(_myPageController.videoInfoBean[index]!.nickname,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis),
                          Flexible(child: Row(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width:screenSize!.width*0.6,
                                child:
                                Text(
                                    maxLines: 1,overflow: TextOverflow.ellipsis,
                                    _myPageController.videoInfoBean[index]!.text
                                    ,style: const TextStyle(fontSize: 20,color: Colors.white)),

                              ),
                              Visibility(
                                  visible: calculateNumberOfLines("s",20)<calculateNumberOfLines(_myPageController.videoInfoBean[index]!.text,20),
                                  child: GestureDetector(
                                    onTap: (){
                                      _myPageController.descriptionH = screenSize!.height*0.5;
                                      if (calculateNumberOfLines(_myPageController.videoInfoBean[index]!.text,20)>screenSize!.height*0.5) {
                                        _myPageController.scrollType = ClampingScrollPhysics();
                                      }

                                    },
                                    child:Container(

                                      width: 50,height: 50,child: Text("展开",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),),
                                  ))


                            ],))],
                      ):
                      SingleChildScrollView(
                        controller: _scrollController,
                        physics: _myPageController.scrollType,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(_myPageController.videoInfoBean[index]!.nickname,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis),
                            Container(
                                width:screenSize!.width*0.7 ,
                                child:
                                RichText(text:
                                TextSpan(
                                    style: const TextStyle(color: Colors.white,fontSize: 20),
                                    children: [
                                      TextSpan(text: _myPageController.videoInfoBean[index]!.text
                                      ),
                                      TextSpan(text: "收起",style:const TextStyle(fontWeight: FontWeight.bold),
                                          recognizer: TapGestureRecognizer()..onTap=(){
                                            _myPageController.descriptionH = screenSize!.height*0.08;
                                            _myPageController.scrollType = NeverScrollableScrollPhysics();


                                          }
                                      )
                                    ])))
                          ],
                        ),
                      )


                  );
                })),
          ],);
        })




      ],
    );



}

double calculateNumberOfLines(String str,double? fontSize){
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: str, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: screenSize!.width*0.5);



    return textPainter.height;

  }


  showSheet(int index,String id,String type) async {
    // _isOpen = true;
    final ScrollController _scrollController = ScrollController();

    await  showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) =>
      Container(
        height:  screenSize!.height*(2/3)-20,
        padding: EdgeInsets.only(top: 20),
        child: GetBuilder<myPageController>(
          builder: (controller){
            return controller.viewPageComment!.containsKey(id)?
                CustomScrollView(
                  controller: _scrollController,
                  key: PageStorageKey<String>("listKey${id}IN"),
                  slivers: [

                    SliverList.builder(

                        itemCount:controller.viewPageComment![id]!.comments.length,
                        itemBuilder: (context,index){
                          return commentItem(info:controller.viewPageComment![id]!.comments[index],
                              id:id, type: type, getPoint: (){
                            print("object----ffff--------------${_scrollController.offset}");
                           return _scrollController.offset;
                            }, );
                    })
                  ],
                )
                :Utils.loadingView(Alignment.topCenter);
          },

        ))


    );


      _myPageController.paddingH = 0.0;
      _myPageController.paddingW = 0.0;

  }
  Widget getCover(String cover){
    if(cover.contains("assets/image/")){
      return Image.asset(cover,fit: BoxFit.cover,);
    }else{
      return Image.network(cover,fit: BoxFit.cover,);
    }
  }



 getData(int index,bool isFirst) async {
    var id = _myPageController.videoList[index].resourceId;
    // var player;
    // if (_myPageController.videoInfoBean[index]!.url!="") {
    //   player   = _myPageController.getPlayer(_myPageController.videoInfoBean[index]!.url, false, SourceType.nte);
    // }


    if (_myPageController.videoList[index].resourceType=="MV") {dioRequest.executeGet(url: "/mv/url",params: {"id":id}).then((v) async {
        var url = v["url"];
          dioRequest.executeGet(url: "/mv/detail",params: {"mvid":id}).then((value){
          var videoInfoBean = VideoInfoBean.fromJson(value, "mv");
          videoInfoBean.url = url;
          if(!isFirst){
            print("object----sdsds${_currentPage}-----}");
            if(_myPageController.videoInfoBean[_currentPage]!=null){
              _myPageController.insertVideoInfoBean(index, videoInfoBean,false);
              return;
            }
          }

          _myPageController.insertVideoInfoBean(index, videoInfoBean,true);



          // if(player!=null){
          //   if(player.state!=FijkState.started) player.start();
          // }


        });
      });
    }else if(_myPageController.videoList[index].resourceType=="MLOG"){
      dioRequest.executeGet(url: "/mlog/url",params: {"id":id}).then((v){
        var videoInfoBean = VideoInfoBean.fromJson(v, "mlog");
        if(!isFirst){
          if(_myPageController.videoInfoBean[_currentPage]!=null){
            _myPageController.insertVideoInfoBean(index, videoInfoBean,false);
            return;
          }
        }
        _myPageController.insertVideoInfoBean(index, videoInfoBean,true);

     //   _myPageController.insertVideoInfoBean(index, videoInfoBean,true);
        // if(player!=null){
        //   if(player.state!=FijkState.started) player.start();
        // }
      });
    }

  }

  void getCommentDate(String resourceType,String id) {
  if (resourceType=="MV") {
    dioRequest.executeGet(url: "/comment/new",params: {"id":id,"type":1,"pageSize":200}).then((value){
        if (value!="error") {
          _myPageController.addViewPageComment(id, CommentInfoBean.fromJson(value));
          print("我都却dadjak${ _myPageController.viewPageComment![id]!.hasMore}");
        }
    });
  }else if(resourceType=="MLOG"){
    dioRequest.executeGet(url: "/mlog/to/video",params: {"id":id}).then((value){
      if (value!="error") {
        dioRequest.executeGet(url: "/comment/new",params: {"id":value,"type":5,"pageSize":200}).then((value){
          if (value!="error") {
            _myPageController.addViewPageComment(id, CommentInfoBean.fromJson(value));
            print("我都却dadjak${ _myPageController.viewPageComment![id]!.hasMore}");
          }
        });
      }
    });
  }
  }
}

class getImg extends StatefulWidget{
  final String Url;
  final bool isRadius;

  const getImg({super.key, required this.Url,this.isRadius=true});
  @override
  State<StatefulWidget> createState() =>getImgState();

}
class getImgState extends State<getImg>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(

        borderRadius:  BorderRadius.circular(widget.isRadius?8.0:0),
        child:
        CachedNetworkImage(
          httpHeaders: { 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 SLBrowser/9.0.3.5211 SLBChan/103',
          },
          fit: BoxFit.cover,
          imageUrl:widget.Url ,
          placeholder:(context, url) => Container(
            width: 100,
            height: 100,
            color: Colors.grey,

          ),
          errorWidget:(context, url, error)=>Container(
            width: 80,
            height:80,
            color: Colors.grey,
          ) ,

        )
    );
  }

}

class commentItem extends StatefulWidget{

 final Comments info;
 final String id;
 final String type;
 final Function  getPoint;
  const commentItem({super.key, required this.info, required this.id, required this.type, required this.getPoint,});

  @override
  State<StatefulWidget> createState() =>commentItemState();

}
class commentItemState extends State<commentItem>{
  bool isOpen = false;
  bool openMoreReply = false;
  int onclickCount = 0;
  CommentInfoBean? beReplay;
  bool isLoading = false;
  double _scrollPositionWhenTapped = 0.0;


 bool haveMore(){
   if(widget.info.replyCount!=0){
     if (beReplay!=null) {
       if(beReplay!.hasMore){
         return true;
       }else return false;
     }else return  true;
   }else{
     return false;
   }
  }
  @override

  Widget build(BuildContext context) {
   print("object这里是要创建Item${widget.info==null}");
    // TODO: implement build
  return   Container(
    width:MediaQuery.of(context).size.width ,
    padding: EdgeInsets.only(top: 40,left: 10,right: 10),
    child:Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        getCircularImg(url: widget.info.user.avatarUrl),
        const SizedBox(width: 10,),
        Flexible(child:  Container(
          width: MediaQuery.of(context).size.width*0.8,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(widget.info.user.nickname,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
              SizedBox(height: 8,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text:
                      TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            WidgetSpan(
                                child: Text(
                                    maxLines: isOpen?null:5,
                                    overflow: isOpen?null:TextOverflow.ellipsis,
                                    widget.info.content
                                )),
                            calculateNumberOfLines( widget.info.content,null)>calculateNumberOfLines("s",null)*5?
                            TextSpan(style:const TextStyle(color: Colors.blue),text:isOpen?"收起":"展开",recognizer: TapGestureRecognizer()..onTap=(){
                              isOpen = !isOpen;
                              setState(() {});
                            }):const WidgetSpan(child: Text("")),
                          ]))
                  ,
                  // Visibility(child: Container(
                  //   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                  //   child: getImg(Url:"https://mmbiz.qpic.cn/mmbiz_jpg/Y4aCiavSOLBBeiaHAJbeYYPXkicicf"
                  //       "8UIIxw8Gicc6iah8fFtOmicFt1EmhNicHoWrCz5ylr0I2zGvUDaUZx2LAIQRR2og/640?wx_fmt=jpeg&tp="
                  //       "webp&wxfrom=5&wx_lazy=1&wx_co=1" ,),
                  // ))
                ],),
              Row(children: [Text("${widget.info.timeStr} · ${widget.info.ipLocation.location}")],),

              beReplay!=null?  Visibility(
                  visible: openMoreReply,
                  child:Column(
                      children: beReplay!.comments.asMap().entries.map((entry){
                        var value = entry.value;
                        var index = entry.key;
                        return Padding(padding: EdgeInsets.symmetric(vertical: 8),child:  replyCommentItem( beReplied:value,parentId: value.commentId.toString(),),);
                      }).toList()

                  )):const SizedBox(),
               SizedBox(width: 10,height:openMoreReply?500:0 ,),
              Visibility(
                  visible: widget.info.replyCount!=0,
                  child: Row(children: [
                    Visibility(
                      visible: haveMore(),
                      child:  TextButton.icon(onPressed: (){

                        if(isLoading)return;
                        isLoading = true;
                        openMoreReply = true;
                        onclickCount+=1;
                        widget.getPoint();
                        if(beReplay!=null){
                          print("objectwwww${beReplay==null}-----${beReplay!.hasMore}");
                          if(beReplay!.hasMore){
                            getMoreReplay(widget.info.commentId,widget.type,widget.id,beReplay!=null?beReplay!.comments[beReplay!.comments.length-1].time:null);
                          }
                        }else if(beReplay==null){
                          getMoreReplay(widget.info.commentId,widget.type,widget.id,beReplay!=null?beReplay!.comments[beReplay!.comments.length-1].time:null);
                        }

                        setState(() {

                        });
                      }, label: Icon(Icons.keyboard_arrow_down,color: Colors.grey,size: 30,),icon: Text("----${isLoading?"加载中......": onclickCount==0?"展开${widget.info.replyCount}条回复":"展开更多回复"}",style: TextStyle(color: Colors.black),) ,),
                    ),

                    SizedBox(width: 20,),
                    Flexible(child: Visibility(
                      visible:openMoreReply ,
                      child:  TextButton.icon(onPressed: (){
                        openMoreReply = false;
                        setState(() {

                        });
                      }, label:Icon(Icons.keyboard_arrow_up,color: Colors.grey,size: 30,),icon: Text("收起",style: TextStyle(color: Colors.black),) ,),
                    ))




                  ],))


            ],

          ),
        ))


      ],) ,

  );
  }
  double calculateNumberOfLines(String str,double? fontSize){
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: str, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: MediaQuery.of(context).size.width*0.5);
    return textPainter.height;

  }

  void getMoreReplay(int commentId,String resourceType,String id,int? timer) {
    if (resourceType=="MV") {
    var  params ={"parentCommentId":commentId,"type":1,"id":id};
   if( timer!=null){
     params["time"] =timer;
   }
      dioRequest.executeGet(url: "/comment/floor",params: params).then((value){
        if (value!="error") {
          var commentInfoBean = CommentInfoBean.fromJson(value);
          if(beReplay!=null){
            beReplay!.comments.addAll(commentInfoBean.comments);
            beReplay!.hasMore = commentInfoBean.hasMore;
          }else{
            beReplay =commentInfoBean;
          }

          setState(() {
            isLoading = false;
          });

        }
      });
    }else if(resourceType=="MLOG"){
      dioRequest.executeGet(url: "/mlog/to/video",params: {"id":id}).then((value){
        if (value!="error") {
          var  params ={"parentCommentId":commentId,"type":5,"id":value};
          if( timer!=null){
            params["time"] =timer;
          }
          dioRequest.executeGet(url: "/comment/floor",params: params).then((value){
            if (value!="error") {
              var commentInfoBean = CommentInfoBean.fromJson(value);
              if(beReplay!=null){
                beReplay!.comments.addAll(commentInfoBean.comments);
                beReplay!.hasMore = commentInfoBean.hasMore;
              }else{
                beReplay =commentInfoBean;
              }
              setState(() {
                isLoading = false;
              });
              print("我都却dadjak${ beReplay!.hasMore}");
            }
          });
        }
      });
    }

  }
}

class replyCommentItem extends StatefulWidget {

final Comments beReplied;
final String parentId;
  const replyCommentItem({super.key, required this.beReplied, required this.parentId});

  @override
  State<StatefulWidget> createState() =>replyCommentItemState();

}
class replyCommentItemState extends State<replyCommentItem> with AutomaticKeepAliveClientMixin{
  bool isOpen = false;

  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return  SizedBox(

        width: MediaQuery.of(context).size.width*0.8,

      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          getCircularImg(url: widget.beReplied.user.avatarUrl,size: 35,),
          const SizedBox(width: 10,),
        Flexible(child:   Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.beReplied.user.nickname } ${widget.parentId!=widget.beReplied.beReplied[0].user.userId?"> ${widget.beReplied.beReplied[0].user}":""}",style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
            const SizedBox(height: 8,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(

                    text:
                    TextSpan(
                        style: TextStyle(color: Colors.black),
                        children: [
                          WidgetSpan(
                              child: Text(
                                  maxLines: isOpen?null:5,
                                  overflow: isOpen?null:TextOverflow.ellipsis,
                                  widget.beReplied.content
                              )),
                          calculateNumberOfLines( widget.beReplied.content,null)>calculateNumberOfLines("s",null)*5?

                          TextSpan(text:isOpen?"收起":"展开",recognizer: TapGestureRecognizer()..onTap=(){
                            isOpen = !isOpen;
                            setState(() {

                            });
                          }):const WidgetSpan(child: Text("")),
                        ]))
                ,
                // Visibility(child: Container(
                //   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                //   child: getImg(Url:"https://mmbiz.qpic.cn/mmbiz_jpg/Y4aCiavSOLBBeiaHAJbeYYPXkicicf"
                //       "8UIIxw8Gicc6iah8fFtOmicFt1EmhNicHoWrCz5ylr0I2zGvUDaUZx2LAIQRR2og/640?wx_fmt=jpeg&tp="
                //       "webp&wxfrom=5&wx_lazy=1&wx_co=1" ,),
                // ))
              ],),
            Row(children: [Text("${widget.beReplied.timeStr} · ${widget.beReplied.ipLocation.location}")],),


          ],

        ))

        ],) ,

    );
  }
  double calculateNumberOfLines(String str,double? fontSize){
    TextPainter textPainter = TextPainter(
      text: TextSpan(text: str, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )
      ..layout(maxWidth: MediaQuery.of(context).size.width*0.5);
    return textPainter.height;

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}