package com.rikkatheworld.wangyiyun.service;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import com.rikkatheworld.wangyiyun.R;

import java.io.IOException;

public class musicService extends Service {


    private IBinders iBinders;

    public musicService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        return   iBinders;
    }
    @Override
    public void onRebind(Intent intent) {
        super.onRebind(intent);

    }
    @Override
    public void onCreate() {
        super.onCreate();

        if (iBinders==null){
            iBinders = new IBinders(this);
        }





    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
//        Intent intent1 = new Intent(this, musicService.class);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            startForegroundService();
//        }
        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(getApplicationContext()).setAutoCancel(true);// 点击后让通知将消失
        mBuilder.setContentText("测试");
        mBuilder.setContentTitle("测试");
        mBuilder.setSmallIcon(R.mipmap.app_icon);
        mBuilder.setWhen(System.currentTimeMillis());//通知产生的时间，会在通知信息里显示
        mBuilder.setPriority(Notification.PRIORITY_DEFAULT);//设置该通知优先级
        mBuilder.setOngoing(false);//ture，设置他为一个正在进行的通知。他们通常是用来表示一个后台任务,用户积极参与(如播放音乐)或以某种方式正在等待,因此占用设备(如一个文件下载,同步操作,主动网络连接)
        mBuilder.setDefaults(Notification.DEFAULT_ALL);//向通知添加声音、闪灯和振动效果的最简单、最一致的方式是使用当前的用户默认设置，使用defaults属性，可以组合：

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager manager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            String channelId = "channelId" + System.currentTimeMillis();
            NotificationChannel channel = new NotificationChannel(channelId, getResources().getString(R.string.app_name), NotificationManager.IMPORTANCE_HIGH);
            manager.createNotificationChannel(channel);
            mBuilder.setChannelId(channelId);
        }
        mBuilder.setContentIntent(null);
        startForeground(222, mBuilder.build());
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//            startForeground(222, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK);
//        }
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE);
        }
        stopForeground(true);
    }


}