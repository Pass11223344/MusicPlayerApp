package com.rikkatheworld.wangyiyun.fragment;



import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_ALBUMS;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_EXCLUSIVE_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_MUSIC_RADAR_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SONG;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_SEARCH;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.DataModel;
import com.rikkatheworld.wangyiyun.EngineBindings;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.RenderMode;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodChannel;

public class SecondPage extends Fragment implements EngineBindings.EngineBindingsDelegate {

 public    EngineBindings otherBindings;
    String OTHER_PAGE = "other_pages";


    private String json;
    private String type;
    private String oldId="-2";
    private FlutterFragment otherFragment;

    private GetParams params;
    private Map<String, Object> param;
    private ToBack back;
    private App app;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_second_page,container,false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        app = (App) getActivity().getApplicationContext();
        initView();
    }

    private void initView() {
        //type:类型
        //id：id

        param = params.getParam();

        getOtherBindings();
        FlutterEngineCache.getInstance().put(OTHER_PAGE,otherBindings.engine);

        otherBindings.attach();

        back =  new ToBack() {
            @Override
            public void back() {

                otherBindings.channel.invokeMethod("pressPage","pressPage");
            }
        };
        SharedPreferences userInfoData = getContext().getSharedPreferences("UserInfoData", Context.MODE_PRIVATE);
        String string1 = userInfoData.getString("token","");
        app.Cookie = string1;
        param.put("userId",playerInfo.getUserInfoBean().getUserId());
        param.put("token",app.Cookie);

            otherFragment = FlutterFragment.withCachedEngine(OTHER_PAGE)
                    .renderMode(RenderMode.texture)
                    .build();

            otherBindings.channel.invokeMethod("to_other_page", param);
            getActivity().getSupportFragmentManager()
                    .beginTransaction()
                    .add(R.id.other_page,otherFragment)
                    .commit();


        Log.d("TAG-------->", "initView: "+ app.Cookie);

        oldId = String.valueOf(param.get("id"));


    }

    private void getOtherBindings() {

        if (otherBindings == null) {
            otherBindings = new EngineBindings(getActivity(), this, "OtherPage");
        }

    }

    @Override
    public void onNext() {

    }

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
//        if (app.touchType == TouchType.ALBUMS) {
//            otherFragment = FlutterFragment.withCachedEngine(OTHER_PAGE)
//                    .build();
//        }else {
//            otherFragment = FlutterFragment.withCachedEngine(OTHER_PAGE)
//                    .renderMode(RenderMode.texture)
//                    .build();
//        }
//        getActivity().getSupportFragmentManager()
//                .beginTransaction()
//                .add(R.id.other_page,otherFragment)
//                .commit();
        if (!hidden) {
            param= params.getParam();
            String type1 = String.valueOf(param.get("type"));
            switch (type1){
                case TO_EXCLUSIVE_SHEET:
                case TO_MUSIC_RADAR_SHEET:
                case TO_RECOMMEND_SHEET:

                case TO_SHEET:
                    Log.d("TAGqqqqqqqqqqq", "onHiddenChanged: "+param.get("type"));
                    if (param.get("id").equals(oldId))
                        return;
                    oldId = String.valueOf(param.get("id"));
                    break;
                case TO_RECOMMEND_SONG:
                case TO_ALBUMS:
                    break;
            }
            otherBindings.channel.invokeMethod("to_other_page", param);

        }
    }

    public void setOldId(String id){
        this.oldId = id;
    }
    public void setParams(GetParams getParams){
        this.params = getParams;

    }


    public interface GetParams {
        Map<String,Object> getParam();

    }


    @Override
    public void onDestroy() {
        super.onDestroy();
        otherBindings.detach();
    }
    public ToBack getBack(){

        return  this.back ;
    }
    public interface ToBack{
        void back( );
    }
}
