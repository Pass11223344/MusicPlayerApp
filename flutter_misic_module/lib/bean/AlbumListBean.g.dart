// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AlbumListBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumListBean _$AlbumListBeanFromJson(Map<String, dynamic> json) =>
    AlbumListBean(
      (json['songs'] as List<dynamic>)
          .map((e) => Songs.fromJson(e as Map<String, dynamic>))
          .toList(),
      Album.fromJson(json['album'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AlbumListBeanToJson(AlbumListBean instance) =>
    <String, dynamic>{
      'songs': instance.songs,
      'album': instance.album,
    };

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
    json['picUrl'] == null ? "" : json['picUrl'] as String,
    json['blurPicUrl'] as String,
    json['description'] as String,
    json['name'] as String,
    (json['id'] as num).toInt(),
    (json['size'] as num).toInt(),
    json['info'] == null
        ? Info(0, 0, 0, 0, false)
        : Info.fromJson(json['info'] as Map<String, dynamic>),
    (json['publishTime'] as num).toInt(),
    json['artists'] == null
        ? []
        : (json['artists'] as List<dynamic>)
            .map((e) => Artists.fromJson(e as Map<String, dynamic>))
            .toList(),
    json['alias'] == null ? [] : List<String>.from(json['alias']));

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'picUrl': instance.picUrl,
      'blurPicUrl': instance.blurPicUrl,
      'description': instance.description,
      'name': instance.name,
      'id': instance.id,
      'size': instance.size,
      'info': instance.info,
      'publishTime': instance.publishTime,
      'artists': instance.artists,
    };

Artists _$ArtistsFromJson(Map<String, dynamic> json) => Artists(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['followed'] == null ? false : json['followed'] as bool,
    );

Map<String, dynamic> _$ArtistsToJson(Artists instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'followed': instance.followed,
    };

Info _$InfoFromJson(Map<String, dynamic> json) => Info(
      (json['resourceType'] as num).toInt(),
      (json['commentCount'] as num).toInt(),
      (json['likedCount'] as num).toInt(),
      (json['shareCount'] as num).toInt(),
      json['liked'] as bool,
    );

Map<String, dynamic> _$InfoToJson(Info instance) => <String, dynamic>{
      'resourceType': instance.resourceType,
      'commentCount': instance.commentCount,
      'likedCount': instance.likedCount,
      'shareCount': instance.shareCount,
      'liked': instance.liked,
    };

Songs _$SongsFromJson(Map<String, dynamic> json) => Songs(
      json['ar'] == null
          ? []
          : (json['ar'] as List<dynamic>)
              .map((e) => AR.fromJson(e as Map<String, dynamic>))
              .toList(),
      json['al'] == null
          ? Al("", "")
          : Al.fromJson(json['al'] as Map<String, dynamic>),
      json['name'] as String,
      (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$SongsToJson(Songs instance) => <String, dynamic>{
      'ar': instance.ar,
      'al': instance.al,
      'name': instance.name,
      'id': instance.id,
    };

Al _$AlFromJson(Map<String, dynamic> json) => Al(
      json['name'] as String,
      json['pic_str'] as String,
    );

Map<String, dynamic> _$AlToJson(Al instance) => <String, dynamic>{
      'name': instance.name,
      'pic_str': instance.pic_str,
    };

AR _$ARFromJson(Map<String, dynamic> json) => AR(
      (json['id'] as num).toInt(),
      json['name'] as String,
    );

Map<String, dynamic> _$ARToJson(AR instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
