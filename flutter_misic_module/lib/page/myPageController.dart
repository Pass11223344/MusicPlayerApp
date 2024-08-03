
import 'package:flutter_misic_module/bean/AlbumListBean.dart';
import 'package:flutter_misic_module/bean/CommentInfoBean.dart';
import 'package:flutter_misic_module/bean/RelayBean.dart';
import 'package:flutter_misic_module/bean/SongListBean.dart';
import 'package:flutter_misic_module/bean/ShowSongSheet.dart';
import 'package:flutter_misic_module/bean/UserInfoBean.dart';
import 'package:flutter_misic_module/bean/VideoInfoBean.dart';
import 'package:flutter_misic_module/main.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:player/player.dart';

import '../bean/SongSheetList.dart';
import '../bean/VideoListBean.dart';


class PageControllers extends GetxController{

  var  _isOverlayVisible = false.obs;
  var _pageIsOk = false.obs;
  var _myPageIsOk = false.obs;
  var _cookie = "".obs;
  var _userId = 0.obs;
  var _pageNum = 0.obs;
  var _currentSongId = 0.obs;
  var _lastId = 0.obs;
  var _lastAlbumId = 0.obs;
  var  _isOpenCommentPage = false.obs;
  var  path ;
  int get currentSongId => _currentSongId.value;
  set currentSongId(int id) => _currentSongId.value = id;

  int get pageNum => _pageNum.value;

  set pageNum(int value) => _pageNum.value = value;
  int get userId => _userId.value;

  set userId(int value) => _userId.value = value;
  bool get pageIsOk => _pageIsOk.value;

  set pageIsOk(bool value) => _pageIsOk.value = value;
  bool get myPageIsOk => _myPageIsOk.value;


  set isOpenCommentPage(bool value) => _isOpenCommentPage.value = value;
  bool get isOpenCommentPage => _isOpenCommentPage.value;
  set myPageIsOk(bool value) => _myPageIsOk.value = value;


  bool get isOverlayVisible => _isOverlayVisible.value;
  set isOverlayVisible(bool isOverlayVisible ) => _isOverlayVisible.value = isOverlayVisible;
  String get cookie => _cookie.value;
  set cookie(String value ) => _cookie.value = value;

  int get lastId => _lastId.value;
  set lastId(int id) => _lastId.value = id;
  int get lastAlbumId => _lastAlbumId.value;
  set lastAlbumId(int id) => _lastAlbumId.value = id;
}
class myPageController extends GetxController{

  var _selectedIndex = 0.obs;
  var _isExpanded = true.obs;
  var _isListExpanded=true.obs;
  var _relayInfo = Rx<RelayBean?>(null);
  var _msgInfo = Rx<Message?>(null);
  var _songSheetInfo = Rx<SongSheetList?>(null);
  var _traceCommentInfo = Rx<CommentInfoBean?>(null);
  var _users = Rx<UserInfoBean?>(null);
  RxList<Events> _events = <Events>[].obs;

  var _traceCommentTabIndex = 0.obs;
  var _descriptionH = 0.0.obs;
  var _isTraceComment = false.obs;
  var _isReplyComment = false.obs;


  var _ItemCount = 0.obs;

  var _currentCommentId = 0.obs;
  var _currentReplyComment = 0.obs;
  var _maps = {"":[]}.obs;
  final RxList<SongListBean> _recentlyPlayedSongs = <SongListBean>[].obs;
  final RxList<ShowSongSheet> _recentlyPlayedSongSheets = <ShowSongSheet>[].obs;
  final RxList<SongSheetList> _myPageSongSheets = <SongSheetList>[].obs;
  final RxList<AlbumListBean> _recentlyPlayedAlbums = <AlbumListBean>[].obs;
  final RxList<VideoListBean> _videoList = <VideoListBean>[].obs;
  final RxList<ShowSong>? _showSongs = <ShowSong>[].obs;
  final RxList<VideoInfoBean?> _videoInfoBean = <VideoInfoBean?>[].obs;

