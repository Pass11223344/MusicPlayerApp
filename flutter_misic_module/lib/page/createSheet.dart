import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class BottomPopupInput extends StatefulWidget {
  final BuildContext context;
 const BottomPopupInput({Key? key, required this.context});

  @override
  State<BottomPopupInput> createState() => _MyHomePageState();

}


class _MyHomePageState extends State<BottomPopupInput> with WidgetsBindingObserver {

  // 创建一个FocusNode
  final FocusNode _focusNode = FocusNode();
  double _virtualHeight = 0;
  final _sheetPadding = const EdgeInsets.all(20);

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      show(); // 在页面加载完成后调用show方法显示底部弹窗
      FocusScope.of(widget.context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {

    // 此处我们用键盘高度减去虚拟框（virtualBox）下面内容的高度，在减去sheet的下方内边距。
    // 即得到虚拟框的高度
    final transDelta = MediaQuery.of(widget.context).viewInsets.bottom  - _sheetPadding.bottom;

    _virtualHeight = transDelta <= 0 ? 0 : transDelta;
    setState(() {});
    super.didChangeMetrics();
  }

  void show() {
    showModalBottomSheet(
        context: widget.context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.25),
        builder: (ctx) {
          return
          Container(

            height:_virtualHeight+200,
            child:  Column(
              children: [
                Container(
                  padding: _sheetPadding,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      // 此处加了一个ListView，用于演示较为复杂的场景
                      Container(
                        height: 110,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white,),
                      ),
                       TextField(
                        focusNode: _focusNode,
                      ),


                    ],
                  ),
                ),
                Container(
                    color: Colors.transparent,
                    height: _virtualHeight),

              ],
            ),
          );

        }).then((v){
      //pageController.isOverlayVisible = ! pageController.isOverlayVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center();
  }

}
