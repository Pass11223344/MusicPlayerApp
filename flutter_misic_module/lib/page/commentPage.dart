
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_misic_module/util/Utils.dart';
import 'package:get/get.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../bean/CommentInfoBean.dart';
import '../main.dart';
import 'WPopupMenu.dart';
import 'commentPageController.dart';
import 'msgListPage.dart';
import 'myPageController.dart';
//接口返回的数据有问题下一页的参数写成2的时候就输出了最后的几十条评论。。。。
//如果一次性数据就太庞大所以只能随便写写
//由于接口的延迟问题(所有操作基本在一两分钟左右才会显示出来所以无法做到即时演示~~~~~)所以只能做演示无法发送但我写了方法

class commentPage extends StatefulWidget {
 final Map? data;

  const commentPage({super.key, this.data});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return commentPageState();
  }
}

class commentPageState extends State<commentPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  var commentController = commentPageController();
  var pageController = Get.find<PageControllers>();
  Map? commentInfo;
  var executeGet;
  late TextEditingController _textController;
  late TextEditingController _replyTextController ;
  late FocusNode _focusNode;
  var _rePlyTextController ;
  var _rePlyFocusNode ;
  var _isOpen = false;
  final FocusNode _replyFocusNode = FocusNode();

  Map<String, dynamic>? params;
  String hintText = "说点什么吧";
  String replyHintText = "说点什么吧";
  int currentIndex = -1;
  bool isReply = false;
  final List<String> actions = [
    '复制',
  ];
  final List<String> actions1 = [
    '复制',
    '删除',

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
    _replyTextController = TextEditingController();
    _focusNode = FocusNode();
    _rePlyTextController = TextEditingController();
    _rePlyFocusNode = FocusNode();
    // 监听输入框获取焦点的事件
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        if(_focusNode.hasFocus){
          commentController.isFocus = true;
        }else if(_rePlyFocusNode.hasFocus){
          commentController.isRePlyFocus = true;
        }

      } else {
        if (_textController.text.trim()=="") {
          hintText = "说点什么吧";
        }
        if(_rePlyTextController.text.trim()==""){
          replyHintText = "说点什么吧";
        }
        if(_focusNode.hasFocus){
          commentController.isFocus = false;
          _focusNode.unfocus();
        }else if(_rePlyFocusNode.hasFocus){
          commentController.isRePlyFocus = false;
        }


      }
    });
    // 监听输入框文字内容的变化
    _textController.addListener(() {
      print('输入框内容变化：${_textController.text}');
      commentController.text = _textController.text;
    });
    _rePlyTextController.addListener((){
      commentController.rePlyText = _rePlyTextController.text;
    });
  if(widget.data==null) {
    receiveDataFromAndroid();
  }else{
    getData();
  }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return  Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              titleSpacing: 10,
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.white,
              title:  Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){

                        Navigator.pop(context);
                      },
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child:
                          const Icon(Icons.arrow_back, color: Colors.black)) ,
                    )
                   ,
                    // 居左对齐的Icon
                    Container(
                      alignment: Alignment.center,
                      child: const Text('评论', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),

            body: PopScope(
              onPopInvoked: (isPop){
                print("object-----------执行$_isOpen");
                if(!_isOpen){
                  pageController.isOpenCommentPage = false;
                  channel.invokeMethod("hideOrShowView",false);
                }
              },
              child: Stack(
                  children: [
                    Center(
                      child:
                      Obx((){
                        return  commentController.allPage
                            ? Container(
                          height: MediaQuery.of(context).size.height,
                          child: NestedScrollView(
                            headerSliverBuilder: ((BuildContext context,
                                bool innerBoxIsScrolled) {
                              return [
                                SliverOverlapAbsorber(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(
                                      context),
                                  sliver: SliverAppBar(
                                    pinned: true,
                                    toolbarHeight: 0,
                                    forceElevated: innerBoxIsScrolled,
                                    expandedHeight: 150,
                                    flexibleSpace: FlexibleSpaceBar(
                                      collapseMode: CollapseMode.pin,
                                      background: Container(
                                        width: double.infinity,
                                        height: 150,
                                        padding: EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 40,
                                                    color: Colors.grey))),
                                        child: Row(

                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: //AssetImage("images/img.png"),
                                                      NetworkImage(
                                                          headers: { 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 SLBrowser/9.0.3.5211 SLBChan/103',
                                                          },
                                                          commentInfo?[
                                                          "imgUrl"]),
                                                      fit: BoxFit.cover),
                                                  borderRadius:BorderRadius.circular(15)
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(left: 10),
                                              // width: Utils.customStringLength(commentInfo?['songName'])>24?
                                              // MediaQuery.of(context).size.width*0.46 :null,
                                              constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width*0.4 ),
                                              child:  Text(
                                                " ${commentInfo?['songName']}",
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    color: Colors
                                                        .black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Flexible(child:Container(
                                              // width: Utils.customStringLength( commentInfo?['singerName'])>24?
                                              // MediaQuery.of(context).size.width*0.3:null,

                                              child: Text(
                                                textAlign: TextAlign.left,
                                                "-${commentInfo?['singerName']}",
                                                maxLines: 1,
                                                style:
                                                const TextStyle(
                                                    color: Colors
                                                        .grey,
                                                    fontSize:
                                                    12),


                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                    bottom: PreferredSize(
                                      preferredSize: const Size.fromHeight(30),
                                      child: Container(
                                        color: Colors.white,
                                        width:
                                        MediaQuery.of(context).size.width,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        height: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 150,

                                              alignment: Alignment.bottomLeft,
                                              child: Obx(() => Text(
                                                maxLines: 1,
                                                "评论(${Utils.formatNumber(commentController.commentInfo!.totalCount, "")})",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )),
                                            ),
                                           SizedBox(
                                             width: 150,
                                             height: 30,
                                             child: Row(
                                               children: [
                                                 Expanded(
                                                     flex: 2,
                                                     child: GestureDetector(
                                                         child: Container(
                                                           alignment: Alignment
                                                               .bottomCenter,
                                                           child: Row(
                                                             mainAxisAlignment:
                                                             MainAxisAlignment
                                                                 .spaceAround,
                                                             children: [
                                                               Obx((){
                                                                 return Text(
                                                                   "推荐",
                                                                   style: TextStyle(
                                                                       color: commentController.sortType == 1
                                                                           ? Colors.black
                                                                           : Colors.grey),
                                                                 );
                                                               }),
                                                               const Text(
                                                                 "|",
                                                                 style: TextStyle(
                                                                     color: Colors
                                                                         .grey),
                                                               )
                                                             ],
                                                           ),
                                                         ),
                                                         onTap: ()=> upDataInfo(1)

                                                     )),
                                                 Expanded(
                                                     flex: 2,
                                                     child: GestureDetector(
                                                         child: Container(
                                                           alignment: Alignment
                                                               .bottomCenter,
                                                           child: Row(
                                                             mainAxisAlignment:
                                                             MainAxisAlignment
                                                                 .spaceAround,
                                                             children: [
                                                               Obx((){
                                                                 return Text("最热",
                                                                     style: TextStyle(
                                                                         color: commentController.sortType == 2
                                                                             ? Colors.black
                                                                             : Colors.grey));
                                                               }),
                                                               const Text("|",
                                                                   style: TextStyle(
                                                                       color:
                                                                       Colors.grey))
                                                             ],
                                                           ),
                                                         ),
                                                         onTap: () =>
                                                             upDataInfo(2))),
                                                 Expanded(
                                                     flex: 1,
                                                     child: GestureDetector(
                                                         child: Container(
                                                           alignment: Alignment
                                                               .bottomCenter,
                                                           child: Obx((){
                                                             return Text("最新",
                                                                 style: TextStyle(
                                                                     color: commentController.sortType == 3
                                                                         ? Colors
                                                                         .black
                                                                         : Colors
                                                                         .grey));
                                                           }),
                                                         ),
                                                         onTap: () =>
                                                             upDataInfo(3))),
                                               ],
                                             ),
                                           )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ];
                            }),
                            body: Obx(() => commentController.secondPage
                                ? Stack(children: [
                              SafeArea(
                                top: false,
                                bottom: false,
                                child: Builder(
                                    builder: (BuildContext context) {
                                      return NotificationListener<ScrollNotification>(
                                          onNotification: (scrollNotification){
                                            if(scrollNotification is ScrollUpdateNotification
                                                &&scrollNotification.metrics.pixels==scrollNotification.metrics.maxScrollExtent){
                                              if( commentController.commentInfo!.comments.length!= commentController.commentInfo?.totalCount) {
                                                if(!commentController.addMoreListIsOk&&commentController.commentInfo!.hasMore) addMoreList();
                                              };
                                              return true;
                                            }
                                            return false;
                                          },
                                          child:
                                          CustomScrollView(
                                            slivers: [
                                              SliverOverlapInjector(
                                                  handle: NestedScrollView
                                                      .sliverOverlapAbsorberHandleFor(
                                                      context)),
                                              Obx((){
                                                return SliverList.builder
                                                  (itemCount:commentController.commentInfo!.comments.length ,
                                                    itemBuilder: (context,index){
                                                      var comment = commentController.commentInfo!.comments[index];
                                                      return  Container(
                                                          padding: const EdgeInsets.all(10),
                                                          color: Colors.white,
                                                          child:getCommentListItem(comment, index)

                                                        //CommentListItem(context,index),
                                                        //  child: ListTile(
                                                        //    title: CommentListItem(context,index),
                                                        //    onTap: ()=>getReply(index),
                                                        //  ),

                                                      ) ;
                                                    });

                                              })

                                              ,
                                              SliverToBoxAdapter(
                                                child: Obx((){return
                                                  commentController.numPage!=2
                                                      ?Utils.loadingView(Alignment.center)
                                                      :const SizedBox();
                                                }),
                                              ),
                                              const SliverToBoxAdapter(
                                                child: SizedBox(
                                                  height: 80,
                                                ),
                                              )
                                            ],
                                          ));


                                    }),
                              ),
                              Obx((){
                                return commentController.isSend? Stack(children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.white24,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 40),
                                    alignment: Alignment.topCenter,
                                    child: const CircularProgressIndicator(
                                      strokeCap: StrokeCap.round,
                                      strokeWidth: 1,
                                      color: Colors.red,
                                    ),
                                  )
                                ],):SizedBox();
                              })

                            ],)
                                : loadingView()),
                          ),
                        )
                            : loadingView();
                      }),

                    )
                  ]
              ),
            ),
          ),
          Obx(() => Visibility(
              visible: commentController.isFocus,
              child: Container(color: Colors.black54))),
          Obx(()=>Visibility(
              visible: commentController.allPage,
              child: Align(alignment: Alignment.bottomCenter, child: inputView()))),
        ],
      ),
    );
  }

  void receiveDataFromAndroid() {
    channel.setMethodCallHandler((call) async {
      if (call.method == "commentChannel") {
        commentInfo = call.arguments;
        print("objectaaaaaaaaaaaaaaaa${jsonEncode(commentInfo)}");
        await getInfo();
        commentController.allPage = true;
       // setState(() {});
      }
      else{
        print("object-----------xxxxx$_isOpen");
        if (_isOpen) {
          Navigator.pop(context);
          return false;
        }
        return true;
      }
    });
  }
