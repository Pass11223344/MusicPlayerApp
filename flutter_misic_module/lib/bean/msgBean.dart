


import 'package:json_annotation/json_annotation.dart';

part 'msgBean.g.dart';

@JsonSerializable()
class msgBean {
FromUser fromUser;
ToUser toUser;
String msg;
int id;
int time;

msgBean(this.fromUser, this.toUser, this.msg, this.id, this.time);
factory msgBean.fromJson(Map<String,dynamic> json)=>_$msgBeanFromJson(json);
Map<String,dynamic> toJson() => _$msgBeanToJson(this);
}
@JsonSerializable()
class ToUser {
  String nickname;

  String avatarUrl;
  String description;
  int userId;

  ToUser(this.nickname,  this.avatarUrl, this.description,
      this.userId);
  factory ToUser.fromJson(Map<String,dynamic> json)=>_$ToUserFromJson(json);
  Map<String,dynamic> toJson() => _$ToUserToJson(this);
}
@JsonSerializable()
class FromUser {
  String nickname;

  String avatarUrl;
  String description;
  int userId;

  FromUser(this.nickname,  this.avatarUrl, this.description,
      this.userId);
  factory FromUser.fromJson(Map<String,dynamic> json)=>_$FromUserFromJson(json);
  Map<String,dynamic> toJson() => _$FromUserToJson(this);
}