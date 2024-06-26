
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'AlbumListBean.g.dart';

@JsonSerializable()
class AlbumListBean {
  List<Songs> songs;
  Album album;
  AlbumListBean(this.songs, this.album);
  factory AlbumListBean.fromJson(Map<String,dynamic> json)=>_$AlbumListBeanFromJson(json);
  Map<String,dynamic> toJson() => _$AlbumListBeanToJson(this);

}
@JsonSerializable()
class Album {
  String picUrl;
  String blurPicUrl;
  String description;
  String name;
  int id;
  int size;
  Info info;
  int publishTime;
  List<Artists> artists;
  List<String> alias;


  Album(this.picUrl, this.blurPicUrl, this.description, this.name, this.id,
      this.size, this.info, this.publishTime, this.artists,this.alias);

  factory Album.fromJson(Map<String,dynamic> json)=>_$AlbumFromJson(json);
  Map<String,dynamic> toJson() => _$AlbumToJson(this);

}
@JsonSerializable()
class Artists {
  int id;
  String name;
  bool followed;

  Artists(this.id, this.name, this.followed);
  factory Artists.fromJson(Map<String,dynamic> json)=>_$ArtistsFromJson(json);
  Map<String,dynamic> toJson() => _$ArtistsToJson(this);
}
@JsonSerializable()
class Info {
  int resourceType;
  int commentCount;
  int likedCount;
  int shareCount;
  bool liked;

  Info(this.resourceType, this.commentCount, this.likedCount, this.shareCount,
      this.liked);
  factory Info.fromJson(Map<String,dynamic> json)=>_$InfoFromJson(json);
  Map<String,dynamic> toJson() => _$InfoToJson(this);
}


@JsonSerializable()
class Songs {
  List<AR> ar;
  Al al;
  String name;
  int id;

  Songs(this.ar, this.al,this.name,this.id);
  factory Songs.fromJson(Map<String,dynamic> json)=>_$SongsFromJson(json);
  Map<String,dynamic> toJson() => _$SongsToJson(this);
}
@JsonSerializable()
class Al {
  String name;

  String pic_str;


  Al(this.name,this.pic_str);
  factory Al.fromJson(Map<String,dynamic> json)=>_$AlFromJson(json);
  Map<String,dynamic> toJson() => _$AlToJson(this);


  void pic(String str) {pic_str = str;}

}
@JsonSerializable()
class AR {
  int id;
  String name;

  AR(this.id, this.name);
  factory AR.fromJson(Map<String,dynamic> json)=>_$ARFromJson(json);
  Map<String,dynamic> toJson() => _$ARToJson(this);
}