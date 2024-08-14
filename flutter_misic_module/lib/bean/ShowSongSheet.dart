import 'package:flutter_misic_module/bean/UserInfoBean.dart';

import 'SongListBean.dart';

class ShowSongSheet {
  int playTime;
  int id;
  String name;
  String coverImgUrl;
  UserInfoBean creator;

  ShowSongSheet(
      this.playTime, this.id, this.name, this.coverImgUrl, this.creator);
}

class ShowSong {
  int songId;
  String name;
  String picUrl;
  String artistName;
  String albumName;
  int boughtCount;

  ShowSong(this.songId, this.name, this.picUrl, this.artistName, this.albumName,
      this.boughtCount);

  factory ShowSong.fromJson(Map<String, dynamic> json) => ShowSong(
      json['songId'],
      json['name'],
      json['picUrl'],
      json['artistName'],
      json['albumName'] == null ? "" : json['albumName'],
      json['boughtCount']);

  Map<String, dynamic> toJson() {
    var split = artistName.split("/");
    List<Ar> ar = [];
    for (var value in split) {
      ar.add(Ar(0, value));
    }
    Al al = Al(albumName, picUrl);
    return {"id": songId, "al": al, "ar": ar, "name": name};
  }
}
