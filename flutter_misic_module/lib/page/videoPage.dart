import 'package:cached_network_image/cached_network_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_misic_module/bean/VideoInfoBean.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/page/msgListPage.dart';
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
  //final player  = Player();
  double paddingH = 0.0;
  double paddingW = 0.0;
  final myPageController _myPageController = Get.find<myPageController>();
  ScrollPhysics scrollType = NeverScrollableScrollPhysics();
  double? descriptionH = 0.0 ;
 Size? screenSize = Size(0, 0) ;
  late PageController _pageController ;
  ScrollController _scrollController = ScrollController();
// late List<Player> _players;
  int _currentPage = 0;

  bool needHide = false;

  final List<String> Mp4List = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _currentPage=widget.index;
  //  player.setCommonDataSource("assets/video/v3.mp4",autoPlay:true,type: SourceType.asset);
 // player.setLoop(0);
    print("object99000ddddd${_myPageController.videoInfoBean.length}");
    getData(widget.index,true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenSize = MediaQuery.of(context).size;
      descriptionH = screenSize!.height*0.08;
      setState(() {});
    });


    _pageController.addListener(()  async {

      // 当前页面索引
      if (!_pageController.page!.isNaN && _pageController.page == _pageController.page!.floorToDouble()) {
        int currentPage = _pageController.page!.toInt();
        if (currentPage != _currentPage) {
      Player player =    _myPageController.getPlayer(_myPageController.videoInfoBean[_currentPage]!.url);
          // 停止上一个页面的视频播放
          if (player.value.duration.inMinutes>=3) {

            player.pause();

          }else{
            player.seekTo(0);
            player.pause();
          }
          setState(() {
            player.isShowCover = true;
            _currentPage = currentPage;
          });
        }
        if (_myPageController.videoInfoBean[currentPage]==null) {
         await getData(currentPage, true);
        }else{

          if ( _myPageController.getPlayer(_myPageController.videoInfoBean[currentPage]!.url)==null) {
            _myPageController.createPlayer(_myPageController.videoInfoBean[currentPage]!.url, true, SourceType.nte);
          }else{
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
    _myPageController.disposePlayer();

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body:PageView.builder(
          scrollDirection: Axis.vertical,
            controller: _pageController,
            itemCount: _myPageController.videoList.length,
            itemBuilder: (BuildContext context, int index){
                  return
                    Obx((){
                      return index>_myPageController.videoInfoBean.length||_myPageController.videoInfoBean[index]==null?
                        Container(color: Colors.black,)
                        :
                      item(_myPageController.getPlayer(_myPageController.videoInfoBean[index]!.url),index);
                  });
        })
      );
  }
item(Player? player,int index){
    print("object---dssdsdsdsdsdsdsds---${player==null}");
    return Stack(
      children: [
        AnimatedPadding(padding: EdgeInsets.only(bottom: paddingH,right: paddingW,left: paddingW), duration: Duration(milliseconds: 350),child:
        Container(
          constraints: BoxConstraints(maxWidth: screenSize!.width,maxHeight: screenSize!.height),
          child: favorite(
            onDouble: (){
              setState(() {
                if(!_myPageController.videoInfoBean[index]!.liked)_myPageController.videoInfoBean[index]!.liked = true;
              });
              print("object双击了老铁666");
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
                  setState(() {
                    needHide = true;
                  });
                  break;
                case 'startOrPause':

                  break;
                case 'ShowControl':
                  setState(() {
                    needHide = false;
                  });
                  break;

              }

            }, AspectRatio: (double videoAspectRatio) {
              _myPageController.videoInfoBean[index]?.videoAspectRatio = videoAspectRatio;
              },)),),),
        Visibility(
            visible: !needHide,
            child: Stack(children: [
              Container(),
              Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(onPressed: (){
                    print("object我能点");
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
                        IconButton(onPressed: (){
                          print("object我也能点");
                          setState(() {
                            _myPageController.videoInfoBean[index]!.liked = !_myPageController.videoInfoBean[index]!.liked;
                            _myPageController.videoInfoBean[index]!.likedCount+=1;
                          });
                        }, icon: _myPageController.videoInfoBean[index]!.liked?Icon(Icons.favorite,size: 40,color: Colors.red,):Icon(Icons.favorite_border_outlined,size: 40,)),
                     Obx((){
                       return   Text("${_myPageController.videoInfoBean[index]!.likedCount}");

                     })
                      ],),
                      SizedBox(height: 20,),
                      Column(children: [
                        IconButton(onPressed: (){
                          setState(() {
                            paddingH =screenSize!.height*(2/3)-20;
                            paddingW = 80.0;
                            showSheet(1);
                          });
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
                  child: Container(

                      constraints:descriptionH==screenSize!.height*0.5?
                      BoxConstraints(maxHeight: descriptionH!):null,
                      height: descriptionH==screenSize!.height*0.5?null:descriptionH,//0.5//0.08
                      width:screenSize!.width*0.8,
                      child:descriptionH != screenSize!.height*0.5?
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
                                      descriptionH = screenSize!.height*0.5;
                                      if (calculateNumberOfLines(_myPageController.videoInfoBean[index]!.text,20)>screenSize!.height*0.5) {
                                        scrollType = ClampingScrollPhysics();
                                      }
                                      setState(() {});
                                    },
                                    child:Container(

                                      width: 50,height: 50,child: Text("展开",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),),
                                  ))


                            ],))],
                      ):
                      SingleChildScrollView(
                        controller: _scrollController,
                        physics: scrollType,
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
                                            descriptionH = screenSize!.height*0.08;
                                            scrollType = NeverScrollableScrollPhysics();
                                            setState(() {});

                                          }
                                      )
                                    ])))
                          ],
                        ),
                      )


                  )),
            ],))



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


  showSheet( int index) async {
    // _isOpen = true;
    await  showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) =>
      Container(
        height:  screenSize!.height*(2/3)-20,

        child: SingleChildScrollView(
        child:   PopScope(
            onPopInvoked: (isPop) {
              // _myPageController.isReplyComment = false;
              // _focusNode.unfocus();
            },
            child:commentItem(children: [replyCommentItem()],)


        ),
      ),)


    );

    setState(() {
      paddingH = 0.0;
      paddingW = 0.0;
    });
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

          _myPageController.insertVideoInfoBean(index, videoInfoBean,true);
          // if(player!=null){
          //   if(player.state!=FijkState.started) player.start();
          // }


        });
      });
    }else{
      dioRequest.executeGet(url: "/mlog/url",params: {"id":id}).then((v){
        var videoInfoBean = VideoInfoBean.fromJson(v, "mlog");
        _myPageController.insertVideoInfoBean(index, videoInfoBean,true);
        // if(player!=null){
        //   if(player.state!=FijkState.started) player.start();
        // }
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
 final List<Widget>? children;

  const commentItem({super.key,   this.children = null});

  @override
  State<StatefulWidget> createState() =>commentItemState();

}
class commentItemState extends State<commentItem>{
  bool isOpen = false;
  bool openMoreReply = false;
  int onclickCount = 0;

  @override

  Widget build(BuildContext context) {
    // TODO: implement build
  return  Container(

      width:MediaQuery.of(context).size.width ,
        padding: EdgeInsets.only(top: 40,left: 10,right: 10),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          getCircularImg(url: "https://mmbiz.qpic.cn/mmbiz_jpg/Y4aCiavSOLBBeiaHAJbeYYPXkicicf"
              "8UIIxw8Gicc6iah8fFtOmicFt1EmhNicHoWrCz5ylr0I2zGvUDaUZx2LAIQRR2og/640?wx_fmt=jpeg&tp="
              "webp&wxfrom=5&wx_lazy=1&wx_co=1"),
          SizedBox(width: 10,),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("这里是昵称",style: TextStyle(fontSize: 12),),
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
                                      " part(这里是内容这里是内容超出最大行数将收"
                                          "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                          "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                          "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                          "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                          "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                          "这里是内容超出最大行数将收起 "
                                  )),
                              calculateNumberOfLines("part(这里是内容这里是内容超出最大行数将收"
                                  "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                  "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                  "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                  "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                  "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                  "这里是内容超出最大行数将收起 ",null)>calculateNumberOfLines("s",null)*5?

                              TextSpan(text:"${isOpen?"收起":"展开"}",recognizer: TapGestureRecognizer()..onTap=(){
                                     isOpen = !isOpen;
                                     setState(() {

                                     });
                              }):WidgetSpan(child: Text("")),
                            ]))
                    ,
                    Visibility(child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                      child: getImg(Url:"https://mmbiz.qpic.cn/mmbiz_jpg/Y4aCiavSOLBBeiaHAJbeYYPXkicicf"
                          "8UIIxw8Gicc6iah8fFtOmicFt1EmhNicHoWrCz5ylr0I2zGvUDaUZx2LAIQRR2og/640?wx_fmt=jpeg&tp="
                          "webp&wxfrom=5&wx_lazy=1&wx_co=1" ,),
                    ))
                  ],),
                Row(children: [Text("  07-17 · 湖北")],),
                Visibility(
                    visible: openMoreReply,
                    child: widget.children==null?SizedBox():widget.children![0]),
                SizedBox(width: 10,),
                Row(children: [
                  TextButton.icon(onPressed: (){
                    openMoreReply = true;
                    onclickCount+=1;
                    setState(() {

                    });
                  }, label: Icon(Icons.keyboard_arrow_down,color: Colors.grey,size: 30,),icon: Text("----${onclickCount==0?"展开648条回复":"展开更多回复"}",style: TextStyle(color: Colors.black),) ,),


                  SizedBox(width: 20,),
                  Visibility(
                      visible:openMoreReply ,
                      child:  TextButton.icon(onPressed: (){
                        openMoreReply = false;
                        setState(() {

                        });
                      }, label:Icon(Icons.keyboard_arrow_up,color: Colors.grey,size: 30,),icon: Text("收起",style: TextStyle(color: Colors.black),) ,),
                  )



                ],)

              ],

            ),
          )

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
}

