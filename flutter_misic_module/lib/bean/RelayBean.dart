

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'AlbumListBean.dart';
import 'CommentInfoBean.dart';
import 'SongSheetList.dart';
part 'RelayBean.g.dart';
@JsonSerializable()
class RelayBean{
  int size ;

  List<Events> events;


  RelayBean(this.size,this.events);
  factory RelayBean.fromJson(Map<String,dynamic> json)=>_$RelayBeanFromJson(json);
  Map<String,dynamic> toJson() => _$RelayBeanToJson(this);
}
@JsonSerializable()
class Events {
  Info info;
  int id;
  int showTime ;
  String json;
  IpLocation ipLocation;
  User user;
  Message message;
  String threadId;
  int type;
 //  Message? get() => message;
 // Events set(Message? msg) {
 //  message = msg;
 //  return this;
 //  }
  Events(this.info, this.id, this.showTime, this.json, this.ipLocation,
      this.user,this.threadId,this.type,this.message);
  factory Events.fromJson(Map<String,dynamic> json)=>_$EventsFromJson(json);
  Map<String,dynamic> toJson() => _$EventsToJson(this);

}
@JsonSerializable()
class Info {
  CommentThread commentThread;
  bool liked;
  int commentCount;
  int likedCount;
  int shareCount;

  Info(this.commentThread, this.liked, this.commentCount, this.likedCount,
      this.shareCount);
  factory Info.fromJson(Map<String,dynamic> json)=>_$InfoFromJson(json);
  Map<String,dynamic> toJson() => _$InfoToJson(this);
}

class CommentThread {
  String resourceTitle;
  List<LatestLikedUsers> latestLikedUsers;
  CommentThread(this.resourceTitle,this.latestLikedUsers);
  factory CommentThread.fromJson(Map<String,dynamic> json)=>_$CommentThreadFromJson(json);
  Map<String,dynamic> toJson() => _$CommentThreadToJson(this);
}

class LatestLikedUsers {
  int s;

  LatestLikedUsers(this.s);
}


class Message{
  String msg;
  OtherInfo info;

  Message(this.msg, this.info);
  factory Message.fromJson(Map<String,dynamic> json,int type)=>_$MessageFromJson(json,type);
  Map<String,dynamic> toJson() => _$MessageToJson(this);
}

class OtherInfo {
  Song? song;
  Album? album;
  SongSheetList? playlist;
}
@JsonSerializable()
class Song {
  String name;
  int id;
  List<Artists> artists;
  Album album;

  Song(this.name, this.id, this.artists, this.album);
  factory Song.fromJson(Map<String,dynamic> json)=>_$SongFromJson(json);
  Map<String,dynamic> toJson() => _$SongToJson(this);
}