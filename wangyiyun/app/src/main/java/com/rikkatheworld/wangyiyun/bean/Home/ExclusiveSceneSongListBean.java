package com.rikkatheworld.wangyiyun.bean.Home;

import java.util.List;

public class ExclusiveSceneSongListBean {
    private   int playCount;
    private    String resourceId;
    String sheetTitle,imageUrl,ModuleTitle;

    public int getPlayCount() {
        return playCount;
    }

    public void setPlayCount(int playCount) {
        this.playCount = playCount;
    }

    public String getResourceId() {
        return resourceId;
    }

    public void setResourceId(String resourceId) {
        this.resourceId = resourceId;
    }

    public String getModuleTitle() {
        return ModuleTitle;
    }

    public void setModuleTitle(String moduleTitle) {
        ModuleTitle = moduleTitle;
    }

    public ExclusiveSceneSongListBean(String sheetTitle, String imageUrl, int playCount, String resourceId, String ModuleTitle) {

        this.sheetTitle = sheetTitle;

        this.imageUrl = imageUrl;

        this.playCount = playCount;
        this.resourceId = resourceId;
        this.ModuleTitle = ModuleTitle;

    }





    public String getSheetTitle() {
        return sheetTitle;
    }

    public void setSheetTitle(String sheetTitle) {
        this.sheetTitle = sheetTitle;
    }



    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }






    public class Res{
        public List<Resources> resources;


    }
    public class Resources{
        public UiElement uiElement;
        public ResourceExtInfo resourceExtInfo;
        public String resourceId;
    }



    public class UiElement {
        public MainTitle mainTitle;
      //  public RecommendableMusics_bean.SubTitle subTitle;
        public Image image;
    }

    public class MainTitle {
        public String title;
    }


    public class Image {
        public String imageUrl;
    }
    public class ResourceExtInfo{
        public int playCount;

    }



}
