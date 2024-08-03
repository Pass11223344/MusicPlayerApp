import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../bean/AlbumListBean.dart';
import '../bean/SongSheetList.dart';
import '../bean/SongListBean.dart';

class songListController extends GetxController{
  RxList<SongListBean> _songList = <SongListBean>[].obs;
  var _albumInfo = Rx<AlbumListBean?>(null);
  var _songSheet = Rx<SongSheetList?>(null);
  var _imgColor = Color(0x1F000000).obs;
  var _isSearch = false.obs;
  var _isContain = false.obs;
  var _isShow = false.obs;
  var _isOpenSheet = false.obs;
  var _text = "".obs;
 var  _showSongsIsOk = false.obs;
 var _expandedHeight = 0.0.obs;


 SongSheetList? get songSheet => _songSheet.value;
  set songSheet(SongSheetList? bean) => _songSheet.value = bean;
  AlbumListBean? get albumInfo => _albumInfo.value;
  set albumInfo(AlbumListBean? bean) => _albumInfo.value = bean;
  List<SongListBean> get songList =>_songList.value;
  Color get imgColor =>_imgColor.value;
  set imgColor(Color c) =>  _imgColor.value = c;
  bool get isSearch => _isSearch.value;
   set isSearch(bool b) => _isSearch.value = b;
  bool get isContain => _isContain.value;
  set isContain(bool b) => _isContain.value = b;
  bool get isShow => _isShow.value;
  set isShow(bool b) => _isShow.value = b;
  String get text => _text.value;
  set text(String str) => _text.value = str;
  bool get showSongsIsOk => _showSongsIsOk.value;
  set showSongsIsOk(bool flag) => _showSongsIsOk.value = flag;
  double get expandedHeight => _expandedHeight.value;
  set expandedHeight(double num) => _expandedHeight.value = num;
  bool get isOpenSheet => _isOpenSheet.value;
  set isOpenSheet(bool flag) => _isOpenSheet.value = flag;
  addSongList(List<SongListBean> list){
    _songList.addAll(list);
  }
  remove(){
    _songList.clear();
  }
 set songList(List<SongListBean> list)=> _songList.value = list;
  setLiked(bool flag){
    if(albumInfo!=null){
      albumInfo!.album.info.liked = flag;
      _albumInfo.refresh();
    }else{
      songSheet?.subscribed = flag;
      //  _songSheet.value.
      _songSheet.refresh();
    }

  }
}