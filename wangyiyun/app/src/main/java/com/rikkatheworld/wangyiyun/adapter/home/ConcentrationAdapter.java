package com.rikkatheworld.wangyiyun.adapter.home;

import static com.bumptech.glide.Glide.with;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.CURRENT_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.RANDOM_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SINGLE_PLAY_MODE_ONE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TOUCH_COUNT;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.UNLIMITED_PLAYBACK_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isOnClick;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isUpData;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setCurrentPageItem;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setList;
import static com.rikkatheworld.wangyiyun.adapter.home.RecommendableMusicAdapter.list;

import android.content.Context;
import android.graphics.Point;
import android.graphics.Rect;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.TouchDelegate;
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
import com.google.gson.reflect.TypeToken;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.bean.Home.ConcentrationBean;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
//最后一段的歌曲
public class ConcentrationAdapter extends RecyclerView.Adapter<ConcentrationAdapter.MyHolder>  {
    private final Context context;
    private final App app;
    private List<ConcentrationBean> list;
    private ConcentrationAdapter.MyHolder myHolder;
    private String  type  = "ConcentrationBean";
    private List<ListBean> concentrationBeanList;



    public ConcentrationAdapter(Context context) {
        this.context = context;
        app = (App) ((MainActivity) context).getApplication();
    }

    public void setData(List<ConcentrationBean> list){

        this.list=list;
        notifyDataSetChanged();
    }
    @NonNull
    @Override
    public ConcentrationAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        myHolder = new ConcentrationAdapter.MyHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.concentration_adapter_item, parent, false));
        return myHolder;
    }

    @Override
    public void onBindViewHolder(@NonNull ConcentrationAdapter.MyHolder holder, int position) {
        Point screen = Utils.getScreen(context);
        int  position1 = position;
        int width = screen.x;
        ViewGroup.LayoutParams layoutParams = holder.root_view.getLayoutParams();
        layoutParams.width = width/3-20;
        holder.root_view.setLayoutParams(layoutParams);

        holder.concentration_img.setScaleType(ImageView.ScaleType.FIT_XY);


        ConcentrationBean bean = list.get(position);
        holder.concentration_title.setText(bean.getSongName());


        Glide.with(context)
                .load(bean.getPicUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.concentration_img);
        holder.root_view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                OnClickItem(bean,position1);
            }
        });

    }

    private void OnClickItem(ConcentrationBean bean,int position) {
        isOnClick = true;
        if (!app.touchType.equals(TouchType.CONCENTRATION)) {
            app.touchType = TouchType.CONCENTRATION;
            if(CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE||CURRENT_PLAY_MODE==SINGLE_PLAY_MODE_ONE){
                ((MainActivity)context).setCurrentMode("");
            }

            if (concentrationBeanList==null) {
                concentrationBeanList = new ArrayList<>();
            }
           concentrationBeanList.clear();
            list.forEach(concentrationBean -> {
                ListBean listBean = new ListBean();
                listBean.setImgUrl(concentrationBean.getPicUrl());
                listBean.setSongId(concentrationBean.getSongId());
                listBean.setSongName(concentrationBean.getSongName());
                String json = app.gson.toJson(concentrationBean.getArtists());
                Type token = new  TypeToken<List< UserSongListBean.Ar >>(){}.getType();
                List<UserSongListBean.Ar> ar = app.gson.fromJson(json, token);
                listBean.setSingerInfo(ar);
                listBean.setSubTitle(concentrationBean.getTitleDesc());
                playerInfo.setTitle(concentrationBean.getModuleTitle());
                activityMainBinding.setPlayerInfo(playerInfo);
                concentrationBeanList.add(listBean);
            });
            setList.setListInfo(concentrationBeanList);
        }
        if (playerInfo.getSongId()!= bean.getSongId()) {


            ((MainActivity)context).play(String.valueOf(bean.getSongId()), urlBeans -> {
                if (urlBeans!=null) {
                    int index = 0;
                    for (int i = 0; i < urlBeans.size(); i++) {
                        UrlBeans urlBean = urlBeans.get(i);

                        if (urlBean.getId() == bean.getSongId()||TOUCH_COUNT==1) {
                            int num = list.size();
                            int currentPage = position;

                            if ( num<=10) {
                                index =  num* 488+currentPage;
                            }else if( num<=100){
                                index =  num* 48+currentPage;
                            }else if( num<=1000){
                                index = num* 6+currentPage;
                            }else {
                                index = currentPage;
                            }

                        }
                    }

                    if(CURRENT_PLAY_MODE == RANDOM_PLAY_MODE){
                        isUpData=2;

                        ((MainActivity)context).upData(bean.getSongId());
                    }else setCurrentPageItem.setCurrentItem(index);
                }
            });
        }
    }

    @Override
    public int getItemCount() {

        return list.size();
    }



    public class MyHolder extends RecyclerView.ViewHolder {



        private final ImageView concentration_img;
        private final TextView concentration_title;

        private final RelativeLayout root_view;



        public MyHolder(@NonNull View itemView) {
            super(itemView);
            root_view = itemView.findViewById(R.id.RE_concentration_root);
            concentration_img = itemView.findViewById(R.id.IV_concentration_img);
            concentration_title = itemView.findViewById(R.id.TV_concentration_title);



        }
    }
}