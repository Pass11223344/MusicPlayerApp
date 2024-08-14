import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_misic_module/NetWork/DioRequest.dart';
import 'package:flutter_misic_module/bean/CommentInfoBean.dart';
import 'package:flutter_misic_module/bean/RelayBean.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/util/Utils.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'SliverHeaderDelegate.dart';
import 'WPopupMenu.dart';
import 'msgListPage.dart';
import 'myPage.dart';
import 'myPageController.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class traceCommentPage extends StatefulWidget {
  final Map params;

  const traceCommentPage({super.key, required this.params});

  @override
  State<StatefulWidget> createState() => traceCommentState();
}

class traceCommentState extends State<traceCommentPage>
    with TickerProviderStateMixin {
  late TabController tabController;

  var size = MediaQueryData.fromView(WidgetsBinding.instance.window).size;

  //final  _myPageController = Get.find<myPageController>();
  ScrollController _scrollController = ScrollController();

  late TextEditingController _textController;

  late TextEditingController _replyTextController;

  String hintText = "发送消息";
  String replyHintText = "发送消息";
  bool isReply = false;
  final List<String> actions = [
    '复制',
    '删除',
  ];
  KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  final myPageController _myPageController = Get.find<myPageController>();

  final FocusNode _focusNode = FocusNode();
  final FocusNode _replyFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //  Get.put(myPageController());
    _textController = TextEditingController();
    _replyTextController = TextEditingController();
    tabController = TabController(length: 2, vsync: this);
    //  _myPageController = Get.find<myPageController>();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
      } else {
        // 键盘隐藏时的处理逻辑
        _focusNode.unfocus();
        _replyFocusNode.unfocus();
        hintText = "发送消息";
        replyHintText = "发送消息";
        isReply = false;
      }
    });
    getData(widget.params['id']);
    tabController.addListener(() {
      _myPageController.traceCommentTabIndex = tabController.index;
    });
  }

  @override
  void didUpdateWidget(covariant traceCommentPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getData(widget.params['id']);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var list = widget.params['latestLikedUsers'] as List<LatestLikedUsers>;
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          //使收缩时不改变appBar的颜色
          backgroundColor: Colors.white,
          toolbarHeight: 38,
          titleSpacing: 0,
          centerTitle: true,
          title: const Text("动态"),
        ),
        body: PopScope(
          onPopInvoked: (isPop) {
            if (!_myPageController.isReplyComment) {
              var p = {"origin": "my_page"};
              channel.invokeMethod("back", p);
            }
          },
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.white,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: expandedItem(widget.params),
                  ),
                  SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverAppBarDelegate(TabBar(
                        dividerHeight: 0,
                        indicatorPadding: EdgeInsets.zero,
                        indicatorColor: Colors.red,
                        labelColor: Colors.black,
                        unselectedLabelColor: const Color(0xff77767c),
                        controller: tabController,
                        tabs: const [
                          Tab(text: "评论 "),
                          Tab(text: "点赞 "),
                        ],
                      ))),
                  Obx(() {
                    return SliverVisibility(
                        visible: _myPageController.traceCommentTabIndex == 0,
                        sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverHeaderDelegate.fixedHeight(
                              height: 40,
                              child: Container(
                                  color: Colors.white,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  width: double.infinity,
                                  child: Text("评论区",
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign.start)),
                            )));
                  }),
                ];
              },
              body: TabBarView(
                controller: tabController,
                children: [
                  Obx(() {
                    return _myPageController.isTraceComment
                        ? Stack(
                            children: [
                              CustomScrollView(
                                // controller: _scrollController,
                                slivers: [
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          childCount: _myPageController
                                              .itemCount, (context, index) {
                                    var comment = _myPageController
                                        .traceCommentInfo!.comments[index];

                                    return comment.parentCommentId == 0
                                        ? getCommentListItem(comment)
                                        : const SizedBox(
                                            height: 0,
                                            width: 0,
                                          );
                                  })),
                                  SliverToBoxAdapter(
                                    child: SizedBox(
                                      height: 50,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    width: size.width - 20,
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
                                                focusNode: _focusNode,
                                                maxLines: 4,
                                                controller: _textController,
                                                decoration: InputDecoration(
                                                    hintText: hintText,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 8,
                                                            vertical: 6),
                                                    hintStyle: const TextStyle(
                                                        color: Colors.grey),
                                                    border: InputBorder.none),
                                              ),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            child: GestureDetector(
                                                onTap: () async {
                                                  String text = _textController
                                                      .text
                                                      .trim();
                                                  if (text.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content:
                                                            Text('输入框不能为空！'),
                                                        duration: Duration(
                                                            seconds:
                                                                1), // 设置显示时间
                                                        backgroundColor: Colors
                                                            .black12, // 设置背景色
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  _myPageController
                                                      .isTraceComment = false;

                                                  if (isReply) {
                                                    sendOrRemoveComment(
                                                        2,
                                                        widget.params['id'],
                                                        _textController.text,
                                                        _myPageController
                                                            .currentCommentId);
                                                  } else {
                                                    sendOrRemoveComment(
                                                        1,
                                                        widget.params['id'],
                                                        _textController.text,
                                                        0);
                                                  }
                                                  isReply = false;
                                                  _focusNode.unfocus();
                                                  _textController.clear();
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text("发送"),
                                                )))
                                      ],
                                    ),
                                  )),
                            ],
                          )
                        : Utils.loadingView(Alignment.center);
                  }),
                  CustomScrollView(
                    slivers: [
                      SliverFixedExtentList.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(
                                Icons.account_circle,
                                color: Colors.deepOrange,
                              ),
                              title: Text("用户: ${list[index].s}"),
                            );
                          },
                          itemExtent: 60)
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  expandedItem(Map event) {
    // "avatarUrl":e.user.avatarUrl,
    // "name":"${e.user.nickname}  分享${getType(e.message!.type)}",
    // "show_time&place":"${Utils.formatDate(e.showTime)} ${e.ipLocation.location}",
    // "msg":e.message!.msg,
    // "img":imageUrl,
    // "title":title,
    // "creatorName":creatorName
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //    Container(color: Colors.red,width: 50,height: 50,margin: EdgeInsets.only(right: 10),),
                getCircularImg(url: event['avatarUrl']),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event['name']),
                    Text(event['show_time&place']),
                  ],
                )
              ],
            ),
            Container(
              height: event['msg'] == "" ? 0 : null,
              padding: const EdgeInsets.only(top: 10, left: 4),
              child: Text(overflow: TextOverflow.ellipsis, event['msg']),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width - 30,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  getSquareImg(Url: event['img'], width: 50, height: 50),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Text(
                        "by: ${event['creatorName']}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  getCommentListItem(Comments event) {
    return Container(
        padding: const EdgeInsets.only(top: 15, left: 10),
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
                        bottom: BorderSide(color: Colors.grey, width: 0.8))),
                child: WPopupMenu(
                    onValueChanged: (int value) {
                      switch (value) {
                        case 0:
                          Utils.copyTextToClipboard(event.content, context);
                          break;
                        case 1:
                          Comments commentsToRemove = _myPageController
                              .traceCommentInfo!.comments
                              .firstWhere((comment) =>
                                  comment.commentId == event.commentId);

                          if (commentsToRemove != null) {
                            _myPageController.traceCommentInfo!.comments
                                .remove(commentsToRemove);
                            _myPageController.itemCount = _myPageController
                                .traceCommentInfo!.comments.length;
                            sendOrRemoveComment(
                                0, widget.params['id'], "", event.commentId);
                            _myPageController
                                .relayInfo!
                                .events[widget.params['index'] as int]
                                .info
                                .commentCount -= 1;
                            Utils.showTopSnackBar(context, "已删除");
                            // 如果需要，可以在这里添加一些删除操作的反馈
                          } else {
                            // 或者如果没找到用户，可以打印一个消息
                            print('User with ID 323230 not found.');
                          }
                          break;
                      }
                    },
                    pressType: PressType.longPress,
                    actions: actions,
                    key: null,
                    child: InkWell(
                        onTap: () {
                          isReply = true;
                          _focusNode.requestFocus();
                          hintText = "回复: ${event.user.nickname}";
                          _myPageController.currentCommentId = event.commentId;
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.user.nickname),
                              Text(
                                  "${event.timeStr}  ${event.ipLocation.location}"),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 4),
                                child: Text(event.content),
                              ),
                              Obx(() {
                                return Visibility(
                                  visible: _myPageController
                                          .maps['${event.commentId}']![0] !=
                                      0,
                                  child: InkWell(
                                    onTap: () {
                                      showSheet(event);
                                      _myPageController.isReplyComment = true;
                                      _myPageController.currentReplyComment =
                                          _myPageController
                                              .maps['${event.commentId}']![0];
                                      channel
                                          .invokeMethod("addPage", {"id": -2});
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 4),
                                        child: Text(
                                          "${_myPageController.maps['${event.commentId}']![0]}条回复>",
                                          style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 10),
                                        )),
                                  ),
                                );
                              })
                            ]))))
          ],
        ));
  }

  getReplyItem(String headId, Comments event, bool showLine, int parentId) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15),
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
              decoration: showLine
                  ? const BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.black12, width: 0.8)))
                  : null,
              child: headId == '0'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(event.user.nickname),
                        Text("${event.timeStr}  ${event.ipLocation.location}"),
                        Container(
                          padding: const EdgeInsets.only(top: 10, left: 4),
                          child: Text(softWrap: true, event.content),
                        ),
                        event.beReplied.length > 0
                            ? Visibility(
                                visible:
                                    event.beReplied[0].beRepliedCommentId !=
                                        parentId,
                                child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(
                                                color: Colors.black12,
                                                width: 2))),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                "  ${event.beReplied[0].user.nickname}",
                                            style: const TextStyle(
                                                color: Colors.blueAccent)),
                                        TextSpan(
                                            text:
                                                " : ${event.beReplied[0].content}",
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ]),
                                    )))
                            : Container()
                      ],
                    )
                  : WPopupMenu(
                      onValueChanged: (int value) {
                        switch (value) {
                          case 0:
                            Utils.copyTextToClipboard(event.content, context);
                            break;
                          case 1:
                            Comments commentsToRemove = _myPageController
                                .traceCommentInfo!.comments
                                .firstWhere((comment) =>
                                    comment.commentId == event.commentId);

                            if (commentsToRemove != null) {
                              _myPageController.traceCommentInfo!.comments
                                  .remove(commentsToRemove);
                              _myPageController.itemCount -= 1;
                              _myPageController.currentReplyComment -= 1;
                              _myPageController.maps[headId]![0] -= 1;

                              _myPageController
                                  .relayInfo!
                                  .events[widget.params['index'] as int]
                                  .info
                                  .commentCount -= 1;
                              Utils.showTopSnackBar(context, "已删除");

                              sendOrRemoveComment(
                                  0, widget.params['id'], "", event.commentId);
                              // 如果需要，可以在这里添加一些删除操作的反馈
                            } else {
                              // 或者如果没找到用户，可以打印一个消息
                              print('User with ID 323230 not found.');
                            }
                            break;
                        }
                      },
                      pressType: PressType.longPress,
                      actions: actions,
                      key: null,
                      child: InkWell(
                          onTap: () {
                            _myPageController.currentCommentId =
                                event.commentId;
                            _replyFocusNode.requestFocus();
                            replyHintText = "回复: ${event.user.nickname}";
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(event.user.nickname),
                              Text(
                                  "${event.timeStr}  ${event.ipLocation.location}"),
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 4),
                                child: Text(softWrap: true, event.content),
                              ),
                              event.beReplied.length > 0
                                  ? Visibility(
                                      visible: event.beReplied[0]
                                              .beRepliedCommentId !=
                                          parentId,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: Colors.black12,
                                                      width: 2))),
                                          child: RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text:
                                                      "  ${event.beReplied[0].user.nickname}",
                                                  style: const TextStyle(
                                                      color:
                                                          Colors.blueAccent)),
                                              TextSpan(
                                                  text:
                                                      " : ${event.beReplied[0].content}",
                                                  style: const TextStyle(
                                                      color: Colors.black))
                                            ]),
                                          )))
                                  : Container()
                            ],
                          ))))
        ],
      ),
    );
  }

  getData(String id) async {
    _myPageController.isTraceComment = false;

    var dioRequest = DioRequest();

    dioRequest.executeGet(url: "/comment/event", params: {"threadId": id}).then(
        (value) {
      _myPageController.traceCommentInfo = CommentInfoBean.fromJson(value);
      getList();
      _myPageController.isTraceComment = true;
    });
  }

  void getList() {
    _myPageController.traceCommentInfo?.comments =
        _myPageController.traceCommentInfo!.comments.reversed.toList();
    // var count = 0;
    Map<String, List> maps = {};
    Map<String, String> reply = {};
    print(
        "object------------------------${_myPageController.traceCommentInfo?.comments.length}");
    _myPageController.traceCommentInfo?.comments.forEach((value) {
      if (value.parentCommentId == 0) {
        // count++;
        print("object------------------------${value.content}");
        maps['${value.commentId}'] = [0];
      } else {
        if (!maps.containsKey("${value.parentCommentId}")) {
          maps[reply['${value.parentCommentId}']]?.add(value.commentId);
          maps[reply['${value.parentCommentId}']]?[0]++;
        } else {
          maps['${value.parentCommentId}']?.add(value.commentId);
          maps['${value.parentCommentId}']?[0]++;
          reply["${value.commentId}"] = "${value.parentCommentId}";
        }
      }
    });
    _myPageController.itemCount =
        _myPageController.traceCommentInfo!.totalCount >= 20
            ? 20
            : _myPageController.traceCommentInfo!.totalCount;
    //_myPageController.traceCommentInfo?.count = count;
    _myPageController.maps = maps;

    _myPageController.traceCommentInfo?.comments =
        _myPageController.traceCommentInfo!.comments.reversed.toList();
  }

  sendOrRemoveComment(
      int type, String threadId, String? comment, int? commentId) {
    // type:1:发送，2:回复 ，0:删除
    var params;
    switch (type) {
      case 0:
        params = {
          "t": type,
          "type": 6,
          "threadId": threadId,
          "commentId": commentId
        };
        break;
      case 1:
        params = {
          "t": type,
          "type": 6,
          "threadId": threadId,
          "content": comment
        };
        break;
      case 2:
        params = {
          "t": type,
          "type": 6,
          "threadId": threadId,
          "commentId": commentId,
          "content": comment
        };
        break;
    }
    dioRequest.executeGet(url: "/comment", params: params).then((value) {
      if (value['code'] == 200) {
        if (type == 0) {
          _myPageController.isTraceComment = true;
          return;
        }
        ;
        getData(widget.params['id']);
      }
    });
  }

  showSheet(Comments event) {
    showMaterialModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => PopScope(
        onPopInvoked: (isPop) {
          _myPageController.isReplyComment = false;
          _focusNode.unfocus();
        },
        child: Container(
            color: Colors.transparent,
            height: size.height * 0.8,
            child: Stack(
              children: [
                Column(
                  children: [
                    AppBar(
                      scrolledUnderElevation: 0.0,
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      title: Obx(() {
                        return Text(
                            "回复(${_myPageController.currentReplyComment})");
                      }),
                    ),
                    Flexible(
                        child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: getReplyItem("0", event, false, 0),
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
                        Obx(() {
                          return _myPageController.isTraceComment
                              ? SliverList.builder(
                                  itemCount: _myPageController.itemCount,
                                  itemBuilder: (BuildContext context, int i) {
                                    var comment = _myPageController
                                        .traceCommentInfo!.comments[i];

                                    return _myPageController
                                            .maps['${event.commentId}']!
                                            .contains(_myPageController
                                                .traceCommentInfo!
                                                .comments[i]
                                                .commentId)
                                        ? _myPageController.maps[
                                                    '${event.commentId}']![0] !=
                                                0
                                            ? getReplyItem("${event.commentId}",
                                                comment, true, event.commentId)
                                            : Container()
                                        : SizedBox();
                                  })
                              : SliverToBoxAdapter(
                                  child: Utils.loadingView(Alignment.center),
                                );
                        }),
                        const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 50,
                          ),
                        ),
                      ],
                    ))
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
                        width: size.width - 20,
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
                                      String text =
                                          _replyTextController.text.trim();
                                      if (text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('输入框不能为空！'),
                                            duration: Duration(seconds: 1),
                                            // 设置显示时间
                                            backgroundColor:
                                                Colors.black12, // 设置背景色
                                          ),
                                        );
                                        return;
                                      }
                                      _myPageController.isTraceComment = false;
                                      sendOrRemoveComment(
                                          2,
                                          widget.params['id'],
                                          _replyTextController.text,
                                          _myPageController.currentCommentId);

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
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}
