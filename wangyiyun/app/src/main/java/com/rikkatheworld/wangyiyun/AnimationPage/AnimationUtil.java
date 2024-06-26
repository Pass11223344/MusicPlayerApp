package com.rikkatheworld.wangyiyun.AnimationPage;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.instance;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.graphics.Point;
import android.util.Log;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.LinearInterpolator;
import android.view.animation.RotateAnimation;
import android.view.animation.TranslateAnimation;

import com.rikkatheworld.wangyiyun.util.Utils;

public class AnimationUtil {

    private  ObjectAnimator rotateAnimation;
    private  View view;
    private ObjectAnimator mNeedleAnimator;

    private View NeedleView;
    private final static  int pauseRotation = 0,playRotation = 30;
    private final static  int backRotation = 30,backPlayRotation = 0;
    private boolean flag = false;
    boolean old = false;
   private boolean playFlag = false;

   final float[]  currentRotation1 = new float[1];
    private float lastJ;

    public  void Rotate(View view,float JD){
        this.view = view;

        rotateAnimation =  ObjectAnimator.ofFloat(view,"rotation",JD,360+JD);
        rotateAnimation.setDuration(20000); // 动画持续时间20000毫秒
        rotateAnimation.setInterpolator(new LinearInterpolator());
        rotateAnimation.setRepeatMode(ObjectAnimator.RESTART);
        rotateAnimation.setRepeatCount(ObjectAnimator.INFINITE);

        rotateAnimation.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                super.onAnimationEnd(animation);
                lastJ = currentRotation1[0];

            }
        });
        rotateAnimation.addUpdateListener(animation -> {
            // 获取当前旋转的角度
            float currentRotation = (float) animation.getAnimatedValue();
            currentRotation1[0] = currentRotation;


        });

// 开始动画

       // view.startAnimation(rotateAnimation);
        rotateAnimation.start();

    }
    public  void Rotate(View view){
        this.view = view;

        rotateAnimation =   ObjectAnimator.ofFloat(view,"rotation",0,360);
        rotateAnimation.setDuration(20000); // 动画持续时间20000毫秒
        rotateAnimation.setInterpolator(new LinearInterpolator());
        rotateAnimation.setRepeatMode(ObjectAnimator.RESTART);
        rotateAnimation.setRepeatCount(ObjectAnimator.INFINITE);
        // view.startAnimation(rotateAnimation);
        rotateAnimation.start();

    }
    public void showView(View view){
        // 显示动画
        Animation slideUpAnimation = new TranslateAnimation(0, 0, view.getHeight(), 0);
        slideUpAnimation.setDuration(250); // 设置动画时长
        view.setAnimation(slideUpAnimation);
        view.setVisibility(View.VISIBLE);


    }
    public void hideView(View view){
        // 隐藏动画
        Animation slideDownAnimation = new TranslateAnimation(0, 0, 0, view.getHeight());
        slideDownAnimation.setDuration(250); // 设置动画时长
        view.setAnimation(slideDownAnimation);
        view.setVisibility(View.GONE);
    }

public  void stopRotate(String flag){
        if (rotateAnimation!=null){
            switch (flag){
                case "pause":
                    rotateAnimation.pause();

                    break;
                case "cancel":
                    view.clearAnimation();
                    view.setRotation(0);
                rotateAnimation.cancel();

                    break;
            }
        }
}

public  void proceedRotate(){

    if (rotateAnimation!=null) {
        rotateAnimation.resume();
    }


}

    public void getObjectAnimator(float y,View NeedleView,Point point) {

        this.NeedleView = NeedleView;

        if (old != instance.serviceBinder.isPlaying()) {
            if (instance.serviceBinder.isPlaying()) {
                mNeedleAnimator = ObjectAnimator.ofFloat(NeedleView ,"rotation",pauseRotation,playRotation);
            }else {
                mNeedleAnimator = ObjectAnimator.ofFloat(NeedleView ,"rotation",backRotation,backPlayRotation);
            }
            NeedleView.setPivotX((float) (point.x/3.5));
            NeedleView.setPivotY(y +135);
            mNeedleAnimator.setDuration(300);
            mNeedleAnimator.setInterpolator(new LinearInterpolator());
            mNeedleAnimator.start();
            old = instance.serviceBinder.isPlaying();
        }


   //     playFlag = !playFlag;

    }

    public void finishAnimation(){
        if (rotateAnimation!=null) {
            rotateAnimation.removeAllListeners();
            rotateAnimation.end();
            rotateAnimation.cancel();
            rotateAnimation = null;
        }
        if (mNeedleAnimator!=null){
            mNeedleAnimator.removeAllListeners();
            mNeedleAnimator.end();
            mNeedleAnimator.cancel();
            mNeedleAnimator =null;
        }
    }
    public float getD(){
        return lastJ;
    }
}
