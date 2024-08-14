import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_misic_module/bean/MsgBean.dart';
import 'package:flutter_misic_module/page/chatPageController.dart';
import 'package:flutter_misic_module/page/msgListPage.dart';
import 'package:get/get.dart';

import '../main.dart';
import 'myPageController.dart';

class chatPage extends StatefulWidget {
  final Map data;

  const chatPage({super.key, required this.data});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return chatPageState();
  }
}

class chatPageState extends State<chatPage> with WidgetsBindingObserver {
  // late final WebSocketChannel socketChannel ;
  var pageController = Get.find<PageControllers>();
  var _textController;

  //var _rePlyFocusNode ;
  var fromUser;
  var toUser;
  var id;
  chatPageController controller = chatPageController();

  final ScrollController _scrollController = ScrollController();
  var mediaQuery = MediaQueryData.fromView(WidgetsBinding.instance.window);
  var keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textController = TextEditingController();
    // _rePlyFocusNode = FocusNode();
    //  socketChannel = IOWebSocketChannel.connect(Uri.parse("wss://www.consistent.top/msg/private/history?uid=${ widget.data["id"]}"));
    receiveDataFromAndroid();
    getData();
    // _listenForMessages();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // socketChannel.sink.close();
    _scrollController.dispose();
  }

  void scrollToBottom() {
    if (_scrollController.offset !=
        _scrollController.position.maxScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.pageIsOk
          ? Scaffold(
              backgroundColor: Color(0xFFFCFCFC),
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                toolbarHeight: 38,
                centerTitle: true,
                title: Text("${widget.data["name"]}"),
                backgroundColor: Colors.white,
              ),
              body: PopScope(
                onPopInvoked: (sisPop) {
                  channel.invokeMethod("back", "");
                },
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: Obx(() {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              scrollToBottom();
                            });

                            return ListView.builder(
                                padding: EdgeInsets.only(bottom: 80),
                                controller: _scrollController,
                                itemCount: controller.msgList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    child: _listItem(index),
                                  );
                                });
                          })),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: mediaQuery.size.width - 20,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 8,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 14, bottom: 2),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: TextField(
                                      maxLines: 6,
                                      controller: _textController,
                                      decoration: const InputDecoration(
                                          hintText: "发送消息",
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () async {
                                      Map<String, dynamic> params = {
                                        "user_ids": widget.data["id"],
                                        "msg": _textController.text
                                      };
                                      await dioRequest.executeGet(
                                          url: "/send/text", params: params);
                                      var dateTime = DateTime.now();
                                      var now = dateTime.millisecondsSinceEpoch;
                                      controller.addMsgList([
                                        MsgBean(
                                            fromUser,
                                            ToUser("", "", "", 0),
                                            '{"msg":"${_textController.text}"}',
                                            0,
                                            now)
                                      ]);
                                      _textController.clear();
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text("发送"),
                                    ),
                                  ))
                            ],
                          ),
                        )),
                  ],
                ),
              ))
          : Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.red,
              ),
            );
    });
  }

  void getData() async {
    var data = await dioRequest.executeGet(
        url: "/msg/private/history", params: {"uid": widget.data['id']});

    var list =
        (data as List<dynamic>).map((json) => MsgBean.fromJson(json)).toList();

    controller.addMsgList(list.reversed.toList());

    controller.pageIsOk = true;
  }

  _listItem(int index) {
    var json = jsonDecode(controller.msgList[index].msg);

    Widget widget;

    if (controller.msgList[index].fromUser.userId == pageController.userId) {
      fromUser = FromUser(
          controller.msgList[index].fromUser.nickname,
          controller.msgList[index].fromUser.avatarUrl,
          _textController.text,
          controller.msgList[index].fromUser.userId);

      widget = Container(
        width: mediaQuery.size.width - 120,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                constraints:
                    BoxConstraints(maxWidth: mediaQuery.size.width - 150),
                padding: EdgeInsets.all(10),
                child: Text("${json['msg']}",
                    style: TextStyle(fontSize: 10, color: Colors.white)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.blue),
              ),
              SizedBox(
                width: 6,
              ),
              getCircularImg(
                url: controller.msgList[index].fromUser.avatarUrl,
              )
            ]),
      );
    } else {
      // toUser = ToUser(controller.msgList[index].fromUser.nickname,
      //     controller.msgList[index].fromUser.avatarUrl, "description", userId);
      widget = Container(
        width: mediaQuery.size.width - 120,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          getCircularImg(url: controller.msgList[index].fromUser.avatarUrl),
          const SizedBox(
            width: 6,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: mediaQuery.size.width - 150),
            padding: EdgeInsets.all(10),
            child: Text(
              "${json['msg']}",
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white),
          ),
        ]),
      );
    }
    return widget;
  }

  void receiveDataFromAndroid() {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "back":
          Navigator.pop(context);
          break;
      }
    });
  }
}
