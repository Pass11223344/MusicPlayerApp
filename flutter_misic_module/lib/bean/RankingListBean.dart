

class RankingListBean{
  List<Tracks> tracks;
  String updateFrequency,coverImgUrl,name;
  int id;

  RankingListBean(
      this.tracks, this.updateFrequency, this.coverImgUrl, this.name, this.id);
  factory RankingListBean.fromJson(Map<String,dynamic> json)=>RankingListBean(
      (json['tracks']as List<dynamic>).map((v)=>Tracks.fromJson(v)).toList(),
      json['updateFrequency'],
      json['coverImgUrl'],
      json['name'],
      json['id'],
      );
Map<String,dynamic>  toJson()=>{
  "tracks":tracks,
  "updateFrequency":updateFrequency,
  "coverImgUrl":coverImgUrl,
  "name":name,
  "id":id,
};
}

class Tracks {
  String first,second;

  Tracks(this.first, this.second);
  factory Tracks.fromJson(Map<String,dynamic> json)=>Tracks(json['first'], json['second']);
  Map<String,dynamic>  toJson()=>{
    "first":first,
    "second":second,

  };
}