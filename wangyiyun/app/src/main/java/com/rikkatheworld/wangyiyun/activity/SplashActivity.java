package com.rikkatheworld.wangyiyun.activity;

import static android.content.ContentValues.TAG;
import static com.rikkatheworld.wangyiyun.activity.LoadCompleteReceiver.ACTION_LOAD_COMPLETE;

import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import com.google.android.material.snackbar.Snackbar;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Message;
import android.util.Log;
import android.view.View;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.rikkatheworld.wangyiyun.databinding.ActivitySplashBinding;

import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;
import com.rikkatheworld.wangyiyun.util.NetworkUtils;

import java.io.IOException;
import java.util.logging.Handler;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttp;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class SplashActivity extends AppCompatActivity {


    private LocalBroadcastManager localBroadcastManager;
    private LoadCompleteReceiver loadCompleteReceiver;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        // 清除Activity的进入动画
        overridePendingTransition(0, 0);
        IntentFilter filter = new IntentFilter(ACTION_LOAD_COMPLETE);
        loadCompleteReceiver = new LoadCompleteReceiver(this);
        localBroadcastManager = LocalBroadcastManager.getInstance(this);
        localBroadcastManager.registerReceiver(loadCompleteReceiver,filter);

        loadData();



    }

    private void loadData() {
        try {
            OkHttpClient httpClient = new  OkHttpClient.Builder()
                    .build();

            Request request = new Request.Builder()
                    .url(NetworkInfo.URL + "/homepage/block/page")
                    .build();
            Call call = httpClient.newCall(request);
            call.enqueue(new Callback() {
                @Override
                public void onFailure(@NonNull Call call, @NonNull IOException e) {

                }

                @Override
                public void onResponse(@NonNull Call call, @NonNull Response response) throws IOException {
                    if (response.body()!=null) {
                        String result = response.body().string();
                        Intent intent = new Intent(ACTION_LOAD_COMPLETE);
                        intent.putExtra("result",result);
                        LocalBroadcastManager.getInstance(SplashActivity.this).sendBroadcast(intent);

                    }
                }
            });


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        localBroadcastManager.unregisterReceiver(loadCompleteReceiver);
    }
}