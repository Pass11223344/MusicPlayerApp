


part 'SongListBean.g.dart';

class songListBean {
  String name;
  int id;
  List<Ar> ar;
  Al al;
  int songCount;
  songListBean(this.name, this.id, this.ar, this.al,this.songCount);
  factory songListBean.fromJson(Map<String,dynamic> json) => _$songListBeanFromJson(json);
  Map<String,dynamic> toJson() => _$songListBeanToJson(this);

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