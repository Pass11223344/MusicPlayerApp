package com.rikkatheworld.wangyiyun.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.rikkatheworld.wangyiyun.App;

import java.util.logging.Handler;

public class LoadCompleteReceiver extends BroadcastReceiver {
    public static String ACTION_LOAD_COMPLETE = "ACTION_LOAD_COMPLETE";
    private final SplashActivity activity;

    public LoadCompleteReceiver(SplashActivity activity) {
        this.activity = activity;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(ACTION_LOAD_COMPLETE)) {

            App applicationContext = (App) activity.getApplicationContext();
            applicationContext.HomeData = intent.getStringExtra("result");
            activity.startActivity(new Intent(activity, MainActivity.class));
            activity.finish();
        }
    }
}
