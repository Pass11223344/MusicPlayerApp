import 'package:flutter/material.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/util/Utils.dart';

import 'myPage.dart';

class sengPage extends StatefulWidget {
  final Map data;

  const sengPage({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => sengPageState();
}

class sengPageState extends State<sengPage> {
  late TextEditingController _textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //  var _isTextOverflow = false;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("分享到动态"),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    print(
                        "object------${widget.data['id']}----${_textController.text}-----${widget.data['type']}");
                    // dioRequest.executeGet(url: "/share/resource",params: {"id":widget.data['id'],
                    //   "msg":_textController.text,"type":widget.data['type']}).then((_){
                    //
                    //
                    // });
                    Utils.showTopSnackBar(context, "接口出现问题了......");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "分享",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
        body: PopScope(
          onPopInvoked: (isPop) {
            channel.invokeMethod("hideOrShowView", false);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                TextField(
                  controller: _textController,
                  maxLength: 140,
                  autofocus: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "说点什么吧",
                    helperText: '最大字数为140', // 在输入框下方显示提示
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        getSquareImg(
                            Url: widget.data['img'], width: 50, height: 50),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              widget.data['subTitle'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
