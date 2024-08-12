package com.rikkatheworld.wangyiyun.util;

import java.util.Timer;
import java.util.TimerTask;

public class AsyncTimer  {
    private Timer timer;
    private TimerTask task;

    public void startTimer(final int delay, final int interval, final Runnable action) {
        stopTimer(); // 先停止之前的计时器（如果有）

        timer = new Timer();
        task = new TimerTask() {
            @Override
            public void run() {
                action.run();
            }
        };
        timer.scheduleAtFixedRate(task, delay, interval);
    }

    public void stopTimer() {
        if (timer != null) {
            timer.cancel();
            timer = null;
        }
        task = null;
    }
}
