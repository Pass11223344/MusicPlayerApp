
part 'CommentInfoBean.g.dart';



class CommentInfoBean{
  List<Comments> comments;
  int totalCount,sortType;
  String cursor;
  CommentInfoBean(this.comments, this.totalCount, this.sortType, this.cursor);
  factory CommentInfoBean.fromJson(Map<String,dynamic> json) => _$CommentInfoBeanFromJson(json);
  Map<String,dynamic> toJson() =>_$CommentInfoBeanToJson(this);
}

class Comments {
  User user;
  List<BeReplied> beReplied;
  int commentId,likedCount,replyCount,parentCommentId;
  String timeStr,content;
  bool liked;
  IpLocation ipLocation;

  Comments(
      this.user,
      this.beReplied,
      this.commentId,
      this.likedCount,
      this.replyCount,
      this.parentCommentId,
      this.timeStr,
      this.content,
      this.liked,
      this.ipLocation);

  factory Comments.fromJson(Map<String,dynamic> json)=>_$CommentsFromJson(json);
  Map<String,dynamic> toJson() => _$CommentsToJson(this);
}

class BeReplied {
User user;
String content;
int beRepliedCommentId;

BeReplied(this.user, this.content, this.beRepliedCommentId);
factory BeReplied.fromJson(Map<String,dynamic> json) => _$BeRepliedFromJson(json);
Map<String,dynamic> toJson() => _$BeRepliedToJson(this);
}

class IpLocation {
  String location;
  IpLocation(this.location);
  factory IpLocation.fromJson(Map<String,dynamic> json) => _$IpLocationFromJson(json);
  Map<String,dynamic> toJson() => _$IpLocationToJson(this);
}

class User {
  bool followed;
  int userId;
  String avatarUrl,nickname;
  User(this.followed, this.userId, this.avatarUrl, this.nickname);
  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String,dynamic> toJson() => _$UserToJson(this);
}