package com.rikkatheworld.wangyiyun.fragment;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.LoginPage;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.adapter.GridItemAdapter;
import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.bean.Home.songSheet;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;
import com.rikkatheworld.wangyiyun.util.NetworkUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

public class SongSheetFragment extends Fragment {

    private final HomeFragment.NavigationToSecond secondPage;
    private SongSheetHandler songSheetHandler;
    private final int SONG_SHEET = 9;
    private App app;
    private RecyclerView song_sheet;
    private List<songSheet> list;

    public SongSheetFragment(HomeFragment.NavigationToSecond secondPage) {
       this.secondPage = secondPage;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_song_sheet,container,false);
        app = (App) getActivity().getApplicationContext();
        list = new ArrayList<>();
        return  view;
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        songSheetHandler = new SongSheetHandler();
        initView();
    }

    private void initView() {
        NetworkUtils.makeRequest(NetworkInfo.URL + "/top/playlist/highquality", songSheetHandler,SONG_SHEET , true, getContext());
        song_sheet = getView().findViewById(R.id.recycler_song_sheet);
        song_sheet.setLayoutManager(new GridLayoutManager(getContext(),3));
        ImageView btn_back = getView().findViewById(R.id.song_sheet_back);
        btn_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                requireActivity().onBackPressed();
            }
        });


    }
    public class SongSheetHandler extends Handler{
        @Override
        public void dispatchMessage(@NonNull Message msg) {
            super.dispatchMessage(msg);
            int what = msg.what;
            switch (what){
                case SONG_SHEET:
                    String string = msg.obj.toString();
                    if (string!=null) {

                        JSONObject jsonObject = null;
                        try {
                            jsonObject = new JSONObject(string);
                            Object o = jsonObject.get("playlists");
                            songSheet[] list1 = app.gson.fromJson(String.valueOf(o), songSheet[].class);
                            list.addAll(Arrays.asList(list1));
                            Log.d("TAG---------", "dispatchMessage: "+list.get(0).getName());
                            GridItemAdapter adapter = new GridItemAdapter(getContext(),secondPage);
                            adapter.setData(list);
                            song_sheet.setAdapter(adapter);

                            //                        else if(json==null){
//                            Log.d("TAG11111111111111111111111", "dispatchMessage: ssss1111");
//
//                            NetworkUtils.makeRequest(NetworkInfo.URL + "/msg/private",MsgFragment.handler,RES_ID,true,getContext());
//
//                        }

                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }


                    }
                    break;
            }
        }
    }
}
