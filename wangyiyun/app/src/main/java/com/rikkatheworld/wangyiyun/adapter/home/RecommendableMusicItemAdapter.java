package com.rikkatheworld.wangyiyun.adapter.home;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.CURRENT_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.RANDOM_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TOUCH_COUNT;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.firstDownWithRecommend;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isUpData;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.oldSheetId;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setCurrentPageItem;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setList;
import static com.rikkatheworld.wangyiyun.adapter.home.RecommendableMusicAdapter.list;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isOnClick;

import android.app.Application;
import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
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
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendableMusicsBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;


import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
//推荐曲
public class RecommendableMusicItemAdapter extends RecyclerView.Adapter<RecommendableMusicItemAdapter.myHolder> {
    private final List<RecommendableMusicsBean> item    ;
    private final Context context;
    private final int height;
    private final List<UrlBeans> urlData;
    private final App app;

    private String url;
    private List<Long> singerIds;
    private List<String> singerName;
    private  List<ListBean> RecommendableMusicListBeans;
    private int index;



    public RecommendableMusicItemAdapter(Context context, List<RecommendableMusicsBean> List, int height,List<UrlBeans> urlData) {
        this.item = List;
        this.context = context;
        this.height = height;
        this.urlData = urlData;
        app = (App) ((MainActivity) context).getApplication();

    }

    @NonNull
    @Override
    public RecommendableMusicItemAdapter.myHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(parent.getContext()).inflate(R.layout.recommendable_music_adapter_item, parent, false);
        return new RecommendableMusicItemAdapter.myHolder(inflate);
    }

    @Override
    public void onBindViewHolder(@NonNull RecommendableMusicItemAdapter.myHolder holder, int position) {
        int position1 = position;
         String  name ="";
         final String newName;
        List<Long> singerId;

        ViewGroup.MarginLayoutParams layoutParams = (ViewGroup.MarginLayoutParams)holder.lin_item.getLayoutParams();
        if (position==0){
            layoutParams.topMargin=0;
        }
        int newHeight = height / 3 - 18;
        layoutParams.height = newHeight;
        holder.lin_item.setLayoutParams(layoutParams);
        RecommendableMusicsBean bean = item.get(position);


        holder.imageView.setScaleType(ImageView.ScaleType.FIT_XY);

        singerId = new ArrayList<>();
            for (int i = 0; i < bean.getArtists().size(); i++) {
                singerId.add(bean.getArtists().get(i).id) ;
              if ( i< bean.getArtists().size()-1){
                  name = name + bean.getArtists().get(i).name+"/";

              }else {
                  name = name + bean.getArtists().get(i).name;
              }

            }
            newName = name;
        if (bean.getSubTitle().equals("")) {
            holder.explain.setVisibility(View.GONE);
            holder.subTitle.setText(name);
        }else {
            holder.explain.setText(bean.getSubTitle());
            holder.subTitle.setText(name);
        }

        holder.title.setText(bean.getSongTitle());

        Glide.with(context)
                .load(bean.getImageUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply(RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.imageView);



        holder.lin_item.setOnClickListener(v -> {
            isOnClick = true;
            oldSheetId = "";

            if(bean.getSongId()!=playerInfo.getSongId()){
                if (!app.touchType.equals(TouchType.RECOMMENDABLE_MUSIC)){
                    app.touchType = TouchType.RECOMMENDABLE_MUSIC;
                    RecommendableMusicListBeans = new ArrayList<>();
                    list.forEach(innerList -> {
                        innerList.forEach(recommendableMusicsBean -> {

                            ListBean listBean = new ListBean();
                            listBean.setImgUrl(recommendableMusicsBean.getImageUrl());

                            String json = app.gson.toJson(recommendableMusicsBean.getArtists());
                            Type token = new TypeToken<List<UserSongListBean.Ar>>(){}.getType();
                            List<UserSongListBean.Ar> SingerInfo =  app.gson.fromJson(json,token);
                            playerInfo.setTitle(recommendableMusicsBean.getModuleTitle());
                            activityMainBinding.setPlayerInfo(playerInfo);
                            listBean.setSingerInfo(SingerInfo);
                            listBean.setSongId(recommendableMusicsBean.getSongId());
                            listBean.setSongName(recommendableMusicsBean.getSongTitle());
                            RecommendableMusicListBeans.add(listBean);
                        });
                    });
                    Log.d("TAG111111333", "onaaaaaaBindViewHolder: "+position1%item.size());

                    setList.setListInfo(RecommendableMusicListBeans);


                }
                 ((MainActivity) context).play(String.valueOf(bean.getSongId()),
                         play -> {

                             if (play!=null) {
                                 for (int i = 0; i < play.size(); i++) {
                                     UrlBeans urlBeans = play.get(i);

                                     if (urlBeans.getId() == bean.getSongId()||TOUCH_COUNT==1) {
                                          int num = 0;
                                         int currentPage = 0;
                                         for (int j = 0; j < list.size(); j++) {
                                             for (int k = 0; k < list.get(j).size(); k++) {
                                                 if (list.get(j).get(k).getSongId()==bean.getSongId()){
                                                     currentPage = num;
                                                 }
                                                 num+=1;
                                             }
                                         }
                                         if ( num<=10) {
                                             index =  num* 500+currentPage;
                                         }else if( num<=100){
                                             index =  num* 50+currentPage;
                                         }else if( num<=1000){
                                             index = num* 5+currentPage;
                                         }else {
                                             index = currentPage;
                                         }

                                     }
                                 }

                                 if(CURRENT_PLAY_MODE == RANDOM_PLAY_MODE){
                                     isUpData=2;
                                     Log.d("TAG111111333", "onBindViewHolder: "+position1%item.size());
                                     // setList.setListInfo(RecommendableMusicListBeans);
                                     ((MainActivity)context).upData(bean.getSongId());
                                 }else setCurrentPageItem.setCurrentItem(index);
                             }

                         }
                 );



                }

            });


        }



    @Override
    public int getItemCount() {
        return item.size();
    }




    public class myHolder extends RecyclerView.ViewHolder {

        private final TextView title;
        private final TextView subTitle;
        private final ImageView imageView;
        private final LinearLayout lin_item;
        private final TextView explain;

        public myHolder(@NonNull View itemView) {
            super(itemView);

            explain = itemView.findViewById(R.id.TV_explain);
            lin_item  = itemView.findViewById(R.id.lin_sing_adapter_item);
            title = itemView.findViewById(R.id.tv_sing_less_title);
            subTitle = itemView.findViewById(R.id.tv_sing_less_subtitle);
            imageView = itemView.findViewById(R.id.iv_sing_img);

        }
    }

}
