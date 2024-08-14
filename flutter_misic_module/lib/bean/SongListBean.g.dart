// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SongListBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SongListBean _$SongListBeanFromJson(Map<String, dynamic> json) {
  var data = json;
  if (json['simpleSong'] != null) {
    data = json['simpleSong'];
  }
  var bean = SongListBean(
    data['name'] == null ? "" : data['name'] as String,
    data['id'] == null ? 0 : (data['id'] as num).toInt(),
    data['ar'] == null
        ? []
        : (data['ar'] as List<dynamic>)
            .map((e) => Ar.fromJson(e as Map<String, dynamic>))
            .toList(),
    data['al'] == null
        ? Al("", "")
        : Al.fromJson(data['al'] as Map<String, dynamic>),
    (data['songCount']) == null ? 0 : (data['songCount'] as num).toInt(),
  );
  bean.singerName = json['artist'] == null ? "" : json['artist'];
  return bean;
}

Map<String, dynamic> _$SongListBeanToJson(SongListBean instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'ar': instance.ar,
      'al': instance.al,
    };

Al _$AlFromJson(Map<String, dynamic> json) => Al(
      json['name'] == null ? "" : json['name'] as String,
      json['picUrl'] as String,
    );

Map<String, dynamic> _$AlToJson(Al instance) => <String, dynamic>{
      'name': instance.name,
      'picUrl': instance.picUrl,
    };

Ar _$ArFromJson(Map<String, dynamic> json) => Ar(
      (json['id'] as num).toInt(),
      json['name'] == null ? "" : json['name'] as String,
    );

Map<String, dynamic> _$ArToJson(Ar instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
