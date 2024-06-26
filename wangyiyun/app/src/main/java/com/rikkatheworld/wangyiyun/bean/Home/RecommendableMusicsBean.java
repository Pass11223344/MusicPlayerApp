package com.rikkatheworld.wangyiyun.bean.Home;

import java.util.List;

public class RecommendableMusicsBean {
    String songTitle,subTitle,imageUrl;
    List<Artists> artists;

    String ModuleTitle;
    long SongId;
    public String getModuleTitle() {
        return ModuleTitle;
    }

    public void setModuleTitle(String moduleTitle) {
        ModuleTitle = moduleTitle;
    }



    public RecommendableMusicsBean( String songTitle, String subTitle, String imageUrl, List<Artists>artists, long songId) {

        this.songTitle = songTitle;
        this.subTitle = subTitle;
        this.imageUrl = imageUrl;
        this.artists = artists;
        this.SongId = songId;

    }

    public RecommendableMusicsBean() {

    }

    public List<Artists> getArtists() {
        return artists;
    }

    public void setArtists(List<Artists> artists) {
        this.artists = artists;
    }



    public String getSongTitle() {
        return songTitle;
    }

    public void setSongTitle(String songTitle) {
        this.songTitle = songTitle;
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


    public long getSongId() {
        return SongId;
    }

    public void setSongId(long songId) {
        SongId = songId;
    }



    public class Res{
        public List<Resources> resources;


    }
public class Resources{
    public UiElement uiElement;
    public ResourceExtInfo resourceExtInfo;
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
    public class ResourceExtInfo{
        public List<Artists> artists;
        public Song song;
    }
    public static class Artists{
        public  String name;
        public  long id;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public long getId() {
            return id;
        }

        public void setId(long id) {
            this.id = id;
        }

        public Artists(String name, long id) {
            this.name = name;
            this.id = id;
        }


    }

    public class Song {
        public  long id;
    }
}
