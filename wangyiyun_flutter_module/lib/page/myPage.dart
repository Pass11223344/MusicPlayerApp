import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:wangyiyun_flutter_module/NetWork/DioRequest.dart';
import 'package:wangyiyun_flutter_module/bean/SongSheetList.dart';
import 'package:wangyiyun_flutter_module/bean/userInfoBean.dart';
import 'package:wangyiyun_flutter_module/page/msgListPage.dart';
import 'package:wangyiyun_flutter_module/page/myPageController.dart';

import '../main.dart';


class myPage extends StatefulWidget {
  static const  channel =  MyApp.channel ;
  late userInfoBean users ;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return myPageState();
  }
}

class myPageState extends State<myPage> with TickerProviderStateMixin{
  late TabController _tabController;
  late TabController _tabControllerWithMusicTab;
  late TabController _tabControllerWithPodcastTab;
  late PrimaryScrollController _primaryScrollController;
  late ScrollController _scrollController;
  late myPageController _myPageController;
  bool isOk = false;

  int x=0;
  var executeGet;
  late List<SongSheetList> sheetList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSheetList();
    _tabController = TabController(length: 3, vsync: this);
    _tabControllerWithMusicTab = TabController(length: 2, vsync: this);
    _tabControllerWithPodcastTab =TabController(length: 2, vsync: this);
    _scrollController = ScrollController(keepScrollOffset: false);
    _myPageController = myPageController();
    _tabController.addListener(_onTabChanged);



  }
  void _onTabChanged() {
      print("object----${_tabController.index}");
      _myPageController.selectedIndex = _tabController.index;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();

    _tabControllerWithMusicTab.dispose();
    _tabControllerWithPodcastTab.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    var statusHeight = mediaQuery.padding.top + kToolbarHeight;
    // TODO: implement build
    return

    Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,//使收缩时不改变appBar的颜色
          backgroundColor: Colors.transparent,
          toolbarHeight: 38,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title:  Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: double.infinity,
            height: 38,
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child:GestureDetector(
                      child:  Container(
                        alignment: Alignment.centerLeft,

                        height: double.infinity,
                        child: Image.asset(
                          "images/menu.png",
                        ),
                      ),
                      onTap: (){
                      },
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                        height: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.outlet,size: 20,),
                            Container(
                                alignment: Alignment.center,
                                height: double.infinity,
                                child: Text(widget.users.nickname,style: TextStyle(fontSize: 8),)
                            )
                          ],
                        ))),
                Expanded(
                    flex: 1,
                    child: Container(
                        height: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [Icon(Icons.saved_search_outlined,size: 20,),
                            Container(

                              alignment: Alignment.centerRight,
                              height: double.infinity,
                              child:  Image.asset("images/more.png"),
                            )
                          ],
                        )))
              ],
            ),
          ),
        ),
        // 设置body背景延伸到Appbar下方
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [

            NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
                  return [
                    SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        sliver: SliverAppBar(
                          scrolledUnderElevation: 0.0,
                          backgroundColor: Colors.white,
                          forceElevated: innerBoxIsScrolled,

                          pinned: true,
                          expandedHeight: MediaQuery.of(context).size.height/2,
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: Stack(
                              children: [

                                Positioned.fill(
                                  child:  getSquareImg(Url: widget.users.backgroundUrl ,
                                      width: double.infinity, height: MediaQuery.of(context).size.height/2),),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(top: 20),

                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 2),
                                            borderRadius: BorderRadius.circular(100)
                                        ),
                                        child:getImg(url: widget.users.avatarUrl,size: 85),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        width:double.infinity/2 ,
                                        child: Text(
                                          widget.users.nickname,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white ,fontSize: 14),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        child:   Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            widget.users.gender==1 ? Icon(Icons.male,size: 10,color: Colors.blue,)
                                                :Icon(Icons.female,size: 10,color: Colors.pinkAccent,),

                                            Text("90后\ 魔羯座\ ·\ 山东\ 泰安\ ·\ 村龄7年",style: TextStyle(fontSize: 10,color: Colors.white38),)
                                          ],),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child:  Row(

                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("${widget.users.followeds}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight:FontWeight.bold )),

                                            Text("关注",style: TextStyle(fontSize: 10,color: Colors.white38)),
                                            SizedBox(width: 10,),
                                            Text("${widget.users.follows}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight:FontWeight.bold )),
                                            Text("粉丝",style: TextStyle(fontSize: 10,color: Colors.white38)),
                                            SizedBox(width: 10,),
                                            Text("LV.${widget.users.eventCount}",style: TextStyle(fontSize: 12,color: Colors.white,fontWeight:FontWeight.bold )),
                                            Text("等级",style: TextStyle(fontSize: 10,color: Colors.white38)),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity-20,
                                        margin: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _functionTable(Icons.access_time_filled_outlined,"最近"),
                                            _functionTable(Icons.get_app_sharp,"本地"),
                                            _functionTable(Icons.backup_rounded,"云盘"),
                                            _functionTable(Icons.receipt_long,"已购"),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                ),



                              ],
                            ),
                          ),
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(56),
                            child: Container(
                              height: 90,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(16),topLeft: Radius.circular(16)),
                                  color: Colors.white
                              ),
                              child:Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: TabBar(
                                      controller: _tabController,
                                      indicatorPadding: EdgeInsets.zero,
                                      dividerHeight:0 ,
                                      indicatorColor: Colors.red,
                                      labelColor: Colors.black,
                                      unselectedLabelColor: Color(0xff77767c),
                                      tabs: const[
                                        Text("音乐" ,style: TextStyle(fontSize: 20,)),
                                        Text("播客",style: TextStyle(fontSize: 20)),
                                        Text("动态",style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 40,child:
                                  Obx((){
                                    return _myPageController.selectedIndex==0||_myPageController.selectedIndex==1 ?
                                    Container(
                                      color: Colors.white,
                                      child: Obx(()=>TabBar(
                                          isScrollable: false,
                                          dividerHeight:double.nan ,
                                          labelColor: Colors.black,
                                          unselectedLabelColor: Color(0xff77767c),
                                          labelStyle: TextStyle(fontSize: 16 ),
                                          padding: EdgeInsets.only(right: 200),
                                          controller: _myPageController.selectedIndex==0? _tabControllerWithMusicTab:_tabControllerWithPodcastTab,
                                          indicator: BoxDecoration(),
                                          tabs: [
                                            Tab(text:_myPageController.selectedIndex==0?"近期":"全部",),
                                            Tab(text:_myPageController.selectedIndex==0? "创建":"播客",)
                                          ])),) : Container();
                                  }

                                  ))

                                ],
                              ),),

                          ),
                        )
                    ),




                  ];
                },

                body:SafeArea(
                  top: false,
                  bottom: false,
                  child:   Container(
                    padding: const EdgeInsets.only(bottom: 40),
                    color: Colors.white,
                    child:  TabBarView(
                      physics: ClampingScrollPhysics(),
                      controller: _tabController,
                      children: [
                        _secondaryTabWithMusicTab(_tabControllerWithMusicTab,mediaQuery),
                        _secondaryTabWithPodcastTab(_tabControllerWithPodcastTab,mediaQuery),
                        Center(child: Text('Tab 3 Content')),
                      ],
                    ) ,
                  ),
                )


            ),
          ],
        )
    );
  }

  _functionTable(IconData iconData,String title) {
    return Expanded(
        flex: 1,
        child: Container(
          height: 30,
          margin: EdgeInsets.only(left: 10,right: 10),
          decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(4)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData,size: 14,color: Colors.white60,),
              Text(title,style: TextStyle(fontSize: 14,color:Colors.white54 ),)
            ],
          ),
        ));
  }


  _secondaryTabWithMusicTab(TabController controller,MediaQueryData mediaQuery){
    return TabBarView(
        controller: controller,
        children: [
          Builder(
              builder: (context){
                return isOk ? CustomScrollView(

                  controller: PrimaryScrollController.of(context),
                  slivers: <Widget>[
                    SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                    SliverFixedExtentList(
                        key: PageStorageKey("${_tabController.index}-${_tabControllerWithMusicTab.index}"),
                        delegate:
                        SliverChildBuilderDelegate(
                            childCount: sheetList.length>12?12:sheetList.length,
                                (context,index){

                              return  Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                child: Row(
                                  children: [
                                    getSquareImg(Url:  sheetList[index].coverImgUrl,width:  80,height:  80),
                                    Container(
                                      width: mediaQuery.size.width-100,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.left,
                                            index==0?"我喜欢的音乐":sheetList[index].name,style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                          Text(
                                              textAlign: TextAlign.left,
                                              index==0?"${sheetList[index].trackCount}首·${sheetList[index].playCount}次播放"
                                                  :"歌单·${sheetList[index].trackCount}首·${sheetList[index].creator.nickname}",style: const TextStyle(fontSize: 12,color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),

                                        ],),
                                    )

                                  ],
                                ),
                              );




                            })
                        , itemExtent: 90),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 70,)
                    )
                  ],
                ):Container(color: Colors.white70,);
              }),
          Builder(builder: (context){
            return  isOk ? CustomScrollView(
              controller: PrimaryScrollController.of(context),
              slivers: <Widget>[
                SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),

                SliverFixedExtentList(
                    key: PageStorageKey("${_tabController.index}-${_tabControllerWithMusicTab.index}"),
                    delegate:
                SliverChildBuilderDelegate(
                    childCount: sheetList.length>12?12:sheetList.length,
                        (context,index){
                      if(sheetList[index].creator.userId==widget.users.userId){
                        return  Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          child: Row(
                       children: [
                              getSquareImg(Url:  sheetList[index].coverImgUrl,width:  80,height:  80),
                              Padding(padding: EdgeInsets.only(left: 10),child:  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(index==0?"我喜欢的音乐":sheetList[index].name,style: const TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  Text(index==0?"${sheetList[index].trackCount}首·${sheetList[index].playCount}次播放"
                                      :"歌单·${sheetList[index].trackCount}首·${sheetList[index].creator.nickname}",style: const TextStyle(fontSize: 12,color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),

                                ],),)

                            ],
                          ),
                        );
                      }else{
                        print("55599999");
                      }


                    })
                    , itemExtent: 90)
              ],
            ) :Container(color: Colors.white70,);
          }),
        ]);
  }
  _secondaryTabWithPodcastTab(TabController controller,MediaQueryData mediaQuery){
    return TabBarView(
        controller: controller,
        children: [
          Builder(builder: (context){
            return  CustomScrollView(
              key: PageStorageKey<String>("listKey${_tabController.index}-${_tabControllerWithPodcastTab.index}"),
              slivers: <Widget>[
                SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                SliverFixedExtentList(
                  //  key: PageStorageKey<String>("listKey${_tabController.index}-${_tabControllerWithPodcastTab.index}"),
                    delegate:
                SliverChildBuilderDelegate(
                    childCount: 12,
                        (context,index){
                      return  Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  image:DecorationImage(image: AssetImage("images/img.png"),fit: BoxFit.cover) ,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10),child:  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("listKey${_tabController.index}-${_tabControllerWithPodcastTab.index}",style:  TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                Text("副标题",style: TextStyle(fontSize: 12,color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),

                              ],),)

                          ],
                        ),
                      );
                    })
                    , itemExtent: 100)
              ],
            );
          }),
          Builder(builder: (context){
            return  CustomScrollView(
              key: PageStorageKey<String>("listKey${_tabController.index}-${_tabControllerWithPodcastTab.index}"),
              slivers: <Widget>[
                SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                SliverFixedExtentList(
                 //   key: PageStorageKey<String>("listKey${_tabController.index}-${_tabControllerWithPodcastTab.index}"),
                    delegate:
                    SliverChildBuilderDelegate(
                        childCount: 12,
                            (context,index){
                          return  Padding(padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      image:DecorationImage(image: AssetImage("images/img.png"),fit: BoxFit.cover) ,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: 10),child:  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("listKey${_tabController.index}-${_tabControllerWithPodcastTab.index}",style:  TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    Text("副标题",style: TextStyle(fontSize: 12,color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis),

                                  ],),)

                              ],
                            ),
                          );
                        })
                    , itemExtent: 100)
              ],
            );
          }),

        ]);
  }

   getSheetList()  {

     myPage.channel.setMethodCallHandler((call) async {
       if (call.method == "to_myPage") {
         var json =  jsonDecode(call.arguments);
         widget.users =  userInfoBean.fromJson(json);
         executeGet = await DioRequest().executeGet(url: "/user/playlist",params: {"uid":287870880});
         print("0sa0ssssss0s-----------------------------------------------------------------------");
         if (executeGet != "error") {

           setState(() {
             isOk = true;
             sheetList =  (executeGet as List<dynamic>).map((json)=>SongSheetList.fromJson(json)).toList();
             print("0sa0ssssss0s${sheetList.length}");
           });
         }
       }
     }
     );


   }







}
class getSquareImg extends StatefulWidget{
  final String Url;
  final double width;
  final  double height;
   final bool isRadius;

  const getSquareImg({super.key, required this.Url, required this.width, required this.height,this.isRadius=true});
  @override
  State<StatefulWidget> createState() =>getSquareImgState();

}
class getSquareImgState extends State<getSquareImg>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(

        borderRadius:  BorderRadius.circular(widget.isRadius?8.0:0),
        child:
          CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl:widget.Url ,
            placeholder:(context, url) => Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey,

            ),
            errorWidget:(context, url, error)=>Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey,
            ) ,
          )
    );
  }

}