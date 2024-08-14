part 'NotificationListBean.g.dart';

//receiveUserId = toUser为自己
//sendUserUserId = fromUser为对方
class NotificationListBean {
  int msgCount, newMsgCount, sendUserUserId, receiveUserId;
  String sendUserSendIdentityIconUrl,
      sendUserNickname,
      sendUserAvatarUrl,
      msg,
      receiveNickname,
      receiveAvatarUrl,
      lastMsgTime;

  NotificationListBean(
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

  factory NotificationListBean.fromJson(Map<String, dynamic> json) =>
      _$NotificationListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationListBeanToJson(this);
}
