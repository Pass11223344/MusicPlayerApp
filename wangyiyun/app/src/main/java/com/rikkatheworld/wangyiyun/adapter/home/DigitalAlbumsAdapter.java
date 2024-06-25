package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_ALBUMS;
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
import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.ArrayList;
import java.util.List;
//数字专辑
public class DigitalAlbumsAdapter extends RecyclerView.Adapter<DigitalAlbumsAdapter.MyHolder> {
    private final Context context;
    private final App app;
    private List<List<SinglesAndAlbumsBean>> list;
    private MyHolder myHolder;
    private List<SinglesAndAlbumsBean> singlesAndAlbumsBeans ;
    private final HomeFragment.NavigationToSecond secondPage;

    public DigitalAlbumsAdapter(Context context,HomeFragment.NavigationToSecond secondPage) {
    this.context = context;
    this.secondPage = secondPage;
        app = (App) context.getApplicationContext();
    }

    public void setData(List<List<SinglesAndAlbumsBean>> list){

        this.list=list;
        notifyDataSetChanged();
    }
    @NonNull
    @Override
    public DigitalAlbumsAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        myHolder = new MyHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.digital_albums_item, parent, false));
        return myHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull DigitalAlbumsAdapter.MyHolder holder, int position) {

        Point screen = Utils.getScreen(context);
        int width = screen.x;
        ViewGroup.LayoutParams layoutParams = holder.digital_root.getLayoutParams();
        layoutParams.width = width/3;
        holder.digital_root.setLayoutParams(layoutParams);

        holder.digital_img.setScaleType(ImageView.ScaleType.FIT_XY);
        SinglesAndAlbumsBean bean = singlesAndAlbumsBeans.get(position );
        holder.digital_title.setText(bean.getTitle());
        String name = "";
        if (bean.getSingerInfo().size()==1){
            name=  bean.getSingerInfo().get(0).name;
        }else {
            for (int i = 0; i < bean.getSingerInfo().size(); i++) {

                if (i < bean.getSingerInfo().size() - 1) {
                    name = name + bean.getSingerInfo().get(i).name + "/";

                } else {
                    name = name + bean.getSingerInfo().get(i).name;
                }
            }

        }
        holder.digital_singer.setText(name);
        Glide.with(context)
                .load(bean.getPicUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.digital_img);
       // Log.d("TAG-----------", "onClaaaaaaaick: "+bean.getAction());
        String s = Utils.parseOrpheusURL(bean.getAction());
        Log.d("TAG-----------", "onClaaaaaaaick: "+s);
        holder.digital_root.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                app.page+=1;
                app.touchType = TouchType.ALBUMS;
                secondPage.toSecond(TO_ALBUMS,s);
            }
        });


    }

    @Override
    public int getItemCount() {

        singlesAndAlbumsBeans = new ArrayList<>();

        for (List<SinglesAndAlbumsBean> andAlbumsBeans : list) {
            for (SinglesAndAlbumsBean andAlbumsBean : andAlbumsBeans) {
                if (!andAlbumsBean.getCreativeType().equals("DIGITAL_ALBUM_HOMEPAGE")) {
                   continue;
                }
                singlesAndAlbumsBeans.add(andAlbumsBean);
            }
        }

        return singlesAndAlbumsBeans.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder {


        private final View dd;
        private final ImageView digital_img;
        private final TextView digital_title;
        private final TextView digital_singer;
        private final RelativeLayout digital_root;

        public MyHolder(@NonNull View itemView) {
            super(itemView);
            digital_root = itemView.findViewById(R.id.RE_digital_root);
            dd = itemView.findViewById(R.id.dd);
            digital_img = itemView.findViewById(R.id.IV_digital_img);
            digital_title = itemView.findViewById(R.id.TV_digital_title);
            digital_singer = itemView.findViewById(R.id.TV_digital_singer);

        }
    }
}
