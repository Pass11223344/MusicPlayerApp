package com.rikkatheworld.wangyiyun;


import androidx.databinding.BaseObservable;
import androidx.databinding.Bindable;

import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.My.UserInfoBean;

import java.util.List;

public class PlayerInfo extends BaseObservable {
    @Bindable
    private long SongId = 1;
    @Bindable
    private List<Long> singerId;
    @Bindable
    private String SongName;
    @Bindable
    private String Title;
    @Bindable
    private int currentIndex;
    @Bindable
    private boolean playOrPause = false;
    @Bindable
    private String duration;
    @Bindable
    private long durationNum;
    @Bindable
    private String currentPosition;


    @Bindable
    private String SingerName;
    @Bindable
    private String ImgUrl;
    @Bindable
    private List<ListBean> listBeans;
    @Bindable
    private String seekTime;
    @Bindable
    private UserInfoBean userInfoBean;

    public UserInfoBean getUserInfoBean() {
        return userInfoBean;
    }

    public void setUserInfoBean(UserInfoBean userInfoBean) {
        this.userInfoBean = userInfoBean;
        notifyPropertyChanged(BR.userInfoBean);
    }

    public String getSongName() {
        return SongName;
    }

    public void setSongName(String songName) {
        SongName = songName;
        notifyPropertyChanged(BR.SongName);
    }

    public String getSingerName() {
        return SingerName;
    }

    public void setSingerName(String singerName) {
        SingerName = singerName;
        notifyPropertyChanged(BR.SingerName);
    }

    public String getImgUrl() {
        return ImgUrl;
    }

    public void setImgUrl(String imgUrl) {
        ImgUrl = imgUrl;
        notifyPropertyChanged(BR.ImgUrl);
    }

    public long getSongId() {
        return SongId;
    }

    public void setSongId(long songId) {
        SongId = songId;
        notifyPropertyChanged(BR.SongId);
    }

    public List<Long> getSingerId() {
        return singerId;
    }

    public void setSingerId(List<Long> singerId) {
        this.singerId = singerId;
        notifyPropertyChanged(BR.singerId);
    }

    public String getTitle() {
        return Title;
    }

    public void setTitle(String title) {
        Title = title;
        notifyPropertyChanged(BR.Title);
    }

    public boolean isPlayOrPause() {
        return playOrPause;
    }

    public void setPlayOrPause(boolean playOrPause) {
        this.playOrPause = playOrPause;
        notifyPropertyChanged(BR.playOrPause);
    }

    public int getCurrentIndex() {
        return currentIndex;
    }

    public void setCurrentIndex(int currentIndex) {
        this.currentIndex = currentIndex;
        notifyPropertyChanged(BR.currentIndex);
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
        notifyPropertyChanged(BR.duration);
    }
    public void setDurationNum(long duration) {
        this.durationNum = duration;
        notifyPropertyChanged(BR.durationNum);
    }
    public long getDurationNum(){return durationNum;}
    public String getCurrentPosition() {
        return currentPosition;

    }

    public void setCurrentPosition(String currentPosition) {
        this.currentPosition = currentPosition;
        notifyPropertyChanged(BR.currentPosition);
    }

    public List<ListBean> getListBeans() {
        return listBeans;
    }

    public void setListBeans(List<ListBean> listBeans) {
        this.listBeans = listBeans;
        notifyPropertyChanged(BR.listBeans);
    }
public void addListBeans(List<ListBean> listBeans){
        this.listBeans.addAll(listBeans);
    notifyPropertyChanged(BR.listBeans);
}
    public String getSeekTime() {
        return seekTime;
    }

    public void setSeekTime(String seekTime) {
        this.seekTime = seekTime;
        notifyPropertyChanged(BR.seekTime);
    }
}
