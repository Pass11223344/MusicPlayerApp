class VideoInfoBean {
  String avatarUrl, text, nickname, url;
  double? videoAspectRatio;
  String id, threadId;
  int likedCount, commentCount;
  bool liked;

  VideoInfoBean(this.avatarUrl, this.text, this.nickname, this.url, this.id,
      this.threadId, this.likedCount, this.commentCount, this.liked);

  factory VideoInfoBean.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case "mv":
        List<dynamic> artistsList = json['artists'];

        return VideoInfoBean(
            artistsList[0]['img1v1Url'],
            "${json['name']}${json['desc']}",
            artistsList[0]['name'],
            "",
            json['id'].toString(),
            json['commentThreadId'],
            0,
            json['commentCount'],
            false);

      case "mlog":
        var json2 = json['resource'];
        return VideoInfoBean(
            json2['profile']['avatarUrl'],
            "${json2['content']['text']}",
            json2['profile']['nickname'],
            json2['content']['video']['urlInfo']['url'],
            json['id'],
            json2['threadId'],
            json2['likedCount'],
            json2['commentCount'],
            json2['liked']);
    }
    return VideoInfoBean("", "", "", "", "", "", 0, 0, false);
  }
}
