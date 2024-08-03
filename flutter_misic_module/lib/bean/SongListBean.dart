



part 'SongListBean.g.dart';

class SongListBean {
  String name;
  String? singerName;
  int id;
  List<Ar> ar;
  Al al;
  int songCount;
  SongListBean(this.name, this.id, this.ar, this.al,this.songCount);
  factory SongListBean.fromJson(Map<String,dynamic> json) => _$SongListBeanFromJson(json);
  Map<String,dynamic> toJson() => _$SongListBeanToJson(this);

}

class Al {
String name,picUrl;

Al(this.name, this.picUrl);
factory Al.fromJson(Map<String,dynamic> json) => _$AlFromJson(json);
Map<String,dynamic> toJson() =>_$AlToJson(this);

}

class Ar {
  int id;
  String name;

  Ar(this.id, this.name);

  factory Ar.fromJson(Map<String,dynamic> json) => _$ArFromJson(json);
  Map<String,dynamic> toJson() => _$ArToJson(this);
}