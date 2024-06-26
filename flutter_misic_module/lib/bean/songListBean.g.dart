// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songListBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

songListBean _$songListBeanFromJson(Map<String, dynamic> json) => songListBean(
      json['name'] as String,
      (json['id'] as num).toInt(),
      (json['ar'] as List<dynamic>)
          .map((e) => Ar.fromJson(e as Map<String, dynamic>))
          .toList(),
      Al.fromJson(json['al'] as Map<String, dynamic>),
  (json['songCount'] ) == null ?0:(json['songCount'] as num).toInt(),
    );

Map<String, dynamic> _$songListBeanToJson(songListBean instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'ar': instance.ar,
      'al': instance.al,
    };

Al _$AlFromJson(Map<String, dynamic> json) => Al(
  json['name']==null?"": json['name'] as String,
      json['picUrl'] as String,
    );

Map<String, dynamic> _$AlToJson(Al instance) => <String, dynamic>{
      'name': instance.name,
      'picUrl': instance.picUrl,
    };

Ar _$ArFromJson(Map<String, dynamic> json) => Ar(
      (json['id'] as num).toInt(),
  json['name']==null?"":  json['name'] as String,
    );

Map<String, dynamic> _$ArToJson(Ar instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
