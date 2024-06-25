package com.rikkatheworld.wangyiyun.adapter.home;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.graphics.drawable.GradientDrawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.palette.graphics.Palette;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.SimpleTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.bean.Home.SpeciallyProducedBean;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.List;
//云村出品
public class SpeciallyProducedAdapter extends RecyclerView.Adapter<SpeciallyProducedAdapter.MyHolder> {
    private final Context context;
    private List<SpeciallyProducedBean> list;
    private SpeciallyProducedAdapter.MyHolder myHolder;



    public SpeciallyProducedAdapter(Context context) {
        this.context = context;
    }

    public void setData(List<SpeciallyProducedBean> list){

        this.list=list;
        notifyDataSetChanged();
    }
    @NonNull
    @Override
    public SpeciallyProducedAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        myHolder = new SpeciallyProducedAdapter.MyHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.specially_produced_adapter_item, parent, false));
        return myHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull SpeciallyProducedAdapter.MyHolder holder, int position) {
        Point screen = Utils.getScreen(context);
        int width = screen.x;
        ViewGroup.LayoutParams layoutParams = holder.root_view.getLayoutParams();
        layoutParams.width = width/2+150;
        holder.root_view.setLayoutParams(layoutParams);

        holder.produced_img.setScaleType(ImageView.ScaleType.FIT_XY);


        SpeciallyProducedBean bean = list.get(position);
        holder.produced_title.setText(bean.getTitle());
        int position1 = position;

        Glide.with(context)
               .asBitmap()
                .load(bean.getImageUrl())

                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(new SimpleTarget<Bitmap>() {
                    @Override
                    public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                        Bitmap bitmap = resource;
                        holder.produced_img.setImageBitmap(bitmap);
                        final MyHolder viewHolder =  holder;
                        if (viewHolder.getAdapterPosition()==position1) {
                            Utils.setColor(bitmap,viewHolder.produced_title,"Dominant");
                        }

                    }
                });






    }

    @Override
    public int getItemCount() {

        return list.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder {



        private final ImageView produced_img;
        private final TextView produced_title;

        private final LinearLayout root_view;



        public MyHolder(@NonNull View itemView) {
            super(itemView);
            root_view = itemView.findViewById(R.id.Lin_produced_root_view);
            produced_img = itemView.findViewById(R.id.IV_produced_img);
            produced_title = itemView.findViewById(R.id.TV_produced_title);



        }
    }
}
