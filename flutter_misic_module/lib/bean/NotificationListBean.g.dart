// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationListBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationListBean _$NotificationListBeanFromJson(
        Map<String, dynamic> json) =>
    NotificationListBean(
      (json['msgCount'] as num).toInt(),
      (json['newMsgCount'] as num).toInt(),
      json['lastMsgTime'] as String,
      (json['sendUserUserId'] as num).toInt(),
      (json['receiveUserId'] as num).toInt(),
      json['sendUserSendIdentityIconUrl'] as String,
      json['sendUserNickname'] as String,
      json['sendUserAvatarUrl'] as String,
      json['msg'] as String,
      json['receiveNickname'] as String,
      json['receiveAvatarUrl'] as String,
    );

Map<String, dynamic> _$NotificationListBeanToJson(
        NotificationListBean instance) =>
    <String, dynamic>{
      'msgCount': instance.msgCount,
      'newMsgCount': instance.newMsgCount,
      'sendUserUserId': instance.sendUserUserId,
      'receiveUserId': instance.receiveUserId,
      'sendUserSendIdentityIconUrl': instance.sendUserSendIdentityIconUrl,
      'sendUserNickname': instance.sendUserNickname,
      'sendUserAvatarUrl': instance.sendUserAvatarUrl,
      'msg': instance.msg,
      'receiveNickname': instance.receiveNickname,
      'receiveAvatarUrl': instance.receiveAvatarUrl,
      'lastMsgTime': instance.lastMsgTime,
    };
