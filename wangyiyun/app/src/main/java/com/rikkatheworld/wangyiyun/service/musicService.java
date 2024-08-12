package com.rikkatheworld.wangyiyun.service;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ServiceInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import android.widget.RemoteViews;

import androidx.core.app.NotificationCompat;

import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.util.NotifyBuilderManager;

import java.io.IOException;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;

import androidx.core.app.NotificationCompat;

public class musicService extends Service {


    private static final String ACTION_UPDATE_PROGRESS = "PROGRESS";
    private static final String ACTION_PREVIOUS = "ACTION_PREVIOUS";
    private static final String ACTION_PLAY_PAUSE = "ACTION_PLAY_PAUSE";
    private static final String ACTION_NEXT = "ACTION_NEXT";
    private IBinders iBinders;
    public static final String CHANNEL_ID = "music_notification_channel";
    private static final String CHANNEL_NAME = "Music Notification Channel";
    private static final String CHANNEL_DESCRIPTION = "Channel for music notifications";
    public static NotifyBuilderManager notifyBuilderManager;

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


        //createNotificationChannel();
        if (iBinders==null){
            iBinders = new IBinders(this);
        }





    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {


        notifyBuilderManager = new NotifyBuilderManager(this);


        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(getApplicationContext()).setAutoCancel(true);// 点击后让通知将消失
        mBuilder.setSmallIcon(R.mipmap.app_icon);
        mBuilder.setWhen(System.currentTimeMillis());//通知产生的时间，会在通知信息里显示
        mBuilder.setPriority(Notification.PRIORITY_DEFAULT);//设置该通知优先级
        mBuilder.setOngoing(true);//ture，设置他为一个正在进行的通知。他们通常是用来表示一个后台任务,用户积极参与(如播放音乐)或以某种方式正在等待,因此占用设备(如一个文件下载,同步操作,主动网络连接)
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

        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.N) {
            stopForeground(STOP_FOREGROUND_REMOVE);
            return;
        }
        stopForeground(true);
    }
    private Notification createNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent contentIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE);

        @SuppressLint("RemoteViewLayout")
        RemoteViews contentView = new RemoteViews(getPackageName(), R.layout.notification_layout);
        contentView.setImageViewBitmap(R.id.songImageView, BitmapFactory.decodeResource(getResources(), R.drawable.zhou));
        contentView.setOnClickPendingIntent(R.id.songImageView, contentIntent);

        // 设置按钮点击事件
        Intent prevIntent = new Intent(this, musicService.class);
        prevIntent.setAction(ACTION_PREVIOUS);
        PendingIntent prevPendingIntent = PendingIntent.getService(this, 0, prevIntent, PendingIntent.FLAG_IMMUTABLE);
        contentView.setOnClickPendingIntent(R.id.prevButton, prevPendingIntent);

        Intent playPauseIntent = new Intent(this, musicService.class);
        playPauseIntent.setAction(ACTION_PLAY_PAUSE);
        PendingIntent playPausePendingIntent = PendingIntent.getService(this, 0, playPauseIntent, PendingIntent.FLAG_IMMUTABLE);
        contentView.setOnClickPendingIntent(R.id.playPauseButton, playPausePendingIntent);

        Intent nextIntent = new Intent(this, musicService.class);
        nextIntent.setAction(ACTION_NEXT);
        PendingIntent nextPendingIntent = PendingIntent.getService(this, 0, nextIntent,PendingIntent.FLAG_IMMUTABLE );
        contentView.setOnClickPendingIntent(R.id.nextButton, nextPendingIntent);

        // 设置进度条更新
        Intent updateProgressIntent = new Intent(this, musicService.class);
        updateProgressIntent.setAction(ACTION_UPDATE_PROGRESS);
        PendingIntent updateProgressPendingIntent = PendingIntent.getService(this, 0, updateProgressIntent, PendingIntent.FLAG_IMMUTABLE);
        contentView.setOnClickPendingIntent(R.id.progressBar, updateProgressPendingIntent);

        // 设置收藏按钮点击事件
//        Intent setFavoriteIntent = new Intent(this, musicService.class);
//        setFavoriteIntent.setAction(ACTION_SET_FAVORITE);
//        PendingIntent setFavoritePendingIntent = PendingIntent.getService(this, 0, setFavoriteIntent, 0);
//        contentView.setOnClickPendingIntent(R.id.favoriteButton, setFavoritePendingIntent);

        // 创建通知
        Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.msg)
                .setContentIntent(contentIntent)
                .setCustomBigContentView(contentView)
                .build();

        return notification;
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_LOW);
            channel.setDescription(CHANNEL_DESCRIPTION);
            channel.setShowBadge(true); // 是否在状态栏显示角标
            channel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC); // 是否在锁屏上显示

            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
}


