package com.rikkatheworld.wangyiyun.bean.My;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class UserSongListBean {
    private  String imgUrl,songName;
    private long songId;
    private List<Ar> singerInfo;
   // private List<String> singerName;

    private String tns;
    // private List<Long>  originSongSingerId;
    private List<Data.OriginSongSimpleData.Artists> originSongSinger;

    public String getTns() {
        return tns;
    }

    public void setTns(String tns) {
        this.tns = tns;
    }


    public List<Data.OriginSongSimpleData.Artists> getOriginSongSinger() {
        return originSongSinger;
    }

    public void setOriginSongSinger(List<Data.OriginSongSimpleData.Artists> originSongSinger) {
        this.originSongSinger = originSongSinger;
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

    public List<Ar> getSingerInfo() {
        return singerInfo;
    }

    public void setSingerInfo(List<Ar> singerInfo) {
        this.singerInfo = singerInfo;
    }



    public class Data{
        public long id;
        public String name;
        @SerializedName("ar")
        public List<Ar>ar;
        @SerializedName("al")
        public Al al;
        @SerializedName("originSongSimpleData")
        public OriginSongSimpleData originSongSimpleData;
        @SerializedName("tns")
            public String[] tns;


        public class Al {
            public String picUrl;
        }

        public class OriginSongSimpleData {

            @SerializedName("artists")
            public List<Artists> artists;

            public class Artists {
                public String name;
            }
        }


    }
    public  class Ar {
        public  long id;
        public String name;

    }
}
