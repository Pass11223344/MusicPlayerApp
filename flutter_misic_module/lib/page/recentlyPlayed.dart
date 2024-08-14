import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_misic_module/bean/AlbumListBean.dart';
import 'package:flutter_misic_module/bean/SongListBean.dart';
import 'package:flutter_misic_module/bean/UserInfoBean.dart';

import 'package:flutter_misic_module/bean/ShowSongSheet.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:flutter_misic_module/page/myPageController.dart';
import 'package:flutter_misic_module/util/Utils.dart';
import 'package:get/get.dart';

import 'myPage.dart';

//最近
class recentlyPlayed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => recentlyPlayedState();
}

class recentlyPlayedState extends State<recentlyPlayed>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late myPageController _myPageController;

  var pageController = Get.find<PageControllers>();
  int lastSongId = 0;
  int currentTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Get.put(myPageController());
    _myPageController = Get.find<myPageController>();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentTab = _tabController.index;
      });
    });
    getData("song");
  }

  @override
  void didUpdateWidget(covariant recentlyPlayed oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _myPageController.recentlyPlayedSongs = [];
    _myPageController.recentlyPlayedSongSheets = [];
    _myPageController.recentlyPlayedAlbums = [];
    getData("song");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("最近播放"),
            bottom: TabBar(
                controller: _tabController,
                indicatorPadding: EdgeInsets.zero,
                dividerHeight: 0,
                indicatorColor: Colors.red,
                labelColor: Colors.black,
                unselectedLabelColor: Color(0xff77767c),
                tabs: const [
                  Tab(
                    text: "单曲",
                  ),
                  Tab(
                    text: "歌单",
                  ),
                  Tab(
                    text: "专辑",
                  ),
                ])),
        body: PopScope(
          onPopInvoked: (isPop) {
            var p = {"origin": "my_page"};
            channel.invokeMethod("back", p);
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              Obx(() {
                return _myPageController.recentlyPlayedSongs.length != 0
                    ? Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: ListView.builder(
                            itemExtent: 60,
                            itemCount:
                                _myPageController.recentlyPlayedSongs.length,
                            itemBuilder: (context, index) {
                              return _SongListItem(index);
                            }),
                      )
                    : Utils.loadingView(Alignment.topCenter);
              }),
              Obx(() {
                if (_myPageController.recentlyPlayedSongSheets.length == 0 &&
                    currentTab == 1) {
                  getData("songSheet");
                }
                return _myPageController.recentlyPlayedSongSheets.length != 0
                    ? ListView.builder(
                        itemExtent: 70,
                        itemCount:
                            _myPageController.recentlyPlayedSongSheets.length,
                        itemBuilder: (context, index) {
                          return _SongSheetListItem(index);
                        })
                    : Utils.loadingView(Alignment.topCenter);
              }),
              Obx(() {
                if (_myPageController.recentlyPlayedAlbums.length == 0 &&
                    currentTab == 2) {
                  getData("album");
                }
                return _myPageController.recentlyPlayedAlbums.length != 0
                    ? ListView.builder(
                        itemExtent: 70,
                        itemCount:
                            _myPageController.recentlyPlayedAlbums.length,
                        itemBuilder: (context, index) {
                          return _AlbumListItem(index);
                        })
                    : Utils.loadingView(Alignment.topCenter);
              }),
            ],
          ),
        ));
  }

  void getData(String type) {
    switch (type) {
      case "song":
        dioRequest.executeGet(url: "/record/recent/song").then((value) {
          if (value != "error") {
            _myPageController.recentlyPlayedSongs =
                (value['list'] as List<dynamic>)
                    .map((json) => SongListBean.fromJson(json['data']))
                    .toList();
          }
        });
        break;
      case "songSheet":
        dioRequest.executeGet(url: "/record/recent/playlist").then((value) {
          if (value != "error") {
            _myPageController.recentlyPlayedSongSheets =
                (value['list'] as List<dynamic>)
                    .map((json) => ShowSongSheet(
                        json['playTime'],
                        json['data']['id'],
                        json['data']['name'],
                        json['data']['coverImgUrl'],
                        UserInfoBean.fromJson(json['data']['creator'])))
                    .toList();
          }
        });
        break;
      case "album":
        dioRequest.executeGet(url: "/record/recent/album").then((value) {
          if (value != "error") {
            _myPageController.recentlyPlayedAlbums =
                (value['list'] as List<dynamic>).map((json) {
              var songs = (json['data']['songs'] as List<dynamic>)
                  .map((e) => Songs.fromJson(e as Map<String, dynamic>))
                  .toList();
              var bean = AlbumListBean(songs, Album.fromJson(json['data']));
              bean.playTime = json['playTime'];
              return bean;
            }).toList();
          }
        });
        break;
    }
  }

  _SongListItem(int index) {
    return ListTile(
      title: Text(
        _myPageController.recentlyPlayedSongs![index].name,
        maxLines: 1,
      ),
      titleTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
      subtitle: Text(
        "${Utils.getSubTitle(_myPageController.recentlyPlayedSongs![index].ar)}-${_myPageController.recentlyPlayedSongs![index].al.name != null ? _myPageController.recentlyPlayedSongs![index].al.name : ""}",
        maxLines: 1,
      ),
      subtitleTextStyle: const TextStyle(
          fontSize: 12, color: Colors.grey, overflow: TextOverflow.ellipsis),
      trailing: Image.asset(
        "images/more.png",
        width: 20,
        height: 20,
      ),
      onTap: () {
        if (pageController.lastId ==
            _myPageController.recentlyPlayedSongs[index].id) {
          return;
        }

        pageController.lastId = _myPageController.recentlyPlayedSongs[index].id;
        channel.invokeMethod("sendSongList", {
          "title": "最近播放",
          "SongIndex": index,
          "SongList": jsonEncode(_myPageController.recentlyPlayedSongs)
        });
      },
    );
  }

  _SongSheetListItem(int index) {
    return ListTile(
      leading: getSquareImg(
        Url: _myPageController.recentlyPlayedSongSheets[index].coverImgUrl,
        width: 55,
        height: 55,
      ),
      title: Text(
        _myPageController.recentlyPlayedSongSheets[index].name,
        maxLines: 1,
      ),
      titleTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
      subtitle: Text(
        "by ${_myPageController.recentlyPlayedSongSheets[index].creator.nickname}",
        maxLines: 1,
      ),
      subtitleTextStyle: const TextStyle(
          fontSize: 12, color: Colors.grey, overflow: TextOverflow.ellipsis),
      trailing: Text(
          Utils.formatDate(
              _myPageController.recentlyPlayedSongSheets[index].playTime),
          style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis)),
      onTap: () async {
        channel.invokeMethod("addPage",
            {"sheetId": _myPageController.recentlyPlayedSongSheets[index].id});
        Navigator.pushNamed(context, "main/songListPage", arguments: {
          "type": "to_my_page_song_list",
          "id": _myPageController.recentlyPlayedSongSheets[index].id.toString(),
          "title": _myPageController.recentlyPlayedSongSheets[index].name,
          "IsTheSame":
              _myPageController.myPageSongSheets[index].creator.userId ==
                  _myPageController.users!.userId
        });
      },
    );
  }

  _AlbumListItem(int index) {
    return ListTile(
      leading: getSquareImg(
        Url: _myPageController.recentlyPlayedAlbums![index].album.picUrl,
        width: 55,
        height: 55,
      ),
      title: Text(
        _myPageController.recentlyPlayedAlbums[index].album.name,
        maxLines: 1,
      ),
      titleTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.bold),
      subtitle: Text(
        Utils.getSubTitle(
            _myPageController.recentlyPlayedAlbums[index].album.artists),
        maxLines: 1,
      ),
      subtitleTextStyle: const TextStyle(
          fontSize: 12, color: Colors.grey, overflow: TextOverflow.ellipsis),
      trailing: Text(
          Utils.formatDate(
              _myPageController.recentlyPlayedAlbums[index].playTime!),
          style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis)),
      onTap: () async {
        // setState(() {
        //   jump_page = true;
        // });
        channel.invokeMethod("addPage", "");
        await Navigator.pushNamed(context, "main/songListPage", arguments: {
          "id": "${_myPageController.recentlyPlayedAlbums[index].album.id}",
          "title": _myPageController.recentlyPlayedAlbums[index].album.name,
          "IsTheSame":
              _myPageController.myPageSongSheets[index].creator.userId ==
                  _myPageController.users!.userId,
          "type": "to_albums"
        });
      },
    );
  }
}
