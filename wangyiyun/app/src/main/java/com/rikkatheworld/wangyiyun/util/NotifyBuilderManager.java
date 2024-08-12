package com.rikkatheworld.wangyiyun.util;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.transition.Transition;
import com.rikkatheworld.wangyiyun.R;


/**
 * 音频播放通知栏管理
 */
public class NotifyBuilderManager {

    private final String TAG = getClass().getSimpleName();
    public static final String ACTION_NEXT = "com.idujing.play.notify.next";// 下一首
    public static final String ACTION_PREV = "com.idujing.play.notify.prev";// 上一首
    public static final String ACTION_PLAY_PAUSE = "com.idujing.play.notify.play_state";// 播放暂停广播
    private static final int NOTIFICATION_ID = 0x123;
    private Service mContext;
    private Notification mNotification;
    private NotificationManager mNotificationManager;
    private NotificationCompat.Builder mNotificationBuilder;
    private MediaSessionManager mSessionManager;
    private PendingIntent mPendingPlay;
    private PendingIntent mPendingPre;
    private PendingIntent mPendingNext;
    private boolean isRunningForeground = false;

    public boolean isRunningForeground() {
        return isRunningForeground;
    }

    public NotifyBuilderManager(Service context) {
        this.mContext = context;
        mSessionManager = new MediaSessionManager(context);
    }

    /**
     * 初始化通知栏
     */
    private void initNotify() {
        mNotificationManager = (NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE);
        Class<?> clazz = null;
        try {
            clazz = Class.forName("com.rikkatheworld.wangyiyun.service.IBinders");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        // 适配12.0及以上
        int flag;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            flag = PendingIntent.FLAG_IMMUTABLE;
        } else {
            flag = PendingIntent.FLAG_UPDATE_CURRENT;
        }
        //绑定事件通过创建的具体广播去接收即可。
        Intent infoIntent = new Intent(mContext, clazz);
        PendingIntent pendingInfo = PendingIntent.getActivity(mContext, 0, infoIntent, flag);
        Intent preIntent = new Intent();
        preIntent.setAction(ACTION_PREV);
        mPendingPre = PendingIntent.getBroadcast(mContext, 1, preIntent, flag);
        Intent playIntent = new Intent();
        playIntent.setAction(ACTION_PLAY_PAUSE);
        mPendingPlay = PendingIntent.getBroadcast(mContext, 2, playIntent, flag);
        Intent nextIntent = new Intent();
        nextIntent.setAction(ACTION_NEXT);
        mPendingNext = PendingIntent.getBroadcast(mContext, 3, nextIntent, PendingIntent.FLAG_IMMUTABLE);


        androidx.media.app.NotificationCompat.MediaStyle style = new androidx.media.app.NotificationCompat.MediaStyle()
                .setShowActionsInCompactView(0, 1, 2)
                .setMediaSession(mSessionManager.getMediaSession());
        mNotificationBuilder = new NotificationCompat.Builder(mContext, initChannelId())
                .setSmallIcon(R.drawable.zhou)
                .setPriority(NotificationCompat.PRIORITY_MAX)
                .setContentIntent(pendingInfo)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)

                .setStyle(style);
        isRunningForeground = true;
    }

    /**
     * 创建Notification ChannelID
     *
     * @return 频道id
     */
    private String initChannelId() {
        // 通知渠道的id
        String id = "music_01";
        // 用户可以看到的通知渠道的名字.
        CharSequence name = mContext.getString(R.string.app_name);
        // 用户可以看到的通知渠道的描述
        String description = "通知栏播放控制";
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            int importance = NotificationManager.IMPORTANCE_LOW;
            NotificationChannel channel = new NotificationChannel(id, name, importance);
            channel.setDescription(description);
            channel.enableLights(false);
            channel.enableVibration(false);
            mNotificationManager.createNotificationChannel(channel);
        }
        return id;
    }

    /**
     * 取消通知
     */
    public void cancelNotification() {
        if (mNotificationManager != null) {
            mSessionManager.release();
            mContext.stopForeground(true);
            mNotificationManager.cancel(NOTIFICATION_ID);
            isRunningForeground = false;
        }
    }

    /**
     * 设置通知栏大图片
     */
    private void updateCoverSmall(String url) {

        Glide.with(mContext).asBitmap()
                .load(url)
                .into(new CustomTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                        mNotificationBuilder.setLargeIcon(resource);
                        mNotification = mNotificationBuilder.build();
                        mNotificationManager.notify(NOTIFICATION_ID, mNotification);
                    }

                    @Override
                    public void onLoadCleared(@Nullable Drawable placeholder) {

                    }
                });
    }

    /**
     * 更新状态栏通知
     */
    @SuppressLint("RestrictedApi")
    public void createDateNotification(String url,String name,String artist,long duration) {
        if (mNotification == null) {
            initNotify();
        }
        mSessionManager.createMetaData(url,name,artist,duration);
        if (mNotificationBuilder != null) {
//            int playButtonResId = isMusicPlaying
//                    ? android.R.drawable.ic_media_pause : android.R.drawable.ic_media_play;
//            if (!mNotificationBuilder.mActions.isEmpty()) {
//                mNotificationBuilder.mActions.clear();
//            }
//            mNotificationBuilder
//                    .addAction(android.R.drawable.ic_media_previous, "Previous", mPendingPre) // #0
//                    .addAction(playButtonResId, "Pause", mPendingPlay)  // #1
//                    .addAction(android.R.drawable.ic_media_next, "Next", mPendingNext);
//            mNotificationBuilder.setContentTitle("主标题");
//            mNotificationBuilder.setContentText("副标题");
            updateCoverSmall(url);
            mNotification = mNotificationBuilder.build();
            mContext.startForeground(NOTIFICATION_ID, mNotification);
            mNotificationManager.notify(NOTIFICATION_ID, mNotification);
        }
    }
    @SuppressLint("RestrictedApi")
    public void updateNotification(boolean isPlay,long position) {

        mSessionManager.upDataMetaData(isPlay,position);
        if (mNotificationBuilder != null) {
            mNotification = mNotificationBuilder.


                    build();
            mContext.startForeground(NOTIFICATION_ID, mNotification);
            mNotificationManager.notify(NOTIFICATION_ID, mNotification);
        }
    }
}

