package com.rikkatheworld.wangyiyun.service;

public interface IPlayerControl {
    //播放
    void playOrPause(int state);

    //停止播放
    void stopPlay();
    //设置播放进度
    void seekTo(int seek);
    //将UI控制权给逻辑层
    void registerViewControl(IPlayerViewChange change);
    //
    void UnRegisterViewControl();
    void setMusicSource(String musicSource);

    long getCurrentPosition();
    boolean isPlaying();

    void seek2(int i);


}
