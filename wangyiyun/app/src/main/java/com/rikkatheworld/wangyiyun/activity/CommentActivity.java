package com.rikkatheworld.wangyiyun.activity;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.FrameLayout;

import androidx.activity.EdgeToEdge;
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

        String num = "";
        switch ((CommentType) extras.get("commentType")){
            case T_SONG://0
               num = "0";
                break;
            case T_SHEET://2
                num = "2";
                break;
            case T_ALBUM://3
                num = "3";
                break;
            case T_DYNAMIC://6
                num = "6";
                break;
        }

        map.put("songName",extras.getString("songName"));
        map.put("commentType",num);
        map.put("commentUrl","/comment/new");
        map.put("songId",extras.getLong("songId"));
        map.put("singerName",extras.getString("singerName"));
        map.put("imgUrl",extras.getString("imgUrl"));
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
}