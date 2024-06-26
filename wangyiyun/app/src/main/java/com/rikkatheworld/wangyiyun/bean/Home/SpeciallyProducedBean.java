package com.rikkatheworld.wangyiyun.bean.Home;

import java.util.List;

public class SpeciallyProducedBean {
    String Title,subTitle,imageUrl,action;


    public SpeciallyProducedBean(String Title, String subTitle, String imageUrl, String action) {

        this.Title = Title;
        this.subTitle = subTitle;
        this.imageUrl = imageUrl;
        this.action = action;


    }





    public String getTitle() {
        return Title;
    }

    public void setTitle(String Title) {
        this.Title = Title;
    }

    public String getSubTitle() {
        return subTitle;
    }

    public void setSubTitle(String subTitle) {
        this.subTitle = subTitle;
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
       public String action;
        public UiElement uiElement;

    }



    public class UiElement {
        public MainTitle mainTitle;
        public SubTitle subTitle;
        public Image image;
    }

    public class MainTitle {
        public String title;
    }
    public class SubTitle{
        public String title;
    }

    public class Image {
        public String imageUrl;
    }


}
