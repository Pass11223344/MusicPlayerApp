package com.rikkatheworld.wangyiyun.util;


import static android.support.v4.media.session.MediaSessionCompat.FLAG_HANDLES_MEDIA_BUTTONS;
import static android.support.v4.media.session.MediaSessionCompat.FLAG_HANDLES_TRANSPORT_CONTROLS;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.support.v4.media.MediaMetadataCompat;
import android.support.v4.media.session.MediaSessionCompat;
import android.support.v4.media.session.PlaybackStateCompat;
import android.util.Log;

import androidx.annotation.NonNull;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.transition.Transition;
import com.rikkatheworld.wangyiyun.activity.MainActivity;

import org.jetbrains.annotations.Nullable;

import java.util.logging.Handler;

/**
 * 主要管理Android 5.0以后线控和蓝牙远程控制播放
 */
public class MediaSessionManager {
    private static final String TAG = "MediaSessionManager";


    //指定可以接收的来自锁屏页面的按键信息
    private static final long MEDIA_SESSION_ACTIONS =
            PlaybackStateCompat.ACTION_PLAY
                    | PlaybackStateCompat.ACTION_PAUSE
                    | PlaybackStateCompat.ACTION_PLAY_PAUSE
                    | PlaybackStateCompat.ACTION_SKIP_TO_NEXT
                    | PlaybackStateCompat.ACTION_SKIP_TO_PREVIOUS
                    | PlaybackStateCompat.ACTION_STOP
                    | PlaybackStateCompat.ACTION_SEEK_TO;
    private final Context mContext;
    private MediaSessionCompat mMediaSession;
    private Handler mHandler;


    public MediaSessionManager(Context context) {
        this.mContext = context;

        setupMediaSession();
    }

    /**
     * 是否在播放
     *
     * @return
     */

    /**
     * 初始化并激活 MediaSession
     */
    private void setupMediaSession() {
        mMediaSession = new MediaSessionCompat(mContext, TAG);
        //指明支持的按键信息类型
        mMediaSession.setFlags(
                FLAG_HANDLES_MEDIA_BUTTONS |
                        FLAG_HANDLES_TRANSPORT_CONTROLS
        );
        mMediaSession.setCallback(MainActivity.callback.callback());
        mMediaSession.setActive(true);
    }




    /**
     * 更新正在播放的音乐信息，切换歌曲时调用
     */
    public void upDataMetaData(boolean isPlay,long position){


        int state = isPlay ? PlaybackStateCompat.STATE_PLAYING :
                PlaybackStateCompat.STATE_PAUSED;
        mMediaSession.setPlaybackState(new PlaybackStateCompat.Builder()
                .setActions(MEDIA_SESSION_ACTIONS)
                .setState(state, position, 1)
                .build());
    }
    public void createMetaData(String url,String name,String artist,long duration) {
        MediaMetadataCompat.Builder metaDta = new MediaMetadataCompat.Builder()
                .putString(MediaMetadataCompat.METADATA_KEY_TITLE, name)
                .putString(MediaMetadataCompat.METADATA_KEY_ARTIST, artist)
                .putLong(MediaMetadataCompat.METADATA_KEY_DURATION, duration); // 总时长（毫秒）;
        mMediaSession.setMetadata(metaDta.build());

//        int state = isPlaying() ? PlaybackStateCompat.STATE_PLAYING :
//                PlaybackStateCompat.STATE_PAUSED;
        mMediaSession.setPlaybackState(new PlaybackStateCompat.Builder()
                .setActions(MEDIA_SESSION_ACTIONS)
                .setState(PlaybackStateCompat.STATE_PLAYING, 0, 1)
                .build());
        //锁屏页封面设置，高本版没有效果，因为通知栏权限调整。
        Glide.with(mContext).asBitmap().
                load(url)
                .into(new CustomTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                        metaDta.putBitmap(MediaMetadataCompat.METADATA_KEY_ALBUM_ART, resource);
                        mMediaSession.setMetadata(metaDta.build());
                    }

                    @Override
                    public void onLoadCleared(@Nullable Drawable placeholder) {

                    }
                });


    }

    public MediaSessionCompat.Token getMediaSession() {
        return mMediaSession.getSessionToken();
    }

    /**
     * 释放MediaSession，退出播放器时调用
     */
    public void release() {
        mMediaSession.setCallback(null);
        mMediaSession.setActive(false);
        mMediaSession.release();
    }


    /**
     * API 21 以上 耳机多媒体按钮监听 MediaSessionCompat.Callback
     *
     */



}

