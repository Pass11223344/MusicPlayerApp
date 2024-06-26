package com.rikkatheworld.wangyiyun.bean.Msg;

import com.google.gson.annotations.SerializedName;
import com.rikkatheworld.wangyiyun.util.Utils;

public class NotificationListBean {
long msgCount,newMsgCount,sendUserUserId,receiveUserId;
String sendUserSendIdentityIconUrl,sendUserNickname,sendUserAvatarUrl,lastMsgTime;
    String receiveNickname,receiveAvatarUrl;
    String msg;

    public long getMsgCount() {
        return msgCount;
    }

    public void setMsgCount(long msgCount) {
        this.msgCount = msgCount;
    }

    public long getNewMsgCount() {
        return newMsgCount;
    }

    public void setNewMsgCount(long newMsgCount) {
        this.newMsgCount = newMsgCount;
    }

    public String getLastMsgTime() {
        return lastMsgTime;
    }

    public void setLastMsgTime(long lastMsgTime) {
        this.lastMsgTime = Utils.dateFormat(lastMsgTime);
    }

    public long getSendUserUserId() {
        return sendUserUserId;
    }

    public void setSendUserUserId(long sendUserUserId) {
        this.sendUserUserId = sendUserUserId;
    }

    public long getReceiveUserId() {
        return receiveUserId;
    }

    public void setReceiveUserId(long receiveUserId) {
        this.receiveUserId = receiveUserId;
    }

    public String getSendUserSendIdentityIconUrl() {
        return sendUserSendIdentityIconUrl;
    }

    public void setSendUserSendIdentityIconUrl(String sendUserSendIdentityIconUrl) {
        this.sendUserSendIdentityIconUrl = sendUserSendIdentityIconUrl;
    }

    public String getSendUserNickname() {
        return sendUserNickname;
    }

    public void setSendUserNickname(String sendUserNickname) {
        this.sendUserNickname = sendUserNickname;
    }

    public String getSendUserAvatarUrl() {
        return sendUserAvatarUrl;
    }

    public void setSendUserAvatarUrl(String sendUserAvatarUrl) {
        this.sendUserAvatarUrl = sendUserAvatarUrl;
    }



    public String getReceiveNickname() {
        return receiveNickname;
    }

    public void setReceiveNickname(String receiveNickname) {
        this.receiveNickname = receiveNickname;
    }

    public String getReceiveAvatarUrl() {
        return receiveAvatarUrl;
    }

    public void setReceiveAvatarUrl(String receiveAvatarUrl) {
        this.receiveAvatarUrl = receiveAvatarUrl;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public  class  Datas{
       public String lastMsg;
        public long lastMsgTime;
        public long newMsgCount;
        @SerializedName("user")
        public User user;
        @SerializedName("fromUser")
        public FromUser fromUser;
        @SerializedName("toUser")
        public ToUser toUser;


        public class User {
            public long msgCount;
        }

        public class FromUser {
            public  AvatarDetail avatarDetail;
            public  String avatarUrl;
            public String nickname;
            public long userId;
            public class AvatarDetail {
               public String identityIconUrl;
            }
        }

        public   class ToUser {

            public  String avatarUrl;
            public String nickname;
            public long userId;

        }
    }
}
