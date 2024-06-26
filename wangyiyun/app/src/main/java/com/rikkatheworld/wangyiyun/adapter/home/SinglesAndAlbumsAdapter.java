package com.rikkatheworld.wangyiyun.adapter.home;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.PagerAdapter;

import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;

import java.util.List;
//单曲与专辑（新歌新碟）
public class SinglesAndAlbumsAdapter extends PagerAdapter{
    private final Context context;
    private List<List<SinglesAndAlbumsBean>> list;
    private final HomeFragment.NavigationToSecond secondPage;
    private int height;


    public SinglesAndAlbumsAdapter(Context context,  HomeFragment.NavigationToSecond secondPage) {
        this.context = context;
        this.secondPage = secondPage;
    }

  public void setData(List<List<SinglesAndAlbumsBean>> list){

      this.list=list;
      notifyDataSetChanged();
  }

    @Override
    public int getCount() {
        return list.size()-2;
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view==object;
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {
        List<SinglesAndAlbumsBean> item = list.get(position);
        RecyclerView recyclerView = new RecyclerView(context);
        recyclerView.setLayoutParams(new RecyclerView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        GridLayoutManager layoutManager = new GridLayoutManager(context,1);
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.setNestedScrollingEnabled(false);
        height=container.getHeight();
        SingAndAlbumsItemAdapter singAndAlbumsItemAdapter = new SingAndAlbumsItemAdapter(context,item,height,secondPage);
        singAndAlbumsItemAdapter.setData(list);
        recyclerView.setAdapter(singAndAlbumsItemAdapter);
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
