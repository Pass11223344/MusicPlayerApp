

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class searchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => searchPageState();

}
class searchPageState extends State<searchPage>{
  final GlobalKey _wrapKey = GlobalKey();
  var warp_widh = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width-20;

  List<Widget> warp_widgets =  [

    Container(
      height: 40,
      child:  Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(
              color: Colors.transparent, // 将边框颜色设为透明
            ),
          ),
          backgroundColor: Colors.black12,
          label: Text('Hamilton222222222222222222222222')),
    ),
    Container(
      height: 40,

      child:  Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(
              color: Colors.transparent, // 将边框颜色设为透明
            ),
          ),
          backgroundColor: Colors.black12,
          label: Text('Hamilton')),
    ),
    Container(
      height: 40,
      child:  Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(
              color: Colors.transparent, // 将边框颜色设为透明
            ),
          ),
          backgroundColor: Colors.black12,
          label: Text('sssssssssssssss')),
    ),

    Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: const BorderSide(
            color: Colors.transparent, // 将边框颜色设为透明
          ),
        ),
        backgroundColor: Colors.grey,
        label: Text('sssssssssssssss')),
    Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: const BorderSide(
            color: Colors.transparent, // 将边框颜色设为透明
          ),
        ),
        backgroundColor: Colors.grey,
        label: Text('Hamilffffffffffton')),
    Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: const BorderSide(
            color: Colors.transparent, // 将边框颜色设为透明
          ),
        ),
        backgroundColor: Colors.grey,
        label: Text('Hamiltofffn')),
    Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: const BorderSide(
            color: Colors.transparent, // 将边框颜色设为透明
          ),
        ),
        backgroundColor: Colors.grey,
        label: Text('Hamiffflton')),


  ];
  late List<Widget> partial_labels ;
  //late List<Widget> added_labels;

  final double charWidthEstimate = 8.0; // 假设每个字符大约占用8像素宽度
  final double chipHorizontalPadding = 8.0; // Chip的左右内边距估算

  double _estimateChipWidth(dynamic widget) {
    String text = '';

    if (widget is Container && widget.child is Chip) {
      text = (widget.child as Chip).label?.toString() ?? '';

      return roughlyWidth(text);
    } else if (widget is Chip) {
      text = widget.label?.toString() ?? '';

      return roughlyWidth(text);
    }
   return 0.0;
  }

  double roughlyWidth(String text) {
    TextSpan textSpan = TextSpan(text: text);
    TextPainter  textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout();
    return textPainter.width+8.0;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      warp_widgets.add(_arrow_downOrUp(false));
     //added_labels = warp_widgets.map((Widget w)=>w).toList()..add(_arrow_downOrUp(false));
      double totalWidth = 0;
      bool isAdd = false;
      for(int i=0 ; i<warp_widgets.length;i++){
       if( _estimateChipWidth(warp_widgets[i])>=warp_widh/2){
         totalWidth+=warp_widh/2;
         isAdd = true;
       }else if(_estimateChipWidth(warp_widgets[i])<40){
         totalWidth+=45;
         isAdd = true;
       }

        if(totalWidth+_estimateChipWidth(warp_widgets[i])+40>warp_widh){
          partial_labels.add(_arrow_downOrUp(true));
          return;
        }else{
          partial_labels.add(warp_widgets[i]);
          if(!isAdd){
            totalWidth += _estimateChipWidth(warp_widgets[i]);
          }

        }
       isAdd = false;
        print("在循环${totalWidth}----->");
      }
    });


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("${MediaQuery.of(context).size.width}");
    return Scaffold(

      appBar: AppBar(
        titleSpacing: 0,
        title:Container(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child:
                      const Icon(Icons.arrow_back, color: Colors.black))),
              Expanded(
                  flex: 8,
                  child:  Container(


                    width: MediaQuery.of(context).size.width-120,
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12,width: 1),
                        borderRadius: BorderRadius.circular(25)),
                    child: const TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: "搜索歌曲",
                          isCollapsed: true,
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child:  GestureDetector(
                    child:
                    Container(
                        alignment: Alignment.centerRight,
                        child:
                        const Text("搜索",style: TextStyle(fontSize: 16)))
                    ,
                  ))
            ],
          ),
        ),
        bottom:1>0?const TabBar(
            tabs: [
              Tab(text: "综合",),
              Tab(text: "单曲",),
              Tab(text: "歌单",),
              Tab(text: "歌手",),
              Tab(text: "用户",),
              Tab(text: "专辑",),
            ]):null

      ),

      body: Container(
        padding: const EdgeInsets.only(right: 10,left: 10,top: 20),
        child: Center(
          child: Stack(
            children: [
            Visibility(
                visible: true,
                child: Stack(
                  children: [Column(
                    children: [
                      Visibility(
                          visible: true,
                          child:Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("搜索历史",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                  Icon(Icons.delete_outline_outlined,size: 20,color: Colors.grey,)
                                ],),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(top:10,bottom: 30),
                                child:  Wrap(
                                  key: _wrapKey,
                                  spacing: 8.0,
                                  runSpacing: 4.0,
                                  children: [

                                    Container(
                                      height: 40,
                                      width: roughlyWidth("Hamilton222222222222222222222222")>=warp_widh/2?
                                      warp_widh/2:
                                      roughlyWidth("Hamilton222222222222222222222222")<40?45:null,
                                      child:  Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            side: const BorderSide(
                                              color: Colors.transparent, // 将边框颜色设为透明
                                            ),
                                          ),
                                          backgroundColor: Colors.black12,
                                          label: Text('Hamilton222222222222222222222222',overflow: TextOverflow.ellipsis,)),
                                    ) ,
                                    Container(
                                      height: 40,
                                      child:  Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            side: const BorderSide(
                                              color: Colors.transparent, // 将边框颜色设为透明
                                            ),
                                          ),
                                          backgroundColor: Colors.black12,
                                          label: Text('Hamilton')),
                                    ),
                                    Container(
                                      height: 40,
                                      child:  Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25.0),
                                            side: const BorderSide(
                                              color: Colors.transparent, // 将边框颜色设为透明
                                            ),
                                          ),
                                          backgroundColor: Colors.black12,
                                          label: Text('sssssssssssssss')),
                                    ),
                                    ClipOval(
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          color: Colors.black12,
                                          alignment: Alignment.center,
                                          child:Icon(Icons.keyboard_arrow_down,color: Colors.grey,size: 30,),)
                                    ),
                                    Chip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: const BorderSide(
                                            color: Colors.transparent, // 将边框颜色设为透明
                                          ),
                                        ),
                                        backgroundColor: Colors.grey,
                                        label: Text('sssssssssssssss')),
                                    Chip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: const BorderSide(
                                            color: Colors.transparent, // 将边框颜色设为透明
                                          ),
                                        ),
                                        backgroundColor: Colors.grey,
                                        label: Text('Hamilffffffffffton')),
                                    Chip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: const BorderSide(
                                            color: Colors.transparent, // 将边框颜色设为透明
                                          ),
                                        ),
                                        backgroundColor: Colors.grey,
                                        label: Text('Hamiltofffn')),
                                    Chip(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: const BorderSide(
                                            color: Colors.transparent, // 将边框颜色设为透明
                                          ),
                                        ),
                                        backgroundColor: Colors.grey,
                                        label: Text('Hamiffflton')),


                                  ],

                                ),)
                            ],
                          ) ),
                      Column(

                        children: [
                          Container(
                            alignment: Alignment.centerLeft,

                            child:Text("猜你喜欢",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                          ),

                          Container(
                            padding: const EdgeInsets.only(bottom: 30,top: 10),
                            child:  Wrap(

                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: [
                                Chip(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(
                                        color: Colors.transparent, // 将边框颜色设为透明
                                      ),
                                    ),
                                    backgroundColor: Colors.grey,
                                    label: Text('Hamilton')),
                                Chip(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(
                                        color: Colors.transparent, // 将边框颜色设为透明
                                      ),
                                    ),
                                    backgroundColor: Colors.grey,
                                    label: Text('Hamilton')),
                                Chip(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(
                                        color: Colors.transparent, // 将边框颜色设为透明
                                      ),
                                    ),
                                    backgroundColor: Colors.grey,
                                    label: Text('sssssssssssssssssss')),


                              ],

                            ),)
                        ],
                      )
                    ],
                  ),
                  //放一个listView
                  ],
                )),



                TabBarView(children: [
                  //放一个listView
                ])




            ],
          ),
        ),
      ),
    );
  }
  _arrow_downOrUp(bool flag ){
  return  ClipOval(
      child: Container(
        width: 40,
        height: 40,
        color: Colors.black12,
        alignment: Alignment.center,
        child:Icon(flag?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: Colors.grey,size: 30,),)
  );
}

}