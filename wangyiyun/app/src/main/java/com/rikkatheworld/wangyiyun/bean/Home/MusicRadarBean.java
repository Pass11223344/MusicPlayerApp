package com.rikkatheworld.wangyiyun.bean.Home;

import java.util.List;

public class MusicRadarBean {
    String SongSheetTitle,RadarType,imageUrl,creativeId,radarTitle;
    int playCount;



    public MusicRadarBean(String songSheetTitle, String imageUrl, String creativeId, int playCount,String radarTitle) {
        this.SongSheetTitle = songSheetTitle;

        this.imageUrl = imageUrl;
        this.creativeId = creativeId;
        this.playCount = playCount;
        this.radarTitle = radarTitle;

    }
    public String getRadarTitle() {
        return radarTitle;
    }

    public void setRadarTitle(String radarTitle) {
        this.radarTitle = radarTitle;
    }
    public String getSongSheetTitle() {
        return SongSheetTitle;
    }

    public void setSongSheetTitle(String songSheetTitle) {
        SongSheetTitle = songSheetTitle;
    }

    public String getRadarType() {
        return RadarType;
    }

    public void setRadarType(String radarType) {
        RadarType = radarType;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCreativeId() {
        return creativeId;
    }

    public void setCreativeId(String creativeId) {
        this.creativeId = creativeId;
    }

    public int getPlayCount() {
        return playCount;
    }

    public void setPlayCount(int playCount) {
        this.playCount = playCount;
    }

    public class Res{
        public UiElement uiElement;
        public List<Creatives> creatives;
    }

    public class UiElement {
        public SubTitle subTitle;
    }

    public class SubTitle {
        public String title;
    }

    public class Creatives {
        public String creativeId;
        public List<Resources> resources;
    }

    public class Resources {
        public Resources.UiElement uiElement;
        public Resources.ResourceExtInfo resourceExtInfo;

        public class UiElement {
            public  MainTitle mainTitle;
            public Image image;
            public class MainTitle {
                public String title;
            }
            public class Image {
                public String imageUrl;
            }
        }


        public class ResourceExtInfo {
           public int playCount;
        }
    }
}
