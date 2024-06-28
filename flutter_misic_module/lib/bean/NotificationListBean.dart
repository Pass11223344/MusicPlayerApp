

part 'NotificationListBean.g.dart';
//receiveUserId = toUser为自己
//sendUserUserId = fromUser为对方
class notificationListBean{
  int msgCount,newMsgCount,sendUserUserId,receiveUserId;
  String sendUserSendIdentityIconUrl,sendUserNickname,sendUserAvatarUrl,msg,receiveNickname,receiveAvatarUrl,lastMsgTime;


  notificationListBean(
      this.msgCount,
      this.newMsgCount,
      this.lastMsgTime,
      this.sendUserUserId,
      this.receiveUserId,
      this.sendUserSendIdentityIconUrl,
      this.sendUserNickname,
      this.sendUserAvatarUrl,
      this.msg,
      this.receiveNickname,
      this.receiveAvatarUrl);

  factory notificationListBean.fromJson(Map<String,dynamic> json)=>_$notificationListBeanFromJson(json);

Map<String,dynamic> toJson() =>_$notificationListBeanToJson(this);
}