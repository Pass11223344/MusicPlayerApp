package com.rikkatheworld.wangyiyun.adapter;





import static com.rikkatheworld.wangyiyun.activity.MainActivity.CURRENT_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.RANDOM_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SINGLE_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SINGLE_PLAY_MODE_ONE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.UNLIMITED_PLAYBACK_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.instance;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isUpData;

import android.content.Context;
import android.graphics.Point;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.viewpager.widget.PagerAdapter;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.rikkatheworld.wangyiyun.AnimationPage.AnimationUtil;

import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.ArrayList;
import java.util.List;

public class PlayerPageAdapter extends PagerAdapter {
    private final App app;
    private  List<ListBean> list = new ArrayList<>();
    private final Context context;

    private int position1=-1;
    public static AnimationUtil playerPageAdapterAnimation;


    private float d;
    private int index=-1;

  //private App  app = (App) getApplicationContext();




    public PlayerPageAdapter(Context context,App app) {
        this.context = context;
        this.app = app;
        if (playerPageAdapterAnimation==null) {
            playerPageAdapterAnimation= new AnimationUtil();
        }


    }



    @Override
    public int getCount() {
        return CURRENT_PLAY_MODE == SINGLE_PLAY_MODE_ONE||CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE?list.size():100000;
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view==object;
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {

        Log.d("TAG___", "instantiateItem: ");

        int i = position % list.size();
        ListBean listBean = list.get(i);

        Point screen = Utils.getScreen(context);
        LinearLayout linearLayout = new LinearLayout(context);
        linearLayout.setTag(position);
        linearLayout.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        linearLayout.setGravity(Gravity.BOTTOM|Gravity.CENTER);
        FrameLayout player_page_album= new FrameLayout(context);

        FrameLayout.LayoutParams frameLayoutLayoutParams = new FrameLayout.LayoutParams(screen.x-180, screen.x-180);
        player_page_album.setBackground(context.getDrawable(R.drawable.album));
        frameLayoutLayoutParams.gravity = Gravity.CENTER;
       frameLayoutLayoutParams.topMargin=300;

        player_page_album.setLayoutParams(frameLayoutLayoutParams);

        ImageView  player_page_img = new ImageView(context);

        player_page_img.setId(position);


        FrameLayout.LayoutParams imageViewLayoutParams = new FrameLayout.LayoutParams(screen.x-100,screen.x-100);
        player_page_img.setLayoutParams(imageViewLayoutParams);
        imageViewLayoutParams.gravity = Gravity.CENTER;
        player_page_img.setPadding(220,220,220,220);
        Glide.with(context)
                .load(listBean.getImgUrl())
                .error(R.drawable.custom_progress_thumb)
                .placeholder(R.drawable.custom_progress_thumb)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(screen.x-20)))
                .into(player_page_img);


        linearLayout.addView(player_page_album);
        player_page_album.addView(player_page_img);
        container.addView(linearLayout);
        return linearLayout;

    }

    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
       container.removeView((View) object);

    }


    @Override
    public void setPrimaryItem(ViewGroup container, int position, Object object) {
   super.setPrimaryItem(container, position, object);
        Log.d("TAGppppp", "setPrimaryItem: "+position+"--"+position1);
        ViewGroup   currentView = (ViewGroup) object;
        ImageView   imgView = currentView.findViewById(position);


        if (position!=position1||app.isUpViewpage) {
            app.isUpViewpage = false;
            if (playerPageAdapterAnimation != null) {
                playerPageAdapterAnimation.stopRotate("cancel");
            }

            playerPageAdapterAnimation.Rotate(imgView);
            playerPageAdapterAnimation.stopRotate("pause");
            position1 = position;
        }





       }




public void setData(List<ListBean> list){
    if (this.list!=null) {
        this.list.clear();
    }
    this.list.addAll(list);
notifyDataSetChanged();
}


    @Override
    public int getItemPosition(Object object)   {
        View view = (View) object;
     final    int  currentPagerIdx = ((MainActivity) context).getCurrentPagerIdx();

         int flag = POSITION_NONE;
        if (isUpData==1) {
            if (CURRENT_PLAY_MODE==RANDOM_PLAY_MODE||CURRENT_PLAY_MODE==SINGLE_PLAY_MODE){
                if(currentPagerIdx  == (Integer) view.getTag()){

                    flag = POSITION_UNCHANGED;
                }

                else if (currentPagerIdx+1 == (Integer) view.getTag()||currentPagerIdx-1  == (Integer) view.getTag()){

                    flag = POSITION_NONE;

                }
                else {
                    flag = POSITION_UNCHANGED;

                }
            }

      }else {
            flag = POSITION_NONE;
        }
       return flag;
    }


}

