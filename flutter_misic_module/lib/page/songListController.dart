import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../bean/AlbumListBean.dart';
import '../bean/SongSheetList.dart';
import '../bean/songListBean.dart';

class songListController extends GetxController{
  RxList<songListBean> _songList = <songListBean>[].obs;
  var _albumInfo = Rx<AlbumListBean?>(null);
  var _songSheet = Rx<SongSheetList?>(null);
 SongSheetList? get songSheet => _songSheet.value;
  set SongSheet(SongSheetList? bean) => _songSheet.value = bean;
  AlbumListBean? get albumInfo => _albumInfo.value;
  set AlbumInfo(AlbumListBean? bean) => _albumInfo.value = bean;
  List<songListBean> get songList =>_songList.value;
  addSongList(List<songListBean> list){
    _songList.addAll(list);
  }
  remove(){
    _songList.clear();
  }
 set SongList(List<songListBean> list)=> _songList.value = list;
}