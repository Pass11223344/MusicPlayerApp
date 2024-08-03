
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import '../bean/CommentInfoBean.dart';
import '../main.dart';
import 'package:dio/dio.dart';

class ss extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => sState();


}
class sState extends State<ss>{
   final  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getTabData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Center(
        child:SafeArea(
          right: false,
          child:  MyImageEditor()

          // Center(
          //   child: ElevatedButton(
          //     child: Text('Show Bottom Sheet'),
          //     onPressed: () async {
          //       var image =   await _picker.pickImage(source: ImageSource.gallery);
          //       print("objectwwwwwwwwwwwwwwwwwwwwwwwwwwaaa${image?.path}");
          //       if (image?.path==null) {
          //         print("objectwwwwwwwwwwwwwwwwwwwwwwwwwwaaa未选择");
          //
          //       }else{
          //   //uploadAvatar(image!.path);
          //   Navigator.push(context,MaterialPageRoute(builder: (context){
          //     return MyImageEditor();
          //   }) );
          //         print("objectwwwwwwwwwwwwwwwwwwwwwwwwwwaaa${image?.path}");
          //       }
          //     },
          //   ),
          // ),
        ),
      ),
    );
  }

  void getTabData()async {
    dioRequest.executeGet(url: "/comment/event",params: {"threadId":"A_EV_2_29945262900_287870880"}).then((value){
       var commentInfoBean = CommentInfoBean.fromJson(value);
      print("objectlllllllllllllllll${commentInfoBean.totalCount}");
    });
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return DraggableScrollableSheet(
    //       expand: false,
    //       builder: (BuildContext context, ScrollController scrollController) {
    //         return Container(
    //           color: Colors.amber,
    //           child: ListView.builder(
    //             controller: scrollController,
    //             itemCount: 50,
    //             itemBuilder: (BuildContext context, int index) {
    //               return ListTile(
    //                 title: Text('Item $index'),
    //               );
    //             },
    //           ),
    //         );
    //       },
    //     );
    //   },
    // );
  }
   void uploadAvatar(String imagePath) async {
     try {
       String uploadUrl = 'https://www.consistent.top/avatar/upload';
       String fileName = imagePath.split('/').last; // 获取文件名
       FormData formData = FormData.fromMap({
         'imgFile': await MultipartFile.fromFile(imagePath, filename: fileName),
         'imgSize': 200, // 可选参数，图片尺寸
         'imgX': 0, // 可选参数，水平裁剪偏移
         'imgY': 0, // 可选参数，垂直裁剪偏移
       });

       Dio dio = Dio();
       dio.options.headers['Content-Type'] = 'multipart/form-data';
       dio.options.headers['Cookie'] = "__remember_me=true; __csrf=1ef8cbd67c83a431b52fad48029b52ed; NMTID=00OGtLNGR169BbPiULOi70La71LDX"
           "gAAAGQfgoH9A; MUSIC_U=00B31BC82F9D723A96A6CEF36D18B3C5B4EE8C10C969773253469B3441EA4E5597EE7F"
           "38EAD49AD192ED6620747C0FFC572AA22B22C5BE0327A7359919105BD70F85F85E9D058B3A4F23A925DF52B5AA55"
           "0BFCC1C7638C663198D7BF0E0CCD7BBE59C5B411B6D68A74D85395723A5DCBDA3CA74AF40381B13150FF1B96509D"
           "F56074E80050CC7E17AE7B5BA6B61488C1EC7BF9C055A9D215DDD80607C9D7ED8E87C21ABB93FB5EDE17F36F787A1"
           "45FBFDDB63F5166545E03387B0C07C53D4DCD652FEC69EE936265BA61FA8D00D1174E73907123BFFFBAC4F7931F007"
           "1B61E2342EA47C30960390048F3D25637BAE20F511C16A0E21F42F3763F8542FB4B89DD8699F861370BAF5E0255050"
           "E7081A0B0A16C7AC43FDE1469A0CA4371912C1094169F150C9E7BB"
           "6F8AA38806332719455F2A644EC6C2A987D9FC9C0964B98F7363DECA88CD730726BE0B310C04B67BFBC2E";

       Response response = await dio.post(uploadUrl, data: formData);

       if (response.statusCode == 200) {
         print('上传成功');
         // 处理成功上传后的逻辑
       } else {
         print('上传失败');
         // 处理上传失败的逻辑
       }
     } catch (e) {
       print('上传过程出现错误：$e');
       // 处理异常情况
     }
   }
}
class MyImageEditor extends StatefulWidget {
  @override
  _MyImageEditorState createState() => _MyImageEditorState();
}

