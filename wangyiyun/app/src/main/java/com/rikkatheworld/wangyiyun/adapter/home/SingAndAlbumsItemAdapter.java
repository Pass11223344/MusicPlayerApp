package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.CURRENT_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.RANDOM_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TOUCH_COUNT;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_SING_AND_ALBUMS;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isOnClick;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isUpData;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.oldSheetId;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setCurrentPageItem;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setList;
import static com.rikkatheworld.wangyiyun.adapter.home.RecommendableMusicAdapter.list;

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
import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
//单曲与专辑（新歌新碟）
public class SingAndAlbumsItemAdapter extends RecyclerView.Adapter<SingAndAlbumsItemAdapter.myHolder> {
    private final App app;
    private List<SinglesAndAlbumsBean> list;
    private List<SinglesAndAlbumsBean> SongList;
    private Context context;

    private int index;
    private final HomeFragment.NavigationToSecond secondPage;

    public SingAndAlbumsItemAdapter(Context context, List<SinglesAndAlbumsBean> list, HomeFragment.NavigationToSecond secondPage) {
        this.list = list;
        this.context = context;

        this.secondPage = secondPage;
        app = (App)context.getApplicationContext();
    }

    @NonNull
    @Override
    public SingAndAlbumsItemAdapter.myHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View inflate = LayoutInflater.from(parent.getContext()).inflate(R.layout.sing_album_adapter_item, parent, false);



        return new myHolder(inflate);
    }

    @Override
    public void onBindViewHolder(@NonNull SingAndAlbumsItemAdapter.myHolder holder, int position) {

        ViewGroup.MarginLayoutParams layoutParams = (ViewGroup.MarginLayoutParams)holder.lin_item.getLayoutParams();
        if (position==0){
            layoutParams.topMargin=0;
        }

        int newHeight = Utils.dp2px(context,200) / 3 - 18;
        layoutParams.height = newHeight;
        holder.lin_item.setLayoutParams(layoutParams);
        SinglesAndAlbumsBean bean = list.get(position);

        if (!bean.getCreativeType().equals("NEW_ALBUM_HOMEPAGE")) {
            holder.view.setVisibility(View.GONE);
        }
        ViewGroup.LayoutParams imageViewLayoutParams = holder.imageView.getLayoutParams();
       imageViewLayoutParams.height = newHeight-12;
        holder.imageView.setScaleType(ImageView.ScaleType.FIT_XY);
        holder.imageView.setLayoutParams(imageViewLayoutParams);
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

        holder.subTitle.setText(bean.getTransName()+" - "+ name);

        holder.title.setText(bean.getTitle());
        Glide.with(context)
                .load(bean.getPicUrl())
                .error(R.drawable.img_background)
                .placeholder(R.drawable.img_background)
                .apply( RequestOptions.bitmapTransform(new RoundedCorners(25)))
                .into(holder.imageView);

        holder.lin_item.setOnClickListener(v -> {
            isOnClick = true;
            oldSheetId = "";
            if (bean.getResourceType().equals("song")) {
                ((MainActivity)context).setCurrentMode("");
                List<ListBean> listBeans = new ArrayList<>();
                if(Long.parseLong(bean.getResourceId())!= playerInfo.getSongId()){
                    if (!app.touchType.equals(TouchType.SING_AND_ALBUMS)){
                        app.touchType = TouchType.SING_AND_ALBUMS;

                        SongList.forEach((bean1) ->{
                            if (!bean1.getResourceType().equals("song")) return;
                            ListBean listBean = new ListBean();
                            String json1 = app.gson.toJson(bean1.getSingerInfo());
                                Type type = new  TypeToken<List<UserSongListBean.Ar>>(){}.getType();
                                List<UserSongListBean.Ar> SingerInfo = app.gson.fromJson(json1,type);
                            listBean.setSingerInfo(SingerInfo);
                            listBean.setImgUrl(bean1.getPicUrl());
                            listBean.setSongId(Long.parseLong(bean1.getResourceId()));
                            listBean.setSongName(bean1.getTitle());
                            listBeans.add(listBean);
                        });
//                        if (playerInfo.getListBeans()!=null) {
//                            playerInfo.getListBeans().clear();
//                        }
                        //  playerInfo.getListBeans().clear();
                        setList.setListInfo(listBeans);
                        playerInfo.setTitle("新歌新碟");
                        activityMainBinding.setPlayerInfo(playerInfo);

                    }
                    ((MainActivity) context).play(String.valueOf(bean.getResourceId()),
                            play -> {
                                if (play!=null) {
                                    for (int i = 0; i < play.size(); i++) {
                                        UrlBeans urlBeans = play.get(i);

                                        if (urlBeans.getId() == Long.parseLong(bean.getResourceId())||TOUCH_COUNT==1) {
                                            int num = 0;
                                            int currentPage = 0;

                                            for (int j = 0; j < SongList.size(); j++) {
                                                if (!SongList.get(j).getResourceType().equals("song")) {
                                                    break;
                                                }
                                                    if (SongList.get(j).getResourceId()==bean.getResourceId()){
                                                        currentPage = num;
                                                    }
                                                    num+=1;

                                            }

                                            Log.d("TAGaoaoaoaoa", "onBindViewHolder: 我走了当前点击"+currentPage);
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
                                        ((MainActivity)context).upData(Long.parseLong(bean.getResourceId()));
                                    } else setCurrentPageItem.setCurrentItem(index);
                                }
                            }
                    );

                }
            }else {
                app.touchType = TouchType.SING_AND_ALBUMS;
                app.page +=1;
                ((MainActivity) context).setRecommendSheetId(bean.getResourceId());
                //跳转
                secondPage.toSecond(TO_SING_AND_ALBUMS,bean.getResourceId());
            }
            Log.d("TAG----------", "onClick: 可以点击当前点击"+bean.getTitle());
        });
    }

    @Override
    public int getItemCount() {
        return list.size();
    }

    public class myHolder extends RecyclerView.ViewHolder {
        private final View view;
        private final TextView title;
        private final TextView subTitle;
        private final ImageView imageView;
       private final LinearLayout lin_item;
        public myHolder(@NonNull View itemView) {
            super(itemView);
            view=  itemView.findViewById(R.id.dd);
            lin_item  = itemView.findViewById(R.id.lin_sing_adapter_item);
            title = itemView.findViewById(R.id.tv_sing_less_title);
            subTitle = itemView.findViewById(R.id.tv_sing_less_subtitle);
            imageView = itemView.findViewById(R.id.iv_sing_img);
        }
    }
   public void setData(List<List<SinglesAndAlbumsBean>> list){
       if (this.SongList==null) {
           this.SongList = new ArrayList<>();
           for (int i = 0; i < list.size() - 2; i++) {
               for (int i1=0;i1<list.get(i).size();i1++){
                   if (list.get(i).get(i1).getCreativeType().equals("NEW_SONG_HOMEPAGE")) {
                       SongList.add(list.get(i).get(i1));
                   }
               }
              //
           }
           //this.SongList = list;
          Log.d("TAGqqqqqqqqqqq", "setData: "+this.SongList.size()+"-----"+list.size());

       }

    }

}
