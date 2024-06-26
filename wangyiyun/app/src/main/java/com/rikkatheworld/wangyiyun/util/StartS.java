package com.rikkatheworld.wangyiyun.util;

import static androidx.core.content.ContextCompat.startForegroundService;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.mIPlayerViewChange;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.service.IPlayerControl;
import com.rikkatheworld.wangyiyun.service.IPlayerViewChange;
import com.rikkatheworld.wangyiyun.service.musicService;

import android.content.ServiceConnection;

import java.util.function.Consumer;

public class StartS {
    public  IPlayerControl serviceBinder;
    public  Connection serviceConnection;
    private static  StartS startS ;
    public Intent intent;
    private Context context;

   private boolean binderFlag=false;
    private StateCallback callback;

    public StartS(){}
    private static class lazyHolder{
        private static final  StartS INSTANCE = new StartS();
    }
    public static StartS getInstance(){

        return lazyHolder.INSTANCE;
    }
    public  void startS(Context context ){
        this.context = context;
        intent = new Intent(context, musicService.class);
        if(serviceConnection==null) {
            serviceConnection = new Connection();
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent);
        } else {
            context.startService(intent);
        }
        context.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);

    }


    private class Connection implements ServiceConnection{
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.d("shengmingzhouqi","onServiceConnected.......");
            serviceBinder = (IPlayerControl) service;
            serviceBinder.registerViewControl(mIPlayerViewChange);
            binderFlag = true;
            callback.onStateUpdated(binderFlag);


        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            serviceBinder=null;
        }
    }

    public void setCallback(StateCallback callback) {
        this.callback = callback;
//        if (binderFlag){
//            this.callback.onStateUpdated(binderFlag);
//
//        }

    }
    public interface StateCallback {
        void onStateUpdated(boolean newState);
    }


}
