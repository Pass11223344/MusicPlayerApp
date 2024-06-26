package com.rikkatheworld.wangyiyun.util;

import android.app.Activity;
import android.util.Log;

import com.google.gson.Gson;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.bean.My.UserInfoBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSheetBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;

import java.util.ArrayList;
import java.util.List;

public class MyGsonUtil {
    private static MyGsonUtil myGsonUtil ;
    public static MyGsonUtil getInstance(){
        if (myGsonUtil==null) {
            myGsonUtil = new MyGsonUtil();
        }
        return myGsonUtil;
    }
    public <T> List<? extends Object> press(String str, String code, Activity activity){
        App app = (App)activity.getApplication();

        Gson gson = app.gson;
        switch (code){
            case "userInfo":
                if (!str.equals("")) {
                    UserInfoBean userInfoBean = gson.fromJson(str, UserInfoBean.class);
                    List<UserInfoBean> list = new ArrayList<>();
                    list.add(userInfoBean);
                    return  list;
                }
                break;
            case "sheetList":
                if (!str.equals("")) {
                    Log.d("TAG-------->", "press: "+str);
                    UserSheetBean.Datas[] datas = gson.fromJson(str, UserSheetBean.Datas[].class);
                    List<UserSheetBean> list = new ArrayList<>();
                    for (UserSheetBean.Datas data : datas) {
                        UserSheetBean bean = new UserSheetBean();
                        bean.setCreatorAvatarUrl(data.creator.avatarUrl);
                        bean.setCreatorId(data.creator.userId);
                        bean.setNickname(data.creator.nickname);
                        bean.setName(data.name);
                        bean.setSheetId(data.id);
                        bean.setCoverImgUrl(data.coverImgUrl);
                        bean.setTrackCount(data.trackCount);
                        list.add(bean);
                    }

                    return list;
                }
                break;
            case "getSongList":
                if (!str.equals("")) {
                    UserSongListBean.Data[] data = gson.fromJson(str, UserSongListBean.Data[].class);
                    List<UserSongListBean> list = new ArrayList<>();
                    for (UserSongListBean.Data datum : data) {
                        UserSongListBean listBean = new UserSongListBean();
                        listBean.setImgUrl(datum.al.picUrl);
                        listBean.setSingerInfo(datum.ar);
                        if (datum.originSongSimpleData!=null) {
                            listBean.setOriginSongSinger(datum.originSongSimpleData.artists);
                        }
                      //  Log.d("getSongList", "press: "+(datum.tns.length));
                        if (datum.tns!=null&&!datum.tns[0].equals("")) {
                            listBean.setTns(datum.tns[0]);
                        }

                        listBean.setSongName(datum.name);
                        listBean.setSongId(datum.id);
                        list.add(listBean);

                    }
                    return list;
                }


        }
        return null;
    }
}
