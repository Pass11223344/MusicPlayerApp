

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_misic_module/bean/songListBean.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/page/msgListPage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../NetWork/DioRequest.dart';
import '../bean/AlbumListBean.dart';
import '../bean/SongSheetList.dart';
import '../bean/SongSheetList.dart';
import '../bean/searchHotListBean.dart';
import '../util/Utils.dart';
import 'myPage.dart';
import 'myPageController.dart';

class searchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => searchPageState();

}
class searchPageState extends State<searchPage> with TickerProviderStateMixin{
  late TabController _tabController;
  int currentTab = 0;

 late TextEditingController _textEditingController;
 bool  isLongPress = false;
 bool isResultOk = false;
 bool isNetOk = true;

 final String HistoryList = "HistoryList";

 late List<searchHotListBean> searchHotList;
  var pageController = Get.find<PageControllers>();
 var currentIndex;
var recommendTab = 0;
var foldTab =  -1;
bool jump_page = false;
  late MediaQueryData mediaQuery ;
  late double warp_widh ;
  late double warp_height ;
  var songOffset = 0;
  var songSheetOffset = 0;
  var albumOffset = 0;
  int lastSongId = 0;
  int lastAlbumId = 0;
  int lastSongSheetId = 0;
  double  expandedHeight = 0.0;


var _inputValue;
  final FocusNode _focusNode = FocusNode();
//单曲
  List<songListBean>? songList;
 int songCount = 0;
  //歌单
  List<SongSheetList>? songSheetList;
  int songSheetCount = 0;
  List<Album>? albumList;
  int albumCount = 0;
  List<String>? suggestList;
  var suggestDio ;
  var resultDio;
  bool suggestOk  = false;
  bool tabIsTrue = true;
  bool foldFlag = false;
  bool pageIsOk = false;
  //是否开启第二页面
  bool isOnclick = false;
  List<String> history_list =  [];
  final double charWidthEstimate = 8.0; // 假设每个字符大约占用8像素宽度
  final double chipHorizontalPadding = 8.0; // Chip的左右内边距估算
  KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _textEditingController = TextEditingController();
    _tabController.addListener(() {

      setState(() {
        currentTab = _tabController.index;
        if (currentTab==0&&songList!=null) {
          isResultOk = true;
          return;
        }
        if (currentTab==1&&songSheetList!=null) {
          isResultOk = true;
          return;
        }
        if(currentTab==2&&albumList!=null){
          isResultOk = true;
          return;
        }

        isResultOk = false;

      });
    });

    getHistoryList();
    getNteWorkData();

    _textEditingController.addListener(() {
      if(_textEditingController.text!=""&&_focusNode.hasFocus){
        getSuggestData( _textEditingController.text);
      }
      setState(() {
      //  if(isResultOk)isOnclick = false;
        _inputValue = _textEditingController.text;
      });
    });

