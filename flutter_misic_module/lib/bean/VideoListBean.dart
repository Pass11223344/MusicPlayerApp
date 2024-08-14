import 'package:flutter_misic_module/bean/UserInfoBean.dart';

import 'AlbumListBean.dart';

class VideoListBean {
  String resourceId, resourceType;
  Data data;

  VideoListBean(this.resourceId, this.resourceType, this.data);

  factory VideoListBean.fromJson(Map<String, dynamic> json) => VideoListBean(
      json['resourceId'], json['resourceType'], Data.fromJson(json['data']));

  Map<String, dynamic> toJson(VideoListBean bean) => {
        "resourceId": bean.resourceId,
        "resourceType": bean.resourceType,
        "data": bean.data,
      };
}

class Data {
  String name, coverUrl;
  int duration;
  List<Artists> artists;
  UserInfoBean? creator;

  Data(this.name, this.coverUrl, this.duration, this.artists, this.creator);

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      json['name'] == null ? json['title'] : json['name'],
      json['coverUrl'],
      json['duration'],
      json['artists'] == null
          ? []
          : (json['artists'] as List<dynamic>)
              .map((json) => Artists.fromJson(json))
              .toList(),
      json['creator'] == null ? null : UserInfoBean.fromJson(json['creator']));

  Map<String, dynamic> toJson(Data bean) => {
        "name": bean.name,
        "coverUrl": bean.coverUrl,
        "duration": bean.duration,
        "artists": bean.artists,
      };
}
