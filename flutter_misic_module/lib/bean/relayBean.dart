import 'package:json_annotation/json_annotation.dart';

import 'AlbumListBean.dart';
import 'CommentInfoBean.dart';
part 'relayBean.g.dart';
@JsonSerializable()
class relayBean{
  int size ;

  List<Events> events;


  relayBean(this.size,this.events);
  factory relayBean.fromJson(Map<String,dynamic> json)=>_$relayBeanFromJson(json);
  Map<String,dynamic> toJson() => _$relayBeanToJson(this);
}
@JsonSerializable()
class Events {
  Info info;

  int id;

  int showTime ;
  String json;
  IpLocation ipLocation;
  User user;
  Message? message;
  Message? get() => message;
  set(Message? msg) => message = msg;
  Events(this.info, this.id, this.showTime, this.json, this.ipLocation,
      this.user);
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
@JsonSerializable()
class CommentThread {
  String resourceTitle;

  CommentThread(this.resourceTitle);
  factory CommentThread.fromJson(Map<String,dynamic> json)=>_$CommentThreadFromJson(json);
  Map<String,dynamic> toJson() => _$CommentThreadToJson(this);
}

@JsonSerializable()
class Message{
  String msg;
  Song song;

  Message(this.msg, this.song);
  factory Message.fromJson(Map<String,dynamic> json)=>_$MessageFromJson(json);
  Map<String,dynamic> toJson() => _$MessageToJson(this);
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