    if(!_focusNode.hasFocus) {

      _focusNode.requestFocus();
    }
    // 添加监听器
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {

        // 键盘显示时的处理逻辑
      } else {
        // 键盘隐藏时的处理逻辑
        setState(() {
          if(!isOnclick&&isResultOk)
            isOnclick = true;
        });
      FocusScope.of(context).unfocus();

      }
    });
 receiveDataFromAndroid();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
  @override
  void didUpdateWidget(covariant searchPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("object1111111111111111111111111111111");
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mediaQuery = MediaQuery.of(context);
    warp_widh = mediaQuery.size.width-20;
    warp_height =  mediaQuery.size.height;
    return
      pageIsOk?   GestureDetector(
        onTap: isLongPress?(){
            setState(() {
              isLongPress= false;
            });
        }:(){

         FocusScope.of(context).unfocus();
        },
        child:
    tabProvider(
    Hlist: history_list,
    child: Scaffold(
      backgroundColor: Colors.white,
          appBar: AppBar(
              scrolledUnderElevation: 0.0,
              titleSpacing: 0,
              backgroundColor: Colors.white,
              title:Container(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child:
                        GestureDetector(
                          onTap: ()  async {
                            _tabController.animateTo(0);
                            _textEditingController.clear();
                              if(!isResultOk&&resultDio!=null) resultDio.cancelToken();

                            if (!isOnclick) {
                              var  prefs = await SharedPreferences.getInstance()  ;
                              prefs.clear();
                              await prefs.setStringList(HistoryList, history_list);
                              if(keyboardVisibilityController.isVisible)_focusNode.unfocus();

                              channel.invokeMethod("back", {"origin":"not_intercept"});
                            }
                            setState(() {
                              isOnclick = false;
                              isResultOk = false;
                              songList = null;
                              albumList = null;
                              songSheetList = null;
                              songCount = 0;
                              songSheetCount = 0;
                              albumCount = 0;
                            });
                          },
                          child:Container(
                              alignment: Alignment.centerLeft,
                              child:
                               Icon(Icons.arrow_back, color: Colors.black)) ,
                        )
                        ),
                    Expanded(
                        flex: 8,
                        child:  Container(
                          width: MediaQuery.of(context).size.width-120,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12,width: 1),
                              borderRadius: BorderRadius.circular(25)),
                          child:  TextField(

                            textInputAction: TextInputAction.done,
                            focusNode: _focusNode,
                            controller:_textEditingController,
                            maxLines: 1,
                            decoration: const InputDecoration(
                                hintText: "搜索歌曲",
                                isCollapsed: true,
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none),
                            onSubmitted: (String value){
                              //1：单曲，10：专辑,1000：歌单
                              if( value==null||value=="")return;
                              jumpSearchResult(value);
                              getResult(value, 1, songOffset);
                            },
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child:  GestureDetector(
                          onTap: (){
                           if( !_textEditingController.text.isEmpty){
                             FocusScope.of(context).unfocus();
                           //  if( _textEditingController.text==null||_textEditingController.text=="")return;

                             jumpSearchResult(_textEditingController.text);
                             getResult(_textEditingController.text, 1, songOffset);
                           }

                          },
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


          ),

          body: Stack(
            children: [
              CustomScrollView(
                slivers:[
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10,left: 10,top: 20),
                      child: Center(
                        child:   Visibility(
                          visible: true,
                          child:
                          Column(
                            children: [
                              Visibility(
                                  visible: history_list.length!=0,
                                  child:Column(
                                    children: [
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("搜索历史",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),

                                          IconButton( icon: Icon(Icons.delete_outline_outlined,size: 20,color: Colors.grey), onPressed: _showAlertDialog)
                                        ],),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(top:10,bottom: 30),
                                        child: Wrap(
                                            spacing: 10.0,
                                            runSpacing: 8.0,
                                            children:
                                            history_list.asMap().entries.map((entry) {
                                              int index = entry.key;
                                              String chipText = entry.value;

                                              if(chipText==""){
                                                return GestureDetector(
                                                  onTap: (){
                                                    if(foldFlag){
                                                      foldFlag=false;
                                                      history_list.remove("");
                                                      history_list.insert(foldTab,"");
                                                    }else{
                                                      foldFlag=true;
                                                      history_list.remove("");
                                                      history_list.add("");
                                                    }
                                                    setState(() {
                                                    });
                                                  },
                                                  child:  _arrow_downOrUp(foldFlag),
                                                );
                                              }else if(foldTab==-1||index<foldTab||foldFlag){
                                                return
                                                  GestureDetector(
                                                    onTap: (){
                                                        if(isLongPress){
                                                          setState(() {

                                                            isLongPress = false;
                                                          });
                                                          return;
                                                        }
                                                       FocusScope.of(context).unfocus();
                                                          jumpSearchResult(chipText);
                                                      getResult(chipText, 1, songOffset);
                                                    },
                                                      onLongPress: (){
                                                        for(int i = 0;i< history_list.length;i++){
                                                          if(history_list[i] == chipText){
                                                            setState(() {
                                                              currentIndex = i;
                                                              isLongPress = true;
                                                            });
                                                            break;
                                                          }
                                                        }
                                                      },
                                                      child:
                                                      _TabItem(chipText, index));
                                              }else{
                                                return SizedBox(height: 0);
                                              }
                                            }).toList()

                                        ) ,

                                      )
                                    ],
                                  ) ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child:const Text("猜你喜欢",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                height:60,
                                alignment: Alignment.bottomCenter,
                                child:  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,

                                    children:searchHotList.asMap().entries.map(( entry) {
                                      int index = entry.key;
                                      String chipText = entry.value.searchWord;

                                      if(index<recommendTab-1){
                                        return _TabItem1(chipText, index);
                                      }
                                      return Container();
                                    }).toList()

                                ),),
                              SizedBox(height: 10,),
                              Text("热搜榜",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child:  Container(
                        margin: EdgeInsets.only(left: 10,right: 10,top: 10 ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.black54
                        ),
                        child: ListView.builder(
                            itemExtent: 40,
                            padding:EdgeInsets.all(8) ,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: searchHotList.length,
                            itemBuilder: (context,index){
                              return  ListTile(
                                onTap: (){
                                  if(isLongPress) {
                                    setState(() {
                                      isLongPress = false;
                                    });
                                    return;
                                  }

                                  FocusScope.of(context).unfocus();
                                  jumpSearchResult(searchHotList[index].searchWord);
                                  getResult(searchHotList[index].searchWord, 1, songOffset);
                                },
                                leading: Text("${index+1}",style: TextStyle(color: index+1<=3?Colors.red:Colors.grey,fontWeight:index+1<=3?FontWeight.bold:FontWeight.normal ),),
                                title: Text(searchHotList[index].searchWord,overflow: TextOverflow.ellipsis,),
                                trailing: searchHotList[index].iconUrl==""?null:getImg(url: searchHotList[index].iconUrl,size: 10,)
                              );
                            })
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 70,),
                  )
                ] ,
              ),
              isOnclick?
              Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child:
               Builder(builder: (context){
                 return NotificationListener<ScrollNotification>(
                     onNotification: (scrollNotification){
                       expandedHeight = scrollNotification.metrics.pixels;
                       if (scrollNotification is ScrollUpdateNotification &&
                           scrollNotification.metrics.pixels ==
                               scrollNotification.metrics.maxScrollExtent) {
                        if(currentTab==0){
                          if( songList?.length!=songCount) {
                            addMostList(_inputValue, 1, songOffset+1);
                            setState(() {
                              songOffset+=1;
                            });
                          };
                        }else if(currentTab==1){

                          if( songSheetList?.length!=songCount) {
                            addMostList(_inputValue, 1000, songSheetOffset+1);
                            setState(() {
                              songSheetOffset+=1;
                            });}
                        }else {
                          if( albumList?.length!=albumCount) {
                            addMostList(_inputValue, 10, albumOffset+1);
                            setState(() {
                              albumOffset+=1;
                            });
                          };
                        }
                         return true; // 阻止通知的进一步处理
                       }
                       return false;
                     },
                     child:
                    Column(
                      children: [
                        isOnclick? TabBar(
                            onTap: (current){
                              setState(() {

                                currentTab = current;
                                if(currentTab==0){
                                  if( songList==null) {
                                    setState(() {
                                      isNetOk=true;
                                    });
                                    getResult(_inputValue, 1, songOffset);

                                  };
                                }else if(currentTab==1){
                                  if( songSheetList==null) {
                                    setState(() {
                                      isNetOk=true;
                                    });
                                    getResult(_inputValue, 1000, songSheetCount);

                                  }
                                }else{
                                  if( albumList==null) {
                                    setState(() {
                                      isNetOk=true;
                                    });
                                    getResult(_inputValue, 10, albumCount);
                                  }
                                }
                              });
                            },
                            controller: _tabController,
                            indicatorPadding: EdgeInsets.zero,
                            dividerHeight:0 ,
                            indicatorColor: Colors.red,
                            labelColor: Colors.black,
                            unselectedLabelColor: Color(0xff77767c),
                            tabs: const [
                              Tab(text: "单曲",),
                              Tab(text: "歌单",),
                              Tab(text: "专辑",),
                            ]):Container(),
                        Expanded(child: Stack(children: [
                          isResultOk?
                          TabBarView(
                              controller: _tabController,
                              children: [
                                //1：单曲，10：专辑,1000：歌单
                                CustomScrollView(
                                  key: PageStorageKey("${_tabController.index}-THENumIS0"),
                                  slivers: [
                                    SliverFixedExtentList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: songList?.length,
                                                (context,index)=>_SongListItem(index)
                                        ), itemExtent: 60),
                                    SliverToBoxAdapter(child: Container(
                                        color: Colors.white,
                                        margin: EdgeInsets.only(top: 10),
                                        width: 35,height: songList?.length==songCount?100:35,
                                        alignment: Alignment.center,
                                        child:
                                        songList?.length!=songCount?
                                        CircularProgressIndicator(color: Colors.red,strokeWidth: 1,)
                                            :Container()) ,),
                                    SliverToBoxAdapter(child: Container(height: 70,),)
                                  ],
                                ),
                                CustomScrollView(
                                  key: PageStorageKey("${_tabController.index}-THENumIS1"),
                                  slivers: [
                                    SliverFixedExtentList(
                                        delegate: SliverChildBuilderDelegate(
                                            childCount: songSheetList?.length,
                                                (context,index){
                                              if(songSheetList==null){
                                                getResult(_textEditingController.text, 1000, songSheetOffset);
                                              }
                                              return currentTab==1&&isResultOk&&songSheetCount>0?
                                              _SongSheetListItem(index):Container();
                                            }
                                        ), itemExtent: 70),
                                    SliverToBoxAdapter(child: Container(
                                        color: Colors.white,
                                        margin: EdgeInsets.only(top: 10),
                                        width: 35,height: songSheetList?.length==songSheetCount?100:35,
                                        alignment: Alignment.center,
                                        child:
                                        songSheetList?.length!=songSheetCount?
                                        const CircularProgressIndicator(color: Colors.red,strokeWidth: 1,)
                                            :Container()) ,),
                                    SliverToBoxAdapter(child: Container(height: 70,))
                                  ],
                                ),
                                CustomScrollView(
                                  key: PageStorageKey("${_tabController.index}-THENumIS2"),
                                  slivers: [
                                    SliverFixedExtentList(

                                        delegate: SliverChildBuilderDelegate(
                                            childCount: albumList?.length,
                                                (context,index) {
                                              if(albumList==null){
                                                getResult(_textEditingController.text, 10, albumOffset);
                                              }
                                              return  currentTab==2&&isResultOk&&albumCount>0?_AlbumListItem(index):Container();
                                            }
                                        ), itemExtent: 70),
                                    SliverToBoxAdapter(child: Container(
                                        color: Colors.white,
                                        margin: EdgeInsets.only(top: 10),
                                        width: 35,height: albumList?.length==albumCount?100:35,
                                        alignment: Alignment.center,
                                        child:
                                        albumList?.length!=albumCount?
                                        CircularProgressIndicator(color: Colors.red,strokeWidth: 1,)
                                            :Container()) ,),
                                    SliverToBoxAdapter(child: Container(height: 70,),)
                                  ],
                                ),

                              ]):
                          isOnclick?  Container(
                              color: Colors.white,
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.topCenter,child:isNetOk? CircularProgressIndicator(strokeWidth: 1,color: Colors.red,) :
                          Container(alignment: Alignment.center,child: Text("请求出错稍后再试")) ):Container(),
                        ],),)


                      ],
                    )
                      );
                     },),
              ):SizedBox(),
              _inputValue!=""&&suggestList!=null&&_focusNode.hasFocus ?
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(10),
                    color:Colors.white,
                    child: ListView.builder(
                        itemCount: suggestList?.length,
                        itemBuilder: ((context,index){
                      return ListTile(
                        onTap: (){
                          if( _textEditingController.text==null||_textEditingController.text=="")return;

                          _textEditingController.text = suggestList![index];
                          isOnclick = false;
                          isResultOk = false;
                          FocusScope.of(context).unfocus();
                          jumpSearchResult(suggestList![index]);
                          getResult(suggestList![index], 1, songOffset);
                          suggestList = null;
                        },
                          leading: const Icon(Icons.search,size: 16,),
                          title: Container(
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                            child: Text("${suggestList?[index]}"),
                          ));
                    })),
                  )
                  :Container(color:Colors.white,height: 0,width: 0)
            ],
          )
        ) ),
      )
          :Container(
        height: 10,
        alignment: Alignment.center,
        child: CircularProgressIndicator(color: Colors.red,strokeWidth: 1,),);
  }
  Widget _arrow_downOrUp(bool flag ){
  return   Container(

        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(100))
        ),
        alignment: Alignment.center,
        child:Icon(flag?Icons.keyboard_arrow_down:Icons.keyboard_arrow_up,color: Colors.grey,size: 30,),);
}
  Widget _TabItem(String msg,int index){

 return Container(
     constraints: BoxConstraints(maxWidth: warp_widh/2),
     child:Chip(
         onDeleted: isLongPress&&currentIndex==index?(){
           setState(() {
             history_list.removeAt(index);
             isLongPress = false;
           });
         }:null,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(25.0),
           side: const BorderSide(
             color: Colors.transparent, // 将边框颜色设为透明
           ),
         ),
         backgroundColor: Colors.grey,
         label: Text(msg,overflow: TextOverflow.ellipsis,maxLines: 1,)) ,
   );
}
  Widget  _TabItem1(String msg,int index){
    print("object-----vvvvvvvvvvvvvvvvvv------${warp_widh}");
  return
  InkWell(
    onTap: (){
      if(isLongPress) {
        setState(() {
          isLongPress = false;
        });
        return;
      }

      FocusScope.of(context).unfocus();
      jumpSearchResult(msg);
      getResult(msg, 1, songOffset);
    },
    child:  Container(
      constraints: BoxConstraints(maxWidth: warp_widh/2),
      child:Chip(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(
              color: Colors.transparent, // 将边框颜色设为透明
            ),
          ),
          backgroundColor: Colors.grey,
          label: Text(msg,overflow: TextOverflow.ellipsis,maxLines: 1,)) ,
    ),
  );

  }
  void getHistoryList() async {
    var  prefs = await SharedPreferences.getInstance()  ;
    List<String>? HistoryLists = await prefs.getStringList(HistoryList);
   if(HistoryLists!=null){
     setState(() {
       history_list.addAll(HistoryLists!);
       double len = 0.0;
       double width = roughlyWidth("msg")<warp_widh/2-20? roughlyWidth("msg")+20: warp_widh/2;
       if(!foldFlag){
         history_list.remove("");
         for(int i=0;i< history_list.length;i++){

           if( len+width>warp_widh){
             foldTab = i-1;
             history_list.insert(i-1, "");
             break;
           }
           len += (roughlyWidth(history_list[i])+20) ;
         }
       }
       history_list.remove("msg");
     });
   }
  }

   jumpSearchResult(String value)  {
     isOnclick = true;
     _textEditingController.text = value;
    double len = 0.0;
   double width = roughlyWidth(value)<warp_widh/2-20? roughlyWidth(value)+20: warp_widh/2;
    if(!foldFlag){
      history_list.remove("");
      for(int i=0;i< history_list.length;i++){

        if( len+width>warp_widh){
          foldTab = i-1;
          history_list.insert(i-1, "");
          break;
        }
        len += (roughlyWidth(history_list[i])+20) ;
      }
    }
    history_list.remove(value);
    history_list.insert(0, value);
   setState(() {});
  }

  getResult(String value,int type,int offset)async{
    //1：单曲，10：专辑,1000：歌单
    resultDio = DioRequest();
    var data;
    data = await  resultDio.executeGet(url: "/cloudsearch",params: {"keywords":value,"type":type});
    if (data=="error") {
      setState(() {
        isNetOk = false;
      });
      return;
    }
    switch(type){
      case 1:

        songList = (data['songs'] as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList();
         songCount = data['songCount'];
        break;
      case 10:

        albumList= (data['albums'] as List<dynamic>).map((json)=>Album.fromJson(json)).toList();
        albumCount = data['albumCount'];

      case 1000:
        songSheetList=(data['playlists'] as List<dynamic>).map((json)=>SongSheetList.fromJson(json)).toList();
        songSheetCount = data['playlistCount'];

      break;
    }
    isNetOk = true;
    isResultOk = true;
        setState(() {});
  }
  addMostList(String value,int type,int offset)async{
    resultDio = DioRequest();
  //  if( !suggestOk&&suggestDio!=null)suggestDio.cancelToken();
print("object$value----------$type-------$offset");
    var data;
    data = await  resultDio.executeGet(url: "/cloudsearch",params: {"keywords":value,"offset":offset,"type":type});
    if (data=="error") {
      setState(() {
        isNetOk = false;
      });
      return;
    }
    switch(type){
      case 1:

        songList?.addAll((data['songs'] as List<dynamic>).map((json)=>songListBean.fromJson(json)).toList());
       // songCount = data['songCount'];
        break;
      case 10:

          albumList?.addAll( (data['albums'] as List<dynamic>).map((json)=>Album.fromJson(json)).toList());
      case 1000:

        songSheetList?.addAll((data['playlists'] as List<dynamic>).map((json)=>SongSheetList.fromJson(json)).toList());
        break;
    }

    isResultOk = true;
    setState(() {});
  }
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
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.width+20;
  }

  void getNteWorkData() async {
    recommendTab = 0;
    double len=0.0;
    var data =  await dioRequest.executeGet(url: "/search/hot/detail");
 setState(() {
   searchHotList = (data as List<dynamic>).map((json)=>searchHotListBean.fromJson(json)).toList();

   searchHotList.asMap().forEach((index, value){
     len += (roughlyWidth(value.searchWord))+8 ;
     if( len<warp_widh){
       recommendTab+=1;

     }
print("object1111111111111111222222222222$recommendTab");
   });
   pageIsOk = true;
 });

  }

  void getSuggestData(String msg) async{
    if(msg==""||msg==null)return;
    suggestDio = DioRequest();

  var data = await suggestDio.executeGet(url: "/search/suggest",params: {"keywords":msg, "type":"mobile"});
 setState(() {

   suggestOk = true;
   suggestList = (data as List<dynamic>).map((json)=>json['keyword'] as String).toList();
 });
  }

  _showAlertDialog() async{
    await  showDialog(context: context, builder: (context){
      return  AlertDialog(
        actionsAlignment: MainAxisAlignment.end,

        title: Text("确定清空全部历史记录？",style: TextStyle(color: Colors.grey)),
        actions: [
          TextButton(
            child: Text("是",style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop();

            FocusScope.of(context).unfocus();
              history_list.clear();
            },
          ),
          // “否”按钮
          TextButton(
            child: Text("否",style: TextStyle(color: Colors.black)),
            onPressed: () {

              Navigator.of(context).pop();
              // 在这里执行“否”按钮的操作


              FocusScope.of(context).unfocus();
            },
          ),
        ],

      );
    });

  }
  _SongListItem(int index){
   return ListTile(
      title: Text(songList![index].name,maxLines: 1,),
      titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
          overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
      subtitle:Text("${ Utils.getSubTitle(songList![index].ar)}-${songList![index].al.name!=null?songList![index].al.name:""}",maxLines: 1,) ,
      subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
          overflow: TextOverflow.ellipsis),
      trailing: Image.asset("images/more.png",width: 20,height: 20,),
      onTap: (){
        if (lastSongId==songList?[index].id)
          return;
        lastSongId = songList![index].id;
       var list = songList![index];

        channel.invokeMethod("sendSongList",{
          "title":"搜索",
          "SongIndex":index,
          "upOrAdd":"add",
          "SongList":jsonEncode([list])});
      },
    );
  }

  _SongSheetListItem(int index){
    return ListTile(
      leading: getSquareImg(Url:songSheetList![index].coverImgUrl, width: 55 ,height: 55,),
      title: Text(songSheetList![index].name,maxLines: 1,),
      titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
          overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
      subtitle:Text("${songSheetList![index].trackCount}首,${songSheetList![index].creator.nickname},播放${Utils.formatNumber(songSheetList![index].playCount)}次",maxLines: 1,) ,
      subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
          overflow: TextOverflow.ellipsis),
      onTap: ()async{
        setState(() {
          jump_page = true;
        });
        await Navigator.pushNamed(context, "main/songListPage",arguments: {
          "id":"${songSheetList![index].id} ",
        "title":songSheetList![index].name,
        "type":"to_page_song_list"});
        _focusNode.unfocus();


      },
    );
  }
  _AlbumListItem(int index){
    return ListTile(
      leading: getSquareImg(Url:albumList![index].picUrl, width: 55 ,height: 55,),
      title: Text("${albumList![index].name}${(albumList![index].alias.length==0?"":albumList![index].alias[0])}",maxLines: 1,),
      titleTextStyle: const TextStyle(fontSize: 16,color: Colors.black,
          overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold),
      subtitle:Text("${Utils.getSubTitle(albumList![index].artists) }${Utils.formatDate(albumList![index].publishTime)}",maxLines: 1,) ,
      subtitleTextStyle:const TextStyle(fontSize: 12,color: Colors.grey,
          overflow: TextOverflow.ellipsis),
      onTap: () async{
        setState(() {
          jump_page = true;
        });
        await Navigator.pushNamed(context, "main/songListPage",arguments: {
          "id":"${albumList![index].id}",
          "title":albumList![index].name,
          "type":"to_albums"});
          _focusNode.unfocus();

      },
    );
  }
  void receiveDataFromAndroid() {

    channel.setMethodCallHandler((call) async {
      print("object--------------------------dddd------${call.method}");
      switch(call.method){
        case"to_search":
          _focusNode.requestFocus();
          break;
        case "pressPage":
          if(jump_page){
            Navigator.pop(context);
            setState(() {
              jump_page = false;
              pageController.pageIsOk = false;
            });
            return;
          }else if(isOnclick){
           setState(() {
             isOnclick = false;
              isResultOk = false;
              songList = null;
              albumList = null;
              songSheetList = null;
              _textEditingController.clear();
              songCount = 0;
              songSheetCount = 0;
              albumCount = 0;
            });
            return;
          }else{

            channel.invokeMethod("back",{"origin":"not_intercept"});
            _tabController.animateTo(0);
              _textEditingController.clear();
              if(!isResultOk&&resultDio!=null) resultDio.cancelToken();
              if (!isOnclick) {
                var  prefs = await SharedPreferences.getInstance()  ;
                prefs.clear();
                await prefs.setStringList(HistoryList, history_list);
                if(keyboardVisibilityController.isVisible)_focusNode.unfocus();
              }

          }



          break;


      }
    });

  }
}
class tabProvider extends InheritedWidget{
  final List<String> Hlist;

  tabProvider( { required this.Hlist ,required super.child});

  static tabProvider? of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<tabProvider>();
  }

  @override
  bool updateShouldNotify(covariant tabProvider oldWidget) {

    return Hlist != oldWidget.Hlist;
  }

}