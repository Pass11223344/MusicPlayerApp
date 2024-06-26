package com.rikkatheworld.wangyiyun.bean.Home;

import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;

import java.util.List;

public class SinglesAndAlbumsBean {
    private String action;
    private List<SinglesAndAlbumsBean.Artists> singerInfo;
    private String picUrl;
    private String title;
    private String transName;
    private String resourceType;
    private String resourceId;
    public SinglesAndAlbumsBean() {

    }

    public SinglesAndAlbumsBean(String action, List<SinglesAndAlbumsBean.Artists> singerInfo, String picUrl, String title, String transName, String resourceType, String resourceId, String creativeType) {
        this.action = action;
        this.singerInfo = singerInfo;
        this.picUrl = picUrl;
        this.title = title;
        this.transName = transName;
        this.resourceType = resourceType;
        this.resourceId = resourceId;
        this.creativeType = creativeType;
    }

    public String getResourceType() {
        return resourceType;
    }

    public void setResourceType(String resourceType) {
        this.resourceType = resourceType;
    }

    public String getResourceId() {
        return resourceId;
    }

    public void setResourceId(String resourceId) {
        this.resourceId = resourceId;
    }

    public String getCreativeType() {
        return creativeType;
    }

    public void setCreativeType(String creativeType) {
        this.creativeType = creativeType;
    }

    private String creativeType;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public List<Artists> getSingerInfo() {
        return singerInfo;
    }

    public void setSingerInfo(List<Artists> singerInfo) {
        this.singerInfo = singerInfo;
    }

    public String getPicUrl() {
        return picUrl;
    }

    public void setPicUrl(String picUrl) {
        this.picUrl = picUrl;
    }



    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getTransName() {
        return transName;
    }

    public void setTransName(String transName) {
        this.transName = transName;
    }


    public class Data {
        public String creativeType;
        public List<Resources> resources;
    }

    public class Resources {
        public UiElement uiElement;
        public ResourceExtInfo resourceExtInfo;
        public String action;
        public String resourceType;
      public String  resourceId;
    }

    public class ResourceExtInfo {
        public List<Artists> artists;

    }


    public class Artists {
        public String name;
        public long id;
    }


    public class UiElement {
        public MainTitle mainTitle;
        public SubTitle subTitle;
        public Image image;
    }

    public class MainTitle {
        public String title;
    }

    public class SubTitle {
        public String title;
    }

    public class Image {
        public String imageUrl;
    }
}
