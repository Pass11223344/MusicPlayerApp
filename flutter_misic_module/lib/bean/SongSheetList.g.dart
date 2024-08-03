// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SongSheetList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongSheetList _$SongSheetListFromJson(Map<String, dynamic> json) =>
    SongSheetList(
        json['creator'] ==null?UserInfoBean("","","",0,0,0,0,0,0,0,0) : UserInfoBean.fromJson(json['creator'] as Map<String, dynamic>),
      (json['trackCount'] as num).toInt(),
      (json['playCount'] as num).toInt(),
      (json['id'] as num).toInt(),
      (json['userId'] as num).toInt(),
      json['shareCount']==null?0: (json['shareCount'] as num).toInt(),
      json['commentCount']==null?0: (json['commentCount'] as num).toInt(),
      json['subscribedCount']==null?0:  (json['subscribedCount'] as num).toInt(),
      json['cloudTrackCount']==null?0:  (json['cloudTrackCount'] as num).toInt(),
      json['coverImgUrl'] as String,
      json['name'] as String,
          json['description'] ==null ?"": json['description'] as String,
      json['updateFrequency'] == null ? "" : json['updateFrequency'] as String,
          json['backgroundCoverUrl'] == null ? "" : json['backgroundCoverUrl'] as String,
          json['detailPageTitle'] == null?"" :json['detailPageTitle'] as String,
          json['sharedUsers'] == null ? [] :(json['sharedUsers'] as List<dynamic>)
              .map((e) => UserInfoBean.fromJson(e as Map<String, dynamic>))
              .toList(),
        json['subscribed']==null?false:  json['subscribed'] as bool
    );

Map<String, dynamic> _$SongSheetListToJson(SongSheetList instance) =>
    <String, dynamic>{
      'creator': instance.creator,
      'trackCount': instance.trackCount,
      'playCount': instance.playCount,
      'id': instance.id,
      'userId': instance.userId,
      'coverImgUrl': instance.coverImgUrl,
      'name': instance.name,
      'description': instance.description,
      'updateFrequency': instance.updateFrequency,
      'backgroundCoverUrl': instance.backgroundCoverUrl,
      'detailPageTitle': instance.detailPageTitle,
      'sharedUsers': instance.sharedUsers,
    };

SharedUsers _$SharedUsersFromJson(Map<String, dynamic> json) => SharedUsers(
      (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$SharedUsersToJson(SharedUsers instance) =>
    <String, dynamic>{
      'userId': instance.userId,
    };