  var _showSongsIsOk = false.obs;
  final Map<String, Player?> _pool = {};
  var  _isFavorites = {"":false}.obs;

  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int index) => _selectedIndex.value = index;
  bool get isExpanded => _isExpanded.value;
  set isExpanded(bool flag) => _isExpanded.value = flag;

  bool get isListExpanded => _isListExpanded.value;
  set isListExpanded(bool flag) => _isListExpanded.value = flag;
  SongSheetList? get songSheetInfo =>_songSheetInfo.value;
  set songSheetInfo(SongSheetList? info) =>_songSheetInfo.value = info;
  RelayBean? get relayInfo =>_relayInfo.value;
  set relayInfo(RelayBean? info) =>_relayInfo.value = info;
  Message? get msgInfo =>_msgInfo.value;
  set msgInfo(Message? info) =>_msgInfo.value = info;
  CommentInfoBean? get traceCommentInfo =>  _traceCommentInfo.value;
  set traceCommentInfo(CommentInfoBean?  info) =>  _traceCommentInfo.value = info;
  int get traceCommentTabIndex => _traceCommentTabIndex.value;
   set traceCommentTabIndex(int index) => _traceCommentTabIndex.value = index;
   bool get isTraceComment => _isTraceComment.value;
   set isTraceComment(bool f) => _isTraceComment.value = f;
  int get currentCommentId => _currentCommentId.value;
  set currentCommentId(int index) => _currentCommentId.value = index;
  bool get isReplyComment => _isReplyComment.value;
  set isReplyComment(bool f) => _isReplyComment.value = f;
  int get itemCount => _ItemCount.value;
  set itemCount(int index) => _ItemCount.value = index;
 List<Events> get events => _events.value;
  set events(value) => _events.value = value;
  int get currentReplyComment => _currentReplyComment.value;
  set currentReplyComment(int index) => _currentReplyComment.value = index;
  Map<String,List> get maps => _maps.value;
  set maps(Map<String,List> info) => _maps.value = info;
  List<SongListBean> get recentlyPlayedSongs => _recentlyPlayedSongs.value;
  set recentlyPlayedSongs(List<SongListBean> value) => _recentlyPlayedSongs.value = value;
  List<ShowSongSheet> get recentlyPlayedSongSheets => _recentlyPlayedSongSheets.value;
  set recentlyPlayedSongSheets(List<ShowSongSheet> value) => _recentlyPlayedSongSheets.value = value;
  List<SongSheetList> get myPageSongSheets => _myPageSongSheets.value;
  set myPageSongSheets(List<SongSheetList> value) => _myPageSongSheets.value = value;
  List<AlbumListBean> get recentlyPlayedAlbums => _recentlyPlayedAlbums.value;
  set recentlyPlayedAlbums(List<AlbumListBean> value) => _recentlyPlayedAlbums.value = value;
  List<ShowSong> get showSongs => _showSongs!.value;
  set showSongs(List<ShowSong>? list)=>_showSongs!.value = list!;
  List<VideoListBean> get videoList => _videoList.value;
  set videoList(List<VideoListBean>? list){
     _videoList.value = list!;}
  bool get showSongsIsOk => _showSongsIsOk.value;
  set showSongsIsOk(bool flag) => _showSongsIsOk.value = flag;
  UserInfoBean? get users => _users.value;
  set users(UserInfoBean? bean) => _users.value = bean;
  List<VideoInfoBean?> get videoInfoBean => _videoInfoBean.value;
  set videoInfoBean(List<VideoInfoBean?> list) => _videoInfoBean.value = list;
  // List<String?> get players => _players.value;
  // set players(List<String?> list)=>_players.value = list;
  double get descriptionH => _descriptionH.value;
  set descriptionH(double v)=>_descriptionH.value = v;
  Map<String,bool> get isFavorites =>_isFavorites.value;
  set isFavorites(Map<String,bool> info) => _isFavorites.value = info;
  void insertVideoInfoBean(int index ,VideoInfoBean? info,bool isFirst){
    _videoInfoBean.replaceRange(index,index+1, [info]);
    _videoInfoBean.refresh();
    createPlayer(_videoInfoBean[index]!.url, isFirst, SourceType.nte);
    // if(info!=null){
    //   print("object这里内容为${_videoInfoBean[index]!.url}");
    //   _players.replaceRange(index, index+1,[ _videoInfoBean[index]!.url]);
    //   _players.refresh();
    // }

  }

