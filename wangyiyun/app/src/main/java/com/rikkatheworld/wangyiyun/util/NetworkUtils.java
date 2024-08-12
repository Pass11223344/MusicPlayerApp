package com.rikkatheworld.wangyiyun.util;

import static android.content.ContentValues.TAG;
import static android.content.Context.MODE_PRIVATE;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.rikkatheworld.wangyiyun.activity.LoginPage;

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;


import okhttp3.Call;

import okhttp3.Callback;
import okhttp3.FormBody;
import okhttp3.Headers;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class NetworkUtils {

    private static OkHttpClient okHttpClient;
    private static String result;

    private static Request request;
    private static String token;

    public static void makeRequest(String url, Handler handler, int id, boolean flag, Context context){


        okHttpClient = new OkHttpClient
                .Builder()
                .addInterceptor(new AuthInterceptor())
                .build();
        if (flag) {

            SharedPreferences share = context.getSharedPreferences("UserInfoData",MODE_PRIVATE);

            token = share.getString("token", "");


        }
            request = new Request.Builder()
                    .url(url)
                    .get()
                    .build();


       Call call = okHttpClient.newCall(request);
       call.enqueue(new Callback() {
   @Override
           public void onFailure(Call call, IOException e) {
           }

           @Override
           public void onResponse(Call call, Response response) throws IOException {
               if (response.body()!=null) {

                    result = response.body().string();
                   Message message = new Message();
                   message.obj = result;
                   message.what = id;
                   handler.sendMessage(message);

               }
           }
       });

    }

    private static class AuthInterceptor implements Interceptor {
        @Override
        public Response intercept(Chain chain) throws IOException {
            Request originalRequest = chain.request();

            // 添加token到请求头
            Request authenticatedRequest = originalRequest.newBuilder()
                    .header("cookie", "MUSIC_U=" + token)
                    .build();

            return chain.proceed(authenticatedRequest);
        }
    }
}
