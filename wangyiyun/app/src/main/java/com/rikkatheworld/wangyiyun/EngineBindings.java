package com.rikkatheworld.wangyiyun;

import android.app.Activity;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.AUTO_PLAY;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.isOnClick;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;

import com.rikkatheworld.wangyiyun.activity.CommentActivity;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;

import java.io.File;
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
                    AUTO_PLAY = true;
                    Log.d("TAG1111111aaaaaaaaaa11111", "1111111111111111111111111111");
                    isOnClick = true;

                    DataModel.getInstance().set((Map<?, ?>) call.arguments);
               //    app.touchType = TouchType.FLUTTER_SONG;
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

                    Log.d("TAG2222222222222222222222222", "attach: 执行"+(!call.arguments.equals("")));
                    if (call.arguments.equals("chatPage")) {
                        app.page+=1;
                        activity.hideView();
                        activity.hide();
                        result.success(null);
                        break;
                    }else {
                        activity.hideView();
                    }


                    result.success(null);
                    break;
                case "back":
                    if (call.arguments!=""&&!call.arguments.equals("")) {
                        Map<?, ?> map = (Map<?, ?>) call.arguments;
                        switch (String.valueOf(map.get("origin"))){
                            case "my_page":
//                                app.page-=1;
                             activity.showView();
                                break;
                           case "my_page2":
                               app.isOpenFence = true;
                               activity.onBackPressed();
                               break;
                            case "other_page":
                            case "not_intercept":
                                app.touchType = TouchType.DEFAULT;
                                activity.onBackPressed();
                                break;
                            case "to_sheet":

                        }
                    }else {
                        Log.d("TAGwotmzoulzhe", "attach: 1");
                        app.page-=1;
                        activity.showView();
                    }
                    result.success(null);
                    break;
                case "sendAlbum":
                    AUTO_PLAY = true;
                    isOnClick = true;

                    DataModel.getInstance().set((Map<?, ?>) call.arguments);
                    playerInfo.setTitle(String.valueOf(((Map<?, ?>) call.arguments).get("title")));
                    activityMainBinding.setPlayerInfo(playerInfo);
                    result.success(null);

                    break;
                case  "requestPermission":
                    Map<?, ?> info = ((Map<?, ?>) call.arguments);

                    activity.requestPermission(info);
                    result.success(null);
                    break;
                case "getPath":
                    File downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
                    String downloadsPath = downloadsDir.getAbsolutePath();
                    result.success(downloadsPath);
                    break;
                case "upDataImage":
                    String path = String.valueOf(call.arguments);
                    activity.upImage(path);
                    break;
                case"upSheetId":

                    if (!call.arguments.equals("")) {
                       // app.page+=1;
                        Map<String,Object> arguments1 = (Map<String, Object>) call.arguments;
//                        if (-1 == (int) arguments1.get("id")) {
//                            activity.hideView();
//                            return;
//                        }else if(-2 == (int) arguments1.get("id")){
//                            return;
//                        }
                        activity.hideView();
                        activity.setRecommendSheetId(String.valueOf(arguments1.get("sheetId")));
                    }else activity.hideView();
                    result.success(null);
                    break;
                case "hideOrShowView":
                   boolean flag = (boolean) call.arguments;
                    if (flag) {
                        activity.hide();
                    }else {
                        activity.show();
                    }

                    result.success(null);
                    break;
                case  "FoldOrUnfold":
                    boolean flag1 = (boolean) call.arguments;
                    if (flag1) {
                        activity.setStop();

                        activity.hideView();
                        activity.hide();
                    }else {
                        activity.showView();

                    }
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