void removeEvents(int index){

  _events.removeAt(index);
  _events.refresh();
}

  void upCount(int index){

    if (_events[index].info.liked){

      _events[index].info.liked = false;
      _events[index].info.likedCount-=1;

    }else{

      _events[index].info.liked = true;
      _events[index].info.likedCount+=1;

    }
   _events.refresh();
  }
  addShowSongsSongList(List<ShowSong> list){
    _showSongs!.addAll(list);
  }
getPlayer(String? url){
    return _pool[url];
}
  createPlayer(String url,bool autoPlay,SourceType type)   {
    // if (_pool.length<=3) {
    //   _pool[url] =  Player()..setCommonDataSource(url,autoPlay:autoPlay,type:type)..setLoop(0);
    //  // return  _pool[url];
    // } else{
    if (_pool.containsKey(url)) return;
      _pool[url] =  Player()..setCommonDataSource(url,autoPlay:autoPlay,type:type)..setLoop(0);
      if (_pool.length>3) {
        final oldestKey  = _pool.keys.first;
        _pool[oldestKey]?.dispose();
        _pool[oldestKey] = null;
        _pool.remove(oldestKey);
     // }

     // return  _pool[url];

    }
  }
  disposePlayer(){
    _pool.forEach((k,v){
      v?.release();
      v?.dispose();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
 //  final  _avatarUrl = myPage().users?.avatarUrl.obs;
 //  final  _backgroundUrl =myPage().users?.backgroundUrl.obs;
 //  final  _nickname = myPage().users?.nickname.obs;
 //  final   _birthday = myPage().users?.birthday.obs;
 //  final  _province = myPage().users?.province.obs;
 //  final  _gender = myPage().users?.gender.obs;
 //  final  _city = myPage().users?.city.obs;
 //  final  _followeds = myPage().users?.followeds.obs;
 //  final  _follows = myPage().users?.follows.obs;
 //  final  _eventCount = myPage().users?.eventCount.obs;
 //  final _userId = myPage().users?.userId.obs;
 //
 //
 //  String get avatar  => _avatarUrl!.value;
 // set avatar(String str) => _avatarUrl!.value = str;
 //
 // String get background => _backgroundUrl!.value;
 // set background(String str) => _backgroundUrl!.value = str;
 //
 // String get nickname => _nickname!.value;
 // set nickname(String str) => _nickname!.value = str;
 //
 // int get birthday => _birthday!.value;
 // set birthday(int num) => _birthday!.value = num;
 //
 // int get province => _province!.value;
 // set province(int num) => _province!.value = num;
 //
 //
 // int get gender => _gender!.value;
 // set gender(int num) => _gender!.value = num;
 //
 // int get city => _city!.value;
 // set city(int num) => _city!.value = num;
 //
 // int get followeds => _followeds!.value;
 // set followeds(int num) => _followeds!.value = num;
 //
 //
 // int get follows => _follows!.value;
 // set follows(int num) => _follows!.value = num;int
 //
 //  get eventCount => _eventCount!.value;
 // set eventCount(int num) => _eventCount!.value = num;int
 //
 //  get userId => _userId!.value;
 // set userId(int num) => _userId!.value = num;
}


