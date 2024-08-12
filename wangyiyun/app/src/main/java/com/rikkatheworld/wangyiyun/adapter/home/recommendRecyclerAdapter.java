package com.rikkatheworld.wangyiyun.adapter.home;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendedPlaylistsBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.view.RecommendSongSheetView;

import java.util.List;
import java.util.Map;

//推荐歌单
public class recommendRecyclerAdapter extends RecyclerView.Adapter<recommendRecyclerAdapter.MyHolder> {

    private final Context context;
    private final HomeFragment.NavigationToSecond secondPage;
    private final App app;
    private List<Object> data;
    private MyHolder holder;


    public recommendRecyclerAdapter(Context context, List<Object> data, HomeFragment.NavigationToSecond secondPage,App app){
    this.data = data;
    this.context = context;
    this.secondPage = secondPage;
        this.app =app ;

    }
    @NonNull
    @Override
    public recommendRecyclerAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {

        holder = new MyHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.recommend_recycler_item, parent, false));
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull recommendRecyclerAdapter.MyHolder holder, int position) {
    holder.myView.initView(context,data.get(position),secondPage);
        int position1 = position;
       if( data.get(position) instanceof List){
           return;
       }
        RecommendedPlaylistsBean   bean = (RecommendedPlaylistsBean) data.get(position);
        holder.myView.setOnClickListener(new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            app.touchType = TouchType.RECOMMENDABLE_SHEET;
            app.page +=1;

           // secondPage.toSecond("这是点击了");
            //设置当前歌单
            ((MainActivity) context).setRecommendSheetId(bean.getResourceId());
            //跳转
            secondPage.toSecond(TO_RECOMMEND_SHEET,bean.getResourceId());
        }
    });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder {

        private RecommendSongSheetView myView;

        public MyHolder(@NonNull View itemView) {
            super(itemView);
            myView = itemView.findViewById(R.id.mv_item);
        }
    }

   public void stop(){
        if(holder!=null){
            if (holder.myView!=null) {
                holder.myView.closeTimer();
               // holder.myView = null;
            }
        }
   }
    public void start(){
        if(holder!=null){
            if (holder.myView!=null) {
                holder.myView.startTimer();
                // holder.myView = null;
            }
        }
    }
}
