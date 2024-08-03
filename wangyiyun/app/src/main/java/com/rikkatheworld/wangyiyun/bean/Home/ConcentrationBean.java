package com.rikkatheworld.wangyiyun.bean.Home;

import java.util.List;

public class ConcentrationBean {
    String creativeId,titleDesc,songName,picUrl;
    long songId;
    String ModuleTitle;
    List<Data.Creatives.Resources.ResourceExtInfo.SongData.Artists> artists;

    public ConcentrationBean(String creativeId, String titleDesc, String songName, String picUrl, long songId, List<Data.Creatives.Resources.ResourceExtInfo.SongData.Artists> artists,String ModuleTitle) {
        this.creativeId = creativeId;
        this.titleDesc = titleDesc;
        this.songName = songName;
        this.picUrl = picUrl;
        this.songId = songId;
        this.artists = artists;
        this.ModuleTitle = ModuleTitle;
    }

    public List<Data.Creatives.Resources.ResourceExtInfo.SongData.Artists> getArtists() {
        return artists;
    }

    public void setArtists(List<Data.Creatives.Resources.ResourceExtInfo.SongData.Artists> artists) {
        this.artists = artists;
    }

    public String getCreativeId() {
        return creativeId;
    }

    public void setCreativeId(String creativeId) {
        this.creativeId = creativeId;
    }

    public String getTitleDesc() {
        return titleDesc;
    }

    public String getModuleTitle() {
        return ModuleTitle;
    }

    public void setModuleTitle(String moduleTitle) {
        ModuleTitle = moduleTitle;
    }

    public void setTitleDesc(String titleDesc) {
        this.titleDesc = titleDesc;
    }

    public String getSongName() {
        return songName;
    }

    public void setSongName(String songName) {
        this.songName = songName;
    }

    public String getPicUrl() {
        return picUrl;
    }

    public void setPicUrl(String picUrl) {
        this.picUrl = picUrl;
    }

    public long getSongId() {
        return songId;
    }

    public void setSongId(long songId) {
        this.songId = songId;
    }



    public class Data{
       public List<Creatives> creatives;

        public class Creatives {
            public String creativeId;

            public List<Resources> resources;

            public class Resources{
                public ResourceExtInfo resourceExtInfo;
                public UiElement uiElement;
                public class UiElement {
                    public MainTitle mainTitle;
                    public class MainTitle{
                        public String titleDesc;
                    }
                }
                public class ResourceExtInfo{
                    public SongData  songData;
                    public class SongData{
                      public String  name;
                      public long id;
                      public List<Artists> artists;
                      public Album  album;
                      public class Artists{
                          public String  name;
                          public int id;
                      }
                      public class Album{
                        public   String name;
                        public String picUrl;
                        public String blurPicUrl;
                        public String subType;

                      }
                    }
                }
            }
        }
    }
}