class replyCommentItem extends StatefulWidget{


  const replyCommentItem({super.key});

  @override
  State<StatefulWidget> createState() =>replyCommentItemState();

}
class replyCommentItemState extends State<replyCommentItem>{
  bool isOpen = false;

  @override

  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(

        width: MediaQuery.of(context).size.width*0.8,

      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          getCircularImg(url: "https://mmbiz.qpic.cn/mmbiz_jpg/Y4aCiavSOLBBeiaHAJbeYYPXkicicf"
              "8UIIxw8Gicc6iah8fFtOmicFt1EmhNicHoWrCz5ylr0I2zGvUDaUZx2LAIQRR2og/640?wx_fmt=jpeg&tp="
              "webp&wxfrom=5&wx_lazy=1&wx_co=1",size: 35,),
          SizedBox(width: 10,),
        Flexible(child:   Container(

          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text("这里是昵称",style: TextStyle(fontSize: 12),),
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
                                    " part(这里是内容这里是内容超出最大行数将收"
                                        "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                        "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                        "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                        "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                        "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                        "这里是内容超出最大行数将收起 "
                                )),
                            calculateNumberOfLines("part(这里是内容这里是内容超出最大行数将收"
                                "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                "这里是内容超出最大行数将收起  part(这里是内容这里是内容超出最大行数将收"
                                "这里是内容超出最大行数将收起 ",null)>calculateNumberOfLines("s",null)*5?

                            TextSpan(text:"${isOpen?"收起":"展开"}",recognizer: TapGestureRecognizer()..onTap=(){
                              isOpen = !isOpen;
                              setState(() {

                              });
                            }):WidgetSpan(child: Text("")),
                          ]))
                  ,
                  Visibility(child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                    child: getImg(Url:"https://mmbiz.qpic.cn/mmbiz_jpg/Y4aCiavSOLBBeiaHAJbeYYPXkicicf"
                        "8UIIxw8Gicc6iah8fFtOmicFt1EmhNicHoWrCz5ylr0I2zGvUDaUZx2LAIQRR2og/640?wx_fmt=jpeg&tp="
                        "webp&wxfrom=5&wx_lazy=1&wx_co=1" ,),
                  ))
                ],),
              Row(children: [Text("  07-17 · 湖北")],),


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
}