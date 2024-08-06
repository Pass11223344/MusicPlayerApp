package com.rikkatheworld.wangyiyun.service;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.CURRENT_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.RANDOM_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SEQUENTIAL_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SINGLE_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SINGLE_PLAY_MODE_ONE;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.STATE_PAUSE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.STATE_PLAY;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.STATE_STOP;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.UNLIMITED_PLAYBACK_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.animationUtils;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.scrollPage;
import static com.rikkatheworld.wangyiyun.adapter.PlayerPageAdapter.playerPageAdapterAnimation;

import android.content.Context;
import android.media.AudioAttributes;
import android.media.MediaPlayer;
import android.net.wifi.WifiManager;
import android.os.Binder;
import android.os.Handler;
import android.os.PowerManager;
import android.util.Log;

import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isUpData;

public class IBinders extends Binder implements IPlayerControl, MediaPlayer.OnPreparedListener, MediaPlayer.OnErrorListener, MediaPlayer.OnCompletionListener {
    private final Context context;
    private MediaPlayer mediaPlayer;


    private IPlayerViewChange mViewChange;
    private Timer timer;
    private TTask tTask;
    private getCurrentPosition currentPosition;
    private long CurrentPosition;
    private int duration;

    @Override
    public long getCurrentPosition() {
        return isPlaying()? mediaPlayer.getCurrentPosition():CurrentPosition;
    }

    public void setCurrentPosition(long currentPosition) {
        CurrentPosition = currentPosition;
    }

    public IBinders(Context context){
        this.context = context;

    }

    private void initPlayer() {
        Log.d("TAGrrrrrrrrrrrrrrrrrr", "onSeekComplete: ");
        mediaPlayer = new MediaPlayer();


    }

    @Override
    public  void setMusicSource(String musicSource){
        Log.d("TAGaaaaaa", "setMusicSource: "+musicSource);
        if(mediaPlayer != null) {
            mediaPlayer.stop();
            stopTime();
        }else {
            initPlayer();
        }

             mediaPlayer.reset();
            mediaPlayer.setAudioAttributes(
                     new AudioAttributes.Builder()
        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
        .setUsage(AudioAttributes.USAGE_MEDIA)
        .build()
            );

        try {

            mediaPlayer.setDataSource(musicSource);
            mediaPlayer.prepareAsync();
            mediaPlayer.setOnPreparedListener(this);
            mediaPlayer.setOnErrorListener(this);
            mediaPlayer.setOnCompletionListener(this);
            mediaPlayer.setWakeMode(context, PowerManager.PARTIAL_WAKE_LOCK);
            WifiManager.WifiLock wifiLock = ((WifiManager) context.getSystemService(Context.WIFI_SERVICE))
                    .createWifiLock(WifiManager.WIFI_MODE_FULL, "mylock");
            wifiLock.acquire();


        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    @Override
    public void playOrPause(int State) {


        if(State== STATE_STOP){
            mediaPlayer.start();
          //  starTime();

        }else if(State ==STATE_PLAY){
            mediaPlayer.pause();
            stopTime();

            Log.d("State..", String.valueOf(State));
        } else if (State == STATE_PAUSE) {
            mediaPlayer.start();

            starTime();
            Log.d("State..", String.valueOf(State));
        }

    }


    @Override
    public void stopPlay() {
        mediaPlayer.reset();
        mediaPlayer.stop();
        mediaPlayer.release();
        mediaPlayer = null;
        stopTime();

    }

    @Override
    public void seekTo(int seek) {
        if(mediaPlayer!=null){

            int v = (int) (seek * 1.0f / 100 * mediaPlayer.getDuration());

            mediaPlayer.seekTo(v);
        }
    }
    @Override
    public void seek2(int position){
        mediaPlayer.seekTo(position);
    }

    @Override
    public void registerViewControl(IPlayerViewChange change) {
        this.mViewChange = change;
    }

    @Override
    public void UnRegisterViewControl() {
        this.mViewChange = null;
    }
    private void starTime(){
        if (timer==null) {
            timer = new Timer();
        }
        if(tTask==null) {
            tTask = new TTask();
        }
        timer.schedule(tTask,200,1000);
    }
    private void stopTime(){
        if (timer!=null) {
            timer.cancel();
            timer=null;
        }
        if(tTask!=null) {
            tTask.cancel();
            tTask=null;
        }

    }

    @Override
    public void onPrepared(MediaPlayer mp) {

        playOrPause(STATE_STOP);
        if (mp != null&&mp.isPlaying()) {

            duration = mp.getDuration();
            String duration = Utils.getTime(this.duration);
            playerInfo.setDuration(duration);
            activityMainBinding.setPlayerInfo(playerInfo);
            starTime();
            currentPosition = () -> {
                if ( mViewChange != null) {

                    long CurrentPosition = mp.getCurrentPosition();
                    setCurrentPosition(CurrentPosition);
                    float currentPosition = (CurrentPosition * 1.0f / this.duration * 100);
                    mViewChange.onSeekChange((int) currentPosition);
                    String Position = Utils.getTime((int) CurrentPosition);
                    playerInfo.setCurrentPosition(Position);
                    activityMainBinding.setPlayerInfo(playerInfo);
                   // mediaPlayer.is

//                    if (duration.equals(Position)) {
//
//
//
//                    }

            }

        } ;
            new Handler().postDelayed(
                    new Runnable() {
                        @Override
                        public void run() {


                            mViewChange.RotateView();
                        }
                    }
            ,1000);


    }

    }

    @Override
    public boolean onError(MediaPlayer mp, int what, int extra) {
        return false;
    }

    @Override
    public void onCompletion(MediaPlayer mp) {
        Log.d("TAG-------当前模式为单曲循环", "onPrepared: 播放完毕"+CURRENT_PLAY_MODE);
        if (CURRENT_PLAY_MODE==SINGLE_PLAY_MODE||CURRENT_PLAY_MODE==SINGLE_PLAY_MODE_ONE){
            mediaPlayer.start();
        }else if(CURRENT_PLAY_MODE==SEQUENTIAL_MODE||CURRENT_PLAY_MODE==RANDOM_PLAY_MODE||CURRENT_PLAY_MODE==UNLIMITED_PLAYBACK_MODE){
            scrollPage();
        } else {
            animationUtils.stopRotate("pause");
            playerPageAdapterAnimation.stopRotate("pause");
            playerInfo.setPlayOrPause(!playerInfo.isPlayOrPause());
            activityMainBinding.setPlayerInfo(playerInfo);
            stopTime();
        }
    }

    public class TTask extends TimerTask {
        @Override
        public void run() {
            currentPosition.CurrentTime();
        }
    }

    public interface getCurrentPosition{
        void CurrentTime();
    }

    @Override
    public boolean isPlaying() {


        return mediaPlayer.isPlaying();
    }


}
