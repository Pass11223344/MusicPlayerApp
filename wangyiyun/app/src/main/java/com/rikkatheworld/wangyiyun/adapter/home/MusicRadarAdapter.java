package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_EXCLUSIVE_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_MUSIC_RADAR_SHEET;

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
import com.rikkatheworld.wangyiyun.bean.Home.MusicRadarBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.List;
//音乐雷达
public class MusicRadarAdapter extends RecyclerView.Adapter<MusicRadarAdapter.MyHolder> {
    private final Context context;
    private final App app;
    private List<MusicRadarBean> list;
    private MusicRadarAdapter.MyHolder myHolder;
    private final HomeFragment.NavigationToSecond secondPage;

    public MusicRadarAdapter(Context context, HomeFragment.NavigationToSecond secondPage) {
        this.context = context;
        this.secondPage = secondPage;
        app = (App) context.getApplicationContext();
    }

    public void setData(List<MusicRadarBean> list){

        this.list=list;
        notifyDataSetChanged();
    }
    @NonNull
    @Override
    public MusicRadarAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        myHolder = new MusicRadarAdapter.MyHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.music_radar_adapter_item, parent, false));
        return myHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull MusicRadarAdapter.MyHolder holder, int position) {
        Point screen = Utils.getScreen(context);
        int width = screen.x;
        ViewGroup.LayoutParams layoutParams = holder.radar_root.getLayoutParams();
        layoutParams.width = width/3-20;
        holder.radar_root.setLayoutParams(layoutParams);

        holder.radar_img.setScaleType(ImageView.ScaleType.FIT_XY);


        MusicRadarBean bean = list.get(position);
        holder.radar_title.setText(bean.getSongSheetTitle());
       holder.playCount.setText(Utils.numFormat(bean.getPlayCount()));

        Glide.with(context)
                .load(bean.getImageUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.radar_img);
        holder.radar_root.setOnClickListener(v -> OnclickItem(bean));


    }
    private void OnclickItem(MusicRadarBean bean) {
        app.touchType = TouchType.MUSIC_RADAR;
        app.page+=1;
        Log.d("TAghghghG", "onClick:当前点击 "+bean.getSongSheetTitle());
        // secondPage.toSecond("这是点击了");
        ((MainActivity) context).setRecommendSheetId(bean.getCreativeId());
        secondPage.toSecond(TO_MUSIC_RADAR_SHEET,bean.getCreativeId());
    }
    @Override
    public int getItemCount() {

        return list.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder {



        private final ImageView radar_img;
        private final TextView radar_title;

        private final RelativeLayout radar_root;

        private final TextView playCount;

        public MyHolder(@NonNull View itemView) {
            super(itemView);
            radar_root = itemView.findViewById(R.id.RE_radar_root);
            playCount = itemView.findViewById(R.id.TV_playCount);
            radar_img = itemView.findViewById(R.id.IV_radar_img);
            radar_title = itemView.findViewById(R.id.TV_radar_title);



        }
    }
}