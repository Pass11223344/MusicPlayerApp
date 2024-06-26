
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../NetWork/DioRequest.dart';
import '../bean/CommentInfoBean.dart';
import '../main.dart';
import 'commentPageController.dart';
import 'msgListPage.dart';

class commentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return commentPageState();
  }
}

class commentPageState extends State<commentPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
 // static const channel = MyApp.channel;
  List<CommentInfoBean> commentInfoList = [];
  CommentInfoBean? commentInfoBean;
  var commentController = commentPageController();

  Map? commentInfo;
  var executeGet;
  var _textController;
  var _focusNode;
  var _rePlyTextController ;
  var _rePlyFocusNode ;
  Map<String, dynamic>? params;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
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
   receiveDataFromAndroid();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              titleSpacing: 10,
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.white,
              title:  Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child:
                        const Icon(Icons.arrow_back, color: Colors.black)),
                    // 居左对齐的Icon
                    Container(
                      alignment: Alignment.center,
                      child: const Text('评论', style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
              ),

            body: Stack(
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
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: //AssetImage("images/img.png"),
                                                    NetworkImage(
                                                        commentInfo?[
                                                        "imgUrl"]),
                                                    fit: BoxFit.cover),
                                                borderRadius:BorderRadius.circular(15)
                                            ),
                                          ),

                                          Container(
                                            width: commentInfo?['songName'].length>24?
                                            MediaQuery.of(context).size.width*0.46 :null,
                                            child:  Text(
                                              " ${commentInfo?['songName']}",
                                              overflow:
                                              TextOverflow
                                                  .visible,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontSize: 14),
                                            ),
                                          ),

                                          Container(
                                            width:  commentInfo?['singerName'].length>24?
                                            MediaQuery.of(context).size.width*0.3:null,
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
                                          ),



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
                                            width: 100,
                                            alignment: Alignment.bottomLeft,
                                            child: Obx(() => Text(
                                              "评论(${commentController.CommentInfo?.totalCount})",
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
                                                              Text(
                                                                "推荐",
                                                                style: TextStyle(
                                                                    color: params?["sortType"] == 1
                                                                        ? Colors.black
                                                                        : Colors.grey),
                                                              ),
                                                              const Text(
                                                                "|",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () =>
                                                            upDataInfo(1))),
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
                                                              Text("最热",
                                                                  style: TextStyle(
                                                                      color: params?["sortType"] == 2
                                                                          ? Colors.black
                                                                          : Colors.grey)),
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
                                                          child: Text("最新",
                                                              style: TextStyle(
                                                                  color: params?["sortType"] == 3
                                                                      ? Colors
                                                                      .black
                                                                      : Colors
                                                                      .grey)),
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
                              ? SafeArea(
                            top: false,
                            bottom: false,
                            child: Builder(
                                builder: (BuildContext context) {
                                  return CustomScrollView(
                                    slivers: [
                                      SliverOverlapInjector(
                                          handle: NestedScrollView
                                              .sliverOverlapAbsorberHandleFor(
                                              context)),
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: commentController.CommentInfo!.comments.length,
                                            // childCount: 100,
                                                (BuildContext context,int index){
                                              return Container(
                                                padding: const EdgeInsets.all(10),
                                                color: Colors.white,
                                                child: CommentListItem(context,index),
                                                //  child: ListTile(
                                                //    title: CommentListItem(context,index),
                                                //    onTap: ()=>getReply(index),
                                                //  ),
                                              ) ;

                                            }),
                                      ),
                                      const SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: 80,
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          )
                              : loadingView()),
                        ),
                      )
                          : loadingView();
                    }),

                )]
            ),
          ),
          Obx(() => Visibility(
              visible: commentController.isFocus,
              child: Container(color: Colors.black54))),
          Obx(()=>Visibility(
              visible: commentController.allPage,
              child: Align(alignment: Alignment.bottomCenter, child: inputView(context)))),
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
        setState(() {});
      }
    });
  }

  Widget loadingView() {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
      Container(
        padding: EdgeInsets.only(top: 40),
        alignment: Alignment.topCenter,
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          color: Colors.red,
        ),
      )
    ]);
  }

  getInfo() async {
    params = {
      "type": commentInfo?["commentType"],
      "id": commentInfo?['songId'],
      "sortType": 1,
    };

    executeGet = await dioRequest
        .executeGet(url: "/comment/new", params: params);
    if (executeGet != "error") {

      commentController.commentInfo = CommentInfoBean.fromJson(executeGet);
      print("aaaaaaaaaaaaaaaaaaaa${commentController.CommentInfo?.cursor}");

    }
  }

  upDataInfo(int sortType) async {
    print("当前为${sortType}");
    if (params?["sortType"] == sortType) return;
    params?["sortType"] = sortType;
    commentController.secondPage = !commentController.secondPage;
    await getInfo();
    commentController.secondPage = !commentController.secondPage;
  }

  Widget CommentListItem(BuildContext context, int index) {
    return Container(
        padding:const EdgeInsets.only(left: 10),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: MediaQuery.of(context).size.width, child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child:
                    GestureDetector(
                      child:
                      Row(
                        children: [
                         getImg(url: commentController.CommentInfo!.comments[index].user.avatarUrl),
                          Expanded(
                              flex: 8,
                              child: Container(padding: EdgeInsets.only(left: 12),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      commentController.CommentInfo!.comments[index].user.nickname,
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text("${commentController.CommentInfo!.comments[index].timeStr}${commentController.CommentInfo!.comments[index].ipLocation.location == "" ?
                                    "" : commentController.CommentInfo!.comments[index].ipLocation.location}",

                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 8,
                                      ),
                                    )
                                  ],) ,)),

                        ],
                      ),
                      onTap: () {},
                    )),
                // Expanded(
                //     flex: 1,
                //     child:  TextButton.icon(
                //         iconAlignment: IconAlignment.end,
                //         onPressed: (){},
                //         label: Text(
                //           maxLines: 1,
                //           overflow: TextOverflow.ellipsis,
                //           "${commentController.CommentInfo!.comments[index].likedCount}",
                //           style: const TextStyle(color: Colors.grey,fontSize: 10),),
                //         icon://Obx(()=>commentController.CommentInfo!.comments[index].liked ?
                //         const Icon(Icons.recommend_outlined,color: Colors.red,size: 10) //:const Icon(Icons.recommend,color: Colors.grey,size: 10,)),
                //     ))

              ],)
              ,),

            ListTile(
              title: Container(
                padding: EdgeInsets.only(left: 50),
                width: double.infinity,
                child:
                  Text(
                      textAlign: TextAlign.left,
                      commentController.CommentInfo!.comments[index].content,
                      style: const TextStyle(color: Colors.black, fontSize: 14,)),
              ),
              onTap: (){},

            ),

            Container(
              margin:EdgeInsets.only(left: 60,top: 8) ,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.5,color: Colors.grey))
              ),)
          ],)
    );
  }

  Widget inputView(BuildContext context) {
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
                        decoration: const InputDecoration(
                            hintText: "我也想说",
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(
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
                              commentController.text == "" ? null : () {},
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
  getReply(int index) async {
    // Map<String,dynamic> replyParams = {
    //   "parentCommentId":commentController.CommentInfo!.comments[index].commentId,
    //   "id":commentInfo?["songId"],
    //   "type":commentInfo?["commentType"]
    // };
    // var NetReplyData = await DioRequest().executeGet(url: '/comment/floor',params: replyParams);
    // if (NetReplyData != "error") {
    //  commentController.replyCommentInfo  =  CommentInfoBean.fromJson(NetReplyData);
    //  commentController.replyPage = true;
    // }
     showModalBottomSheet(

         isScrollControlled: true, // 允许滚动
         context: context,
        builder: (context){
      return Container(

        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.9,
        child: Stack(

            children: [
              Column(children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height:  kToolbarHeight,
                      color: Colors.transparent,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        title: Text("回复()"),centerTitle: true,),)),
                Container(
                    decoration: const BoxDecoration( border: Border(bottom:BorderSide(width: 15,color: Colors.grey))),
                    padding:const EdgeInsets.only(left: 10,right: 10),
                    child:    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child:
                          Row(
                            children: [
                              getImg(url: commentController.CommentInfo!.comments[index].beReplied[index].user.avatarUrl),
                              Expanded(
                                  flex: 8,
                                  child: Container(padding: EdgeInsets.only(left: 12),

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          commentController.CommentInfo!.comments[index].beReplied[index].user.nickname,
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),

                                        Text("${commentController.CommentInfo!.comments[index].timeStr}${commentController.CommentInfo!.comments[index].ipLocation.location == "" ? "" : commentController.CommentInfo!.comments[index].ipLocation.location}",

                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 8,
                                          ),
                                        )
                                      ],) ,)),

                            ],
                          ),
                          onTap: () {},
                        ),

                        ListTile(
                          title: Container(
                            width: double.infinity,
                            child: Text(
                                textAlign: TextAlign.left,
                                commentController.CommentInfo!.comments[index].content,
                                style: const TextStyle(color: Colors.black, fontSize: 14,)),
                          ),

                        ),

                      ],)
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Text("全部回复()"),),
                Container(
                    padding:const EdgeInsets.only(left: 10),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: MediaQuery.of(context).size.width, child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child:
                                GestureDetector(
                                  child:
                                  Row(
                                    children: [
                                      ClipOval(
                                        child:
                                        Image.asset("images/img.png",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                          flex: 8,
                                          child: Container(padding: EdgeInsets.only(left: 12),

                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  "commentContccccccccccccccccccccccccccccccroller.CommentI",
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold),
                                                ),

                                                Text("${commentController.CommentInfo!.comments[index].timeStr}${commentController.CommentInfo!.comments[index].ipLocation.location == "" ? "" : commentController.CommentInfo!.comments[index].ipLocation.location}",

                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 8,
                                                  ),
                                                )
                                              ],) ,)),

                                    ],
                                  ),
                                  onTap: () {},
                                )),
                            Expanded(
                                flex: 1,
                                child:  TextButton.icon(
                                    iconAlignment: IconAlignment.end,
                                    onPressed: (){},
                                    label: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      "${commentController.CommentInfo!.comments[index].likedCount}",
                                      style: const TextStyle(color: Colors.grey,fontSize: 10),),
                                    icon://Obx(()=>commentController.CommentInfo!.comments[index].liked ?
                                    const Icon(Icons.recommend_outlined,color: Colors.red,size: 10) //:const Icon(Icons.recommend,color: Colors.grey,size: 10,)),
                                ))

                          ],)
                          ,),

                        ListTile(
                          title: Container(
                            padding: EdgeInsets.only(left: 50),
                            width: double.infinity,
                            child: Column(children: [
                              Text(
                                  textAlign: TextAlign.left,
                                  commentController.CommentInfo!.comments[index].content,
                                  style: const TextStyle(color: Colors.black, fontSize: 14,)),
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                child: Row(children: [
                                  Text("开发贷款 : ",style: TextStyle(color: Colors.blue,fontSize: 10),),
                                  Text("大幅度反对法反对士大夫十分",style: TextStyle(color: Colors.grey,fontSize: 10),)
                                ],),
                                decoration: BoxDecoration(border: Border(left: BorderSide(width: 2,color: Colors.grey))),
                              )
                            ],),

                          ),
                          onTap: (){},

                        ),

                        Container(
                          margin:EdgeInsets.only(left: 60,top: 8) ,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.5,color: Colors.grey))
                          ),)
                      ],)
                ),




              ],
              ),
              Obx(() => Visibility(
                  visible: commentController.isFocus,
                  child: Container(color: Colors.black54))),
              Obx(()=>Visibility(
                  visible: commentController.allPage,
                  child: AnimatedPadding(
                    padding:EdgeInsets.only(
                     bottom: MediaQuery.of(context).viewInsets.bottom,
                      ) ,
                    duration: Duration(milliseconds: 1),
                    child: Align(
                        alignment: Alignment.bottomCenter, child:
                    Container(
                      height: 60,
                      color: Colors.red,
                      child: TextField(
                        focusNode: _rePlyFocusNode,
                        controller: _rePlyTextController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ) ,
                    )
                    ),
                  )
              )),]

        ),
      );

        });
  }
}
