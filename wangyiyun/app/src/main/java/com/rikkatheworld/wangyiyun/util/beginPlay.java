package com.rikkatheworld.wangyiyun.util;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.TOUCH_COUNT;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.beginService;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.binderFlag;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.instance;

import android.content.Context;

import com.rikkatheworld.wangyiyun.bean.ListBean;

import java.util.List;

public  class  beginPlay {

    public static void play( Context context,doSomething thing){
        if( TOUCH_COUNT==0&&!binderFlag){
           beginService(context);

        }
        instance.setCallback(newState -> {
            TOUCH_COUNT++;
            if (newState) {
              thing.something();

            }
        });
    }
   public interface doSomething{
        void something();
   }

    public interface TaskImage{
        void setImg(String url);
    }
    public interface GetListInfo{
        void setListInfo(List<ListBean> listBean);
    }
    public interface CurrentItem{
        void setCurrentItem(int current);
    }

}
