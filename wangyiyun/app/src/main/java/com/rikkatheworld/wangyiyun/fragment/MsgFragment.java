package com.rikkatheworld.wangyiyun.fragment;



import static com.rikkatheworld.wangyiyun.activity.MainActivity.MSG_ENGINE_ID;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
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


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.google.gson.Gson;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.EngineBindings;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.LoginPage;
import com.rikkatheworld.wangyiyun.bean.Msg.NotificationListBean;
import com.rikkatheworld.wangyiyun.bean.My.UserInfoBean;
import com.rikkatheworld.wangyiyun.util.MsgGsonUtil;
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

public class MsgFragment extends Fragment implements EngineBindings.EngineBindingsDelegate{
private final int RES_ID = 1;

private final int LOGIN = 2;




    public static MsgHandler handler;

    private String json;
    public EngineBindings msgBindings;
    private boolean isPrepare;
    private boolean isFirstLoad   = true;
    private App app;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.msg_fragment,container,false);

    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        Log.d("TAGggggggggggghhhhh", "onActivityCreated:我已运行222 ");

        getMsgBindings();
        //onRefresh();
        app = (App) getActivity().getApplicationContext();
    }


    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
        Log.d("TAGggggggggggghhhhh", "onActivityCreated:我已运行2 ");

//        if (hidden && isResumed()){
//
//        }
    }



    private void onRefresh() {

        if (isFirstLoad) {
            initView();
            LoadData();
            isFirstLoad = false;
        }
    }

    private void initView() {
        if (handler==null) {
            handler = new MsgHandler();
        }

//        FrameLayout msg_rootView = getView().findViewById(R.id.msg_rootView);
//        int px = Utils.getStatusBarHeight(getContext());
//            msg_rootView.setPadding(0, px, 0, 0);





    }

    @Override
    public void onDestroy() {
        super.onDestroy();

    }

    @Override
    public void onResume() {
        super.onResume();

            onRefresh();

        Log.d("TssssAG", "onStart: -------");
    }

    @Override
    public void onStart() {
        super.onStart();

    }

    public void LoadData() {
        try {
            NetworkUtils.makeRequest(NetworkInfo.URL + "/msg/private",MsgFragment.handler,RES_ID,true,getContext());

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void onNext() {

    }

    public    class  MsgHandler extends Handler{

        private JSONObject data;
        private String account;


        @Override
        public void dispatchMessage(@NonNull Message msg) {
            super.dispatchMessage(msg);

            switch (msg.what){

//                case STATUS :
//                    String string = msg.obj.toString();
//                    if (string!=null) {
//
//                        JSONObject jsonObject = null;
//                        try {
//                            jsonObject = new JSONObject(string);
//                            if (jsonObject.has("data")) {
//                                data = (JSONObject) jsonObject.get("data");
//                                account = String.valueOf(data.get("account"));
//                            }else {
//                                account = String.valueOf(jsonObject.get("account"));
//                            }
//
//                            if (account.equals("null")) {
//                                Intent intent = new Intent(getContext(), LoginPage.class);
//                                startActivity(intent);
//                            }else if(json==null){
//                                Log.d("TAG11111111111111111111111", "dispatchMessage: ssss1111");
//
//                                NetworkUtils.makeRequest(NetworkInfo.URL + "/msg/private",MsgFragment.handler,RES_ID,true,getContext());
//
//                            }
//
//                        } catch (JSONException e) {
//                            throw new RuntimeException(e);
//                        }
//
//
//                    }
//
//                    break;
                case RES_ID:
                   String str = msg.obj.toString();
                    if (str!=null) {

                        List<NotificationListBean> notificationInfo = MsgGsonUtil.getInstance().press(str, "NotificationInfo",getActivity());

                        Gson gson = new Gson();
                        json = gson.toJson(notificationInfo);
                        SharedPreferences userInfoData = getContext().getSharedPreferences("UserInfoData", Context.MODE_PRIVATE);
                        String string1 = userInfoData.getString("token","");
                        String string = userInfoData.getString("UserInfo","");
                        if (!string.equals("")|| !TextUtils.isEmpty(string)&&  playerInfo.getUserInfoBean()==null) {
                            try {
                                JSONObject info = new JSONObject(string);
                                String profile = String.valueOf(info.get("profile"));
                                UserInfoBean userInfo = (UserInfoBean) MyGsonUtil.getInstance().press(profile, "userInfo", getActivity()).get(0);
                                playerInfo.setUserInfoBean(userInfo);
                                activityMainBinding.setPlayerInfo(playerInfo);

                            } catch (JSONException e) {
                                throw new RuntimeException(e);
                            }
                        }
                        Log.d("TAG11111111111111111111111", "dispatchMessage: "+string1);
                        app.Cookie = string1;
                        if (json!=null){
                            FlutterEngineCache.getInstance().put(MSG_ENGINE_ID,msgBindings.engine);
                            msgBindings.attach();
                            FlutterFragment msgflutterFragment = FlutterFragment.withCachedEngine(MSG_ENGINE_ID)
                                   .renderMode(RenderMode.texture)
                                    .build();
                            Map<String,Object> map = new HashMap<>();
                            map.put("json" ,json);
                            map.put("token" ,string1);
                            map.put("userId",playerInfo.getUserInfoBean().getUserId());
                            msgBindings.channel.invokeMethod("to_msgPage", map);
                            getActivity().getSupportFragmentManager()
                                    .beginTransaction()
                                    .add(R.id.FV_msg_list,msgflutterFragment)
                                    .commit();
                        }


                    }

                    break;
            }
        }
    }
    private EngineBindings getMsgBindings() {
        if (msgBindings == null) {
            msgBindings = new EngineBindings(getActivity(), this, "msgMain");
        }

        return msgBindings;
    }


}

