package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_EXCLUSIVE_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;

import android.content.Context;
import android.graphics.Point;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.bean.Home.ExclusiveSceneSongListBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.List;
//独家场景歌单
public class ExclusiveSceneSongListAdapter extends RecyclerView.Adapter<ExclusiveSceneSongListAdapter.MyHolder> {
    private final Context context;
    private final App app;
    private List<ExclusiveSceneSongListBean> list;
    private final HomeFragment.NavigationToSecond secondPage;
    private ExclusiveSceneSongListAdapter.MyHolder myHolder;

    public ExclusiveSceneSongListAdapter(Context context, HomeFragment.NavigationToSecond secondPage) {
        this.context = context;
        this.secondPage = secondPage;
        app = (App) context.getApplicationContext();
    }

    public void setData(List<ExclusiveSceneSongListBean> list){

        this.list=list;
        notifyDataSetChanged();
    }
    @NonNull
    @Override
    public ExclusiveSceneSongListAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        myHolder = new ExclusiveSceneSongListAdapter.MyHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.exclusive_scene_song_adapter_item, parent, false));
        return myHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull ExclusiveSceneSongListAdapter.MyHolder holder, int position) {
        Point screen = Utils.getScreen(context);

        int width = screen.x;
        ViewGroup.LayoutParams layoutParams = holder.root_view.getLayoutParams();
        layoutParams.width = width/3-20;
        holder.root_view.setLayoutParams(layoutParams);

        holder.exclusive_img.setScaleType(ImageView.ScaleType.FIT_XY);


        ExclusiveSceneSongListBean bean = list.get(position);
        holder.exclusive_title.setText(bean.getSheetTitle());
        holder.playCount.setText(Utils.numFormat(bean.getPlayCount()));

        Glide.with(context)
                .load(bean.getImageUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.exclusive_img);
        holder.root_view.setOnClickListener(v -> OnclickItem(bean));



    }

    private void OnclickItem(ExclusiveSceneSongListBean bean) {
        app.touchType = TouchType.EXCLUSIVE_SCENE;
        app.page +=1;
        Log.d("TAghghghG", "onClick:当前点击 "+bean.getSheetTitle());
        // secondPage.toSecond("这是点击了");
        ((MainActivity) context).setRecommendSheetId(bean.getResourceId());
        secondPage.toSecond(TO_EXCLUSIVE_SHEET,bean.getResourceId());
    }

    @Override
    public int getItemCount() {

        return list.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder {



        private final ImageView exclusive_img;
        private final TextView exclusive_title;

        private final RelativeLayout root_view;

        private final TextView playCount;

        public MyHolder(@NonNull View itemView) {
            super(itemView);
            root_view = itemView.findViewById(R.id.RE_exclusive_root);
            playCount = itemView.findViewById(R.id.TV_exclusive_playCount);
            exclusive_img = itemView.findViewById(R.id.IV_exclusive_img);
            exclusive_title = itemView.findViewById(R.id.TV_exclusive_title);



        }
    }
}