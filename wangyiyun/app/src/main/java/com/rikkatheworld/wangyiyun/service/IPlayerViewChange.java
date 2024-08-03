package com.rikkatheworld.wangyiyun.service;
//视图更新
public interface IPlayerViewChange {


    //进度条状态
    void onSeekChange(int seek);
    void RotateView();
    void loadUrl();
    int currentIndex();
}
