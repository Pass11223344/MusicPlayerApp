// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MsgBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MsgBean _$MsgBeanFromJson(Map<String, dynamic> json) => MsgBean(
      FromUser.fromJson(json['fromUser'] as Map<String, dynamic>),
      ToUser.fromJson(json['toUser'] as Map<String, dynamic>),
      json['msg'] as String,
      (json['id'] as num).toInt(),
      (json['time'] as num).toInt(),
    );

Map<String, dynamic> _$MsgBeanToJson(MsgBean instance) => <String, dynamic>{
      'fromUser': instance.fromUser,
      'toUser': instance.toUser,
      'msg': instance.msg,
      'id': instance.id,
      'time': instance.time,
    };

ToUser _$ToUserFromJson(Map<String, dynamic> json) => ToUser(
      json['nickname'] as String,
      json['avatarUrl'] as String,
      json['description'] as String,
      (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$ToUserToJson(ToUser instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'description': instance.description,
      'userId': instance.userId,
    };

FromUser _$FromUserFromJson(Map<String, dynamic> json) => FromUser(
      json['nickname'] as String,
      json['avatarUrl'] as String,
      json['description'] as String,
      (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$FromUserToJson(FromUser instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'avatarUrl': instance.avatarUrl,
      'description': instance.description,
      'userId': instance.userId,
    };
