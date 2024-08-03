import 'package:flutter/material.dart';

import 'WPopupMenu.dart';

class PopupRoutePage extends StatefulWidget {
  @override
  _PopupRoutePageState createState() => _PopupRoutePageState();
}

class _PopupRoutePageState extends State<PopupRoutePage> {
  final List<String> actions = [
    '复制',
    '转发',
    '收藏',
    '删除',
    '转发',
    '收藏',
    '删除',

  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PopupRoutePage'),
        ),
        body: Stack(
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: 40,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    alignment: index % 2 == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: WPopupMenu(
                      onValueChanged: (int value) {
                       print("object-----------------点击了$value");
                      },
                      pressType: PressType.longPress,
                      actions: actions,
                      key: null,
                      child: UnconstrainedBox(
                        child: Container(
                          height: 40,
                          color: Colors.cyan,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              Image.asset("images/img.png",fit: BoxFit.cover,),
                              Text(
                                '我是Title $index',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

          ],
        ));
//    );
  }
}
