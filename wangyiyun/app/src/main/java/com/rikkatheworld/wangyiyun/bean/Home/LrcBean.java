package com.rikkatheworld.wangyiyun.bean.Home;

public class LrcBean {
   private String Lrc;
   private String translateLrc;
   private long start;
   private long end;
   //private String ImgUrl;

    public String getLrc() {
        return Lrc;
    }

    public void setLrc(String lrc) {
        Lrc = lrc;
    }

    public String getTranslateLrc() {
        return translateLrc;
    }

    public void setTranslateLrc(String translateLrc) {
        this.translateLrc = translateLrc;
    }

    public long getStart() {
        return start;
    }

    public void setStart(long start) {
        this.start = start;
    }

    public long getEnd() {
        return end;
    }

    public void setEnd(long end) {
        this.end = end;
    }
    public LrcBean(String lrc) {
        Lrc = lrc;


    }
    public LrcBean(String lrc, long start) {
        Lrc = lrc;
        this.start = start;

    }
}
