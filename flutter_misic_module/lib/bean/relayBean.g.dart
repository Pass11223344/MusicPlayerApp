// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relayBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

relayBean _$relayBeanFromJson(Map<String, dynamic> json) => relayBean(
      (json['size'] as num).toInt(),
      (json['events'] as List<dynamic>)
          .map((e) => Events.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$relayBeanToJson(relayBean instance) => <String, dynamic>{
      'size': instance.size,
      'events': instance.events,
    };

Events _$EventsFromJson(Map<String, dynamic> json) => Events(
      Info.fromJson(json['info'] as Map<String, dynamic>),
      (json['id'] as num).toInt(),
      (json['showTime'] as num).toInt(),
      json['json'] as String,
      IpLocation.fromJson(json['ipLocation'] as Map<String, dynamic>),
      User.fromJson(json['user'] as Map<String, dynamic>),

    );

Map<String, dynamic> _$EventsToJson(Events instance) => <String, dynamic>{
      'info': instance.info,
      'id': instance.id,
      'showTime': instance.showTime,
      'json': instance.json,
      'ipLocation': instance.ipLocation,
      'user': instance.user,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      CommentThread.fromJson(json['commentThread'] as Map<String, dynamic>),
      json['liked'] as bool,
      (json['commentCount'] as num).toInt(),
      (json['likedCount'] as num).toInt(),
      (json['shareCount'] as num).toInt(),
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'commentThread': instance.commentThread,
      'liked': instance.liked,
      'commentCount': instance.commentCount,
      'likedCount': instance.likedCount,
      'shareCount': instance.shareCount,
    };

CommentThread _$CommentThreadFromJson(Map<String, dynamic> json) =>
    CommentThread(
      json['resourceTitle'] as String,
    );

Map<String, dynamic> _$CommentThreadToJson(CommentThread instance) =>
    <String, dynamic>{
      'resourceTitle': instance.resourceTitle,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      json['msg'] as String,
      Song.fromJson(json['song'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'msg': instance.msg,
      'song': instance.song,
    };

Song _$SongFromJson(Map<String, dynamic> json) => Song(
      json['name'] as String,
      (json['id'] as num).toInt(),
      (json['artists'] as List<dynamic>)
          .map((e) => Artists.fromJson(e as Map<String, dynamic>))
          .toList(),
      Album.fromJson(json['album'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'artists': instance.artists,
      'album': instance.album,
    };
