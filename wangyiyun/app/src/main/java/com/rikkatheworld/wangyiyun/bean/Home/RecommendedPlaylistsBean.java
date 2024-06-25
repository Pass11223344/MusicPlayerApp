package com.rikkatheworld.wangyiyun.bean.Home;



public class RecommendedPlaylistsBean {


    private  String resourceId;
    private long playcount;



    private String title,imageUrl;

    public String getResourceId() {
        return resourceId;
    }

    public void setResourceId(String resourceId) {
        this.resourceId = resourceId;
    }


    public long getPlaycount() {
        return playcount;
    }

    public void setPlaycount(long playcount) {
        this.playcount = playcount;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public RecommendedPlaylistsBean() {
    }

    public RecommendedPlaylistsBean(long playcount, String title, String imageUrl,String resourceId) {
        this.playcount = playcount;
        this.title = title;
        this.imageUrl = imageUrl;
        this.resourceId = resourceId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }


}
