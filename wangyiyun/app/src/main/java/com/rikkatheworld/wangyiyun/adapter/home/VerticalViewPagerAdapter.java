package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendedPlaylistsBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.view.RecommendSongSheetView;

import java.util.List;
//垂直轮播歌单
public class VerticalViewPagerAdapter extends RecyclerView.Adapter<VerticalViewPagerAdapter.Holder> {
    private List<RecommendedPlaylistsBean> list ;
    private Context context;
    private  HomeFragment.NavigationToSecond secondPage;
    private RecommendSongSheetView.OnItem onItem;
    private App app;

    public VerticalViewPagerAdapter(){}

    @NonNull
    @Override
    public VerticalViewPagerAdapter.Holder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Holder(LayoutInflater.from(parent.getContext()).inflate(R.layout.vertical_viewpager_adapter_item,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull VerticalViewPagerAdapter.Holder holder, int position) {
        RecommendedPlaylistsBean bean = list.get(position);
        Glide.with(context)
                .load(bean.getImageUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.imageView);
            onItem = new RecommendSongSheetView.OnItem() {
                @Override
                public void setTextOnclick() {
                    OnClickItem(bean);
                }
            };
        holder.imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                OnClickItem(bean);

            }
        });
    }
public void OnClickItem(RecommendedPlaylistsBean bean){
    app.page +=1;
    app.touchType = TouchType.RECOMMENDABLE_SHEET;
    ((MainActivity) context).setRecommendSheetId(bean.getResourceId());
    secondPage.toSecond(TO_RECOMMEND_SHEET,bean.getResourceId());
}
    @Override
    public int getItemCount() {
        return list!=null?list.size():0;
    }

    public VerticalViewPagerAdapter(Context context){
        this.context = context;
        app = (App) context.getApplicationContext();

    }


    public void setData(List<RecommendedPlaylistsBean> list,HomeFragment.NavigationToSecond secondPage){
        this.list = list;
        this.secondPage = secondPage;
        notifyDataSetChanged();
    }

    public class Holder extends RecyclerView.ViewHolder {

        private final ImageView imageView;

        public Holder(@NonNull View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.iv_vertical_item);
        }
    }
    public RecommendSongSheetView.OnItem setOnItem(){
        return onItem;
    }
}
