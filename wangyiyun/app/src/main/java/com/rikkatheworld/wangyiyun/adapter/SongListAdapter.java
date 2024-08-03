package com.rikkatheworld.wangyiyun.adapter;



import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;

import android.content.Context;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.ArrayList;
import java.util.List;

public class SongListAdapter extends RecyclerView.Adapter<SongListAdapter.Holder> {

    private  List<ListBean> listBeans= new ArrayList<>();
    private final Context context;
    private int index;



    public SongListAdapter(Context context) {
        this.listBeans.addAll(playerInfo.getListBeans());
        this.context = context;

       // this.index = index;
       // Log.d("kklifghdkjhgks", "getItemCount: "+index);
    }

    @NonNull
    @Override
    public SongListAdapter.Holder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        Holder holder = new Holder(LayoutInflater.from(parent.getContext()).inflate(R.layout.song_list_item, parent, false));
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull SongListAdapter.Holder holder, int position) {
       int i = index% listBeans.size() ;
        int position1 = position;
        ListBean listBean = listBeans.get(position);
        String songName = listBean.getSongName();
        String name = Utils.getString(listBean);
        Log.d("TAGddddddddffff", String.valueOf("initView: " + position1+"-->"+(this.index% listBeans.size())));
//
            if (this.index % listBeans.size() == position1) {
                holder.list_title.setTextColor(context.getColor(R.color.red));
            } else {
                holder.list_title.setTextColor(context.getColor(R.color.black));
            }


        holder.list_title.setText(songName+"·"+name);
    }

    @Override
    public int getItemCount() {

        return listBeans.size();
    }

    public class Holder extends RecyclerView.ViewHolder {

        private final TextView list_title;
        private final ImageView list_clear;

        public Holder(@NonNull View itemView) {
            super(itemView);
            list_title = itemView.findViewById(R.id.song_list_title);
            list_clear = itemView.findViewById(R.id.song_list_clear);
        }
    }
    public interface UpColor{
        void setColor(int index);
    }
    public void setIndex(int index){
        this.index = index;
        notifyDataSetChanged();

    }
    public void upData(List<ListBean> list){
        Log.d("TAG-------zoul走了", "upData: ");
        if (listBeans!=null) {
            listBeans.clear();
        }
        this.listBeans.addAll(list);

    notifyDataSetChanged();

    }

}
