package com.rikkatheworld.wangyiyun.bean;

import java.io.Serializable;
import java.util.List;

public class MusicCacheBean implements Serializable {
    private static final long serialVersionUID = 1L;
    private int index;
    private long progress;
    private long durationNum;
    private String duration;
    private String strProgress;
    private int  playMode;
    private List<ListBean> playList;

    public MusicCacheBean(int index, long progress,String strProgress,long durationNum, String duration, int playMode, List<ListBean> playList) {
        this.index = index;
        this.progress = progress;
        this.duration = duration;
        this.playMode = playMode;
        this.playList = playList;
        this.strProgress = strProgress;
        this.durationNum = durationNum;
    }

    public long getDurationNum() {
        return durationNum;
    }

    public void setDurationNum(long durationNum) {
        this.durationNum = durationNum;
    }

    public String getStrProgress() {
        return strProgress;
    }

    public void setStrProgress(String strProgress) {
        this.strProgress = strProgress;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }

    public long getProgress() {
        return progress;
    }

    public void setProgress(long progress) {
        this.progress = progress;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getPlayMode() {
        return playMode;
    }

    public void setPlayMode(int playMode) {
        this.playMode = playMode;
    }

    public List<ListBean> getPlayList() {
        return playList;
    }

    public void setPlayList(List<ListBean> playList) {
        this.playList = playList;
    }
}

