package com.rikkatheworld.wangyiyun.view;

import static com.rikkatheworld.wangyiyun.fragment.MsgFragment.handler;

import android.R.drawable;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.Typeface;
import android.os.Message;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.viewpager2.widget.ViewPager2;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.adapter.home.VerticalViewPagerAdapter;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendedPlaylistsBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.util.AsyncTimer;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.List;
import android.os.Handler;

public class RecommendSongSheetView extends RelativeLayout {
    final int BG_ID = 0301;
    final int COUNT_ID = 0302;
    private List<RecommendedPlaylistsBean> list;
    private ViewPager2 viewPager;
    private TextView titleText;
    private AsyncTimer pager_timer;
    private  HomeFragment.NavigationToSecond secondPage;
    private OnItem onItem;
    private Runnable runnable;
    private RecommendHandler handler;

    public RecommendSongSheetView(@NonNull Context context) {

        super(context);

    }

    public RecommendSongSheetView(@NonNull Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);

    }

    public RecommendSongSheetView(@NonNull Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

    }

    public void initView(Context context, Object data,HomeFragment.NavigationToSecond secondPage) {
        this.secondPage = secondPage;
        handler = new RecommendHandler();
        Point screen = Utils.getScreen(context);
        int x = screen.x;
        View grayBackground = new View(context);
        LayoutParams background_params = new LayoutParams(x / 3-Utils.dp2px(context,10) , Utils.dp2px(context, 125));
        background_params.addRule(RelativeLayout.CENTER_HORIZONTAL);
        grayBackground.setLayoutParams(background_params);
        grayBackground.setBackground(getResources().getDrawable(R.drawable.img_background, getContext().getTheme()));
        grayBackground.setId(BG_ID);
        addView(grayBackground);

        titleText = new TextView(context);
        LayoutParams title_params = new LayoutParams(x / 3, ViewGroup.LayoutParams.WRAP_CONTENT);
        title_params.addRule(RelativeLayout.BELOW, BG_ID);
        title_params.addRule(RelativeLayout.CENTER_HORIZONTAL);
        title_params.topMargin = Utils.dp2px(context,2);
        titleText.setTextSize(14);
        titleText.setMaxLines(2);
        titleText.setEllipsize(TextUtils.TruncateAt.END);
        titleText.setGravity(Gravity.CENTER);

        titleText.setLayoutParams(title_params);

        TextView countText = new TextView(context);
        countText.setId(COUNT_ID);
        LayoutParams count_params = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        count_params.rightMargin = Utils.dp2px(context,0);
        count_params.topMargin = Utils.dp2px(context,8);
        count_params.addRule(RelativeLayout.ALIGN_RIGHT,BG_ID);
        countText.setGravity(Gravity.CENTER);
        countText.setTextColor(Color.WHITE);
        countText.setTypeface(Typeface.DEFAULT_BOLD);
        countText.setBackgroundColor(Color.TRANSPARENT);
        countText.setLayoutParams(count_params);



        if (data instanceof List) {
            list = (List<RecommendedPlaylistsBean>) data;
            viewPager = new ViewPager2(context);
            viewPager.setRotation(90f);
            VerticalViewPagerAdapter viewPagerAdapter = new VerticalViewPagerAdapter(context);
            viewPagerAdapter.setData(list,secondPage);
            viewPager.setAdapter(viewPagerAdapter);
             LayoutParams params = new LayoutParams(Utils.dp2px(context, 120) ,x/3);
            params.addRule(RelativeLayout.CENTER_HORIZONTAL);
            params.addRule(RelativeLayout.ALIGN_BOTTOM,BG_ID);
            viewPager.setLayoutParams(params);

           addView(viewPager);
            pager_timer = new AsyncTimer();
            runnable = new Runnable() {
                @Override
                public void run() {

                    int currentItem = viewPager.getCurrentItem();

                    Message message = new Message();
                    message.what = currentItem;
                    handler.sendMessage(message);

                }
            };
            pager_timer.startTimer(4000,4000, runnable);
           // viewPagerAdapter.notifyDataSetChanged();
            titleText.setText(list.get(viewPager.getCurrentItem()).getTitle());
            titleText.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    viewPagerAdapter.setOnItem().setTextOnclick();
                }
            });
            addView(titleText);

        } else {
            RecommendedPlaylistsBean bean = (RecommendedPlaylistsBean) data;
            ImageView img_url = new ImageView(context);
            LayoutParams params = new LayoutParams(x / 3, Utils.dp2px(context, 120
            ));
            params.addRule(RelativeLayout.CENTER_HORIZONTAL);
            params.addRule(RelativeLayout.ALIGN_BOTTOM,BG_ID);
            img_url.setScaleType(ImageView.ScaleType.FIT_XY);
            img_url.setLayoutParams(params);
            Glide.with(context)
                    .load(bean.getImageUrl())
                    .error(R.drawable.img_background)
                    .placeholder(R.drawable.img_background)
                    .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                    .into(img_url);
            addView(img_url);
            countText.setText(Utils.numFormat(Long.valueOf( String.valueOf(bean.getPlaycount()))));
            titleText.setText(bean.getTitle());
            ImageView icon = new ImageView(context);
            LayoutParams icon_params = new LayoutParams(Utils.dp2px(getContext(), 16), Utils.dp2px(getContext(), 18));
            icon_params.addRule(RelativeLayout.LEFT_OF, COUNT_ID);
            icon_params.topMargin = Utils.dp2px(context,9);
            icon.setPadding(0,0,6,0);
            icon.setLayoutParams(icon_params);
            icon.setImageResource(drawable.stat_sys_headset);
            addView(icon);
            addView(titleText);
            addView(countText);
        }



    }

    class RecommendHandler extends Handler{
        @Override
        public void dispatchMessage(@NonNull Message msg) {
            super.dispatchMessage(msg);

            if (msg.what==list.size()-1) {

                viewPager.setCurrentItem(0);
                titleText.setText(list.get(viewPager.getCurrentItem()).getTitle());

            }else {
                viewPager.setCurrentItem(msg.what+1);
                titleText.setText(list.get(viewPager.getCurrentItem()).getTitle());

            }
        }
    }
    public void closeTimer(){
        if (pager_timer!=null) {
            pager_timer.stopTimer();
            pager_timer = null;
        }

    }
    public void startTimer(){
        Log.d("TAGooooaaaa", "startTimer: "+(runnable==null));
        if (runnable==null) {
            runnable = new Runnable() {
                @Override
                public void run() {

                    int currentItem = viewPager.getCurrentItem();
                    Message message = new Message();
                    message.what = currentItem;
                    handler.sendMessage(message);

                }
            };
        }
        if (pager_timer==null) {
            pager_timer = new AsyncTimer();
            pager_timer.startTimer(4000,4000, runnable);

        }else   pager_timer.startTimer(4000,4000, runnable);

    }
    public interface OnItem{
        void setTextOnclick();
    }

}
