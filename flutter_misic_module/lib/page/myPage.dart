import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_misic_module/bean/RelayBean.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

import '../bean/SongSheetList.dart';
import '../bean/UserInfoBean.dart';
import '../bean/VideoListBean.dart';
import '../main.dart';
import '../util/Utils.dart';
import 'msgListPage.dart';
import 'myPageController.dart';
import 'mySongListPage.dart';

class myPage extends StatefulWidget {
  // static const  channel =  MyApp.channel ;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // Get.lazyPut(() => PageControllers());
    return myPageState();
  }
}

class myPageState extends State<myPage> with TickerProviderStateMixin {
  static final GlobalKey<mySongListPageState> childKey =
      GlobalKey<mySongListPageState>();
  late TabController _tabController;
  late TabController _tabControllerWithMusicTab;
  late TabController _tabControllerWithPodcastTab;

  late ScrollController _scrollController;
  final myPageController _myPageController = Get.find<myPageController>();
  PickedFile? _imageFile;

  var pageController = Get.find<PageControllers>();
  int x = 0;
  var executeGet;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSheetList();

    // Get.put(myPageController());
    _tabController = TabController(length: 3, vsync: this);
    _tabControllerWithMusicTab = TabController(length: 2, vsync: this);

    _scrollController = ScrollController(keepScrollOffset: false);
    //   _myPageController = Get.find<myPageController>();
    _tabController.addListener(_onTabChanged);
  }

  Future<Database> _initDatabase() async {
    var path = await getDatabasesPath();
    String file = path + '/music_db';
    var database = await openDatabase(file, version: 1);

    List<Map<String, dynamic>> query = await database.query("user_table",
        where: "userId = ?", whereArgs: [pageController.userId]);

    return await openDatabase(path, version: 1);
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
    return Obx(() {
      return _myPageController.users != null
          ? Scaffold(
              // 设置body背景延伸到Appbar下方
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                scrolledUnderElevation: 0.0,
                //使收缩时不改变appBar的颜色
                backgroundColor: Colors.transparent,
                toolbarHeight: 38,
                titleSpacing: 0,
                automaticallyImplyLeading: false,
                title: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: double.infinity,
                    height: 38,
                    child: Container(
                        alignment: Alignment.center,
                        height: double.infinity,
                        child: Text(
                          _myPageController.users!.nickname,
                          style: TextStyle(fontSize: 8),
                        ))),
              ),
              body: Stack(
                children: [
                  NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        var generationAndZodiac = Utils.getGenerationAndZodiac(
                            _myPageController.users!.birthday);
                        return [
                          SliverOverlapAbsorber(
                              handle: NestedScrollView
                                  .sliverOverlapAbsorberHandleFor(context),
                              sliver: SliverAppBar(
                                scrolledUnderElevation: 0.0,
                                backgroundColor: Colors.white,
                                forceElevated: innerBoxIsScrolled,
                                pinned: true,
                                expandedHeight:
                                    MediaQuery.of(context).size.height / 2,
                                flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.pin,
                                  background: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (await Utils.requestPermission(
                                              {"info": ""})) {
                                            var path =
                                                await Utils.chooseImage();
                                          }
                                        },
                                        child: Positioned.fill(
                                          child: getSquareImg(
                                              Url: _myPageController
                                                  .users!.backgroundUrl,
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  2),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.only(top: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: getCircularImg(
                                                  url: _myPageController
                                                      .users!.avatarUrl,
                                                  size: 85),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              width: double.infinity / 2,
                                              child: Text(
                                                _myPageController
                                                    .users!.nickname,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  _myPageController
                                                              .users!.gender ==
                                                          1
                                                      ? Icon(
                                                          Icons.male,
                                                          size: 10,
                                                          color: Colors.blue,
                                                        )
                                                      : Icon(
                                                          Icons.female,
                                                          size: 10,
                                                          color:
                                                              Colors.pinkAccent,
                                                        ),
                                                  Text(
                                                    "${generationAndZodiac['generation']}\ ${generationAndZodiac['zodiac']}\ ·\ 村龄${_myPageController.users!.level}年",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white38),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "${_myPageController.users!.followeds}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text("关注",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.white38)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      "${_myPageController.users!.follows}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text("粉丝",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.white38)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                      "LV.${_myPageController.users!.eventCount}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text("等级",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Colors.white38)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity - 20,
                                              margin: EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          channel.invokeMethod(
                                                              "addPage", "");
                                                          Navigator.pushNamed(
                                                              context,
                                                              "main/recentlyPlayedPage");
                                                          _myPageController
                                                                  .myPageIsShow =
                                                              false;
                                                        },
                                                        child: _functionTable(
                                                            Icons
                                                                .access_time_filled_outlined,
                                                            "最近"),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          channel.invokeMethod(
                                                              "addPage", "");
                                                          Navigator.pushNamed(
                                                              context,
                                                              "main/musicCloudDiskPage");
                                                          _myPageController
                                                                  .myPageIsShow =
                                                              false;
                                                        },
                                                        child: _functionTable(
                                                            Icons
                                                                .backup_rounded,
                                                            "云盘"),
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: InkWell(
                                                        onTap: () {
                                                          channel.invokeMethod(
                                                              "addPage", "");
                                                          Navigator.pushNamed(
                                                              context,
                                                              "main/purchasedPage");
                                                          _myPageController
                                                                  .myPageIsShow =
                                                              false;
                                                        },
                                                        child: _functionTable(
                                                            Icons.receipt_long,
                                                            "已购"),
                                                      )),
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
                                  child: Obx(() {
                                    return Container(
                                      height: 90,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(16),
                                              topLeft: Radius.circular(16)),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: TabBar(
                                              controller: _tabController,
                                              indicatorPadding: EdgeInsets.zero,
                                              dividerHeight: 0,
                                              indicatorColor: Colors.red,
                                              labelColor: Colors.black,
                                              unselectedLabelColor:
                                                  Color(0xff77767c),
                                              tabs: const [
                                                Text("音乐",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                                Text("视频",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                Text("动态",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                              visible: _myPageController
                                                      .selectedIndex ==
                                                  0,
                                              child: Container(
                                                height: 40,
                                                color: Colors.white,
                                                child: TabBar(
                                                    isScrollable: false,
                                                    dividerHeight: double.nan,
                                                    labelColor: Colors.black,
                                                    unselectedLabelColor:
                                                        Color(0xff77767c),
                                                    labelStyle:
                                                        TextStyle(fontSize: 16),
                                                    padding: EdgeInsets.only(
                                                        right: 200),
                                                    controller:
                                                        _tabControllerWithMusicTab,
                                                    indicator: BoxDecoration(),
                                                    tabs: [
                                                      Tab(text: "近期"),
                                                      Tab(text: "创建")
                                                    ]),
                                              ))
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                              )),
                        ];
                      },
                      body: SafeArea(
                        top: false,
                        bottom: false,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 40),
                          color: Colors.white,
                          child: TabBarView(
                            physics: ClampingScrollPhysics(),
                            controller: _tabController,
                            children: [
                              _secondaryTabWithMusicTab(
                                  _tabControllerWithMusicTab, mediaQuery),
                              _secondaryTabWithPodcastTab(mediaQuery),
                              _pageThreeTabView()
                            ],
                          ),
                        ),
                      )),
                ],
              ))
          : Container(
              color: Colors.white,
            );
    });
  }

  _functionTable(IconData iconData, String title) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.white12, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            size: 14,
            color: Colors.white60,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.white54),
          )
        ],
      ),
    );
  }

  _secondaryTabWithMusicTab(
      TabController controller, MediaQueryData mediaQuery) {
    return TabBarView(controller: controller, children: [
      Builder(builder: (context) {
        return Obx(() {
          return _myPageController.myPageSongSheets.length != 0
              ? CustomScrollView(
                  key: PageStorageKey(
                      "${_tabController.index}-${_tabControllerWithMusicTab.index}"),
                  controller: PrimaryScrollController.of(context),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                    SliverFixedExtentList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: _myPageController
                                .myPageSongSheets.length, (context, index) {
                          return InkWell(
                            onTap: () {
                              channel.invokeMethod("upSheetId", {
                                "sheetId":
                                    _myPageController.myPageSongSheets[index].id
                              });
                              Navigator.pushNamed(context, "main/songListPage",
                                  arguments: {
                                    "type": "to_my_page_song_list",
                                    "id": _myPageController
                                        .myPageSongSheets[index].id
                                        .toString(),
                                    "title": index == 0
                                        ? "我喜欢的音乐"
                                        : _myPageController
                                            .myPageSongSheets[index].name,
                                    "IsTheSame": _myPageController
                                            .myPageSongSheets[index]
                                            .creator
                                            .userId ==
                                        _myPageController.users!.userId
                                  });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Row(
                                children: [
                                  getSquareImg(
                                      Url: _myPageController
                                          .myPageSongSheets[index].coverImgUrl,
                                      width: 80,
                                      height: 80),
                                  Container(
                                    width: mediaQuery.size.width - 100,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          textAlign: TextAlign.left,
                                          index == 0
                                              ? "我喜欢的音乐"
                                              : _myPageController
                                                  .myPageSongSheets[index].name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                            textAlign: TextAlign.left,
                                            index == 0
                                                ? "${_myPageController.myPageSongSheets[index].trackCount + _myPageController.myPageSongSheets[index]!.cloudTrackCount}首·${_myPageController.myPageSongSheets[index].playCount}次播放"
                                                : "歌单·${_myPageController.myPageSongSheets[index].trackCount}首·${_myPageController.myPageSongSheets[index].creator.nickname}",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                        itemExtent: 90),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 70,
                    ))
                  ],
                )
              : Utils.loadingView(Alignment.center);
        });
      }),
      Builder(builder: (context) {
        return Obx(() {
          return _myPageController.myPageSongSheets.length != 0
              ? CustomScrollView(
                  key: PageStorageKey(
                      "${_tabController.index}-${_tabControllerWithMusicTab.index}"),
                  controller: PrimaryScrollController.of(context),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context)),
                    SliverFixedExtentList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: _myPageController
                                .myPageSongSheets.length, (context, index) {
                          if (_myPageController
                                  .myPageSongSheets[index].creator.userId ==
                              _myPageController.users!.userId) {
                            return GestureDetector(
                              onTap: () {
                                channel.invokeMethod("upSheetId", {
                                  "sheetId": _myPageController
                                      .myPageSongSheets[index].id
                                });
                                Navigator.pushNamed(
                                    context, "main/songListPage",
                                    arguments: {
                                      "type": "to_my_page_song_list",
                                      "id": _myPageController
                                          .myPageSongSheets[index].id
                                          .toString(),
                                      "title": index == 0
                                          ? "我喜欢的音乐"
                                          : _myPageController
                                              .myPageSongSheets[index].name,
                                      "IsTheSame": true
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    getSquareImg(
                                        Url: _myPageController
                                            .myPageSongSheets[index]
                                            .coverImgUrl,
                                        width: 80,
                                        height: 80),
                                    Container(
                                      width: mediaQuery.size.width - 100,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            textAlign: TextAlign.left,
                                            index == 0
                                                ? "我喜欢的音乐"
                                                : _myPageController
                                                    .myPageSongSheets[index]
                                                    .name,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                              textAlign: TextAlign.left,
                                              index == 0
                                                  ? "${_myPageController.myPageSongSheets[index].trackCount}首·${_myPageController.myPageSongSheets[index].playCount}次播放"
                                                  : "歌单·${_myPageController.myPageSongSheets[index].trackCount}首·${_myPageController.myPageSongSheets[index].creator.nickname}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                        itemExtent: 90),
                    const SliverToBoxAdapter(
                        child: SizedBox(
                      height: 70,
                    ))
                  ],
                )
              : Utils.loadingView(Alignment.center);
        });
      }),
    ]);
  }

  _secondaryTabWithPodcastTab(MediaQueryData mediaQuery) {
    return Builder(builder: (context) {
      return Obx(() {
        return _myPageController.videoList.length != 0
            ? CustomScrollView(
                key:
                    PageStorageKey<String>("listKey${_tabController.index}IN1"),
                slivers: <Widget>[
                  SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context)),
                  SliverFixedExtentList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: _myPageController.videoList.length,
                          (context, index) {
                        return InkWell(
                          onTap: () {
                            channel.invokeMethod("FoldOrUnfold", true);
                            Navigator.pushNamed(context, "main/VideoPage",
                                arguments: index);
                            _myPageController.myPageIsShow = false;
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: Row(
                              children: [
                                getSquareImg(
                                    Url: _myPageController
                                        .videoList![index].data.coverUrl,
                                    width: 100,
                                    height: 80),
                                Container(
                                  width: mediaQuery.size.width - 140,
                                  padding: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_myPageController.videoList![index].data.name}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                          "${Utils.formatTime(_myPageController.videoList![index].data.duration)} "
                                          "${_myPageController.videoList![index].resourceType == "MV" ? Utils.getSubTitle(_myPageController.videoList![index].data.artists) : "by ${_myPageController.videoList![index].data.creator!.nickname}"}",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                      itemExtent: 100),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 70,
                  ))
                ],
              )
            : Utils.loadingView(Alignment.center);
      });
    });
  }

  _pageThreeTabView() {
    return Builder(builder: (context) {
      return Obx(() {
        return _myPageController.relayInfo != null
            ? CustomScrollView(
                key:
                    PageStorageKey<String>("listKey${_tabController.index}IN2"),
                slivers: <Widget>[
                  SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context)),
                  SliverList.builder(
                      itemCount: _myPageController.events.length,
                      itemBuilder: (context, index) {
                        var info =
                            _myPageController.events[index].message!.info;
                        var imageUrl = info.playlist?.coverImgUrl ??
                            info.song?.album.picUrl ??
                            info.album?.picUrl;

                        var title = info.playlist?.name ??
                            info.song?.album.name ??
                            info.album?.name;

                        var creatorName = info.playlist?.creator.nickname ??
                            Utils.getSubTitle(
                                info.song?.artists ?? info.album?.artists);

                        return InkWell(
                          onTap: () {
                            Events e = _myPageController.events[index];
                            navigatorComment(e, imageUrl, title, creatorName,
                                context, index);
                            channel.invokeMethod("hideOrShowView", true);
                          },
                          child: pageThreeItem(_myPageController.events[index],
                              "$imageUrl", "$title", creatorName, index),
                        );
                      }),
                  const SliverToBoxAdapter(
                      child: SizedBox(
                    height: 70,
                  ))
                ],
              )
            : Utils.loadingView(Alignment.center);
      });
    });
  }

  void navigatorComment(Events e, String? imageUrl, String? title,
      String creatorName, BuildContext context, int index) {
    var params = {
      "avatarUrl": e.user.avatarUrl,
      "name": "${e.user.nickname}  分享${getType(e.type)}",
      "show_time&place":
          "${Utils.formatDate(e.showTime)} ${e.ipLocation.location}",
      "msg": e.message!.msg,
      "img": imageUrl,
      "title": title,
      "creatorName": creatorName,
      "id": e.threadId,
      "commentCount": e.info.commentCount,
      "likedCount": e.info.likedCount,
      "latestLikedUsers": e.info.commentThread.latestLikedUsers,
      "index": index
    };
    channel.invokeMethod("upSheetId", {"id": -1});
    // Navigator.push(context,CustomUpPageRoute(widget: traceCommentPage(params: params,)));
    _myPageController.myPageIsShow = false;
    Navigator.pushNamed(context, "main/traceCommentPage", arguments: params);
  }

  String getType(int type) {
    switch (type) {
      case 19:
        return "专辑";
      case 18:
        return "单曲";
      case 35:
      case 13:
        return "歌单";
    }
    return "";
  }

  getTabData() {
    dioRequest.executeGet(url: "/record/recent/video").then((value) {
      _myPageController.videoList = (value['list'] as List<dynamic>)
          .map((json) => VideoListBean.fromJson(json))
          .toList();
      _myPageController.videoInfoBean =
          List.generate(_myPageController.videoList.length, (index) => null);
      // _myPageController.players = List.generate(_myPageController.videoList.length, (index)=>null);
    });
    //relay;
    dioRequest.executeGet(
        url: "/user/event",
        params: {"uid": pageController.userId}).then((value) {
      var relayBeans = RelayBean.fromJson(value);
      _myPageController.relayInfo = relayBeans;
      _myPageController.events = _myPageController.relayInfo?.events;
    });
  }

  getSheetList() {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "to_myPage":
          var json = call.arguments;

          var userId = json['userId'];
          pageController.userId = userId;
          pageController.cookie = json['token'];

          var path = await getDatabasesPath();
          String file = path + '/music_db';
          var database = await openDatabase(file, version: 1);

          List<Map<String, dynamic>> query = await database.query("user_table",
              where: "userId = ?", whereArgs: [pageController.userId]);
          var range = query[0];

          _myPageController.users = UserInfoBean(
              range["avatarUrl"],
              range["backgroundUrl"],
              range["nickname"],
              range["birthday"],
              range["province"],
              range["gender"],
              range["city"],
              range["followeds"],
              range["follows"],
              range["eventCount"],
              range["userId"]);
          dioRequest.executeGet(
              url: "/user/detail", params: {"uid": userId}).then((value) {
            var userInfoBean = UserInfoBean.fromJson(value['profile']);
            userInfoBean.level = value['level'];
            //  print("9999ssdjdjfflfldslslslslsls${_myPageController.users!=null}------${_myPageController.users==userInfoBean}");
            // if( _myPageController.users!=null&&_myPageController.users==userInfoBean)return;
            _myPageController.users = userInfoBean;
          });
          dioRequest.executeGet(
              url: "/user/playlist", params: {"uid": userId}).then((value) {
            _myPageController.myPageSongSheets = (value as List<dynamic>)
                .map((json) => SongSheetList.fromJson(json))
                .toList();
          });
          getTabData();
          break;

        case "back":
          bool isBack = true;
          isBack = await childKey.currentState?.isPop() ?? false;

          if (isBack) {
            var p = {"origin": "my_page"};
            await channel.invokeMethod("back", p);
            pageController.pageIsOk = false;
          }
          if (childKey.currentState == null) {
            if (!_myPageController.myPageIsShow) {
              _myPageController.myPageIsShow = true;
              Navigator.pop(context);
            } else {
              var p = {"origin": "my_page2"};
              await channel.invokeMethod("back", p);
            }
          }

          break;
        case "currentId":
          pageController.currentSongId = call.arguments;
          break;
        case "RequestResults":
          var info = call.arguments;
          if (info['isSuccess']) {
            print(
                "object-------xxxxx-----${info['action']}---------${info['info']}");
            switch (info['action']) {
              case "saveImg":
                pageController.path ??= info['path'];
                Utils.downloadImage(info['info'], pageController.path)
                    .then((flag) {
                  childKey.currentState?.show(flag);
                });
                break;
              case "chooseImg":
                _imageFile = await Utils.chooseImage() as PickedFile?;

                break;
            }
          }
          break;
      }
    });
  }

  pageThreeItem(Events event, String imageUrl, String title, String creatorName,
      int index) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.grey,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //    Container(color: Colors.red,width: 50,height: 50,margin: EdgeInsets.only(right: 10),),
          getCircularImg(url: event.user.avatarUrl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${event.user.nickname}  分享${getType(event.type)}"),
              Text(Utils.formatDate(event.showTime)),
              Container(
                height: event.message!.msg == "" ? 0 : null,
                padding: EdgeInsets.only(top: 8),
                child: Text(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    event.message!.msg),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    getSquareImg(Url: imageUrl, width: 50, height: 50),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "by: $creatorName",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        navigatorComment(event, imageUrl, title, creatorName,
                            context, index);
                      },
                      label: Text(
                        "${event.info.commentCount == 0 ? "评论" : event.info.commentCount}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      icon: Icon(
                        Icons.question_answer,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton.icon(
                        onPressed: () async {
                          var t;
                          _myPageController.upCount(index);

                          if (_myPageController.events[index].info.liked) {
                            t = 0;
                          } else {
                            t = 1;
                          }

                          await dioRequest.executeGet(
                              url: "/resource/like",
                              params: {
                                "t": t,
                                "type": 6,
                                "threadId": event.threadId
                              });
                        },
                        label: Text(
                            "${_myPageController.events[index].info.likedCount == 0 ? "赞" : _myPageController.events[index].info.likedCount}",
                            style: TextStyle(color: Colors.grey)),
                        icon: Icon(
                          Icons.favorite_border_outlined,
                          color: _myPageController.events[index].info.liked
                              ? Colors.red
                              : Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {
                          _myPageController.myPageIsShow = false;
                          _showAlertDialog(index);
                        },
                        icon: Icon(
                          Icons.dangerous_outlined,
                          color: Colors.grey,
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _showAlertDialog(int index) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.end,
            title: Text("确定删除这条动态？", style: TextStyle(color: Colors.grey)),
            actions: [
              TextButton(
                child: Text("是", style: TextStyle(color: Colors.red)),
                onPressed: () {
                  dioRequest.executeGet(url: "/event/del", params: {
                    "evId": _myPageController.events[index].id
                  }).then((value) {
                    _myPageController.removeEvents(index);
                  });

                  Navigator.of(context).pop();
                },
              ),
              // “否”按钮
              TextButton(
                child: Text("否", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class getSquareImg extends StatefulWidget {
  final String Url;
  final double width;
  final double height;
  final bool isRadius;

  const getSquareImg(
      {super.key,
      required this.Url,
      required this.width,
      required this.height,
      this.isRadius = true});

  @override
  State<StatefulWidget> createState() => getSquareImgState();
}

class getSquareImgState extends State<getSquareImg> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.isRadius ? 8.0 : 0),
        child: CachedNetworkImage(
          httpHeaders: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36 SLBrowser/9.0.3.5211 SLBChan/103',
          },
          height: widget.height,
          width: widget.width,
          fit: BoxFit.cover,
          imageUrl: widget.Url,
          placeholder: (context, url) => Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey,
          ),
          errorWidget: (context, url, error) => Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey,
          ),
        ));
  }
}
