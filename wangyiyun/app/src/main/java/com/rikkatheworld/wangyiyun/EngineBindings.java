package com.rikkatheworld.wangyiyun;

import android.app.Activity;
import android.util.Log;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.firstDownWithRecommend;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isOnClick;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;

import com.rikkatheworld.wangyiyun.activity.CommentActivity;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;

import java.util.Map;
import java.util.Objects;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class EngineBindings {
    public final EngineBindingsDelegate delegate;
    public final FlutterEngine engine;
    public final MethodChannel channel;
    private  MainActivity activity;
    private  CommentActivity commentActivity;
    private final App app;

    public EngineBindings(Activity activity, EngineBindingsDelegate  delegate, String entrypoint){

        app = (App) activity.getApplicationContext();
           if (activity instanceof  MainActivity){
               this.activity = (MainActivity) activity;
           }else {this.commentActivity = (CommentActivity)activity;}
            DartExecutor.DartEntrypoint dartEntrypoint = new DartExecutor.DartEntrypoint(
                    FlutterInjector.instance().flutterLoader().findAppBundlePath(), entrypoint
            );
        engine = app.engines.createAndRunEngine(activity, dartEntrypoint);
        this.delegate = delegate;
        channel = new MethodChannel(engine.getDartExecutor().getBinaryMessenger(), "from_flutter");
    }


    public void attach() {

   //     channel.invokeMethod("setCount", DataModel.getInstance().counter);
        channel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "sendSongList":
                    Log.d("TAG1111111aaaaaaaaaa11111", "attach: "+(call.arguments));
                    isOnClick = true;
                    firstDownWithRecommend = true;
                    DataModel.getInstance().set((Map<?, ?>) call.arguments);
                    playerInfo.setTitle(String.valueOf(((Map<?, ?>) call.arguments).get("title")));
                    activityMainBinding.setPlayerInfo(playerInfo);
                    result.success(null);

                    break;
                case "loadComplete":
                    boolean arguments = (boolean) call.arguments;

                    if (!arguments) {

                     activity.setRecommendSheetId("");
                     activity.secondFragment.setOldId("");
                    }
                    result.success(null);
                    break;
                case "addPage":
                    app.page+=1;
                    activity.hideView();
                    if (!call.arguments.equals("")) {
                        Map<String,Object> arguments1 = (Map<String, Object>) call.arguments;

                        activity.setRecommendSheetId(String.valueOf(arguments1.get("sheetId")));
                    }

                    result.success(null);
                    break;
                case "back":
                    if (call.arguments!=""&&!call.arguments.equals("")) {
                        Map<?, ?> map = (Map<?, ?>) call.arguments;

                        switch (String.valueOf(map.get("origin"))){
                            case "my_page":
                                app.page-=1;
                                activity.showView();
                                break;
                            case "other_page":
                                activity.onBackPressed();
                                break;
                            case "not_intercept":
                                app.touchType = TouchType.DEFAULT;
                                activity.onBackPressed();
                                break;
                            case "to_sheet":

                        }
                    }else {

                        activity.showView();
                    }
                    result.success(null);
                    break;
                case "sendAlbum":
                    Log.d("TAG1111111111111111111111111", "attach: 1111111111111111111111111111");
                    isOnClick = true;
                    firstDownWithRecommend = true;
                    DataModel.getInstance().set((Map<?, ?>) call.arguments);
                    playerInfo.setTitle(String.valueOf(((Map<?, ?>) call.arguments).get("title")));
                    activityMainBinding.setPlayerInfo(playerInfo);
                    result.success(null);

                    break;
                default:
                    result.notImplemented();

            }

        });
    }

    /**
     * This tears down the messaging connections on the platform channel and the DataModel.
     */
    public void detach() {
        engine.destroy();

        channel.setMethodCallHandler(null);
    }


    public interface EngineBindingsDelegate {
        void onNext();
    }
}
