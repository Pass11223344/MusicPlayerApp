// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentInfoBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentInfoBean _$CommentInfoBeanFromJson(Map<String, dynamic> json) =>
    CommentInfoBean(
      (json['comments'] as List<dynamic>)
          .map((e) => Comments.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['totalCount'] as num).toInt(),
      (json['sortType'] as num).toInt(),
      json['cursor'] as String,
    );

Map<String, dynamic> _$CommentInfoBeanToJson(CommentInfoBean instance) =>
    <String, dynamic>{
      'comments': instance.comments,
      'totalCount': instance.totalCount,
      'sortType': instance.sortType,
      'cursor': instance.cursor,
    };

Comments _$CommentsFromJson(Map<String, dynamic> json) => Comments(
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['beReplied']==null?[]: (json['beReplied'] as List<dynamic>)
          .map((e) => BeReplied.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['commentId'] as num).toInt(),
      (json['likedCount'] as num).toInt(),
      (json['replyCount'] as num).toInt(),
      (json['parentCommentId'] as num).toInt(),
      json['timeStr'] as String,
      json['content'] as String,
      json['liked'] as bool,
      IpLocation.fromJson(json['ipLocation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CommentsToJson(Comments instance) => <String, dynamic>{
      'user': instance.user,
      'beReplied': instance.beReplied,
      'commentId': instance.commentId,
      'likedCount': instance.likedCount,
      'replyCount': instance.replyCount,
      'parentCommentId': instance.parentCommentId,
      'timeStr': instance.timeStr,
      'content': instance.content,
      'liked': instance.liked,
      'ipLocation': instance.ipLocation,
    };

BeReplied _$BeRepliedFromJson(Map<String, dynamic> json) => BeReplied(
      User.fromJson(json['user'] as Map<String, dynamic>),
      json['content'] as String,
      (json['beRepliedCommentId'] as num).toInt(),
    );

Map<String, dynamic> _$BeRepliedToJson(BeReplied instance) => <String, dynamic>{
      'user': instance.user,
      'content': instance.content,
      'beRepliedCommentId': instance.beRepliedCommentId,
    };

IpLocation _$IpLocationFromJson(Map<String, dynamic> json) => IpLocation(
      json['location'] as String,
    );

Map<String, dynamic> _$IpLocationToJson(IpLocation instance) =>
    <String, dynamic>{
      'location': instance.location,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['followed'] as bool,
      (json['userId'] as num).toInt(),
      json['avatarUrl'] as String,
      json['nickname'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'followed': instance.followed,
      'userId': instance.userId,
      'avatarUrl': instance.avatarUrl,
      'nickname': instance.nickname,
    };
