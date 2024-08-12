





class UserInfoBean{
   String avatarUrl;
   String backgroundUrl;
   String nickname;
   int birthday;
   int province;
   int gender;
   int city;
   int followeds;
   int follows;
   int eventCount;
   int userId;
   int? level;

   UserInfoBean(
      this.avatarUrl,
      this.backgroundUrl,
      this.nickname,
      this.birthday,
      this.province,
      this.gender,
      this.city,
      this.followeds,
      this.follows,
      this.eventCount,
       this.userId);

   factory UserInfoBean.fromJson(Map<String,dynamic> json)=> _$UserInfoBeanFromJson(json);


   Map<String,dynamic> toJson(UserInfoBean u)=>
       <String,dynamic>{
          "avatarUrl":u.avatarUrl,
          "backgroundUrl":u.backgroundUrl,
          "nickname":u.nickname,
          "birthday":u.birthday,
          "province":u.province,
          "gender":u.gender,
          "city":u.city,
          "followeds":u.followeds,
          "follows":u.follows,
          "eventCount":u.eventCount,
          "userId":u.userId,
         "level":u.level
       };
   @override
   bool operator ==(Object other) {
     other as UserInfoBean;

     return identical(this, other) ||
         (other is UserInfoBean &&
             userId == other.userId &&
             runtimeType == other.runtimeType &&
             avatarUrl == other.avatarUrl &&
             backgroundUrl == other.backgroundUrl &&
             nickname == other.nickname &&
             birthday == other.birthday &&
             province == other.province &&
             gender == other.gender &&
             city == other.city &&
             followeds == other.followeds &&
             follows == other.follows &&
             eventCount == other.eventCount &&
             level == other.level
         );
   }


}

UserInfoBean  _$UserInfoBeanFromJson(Map<String,dynamic> json) {

   return UserInfoBean(
       json["avatarUrl"] ==null?"":  (json["avatarUrl"] as String),
       ( json["backgroundUrl"] )==null?"":( json["backgroundUrl"] as String),
       json["nickname"]==null?"": (json["nickname"] as String),
       json["birthday"] ==null?0:(json["birthday"] as num ).toInt(),
        json["province"] ==null?0: ( json["province"] as num ).toInt(),
        json["gender"] ==null?0: ( json["gender"] as num ).toInt(),
       json["city"] ==null?0: ( json["city"] as num ).toInt(),
       json["followeds"] ==null ? 0 :  (json["followeds"] as num ).toInt(),
       json["follows"]  ==null ?0: (json["follows"] as num ).toInt(),
       json["eventCount"]==null  ? 0 : (json["eventCount"] as num ).toInt(),
       (json["userId"] as num ).toInt());
}