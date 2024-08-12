package com.rikkatheworld.wangyiyun.fragment;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.MY_ENGINE_ID;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;


import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.IdRes;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;


import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.EngineBindings;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.bean.My.UserInfoBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSheetBean;
import com.rikkatheworld.wangyiyun.util.MyGsonUtil;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;
import com.rikkatheworld.wangyiyun.util.NetworkUtils;
import com.rikkatheworld.wangyiyun.util.Utils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.RenderMode;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;


public class MyFragment extends Fragment implements EngineBindings.EngineBindingsDelegate {

    public EngineBindings  myBindings;;
    private JSONObject profile;
    private MyFragmentHandler handler;
    private static  final int SONG_SHEET_ID = 1;
    private UserInfoBean userInfoBean;
    private boolean isFirst = true;
    public FlutterFragment myflutterFragment;
    private Map<String, Object> map;
    private App app;


    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View inflate = inflater.inflate(R.layout.my_fragment, container, false);

        return inflate;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        myflutterFragment.onActivityResult(requestCode, resultCode, data);
    }


    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        getMyBindings();
        app = (App) getActivity().getApplicationContext();
       // initView();

    }
    private void LoadData() {
        try {
            NetworkUtils.makeRequest(NetworkInfo.URL + "/user/playlist?uid="+userInfoBean.getUserId(), handler, SONG_SHEET_ID,true,getContext());
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    private void initView() {
        userInfoBean = playerInfo.getUserInfoBean();
        handler = new MyFragmentHandler();
        //  LoadData();
        FlutterEngineCache.getInstance().put(MY_ENGINE_ID,myBindings.engine);
        myBindings.attach();
        myflutterFragment = FlutterFragment.withCachedEngine(MY_ENGINE_ID)
                .renderMode(RenderMode.texture)
                .build();

        SharedPreferences userInfoData = getContext().getSharedPreferences("UserInfoData", Context.MODE_PRIVATE);
        String string = userInfoData.getString("UserInfo","");
        String string1 = userInfoData.getString("token","");

        if (!string.equals("")|| !TextUtils.isEmpty(string)) {
            JSONObject info = null;
            try {
                info = new JSONObject(string);
                profile = (JSONObject) info.get("profile");
                map = new HashMap<>();
                map.put("userId" ,profile.get("userId"));
                map.put("token" ,string1);

            } catch (JSONException e) {
                throw new RuntimeException(e);
            }
        }

        myBindings.channel.invokeMethod("to_myPage", map);
        getActivity().getSupportFragmentManager()
                .beginTransaction()
                .add(R.id.my_Fl_flutterView, myflutterFragment)
                .commit();

    }
    private EngineBindings getMyBindings() {
        if (myBindings == null) {
            myBindings = new EngineBindings(getActivity(), this, "MyPage");
        }

        return myBindings;
    }

    @Override
    public void onNext() {

    }
    public class MyFragmentHandler extends Handler{
        @Override
        public void dispatchMessage(@NonNull Message msg) {
            super.dispatchMessage(msg);
            String obj = String.valueOf(msg.obj);
            switch (msg.what){

                case SONG_SHEET_ID:

                    if (obj!=null) {
                        try {
                            JSONObject object = new JSONObject(obj);
                            String o = object.getString("playlist");
                            List<UserSheetBean> sheetList = (List<UserSheetBean>) MyGsonUtil.getInstance().press(o, "sheetList", app);
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
//getArguments()
                       // UserSheetBean userSheetBean = (UserSheetBean) sheetList.get(0);

                    }
                    break;
            }
        }
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
//        if (hidden&&isResumed()){
//            onRefresh();
//        }
    }

    @Override
    public void onResume() {
        super.onResume();
       // onRefresh();
        onRefresh();
    }
    private void onRefresh() {
        if (isFirst) {
            initView();
            isFirst = false;
        }
    }
}
