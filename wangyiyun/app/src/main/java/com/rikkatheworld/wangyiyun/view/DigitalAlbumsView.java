package com.rikkatheworld.wangyiyun.view;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.Typeface;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendedPlaylistsBean;
import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.List;

public class DigitalAlbumsView extends RelativeLayout{

    public DigitalAlbumsView(Context context) {
        super(context);
    }

    public DigitalAlbumsView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public DigitalAlbumsView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }


        final int BG_ID = 0301;
        final int COUNT_ID = 0302;
        private List<SinglesAndAlbumsBean> list;

        private TextView titleText;





    public void initView(Context context, Object data) {

            Point screen = Utils.getScreen(context);
            int x = screen.x;
            View grayBackground = new View(context);
            LayoutParams background_params = new LayoutParams(x / 3-Utils.dp2px(context,10) , Utils.dp2px(context, 125));
            background_params.addRule(RelativeLayout.CENTER_HORIZONTAL);
            grayBackground.setLayoutParams(background_params);
            grayBackground.setBackground(getResources().getDrawable(R.drawable.album_img, getContext().getTheme()));
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

            Log.d("TAG initView", String.valueOf(data));


                RecommendedPlaylistsBean bean = (RecommendedPlaylistsBean) data;
                bean.getImageUrl();
                ImageView img_url = new ImageView(context);
                img_url.setBackground(getResources().getDrawable(R.drawable.img_background,context.getTheme()));
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
                icon.setImageResource(android.R.drawable.stat_sys_headset);
                addView(icon);

                addView(titleText);
                addView(countText);
            }








}
