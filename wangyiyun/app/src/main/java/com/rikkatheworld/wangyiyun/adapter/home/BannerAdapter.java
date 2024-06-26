package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_ALBUMS;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.viewpager.widget.PagerAdapter;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.CenterCrop;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.azimuth.MarginTransformation;
import com.rikkatheworld.wangyiyun.bean.Home.BannerBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.view.CustomToast;

import java.util.List;
//轮播图
public class BannerAdapter extends PagerAdapter {


    private Context context;
    private List<BannerBean> list;
    private App app;
    private final HomeFragment.NavigationToSecond secondPage;
    public BannerAdapter(Context context, HomeFragment.NavigationToSecond secondPage) {
        this.context = context;
        this.secondPage = secondPage;
        app = (App) context.getApplicationContext();
    }



    @Override
    public int getCount() {
        return 10000;
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return object == view;

    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {
        Integer i = position % list.size();
        BannerBean bean = list.get(i);

        ImageView imageView = new ImageView(context);
        Glide.with(context)
                .load(bean.getPic())
                .error(R.drawable.img_background)

                .apply(RequestOptions.bitmapTransform(new CenterCrop())
                        .override(Target.SIZE_ORIGINAL) // 使用原始图片尺寸
                        .transform(new MarginTransformation(40, 25)))
                .into(imageView);
        if (imageView.getParent() instanceof ViewGroup) {
            ((ViewGroup) imageView.getParent()).removeView(imageView);
        }
            imageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    switch (bean.getTypeTitle()){
                        case "演出":
                        case "独家策划":
                            app.page+=1;
                            app.touchType = TouchType.ALBUMS;
                            secondPage.toSecond(TO_ALBUMS,bean.getUrl());
                            break;

                        case "歌单":
                            app.page +=1;
                            app.touchType = TouchType.RECOMMENDABLE_SHEET;
                            ((MainActivity) context).setRecommendSheetId(String.valueOf(bean.getTargetId()));
                            secondPage.toSecond(TO_RECOMMEND_SHEET, String.valueOf(bean.getTargetId()));
                            break;
                        case "广告":
                            CustomToast.showToast(context,"这是个广告");
                            break;
//                        case "":
//                            break;
                    }
                }
            });
        container.addView(imageView);
        return imageView;
    }

    public void setData(List<BannerBean> list) {

        this.list = list;
        Log.d("TAG1qqqqqqqqqqqqqqqqqqqq", "instantiateItem: "+list.size());

        notifyDataSetChanged();
    }

    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {

        container.removeView((View) object);
    }
}
