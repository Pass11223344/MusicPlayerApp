package com.rikkatheworld.wangyiyun;

import android.app.Application;

import com.google.gson.Gson;
import com.rikkatheworld.wangyiyun.activity.TouchType;

import io.flutter.embedding.engine.FlutterEngineGroup;

public class App extends Application {

    public FlutterEngineGroup engines;
    public Gson gson;
    public String HomeData;
    public TouchType touchType = TouchType.DEFAULT;
    public   int page = 0;
    public String Cookie;

    @Override
    public void onCreate() {
        super.onCreate();
         gson = new Gson();
        engines = new  FlutterEngineGroup(this);

    }
}
