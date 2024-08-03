
import 'package:flutter_misic_module/bean/UserInfoBean.dart';


part 'SongSheetList.g.dart';

class SongSheetList{
   UserInfoBean creator;
   int trackCount,playCount,id,userId,shareCount,commentCount,subscribedCount,cloudTrackCount;
   String coverImgUrl,name,description,updateFrequency,backgroundCoverUrl,detailPageTitle;
   List<UserInfoBean> sharedUsers;
   bool subscribed;


   SongSheetList(
      this.creator,
      this.trackCount,
      this.playCount,
      this.id,
      this.userId,
      this.shareCount,
      this.commentCount,
      this.subscribedCount,
      this.cloudTrackCount,
      this.coverImgUrl,
      this.name,
      this.description,
      this.updateFrequency,
      this.backgroundCoverUrl,
      this.detailPageTitle,
      this.sharedUsers,
       this.subscribed);

  factory SongSheetList.fromJson(Map<String,dynamic> json) => _$SongSheetListFromJson(json);
Map<String,dynamic> toJson() => _$SongSheetListToJson(this);
}

class SharedUsers {
   int userId;

   SharedUsers(this.userId);

   factory SharedUsers.fromJson(Map<String ,dynamic> json)=>_$SharedUsersFromJson(json);
   Map<String,dynamic>toJson(SharedUsers s)=>_$SharedUsersToJson(this);
}