getData() async {
  commentInfo = widget.data;
  print("objectaaaaaaaaaaaaaaaa${jsonEncode(commentInfo)}");
  await getInfo();
  commentController.allPage = true;
}
  Widget loadingView() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
      Container(
        padding: const EdgeInsets.only(top: 40),
        alignment: Alignment.topCenter,
        child: const CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: 1,
          color: Colors.red,
        ),
      )
    ]);
  }

  getInfo() async {
    params = {
      "type": commentInfo?["commentType"],
      "id": commentInfo?['Id'],
      "sortType": commentController.sortType,
      "pageSize":100
    };

    executeGet = await dioRequest
        .executeGet(url: "/comment/new", params: params);
    if (executeGet != "error") {
      commentController.commentInfo = CommentInfoBean.fromJson(executeGet);

      print("aaaaaaaaaaaaaaaaaaaa${commentController.commentInfo?.cursor}");
    }
  }

  upDataInfo(int sortType) async {

    if (commentController.sortType == sortType) return;
    commentController.sortType = sortType;
    commentController.secondPage = false;
    await getInfo();
    commentController.secondPage = true;
  }


  getCommentListItem(Comments event,int index) {
    return
      Container(
       //   padding: const EdgeInsets.only(top: 15, left: 10),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getCircularImg(url: event.user.avatarUrl),
              const SizedBox(
                width: 8,
              ),
              Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black12, width: 0.8))),
                  child:
                  WPopupMenu(
                      onValueChanged: (int value) {

                        switch(value){
                          case 0:
                            Utils.copyTextToClipboard(event.content, context);
                            break;
                          case 1:
                          // sendOrRemoveComment(0,0,commentInfo?['Id'],"",event.commentId,index);
                            // Comments commentsToRemove = _myPageController.traceCommentInfo!.comments.firstWhere((comment) => comment.commentId == event.commentId);
                            //
                            // if (commentsToRemove != null) {
                            //   _myPageController.traceCommentInfo!.comments.remove(commentsToRemove);
                            //   _myPageController.itemCount = _myPageController.traceCommentInfo!.comments.length;
                            //   sendOrRemoveComment(0,widget.params['id'],"",event.commentId);
                            //   _myPageController.relayInfo!.events[widget.params['index'] as int].info.commentCount -=1;
                            //   Utils.showTopSnackBar(context, "已删除");
                            //   // 如果需要，可以在这里添加一些删除操作的反馈
                            // } else {
                            //   // 或者如果没找到用户，可以打印一个消息
                            //   print('User with ID 323230 not found.');
                            // }
                            break;
                        }
                      },
                      pressType: PressType.longPress,
                      actions: event.user.userId==commentInfo?['userId']?actions1:actions,
                      key: null,
                      child:
                      InkWell(
                          onTap: () {
                            print("object----------------点击了");
                            hintText = "回复${event.user.nickname}";
                            isReply = true;
                            currentIndex = index;
                            _focusNode.requestFocus();
                          },

                          child:
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(event.user.nickname),
                                Text("${event.timeStr}  ${event.ipLocation.location}"),
                                Container(
                                  padding: const EdgeInsets.only(top: 10, left: 4),
                                  child: Text(event.content),
                                ),
                                Obx((){
                                  return Visibility(
                                      visible:commentController.commentInfo!.comments[index].replyCount!=0 ,
                                      child: GestureDetector(
                                        onTap: (){
                                          commentController.isTraceComment = false;
                                          showSheet(event,index);

                                          dioRequest.executeGet(url: "/comment/floor",params: {"parentCommentId":event.commentId,
                                          "id":commentInfo?['Id'],"type":commentInfo?["commentType"]}).then((value){
                                            commentController.replyCommentInfo = CommentInfoBean.fromJson(value);
                                            commentController.isTraceComment = true;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 15),
                                          child: Text("${commentController.commentInfo!.comments[index].replyCount}条回复 >",style: const TextStyle(
                                              color: Colors.blueAccent, fontSize: 10)),
                                        ),
                                      ));
                                })

                              ])
                      )))
            ],
          )
      );

  }
  showSheet(Comments event, int index) async {
    _isOpen = true;
  await  showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => PopScope(
        onPopInvoked: (isPop) {
          // _myPageController.isReplyComment = false;
          // _focusNode.unfocus();
        },
        child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                Column(
                  children: [
                    AppBar(
                      scrolledUnderElevation: 0.0,
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      title:
                      Obx((){
                        return  Text(
                            "回复(${commentController.commentInfo!.comments[index].replyCount})");
                      }),

                    ),
                    Flexible(
                        child:
                            NotificationListener<ScrollNotification>(
                                onNotification: ((scrollNotification){
                                  if(scrollNotification is ScrollUpdateNotification&&
                                  scrollNotification.metrics.pixels==scrollNotification.metrics.maxScrollExtent){
                                    if(!commentController.addMoreReplyListIsOk&&commentController.replyCommentInfo!.hasMore) {
                                      addMoreReplyList(commentInfo?["commentType"],
                                        commentController.replyCommentInfo!.comments[commentController.replyCommentInfo!.comments.length-1].time, event.commentId, commentInfo?['Id']);
                                    }
                                    return true;
                                  }

                                  return false;
                                }),
                                child:CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 15, left: 15),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(color: Colors.white24, width: 0.8))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        getCircularImg(url: event.user.avatarUrl),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            width: MediaQuery.of(context).size.width - 100,
                                            child:  Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(event.user.nickname),
                                                Text("${event.timeStr}  ${event.ipLocation.location}"),
                                                Container(
                                                  padding: const EdgeInsets.only(top: 10, left: 4),
                                                  child: Text(softWrap: true, event.content),
                                                ),
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: Colors.black12, width: 15))),
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 10, left: 14),
                                      child: Text("全部回复"),
                                    ),
                                  ),
                                ),
                                Obx((){
                                  return commentController.isTraceComment?
                                  SliverList.builder(
                                      itemCount: commentController.replyCommentInfo!.comments.length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return  Container(
                                          padding: const EdgeInsets.only(top: 15, left: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              getCircularImg(url: commentController.replyCommentInfo!.comments[i].user.avatarUrl),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                  padding: const EdgeInsets.only(bottom: 10),
                                                  width: MediaQuery.of(context).size.width - 80,
                                                  decoration:  const BoxDecoration(
                                                      border: Border(
                                                          bottom:
                                                          BorderSide(color: Colors.black12, width: 0.8))),
                                                  child: WPopupMenu(
                                                      onValueChanged: (int value) {
                                                        switch(value){
                                                          case 0:
                                                            Utils.copyTextToClipboard(commentController.replyCommentInfo!.comments[i].content, context);
                                                            break;
                                                          case 1:

                                                           // sendOrRemoveComment(0, 0, commentInfo?['Id'], "", commentController.replyCommentInfo!.comments[i].commentId, i);
                                                           // commentController.replyCommentInfo!.comments.removeAt(i);
                                                            commentController.removeList("reply", i);
                                                          //  Comments commentsToRemove = _myPageController.traceCommentInfo!.comments.firstWhere((comment) => comment.commentId == event.commentId);
                                                          //
                                                          //  if (commentsToRemove != null) {
                                                          //    _myPageController.traceCommentInfo!.comments.remove(commentsToRemove);
                                                          //    _myPageController.itemCount -= 1;
                                                          //    _myPageController.currentReplyComment -=1;
                                                          //    _myPageController.maps[headId]![0] -=1 ;
                                                          //
                                                          //    _myPageController.relayInfo!.events[widget.params['index'] as int].info.commentCount -=1;
                                                          //    Utils.showTopSnackBar(context, "已删除");
                                                          //
                                                          //
                                                          // //   sendOrRemoveComment(0,widget.params['id'],"",event.commentId);
                                                          //    // 如果需要，可以在这里添加一些删除操作的反馈
                                                          //  } else {
                                                          //    // 或者如果没找到用户，可以打印一个消息
                                                          //    print('User with ID 323230 not found.');
                                                          //  }
                                                            break;
                                                        }
                                                      },
                                                      pressType: PressType.longPress,
                                                      actions:
                                                      event.user.userId==commentInfo?['userId']?
                                                      actions1:actions,
                                                      key: null,
                                                      child:
                                                      InkWell(
                                                          onTap: () {

                                                            // commentInfo[] = event.commentId;
                                                            _replyFocusNode.requestFocus();
                                                            replyHintText =
                                                            "回复: ${commentController.replyCommentInfo!.comments[i].user.nickname}";
                                                          },
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(commentController.replyCommentInfo!.comments[i].user.nickname),
                                                              Text("${commentController.replyCommentInfo!.comments[i].timeStr}  ${commentController.replyCommentInfo!.comments[i].ipLocation.location}"),
                                                              Container(
                                                                padding: const EdgeInsets.only(top: 10, left: 4),
                                                                child: Text(softWrap: true, commentController.replyCommentInfo!.comments[i].content),
                                                              ),

                                                              Visibility(
                                                                 visible: commentController.replyCommentInfo!.comments[i].beReplied[0].beRepliedCommentId != event.commentId,
                                                                  child: Container(
                                                                    margin:    EdgeInsets.only(top: 10),
                                                                    decoration: BoxDecoration(
                                                                        border: Border(
                                                                            left: BorderSide(
                                                                                color: Colors.black12, width: 2))),
                                                                    child: RichText(text: TextSpan(children: [
                                                                      TextSpan(text: "  ${commentController.replyCommentInfo!.comments[i].beReplied[0].user.nickname}",
                                                                          style: const TextStyle(color: Colors.blueAccent)),
                                                                      TextSpan(text:" : ${commentController.replyCommentInfo!.comments[i].beReplied[0].content}",  style: const TextStyle(color: Colors.black) )
                                                                    ])),

                                                                  ))
                                                              //  : Container()
                                                            ],
                                                          )))
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                      :SliverToBoxAdapter(child: Utils.loadingView(Alignment.center),);}),
                               SliverToBoxAdapter(child:
                               Obx((){
                                 return commentController.replyCommentInfo!=null? commentController.replyCommentInfo!.hasMore?Utils.loadingView(Alignment.center):const SizedBox(height: 60):const SizedBox();
                               })),
                                const SliverToBoxAdapter(child: SizedBox(height: 50,),),
                              ],
                            ) )


                    )
                  ],
                ),
                AnimatedPadding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  duration: Duration(milliseconds: 200),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width - 20,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 14, bottom: 2),
                                  padding: EdgeInsets.all(8),
                                  child: TextField(
                                    focusNode: _replyFocusNode,
                                    maxLines: 4,
                                    controller: _replyTextController,
                                    decoration: InputDecoration(
                                        hintText: replyHintText,
                                        isCollapsed: true,
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        hintStyle:
                                        const TextStyle(color: Colors.grey),
                                        border: InputBorder.none),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: GestureDetector(
                                    onTap: () async {
                                      String text = _replyTextController.text.trim();
                                      if (text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('输入框不能为空！'),
                                            duration: Duration(seconds: 1), // 设置显示时间
                                            backgroundColor: Colors.black12, // 设置背景色
                                          ),
                                        );
                                        return;
                                      }
                                      // _myPageController.isTraceComment = false;
                                      // sendOrRemoveComment(2, widget.params['id'], _replyTextController.text, _myPageController.currentCommentId );

                                      _replyFocusNode.unfocus();
                                      _replyTextController.clear();
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("发送"),
                                    )))
                          ],
                        ),
                      )),
                )
              ],
            )),
      ),
    );
    _isOpen = false;
    Future.delayed(Duration(seconds: 1),(){
      commentController.replyCommentInfo=CommentInfoBean([], 0, 0, "0", false);
    });

  }
  Widget inputView() {
    return Obx(() => Container(
          height: commentController.isFocus ? 200 : 100,
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 35, bottom: 10),
          width: double.infinity,
          color: const Color(0xD7FFFFFF),
          child: Row(
            children: [
              Expanded(
                  flex: 11,
                  child: GestureDetector(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: EdgeInsets.only(bottom: 2),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(25)),
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _textController,

                        maxLines: 6,
                        decoration:  InputDecoration(
                            hintText: hintText,
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            //内容内边距，影响高度
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none),
                      ),
                    ),
                    onTap: () {},
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(left: 8),
                    alignment: Alignment.centerLeft,
                    child: Obx(() => TextButton(
                          onPressed:
                              commentController.text.trim() == "" ? null : () {
                            print("点击了------------");
                            print("发送消息为${commentController.text}--歌曲Id:${ commentInfo?['Id']}---isReply${isReply}-----${currentIndex}");
                            print("you---${commentController.commentInfo!.comments[currentIndex].commentId}");

                            // if(isReply){
                              //sendOrRemoveComment(2, 0, commentInfo?['Id'], commentController.text, commentController.commentInfo!.comments[currentIndex].commentId, currentIndex);
                            //  hintText = "说点什么吧";
                            // }else{
                            //   sendOrRemoveComment(1, 0, commentInfo?['Id'], commentController.text, 0, -1);
                            // }
                            commentController.isFocus = false;
                            _focusNode.unfocus();

                              },
                          child: Text(
                            "发送",
                            maxLines: 1,
                          ),
                        )),
                  ))
            ],
          ),
        ));
  }

  sendOrRemoveComment(int t,int type,String id,String? comment,int? commentId,int index){
    // t:1:发送，2:回复 ，0:删除
    var params ;
    switch(t){
      case 0:
        params={
          "t":t,
          "type":type,
          "id":id,
          "commentId":commentId
        };

        break;
      case 1:
        params={
          "t":t,
          "type":type,
          "id":id,
          "content":comment
        };
        break;
      case 2:
        params={
          "t":t,
          "type":type,
          "id":id,
          "commentId":commentId,
          "content":comment
        };
        commentController.commentInfo!.comments[index].replyCount+=1;
        break;
    }
    commentController.isSend = true;
    dioRequest.executeGet(url: "/comment",params: params).then((value){

      if(value['code']==200){
        commentController.isSend = false;
        getInfo();
        // if (t==0) {
        //   return;
        // };

      //  getData(widget.params['id']);
      }
    });

  }
  addMoreList()  {

    commentController.addMoreListIsOk = true;
    commentController.numPage+=1;
    print("object加载更多------------------------------------------------${commentInfo?["commentType"]}---"
        "${commentInfo?['Id']}-------${commentController.commentInfo!.totalCount}");

    //排序：1:推荐··2:热度··3:事件
        switch(commentController.sortType){
          case 1:
          case 2:
          params = {
            "type": commentInfo?["commentType"],
            "id": commentInfo?['Id'],
            "sortType": commentController.sortType,
            "pageNo":2

          };
            break;
          case 3:
            params = {
              "type": commentInfo?["commentType"],
              "id": commentInfo?['Id'],
              "sortType": commentController.sortType,
              "pageNo":2,
              "cursor":commentController.commentInfo!.comments[commentController.commentInfo!.comments.length-1].time
            };
            break;
        }
    dioRequest
        .executeGet(url: "/comment/new", params: params).then((value){
      if (value != "error") {
        commentController.commentInfo!.hasMore = value['hasMore'];
        var comments = CommentInfoBean.fromJson(value).comments;
        commentController.addList("comment", comments);
        //  commentController.commentInfo = CommentInfoBean.fromJson(value);
        print("aaaaaaaaaaaaaaaaaaaawwwwwwww${commentController.commentInfo?.comments.length}");
        //   commentController.addMoreListIsOk = false;
        // setState(() {
        //
        // });
      }
    });
  }
  addMoreReplyList(int type,int time,int parentId,int sourceId){
      commentController.addMoreReplyListIsOk = true;
      print("object$type-----$time----z$parentId----$sourceId");
      var p = {"parentCommentId":parentId,"id":sourceId,"type":type,"time":time};
      dioRequest.executeGet(url: "/comment/floor",params: p).then((value){
        print("object$value");
        commentController.replyCommentInfo!.hasMore = value['hasMore'];
        var comments = CommentInfoBean.fromJson(value).comments;
        commentController.addList("reply", comments);
        commentController.addMoreReplyListIsOk = false;
      });
  }
}
