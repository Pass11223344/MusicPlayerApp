package com.rikkatheworld.wangyiyun.util;


import android.app.Activity;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.bean.Msg.NotificationListBean;

import org.json.JSONException;
import org.json.JSONObject;


import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

public class MsgGsonUtil {
private static MsgGsonUtil msgGsonUtil;
public static MsgGsonUtil getInstance(){
    if (msgGsonUtil==null) {
        msgGsonUtil= new MsgGsonUtil();
    }
    return msgGsonUtil;
}
    public static List press(String str,String code, Activity activity){
        App app = (App)activity.getApplication();
        Gson gson = app.gson;
            switch (code){
                case "NotificationInfo":

                    try {
                        JSONObject jsonObject = new JSONObject(str);
                        String msgs = String.valueOf(jsonObject.get("msgs")) ;
                        Type msgtype = new TypeToken<List<NotificationListBean.Datas>>() {
                        }.getType();
                       List<NotificationListBean.Datas> Datalist = gson.fromJson(msgs,msgtype);
                       List<NotificationListBean> list = new ArrayList<>();

                        for (NotificationListBean.Datas datas : Datalist) {
                            NotificationListBean bean = new NotificationListBean();
                            String lastMsg = datas.lastMsg;
                            JSONObject jsonObject1 = new JSONObject(lastMsg);
                            String msg = String.valueOf(jsonObject1.get("msg"));
                            bean.setMsg(msg);
                            bean.setLastMsgTime(datas.lastMsgTime);
                            bean.setMsgCount(datas.user.msgCount);
                            bean.setNewMsgCount(datas.newMsgCount);
                            bean.setReceiveNickname(datas.toUser.nickname);
                            bean.setReceiveAvatarUrl(datas.toUser.avatarUrl);
                            bean.setReceiveUserId(datas.toUser.userId);
                            bean.setSendUserNickname(datas.fromUser.nickname);
                            bean.setSendUserAvatarUrl(datas.fromUser.avatarUrl);
                            bean.setSendUserUserId(datas.fromUser.userId);
                            bean.setSendUserSendIdentityIconUrl(datas.fromUser.avatarDetail.identityIconUrl);
                            list.add(bean);

                        }
                        return  list;
                    } catch (JSONException e) {
                        throw new RuntimeException(e);
                    }
            }
        return null;
    }
}
