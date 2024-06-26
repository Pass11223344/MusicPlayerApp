package com.rikkatheworld.wangyiyun.bean;

import com.google.gson.annotations.SerializedName;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;

import java.util.List;

public class ListBean {
  private  String imgUrl,songName;
  private long songId;
 private List<UserSongListBean.Ar> singerInfo;
  private String subTitle;


  public String getSubTitle() {
    return subTitle;
  }

  public void setSubTitle(String subTitle) {
    this.subTitle = subTitle;
  }

  public String getImgUrl() {
    return imgUrl;
  }

  public void setImgUrl(String imgUrl) {
    this.imgUrl = imgUrl;
  }

  public String getSongName() {
    return songName;
  }

  public void setSongName(String songName) {
    this.songName = songName;
  }

  public long getSongId() {
    return songId;
  }

  public void setSongId(long songId) {
    this.songId = songId;
  }

    public List<UserSongListBean.Ar> getSingerInfo() {
        return singerInfo;
    }

    public void setSingerInfo(List<UserSongListBean.Ar> singerInfo) {
        this.singerInfo = singerInfo;
    }




}
