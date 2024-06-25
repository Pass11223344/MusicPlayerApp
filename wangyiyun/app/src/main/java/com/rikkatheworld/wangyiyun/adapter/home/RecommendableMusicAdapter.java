package com.rikkatheworld.wangyiyun.adapter.home;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.PagerAdapter;

import com.rikkatheworld.wangyiyun.bean.Home.RecommendableMusicsBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;

import java.util.List;
//推荐歌曲
public class RecommendableMusicAdapter extends PagerAdapter {

    private final Context context;

    public static List<List<RecommendableMusicsBean>> list;
    private int height;
    private List<UrlBeans> urlData;
    private UrlBeans urlDataInfo;

    public static RecommendableMusicItemAdapter  recommendableMusicItemAdapter;


    public RecommendableMusicAdapter(Context context) {
        this.context = context;
    }

    public void setData(List<List<RecommendableMusicsBean>> list){

        this.list=list;

        notifyDataSetChanged();
    }
    public void setUrlData(List<UrlBeans> urlData){
        this.urlData = urlData;
        notifyDataSetChanged();

    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view==object;
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {
        List<RecommendableMusicsBean> item = list.get(position);
        RecyclerView recyclerView = new RecyclerView(context);
        recyclerView.setLayoutParams(new RecyclerView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        GridLayoutManager layoutManager = new GridLayoutManager(context,1);
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setNestedScrollingEnabled(false);
        height=container.getHeight();


        recommendableMusicItemAdapter = new RecommendableMusicItemAdapter(context,item,height,urlData);

        recyclerView.setAdapter(recommendableMusicItemAdapter);
        container.addView(recyclerView);
        return recyclerView;
    }

    @Override
    public float getPageWidth(int position) {

        return (float) 0.958f;
    }

    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {

        container.removeView((View) object);
    }


}

