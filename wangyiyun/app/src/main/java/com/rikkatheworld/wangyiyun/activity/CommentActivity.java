package com.rikkatheworld.wangyiyun.activity;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import androidx.activity.EdgeToEdge;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.rikkatheworld.wangyiyun.EngineBindings;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class CommentActivity extends AppCompatActivity implements EngineBindings.EngineBindingsDelegate {

    private FrameLayout comment_view;
    private EngineBindings commentBindings;
    private final static String COMMENT_ENGINE_ID = "comment_engine_id";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_comment);

        getCommentBindings();
        initView();



    }

    private void initView() {

        Bundle extras = getIntent().getExtras();
        Map<String ,Object> map = new HashMap<>();
        map.put("songName",extras.getString("songName"));
        map.put("commentType",0);
       // map.put("commentUrl","/comment/new");
        map.put("Id",extras.getLong("Id"));
        map.put("singerName",extras.getString("singerName"));
        map.put("imgUrl",extras.getString("imgUrl"));
            map.put("userId",extras.getString("userId"));
        FlutterEngineCache.getInstance().put(COMMENT_ENGINE_ID,commentBindings.engine);
        FlutterFragment commentFragment = FlutterFragment.withCachedEngine(COMMENT_ENGINE_ID)
                .build();
        commentBindings.channel.invokeMethod("commentChannel",map);
        getSupportFragmentManager()
                .beginTransaction()
                .add(R.id.comment_view,commentFragment)
                .commit();
    }

    public EngineBindings getCommentBindings(){
        if (commentBindings==null) {
            commentBindings = new EngineBindings(this,this,"CommentPage");

        }
        return commentBindings;
    }

    @Override
    public void onNext() {

    }

    @Override
    public void onBackPressed() {

        commentBindings.channel.invokeMethod("canPop", "", new MethodChannel.Result() {
            @Override
            public void success(@Nullable Object result) {
                boolean canPop = (boolean) result;
                if(canPop){
                    Log.d("TAG-------", "successdddddd: "+canPop);
                    CommentActivity.super.onBackPressed();
                }
            }

            @Override
            public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {

            }

            @Override
            public void notImplemented() {

            }
        });

        return;
    }

}