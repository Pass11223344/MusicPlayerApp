package com.rikkatheworld.wangyiyun.util;



import static com.rikkatheworld.wangyiyun.activity.MainActivity.TOUCH_COUNT;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.firstDownWithRecommend;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isOnClick;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.oldSheetId;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setCurrentPageItem;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setList;
import static com.rikkatheworld.wangyiyun.adapter.home.RecommendableMusicAdapter.list;

import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Point;
import android.graphics.drawable.GradientDrawable;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;

import androidx.annotation.Nullable;
import androidx.palette.graphics.Palette;

import com.google.gson.reflect.TypeToken;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.adapter.home.SpeciallyProducedAdapter;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Type;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

public class Utils {

    private static List<ListBean> recommendableMusicListBeans = new ArrayList<>();
    private static String lastType = "";

    public static int px2dp(Context context, float px) {
        float density = context.getResources().getDisplayMetrics().density;
        return (int) (px / density + 0.5f);
    }

    public static int dp2px(Context context, int dp) {
        float density = context.getResources().getDisplayMetrics().density;
        return (int) (dp * density + 0.5f);
    }

    public static Point getScreen(Context context) {
        Point point = new Point();
        ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay().getSize(point);
        return point;
    }

    public static String numFormat(long number) {
        if (number < 10000) {
            return String.valueOf(number);
        } else if (number < 100000000) {
            long result = (number / 1000);
            int result1 = (int) Math.floor(number / 10000);

            int d = (int) Math.floor(result % 10);
            Log.d("TAG----vvv", "numFormat: " + result + "---" + result1 + "--" + d);
            if (d != 0) {
                return result1 + "." + d + "万";
            } else {
                return result1 + "万";
            }

        } else {
            long result = (number / 10000000);
            int result1 = (int) Math.floor(number / 100000000);

            int d = (int) Math.floor(result % 10);
            Log.d("TAG----vvv", "numFormat: " + result + "---" + result1 + "--" + d);

            if (d != 0) {
                return result1 + "." + d + "亿";
            } else {
                return result1 + "亿";
            }

        }

    }

    public static String dateFormat(long timestamp) {
        Date date = new Date(timestamp); // 将时间戳转换为Date对象
        long currentTimestamp = new Date().getTime();
        long difference = currentTimestamp - timestamp;
        Log.d("TAGqqwqwqwqwqwqwq", "dateFormat: "+timestamp+"ppppppppp"+currentTimestamp+"pppppppp"+difference);
        if (difference < 86400000) {
            if (difference < 3600000) {
                long minutesAgo = TimeUnit.MILLISECONDS.toMinutes(difference) -
                        TimeUnit.HOURS.toMinutes(difference);;
                return String.valueOf(minutesAgo + "分钟前");
            } else {
                long hours = TimeUnit.MILLISECONDS.toHours(difference);
                long minutes = TimeUnit.MILLISECONDS.toMinutes(difference) -
                        TimeUnit.HOURS.toMinutes(hours);
                if (minutes == 0) {
                    return String.valueOf(hours + "小时前");
                }
                return String.valueOf(hours + "小时" + hours + "分钟前");
            }
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 创建日期格式化对象
            String formattedDate = sdf.format(date);
            return formattedDate;
        }

    }
    public static void setColor(Bitmap resource, View view,String ColorStyle){
        Log.d("TAG1111111111111111111111", "onGenerated: "+(resource!=null)+"---"+ColorStyle);
        Palette.from(resource).generate(new Palette.PaletteAsyncListener() {
            //Palette.Swatch dominantSwatch;
            int defaultColor = Color.parseColor("#7a505050"); // 默认灰色
            int titleTextColor=0;
            @Override
            public void onGenerated(@Nullable Palette palette) {

                    //调成图片相配颜色
                assert palette != null;

             //   dominantSwatch = null;
                switch (ColorStyle){
                    case "Dominant":
                        Palette.Swatch dominantSwatch = palette.getDominantSwatch();
                        if (dominantSwatch != null) {
                            titleTextColor = dominantSwatch.getRgb();
                        } else {
                            Log.e("Palette", "Dominant swatch is null");
                        }
                        break;
                    case "Muted":
                        Palette.Swatch mutedSwatch = palette.getMutedSwatch();
                        if (mutedSwatch != null) {
                            titleTextColor = mutedSwatch.getRgb();
                        } else {
                          titleTextColor = defaultColor;
                        }

                        break;
                }

               // assert dominantSwatch != null;

                GradientDrawable gradientDrawable = new GradientDrawable();
                gradientDrawable.setColor(titleTextColor);
                gradientDrawable.setCornerRadii(new float[]{0,0,0,0,24,24,24,24});
                view.setBackground(gradientDrawable);
            }
        });
    }
    public static int getStatusBarHeight(Context context) {
        int px = 0;
        int identifierId = context.getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (identifierId > 0) {
            px = context.getResources().getDimensionPixelSize(identifierId);

        }
        return px;
    }

    public static String getString(ListBean listBean) {
        String name = "";
        if (listBean.getSingerInfo().size()==1){
            return  listBean.getSingerInfo().get(0).name;
        }
        for (int i = 0; i < listBean.getSingerInfo().size(); i++) {

            if (i < listBean.getSingerInfo().size() - 1) {
                name = name + listBean.getSingerInfo().get(i).name + "/";

            } else {
                name = name + listBean.getSingerInfo().get(i).name;
            }
        }


        return name;
    }

    public static String getTime(int duration) {

        // 将毫秒转换为秒
        int durationInSeconds = duration / 1000;
        // 获取分钟数
        int minutes = durationInSeconds / 60;
        // 获取秒数
        int seconds = durationInSeconds % 60;
        String s = seconds >= 10 ? String.valueOf(seconds) : ("0" + seconds);
        String m = minutes >= 10 ? String.valueOf(minutes) : ("0" + minutes);
        return m + ":" + s;
    }
    public static String parseOrpheusURL(String input) {
        String decodedURL = null;

        // 检查并清理前缀
        if (input.startsWith("orpheus://openurl?url=")) {
            input = input.substring("orpheus://openurl?url=".length());  // 去掉前缀 "orpheus:\\\\"
        }

        // 分离主URL和参数部分
      input = input.replaceAll("&#10;", "\n")
               .replaceAll("&#46;", ".")
               .replaceAll("&#32;", " ")
               .replaceAll("&#45;", "-")
               .replaceAll("&#13;", "\r")
               .replaceAll("&#39;", "'")
               .replaceAll("&nbsp;", " ")
               .replaceAll("&apos;", "'")
               .replaceAll("%3a",":")
               .replaceAll("%3f","?")
               .replaceAll("%3d","=")
               .replaceAll("%2f","/");

        return input;
    }

}