class _MyImageEditorState extends State<MyImageEditor> with TickerProviderStateMixin {
  double x = 0.0, y = 0.0, endX = 0.0,endY = 0.0, scale = 1.0;
  Offset lastFocalPoint = Offset.zero;
  double z=500,s=500,y1=500,x1=500;
  final key = GlobalKey();
// 在组件构建完成后获取 RenderObject

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  void _onInteractionStart(ScaleStartDetails details) {
    lastFocalPoint = details.focalPoint;

    z=500;s=500;y1=500;x1=500;
    setState(() {

    });
  }
  void _onInteractionEnd(ScaleEndDetails details) {

      // 获取蒙版层的边界
      double minX = -10; // 左边界
      double maxX = 10; // 右边界
      double minY = MediaQuery.of(context).size.height/2-250; // 上边界
      double maxY = MediaQuery.of(context).size.height / 2-399 ; // 下边界
      x1= 0;
      y1 = 20;
      s = 0;
      z = 20;
      // 限制 x 坐标在 minX 到 maxX 之间
    //   if (x < minX) {
    //     z = 10;
    //     print("object----1---qq${x}--------qq$y");
    //   } else if (x > maxX) {
    //     y1 = 10;
    //     print("object----2---qq${x}--------qq$y");
    //   }
    //   if (y < minY) {
    //   s = 250;
    //   print("object------3-qq${x}--------qq$y");
    // } else if (y > maxY) {
    //   x1 = 250;
    //   print("object---4----qq${x}--------qq$y");
    // }
    //   print("object-------qq${x}--------qq$y");

print("objectend-----------------------------");


setState(() {

});
  }

  void _onInteractionUpdate(BuildContext context, ScaleUpdateDetails details) {
    setState(() {
      final double deltaX = details.focalPoint.dx - lastFocalPoint.dx;
      final double deltaY = details.focalPoint.dy - lastFocalPoint.dy;
      x += deltaX;
      y += deltaY;
      lastFocalPoint = details.focalPoint;
   //   scale = details.scale;
      print("object-------qq${x}--------qq$y");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 蒙版层
        Container(
          color: Colors.black38, // 半透明背景
          child: Center(
            child: Container(

              margin:EdgeInsets.only(left: 20,right: 20) ,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2-50,
              color: Colors.white, // 蒙版内部的透明区域
            ),
          ),
        ),
        // 图片显示与操作
        Center(
          child:   Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(

              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width
            ),
            child:

            InteractiveViewer(
              // transformationController: TransformationController(),
              onInteractionStart: _onInteractionStart,
              onInteractionUpdate: (details) => _onInteractionUpdate(context, details),
              onInteractionEnd: _onInteractionEnd,
               minScale: 1.0, // 最小缩放比例
              //  maxScale: 2.0, // 最大缩放比例
              constrained: true,
              boundaryMargin: EdgeInsets.only(left: z,top: s,right: y1,bottom: x1),
              child: Image.asset(
                key: key,
                'images/Bimage.png', // 替换成你的图片路径
                fit: BoxFit.contain,
              ),
            ),
          ),
        )
      ,
        // 确定按钮
        Positioned(
          bottom: 16,
          right: 16,
          child: ElevatedButton(
            onPressed: () {
              RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
              double width = renderBox.size.width;
              double height = renderBox.size.height;
              print("Width: $width, Height: $height h:${MediaQuery.of(context).size.height}");

              // 这里处理确定按钮的点击事件，可以返回图片的最终位置和大小
            //  print('最终位置: ($x,$y), 缩放: $scale');
            },
            child: Text('确定'),
          ),
        ),
      ],
    );
  }
}