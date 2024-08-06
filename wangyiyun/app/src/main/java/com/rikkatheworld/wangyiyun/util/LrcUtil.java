package com.rikkatheworld.wangyiyun.util;

import static android.content.ContentValues.TAG;

import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.rikkatheworld.wangyiyun.bean.Home.LrcBean;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

/**
 * 将歌词解析成List<LrcBean>
 * */
public class LrcUtil {

    private static String mills;
    //private static String timeText;
   // private static String[] times;
   // private static String timesInfo;
    private static JSONObject jsonObject;
 //   private static String tMills;


    public  static List<LrcBean> parseStr2List(String lrcStr, String tLrc){
        if (TextUtils.isEmpty(lrcStr)) return null;
        List<LrcBean> list = new ArrayList<>();
        String lrcText = getText(lrcStr);
        String[] split = lrcText.split("\n");




        long startTime = 0;
       // long duration = 0;
        try{
            for (int i = 0; i <  split.length; i++) {
                String lrc="";
                String lrcInfo = split[i];
                if ("".equals(lrcInfo)|| TextUtils.isEmpty(lrcInfo)) continue;
                if (lrcInfo.indexOf("}]}",lrcInfo.indexOf("{"))!=-1) {
                    try {
                        jsonObject = new JSONObject(split[i]);
                        if (jsonObject.has("t")) {
                            startTime = Long.parseLong(jsonObject.getString("t"));
                        }
                        if (jsonObject.has("c")) {
                            JSONArray contentArray = jsonObject.getJSONArray("c");
                            for (int j = 0; j < contentArray.length(); j++) {
                                JSONObject contentObject = contentArray.getJSONObject(j);
                                if (contentObject.has("tx")) {
                                    lrc = lrc+contentObject.getString("tx");
                                }
                            }
                        }
                        LrcBean lrcBean = new LrcBean(lrc,startTime);
                        list.add(lrcBean);

                        list.get(list.size()-1).setEnd(startTime+200);


                    } catch (JSONException e) {
                        throw new RuntimeException(e);
                    }

                }else {

                    if (lrcInfo.contains("]")) {

                        lrc = lrcInfo.substring(lrcInfo.indexOf("]")+1);

                        if ("".equals(lrc)|| TextUtils.isEmpty(lrc)||"//".equals(lrc))
                            continue;
                        LrcBean lrcBean = new LrcBean(lrc);
                        list.add(lrcBean);
                        // if (times==null){
                        String min = lrcInfo.substring(lrcInfo.indexOf("[") + 1, lrcInfo.indexOf("[") + 3);
                        if (min.contains(":")) {
                            min = lrcInfo.substring(lrcInfo.indexOf("[") + 1, lrcInfo.indexOf("[") + 2);
                        }
                        String seconds = lrcInfo.substring(lrcInfo.indexOf(":") + 1, lrcInfo.indexOf("]"));
                        Log.d("TAGpwwwwwwwwwww", "parseStr2List: "+min+"sss"+seconds);
                        startTime = (long) (Long.parseLong(min)*60*1000 +
                                Double.parseDouble(seconds)*1000);

                        lrcBean.setStart(startTime);
                        if (list.size()>1) {
                            list.get(list.size()-2).setEnd(startTime);
                        }
                        if (i == split.length - 1) list.get(list.size() - 1).setEnd(startTime + 2000);



                    }else {
                        LrcBean lrcBean = new LrcBean(lrcInfo,0);
                        list.add(lrcBean);
                    }

                }
            }

            String tLrcText = getText(tLrc);
            String[] tLrcSplit = tLrcText.split("\n");
            for (int i = 0; i < tLrcSplit.length; i++) {
                if (tLrcSplit[i].contains("by")) continue;
                if (tLrcSplit[i].equals(""))continue;
                String s = tLrcSplit[i];
                String tLrcString = s.substring(s.indexOf("]") + 1);
                if (tLrcString.equals(""))continue;
                String min = s.substring(s.indexOf("[") + 1, s.indexOf("[") + 3);
                String seconds = s.substring(s.indexOf(":") + 1, s.indexOf("]") );

                long  startTimes = (long) (Long.parseLong(min)*60*1000 +
                        Double.parseDouble(seconds)*1000);
                for (LrcBean lrcBean : list) {
                    if (lrcBean.getStart()>=startTimes) {
                        lrcBean.setTranslateLrc(tLrcString);
                        break;
                    }
                }

            }

            return list;
        }catch (Exception ignored){
            list.clear();
            list.add(new LrcBean("暂无歌词"));
            return  list;
        }

    }



    @NonNull
    private static String getText(String lrcStr) {
        String lrcText = lrcStr.replaceAll("&#58;", ":")
                .replaceAll("&#10;", "\n")
                .replaceAll("&#46;", ".")
                .replaceAll("&#32;", " ")
                .replaceAll("&#45;", "-")
                .replaceAll("&#13;", "\r")
                .replaceAll("&#39;", "'")
                .replaceAll("&nbsp;", " ")
                .replaceAll("&apos;", "'")
                .replaceAll("&&;", "/")
                .replaceAll("\\|;", "/");
        return lrcText;
    }


    public static String parseLrcFile(String MusicPath) throws IOException {
        if (TextUtils.isEmpty(MusicPath)|| !MusicPath.contains(".lrc")) return null;
        Log.d(TAG, "歌词路径------->: "+MusicPath);
        File file = new File(MusicPath);
        FileInputStream fil = null;
        BufferedInputStream bis = null;
        StringBuilder LrcStr = new StringBuilder();
        BufferedReader reader = null;

        try {
            fil = new FileInputStream(file);
            bis = new BufferedInputStream(fil);
            reader = new BufferedReader(new InputStreamReader(bis, StandardCharsets.UTF_8));
            String str = reader.readLine();
            while (str!=null){
                LrcStr.append(str).append("\n");
                str = reader.readLine();
            }
        } catch (IOException e) {
            return null;
        }finally {
            if (fil!=null) {
                fil.close();
                if (bis!=null) bis.close();
            }
        }

        return LrcStr.toString();
    }

    public static boolean JudgingLanguage(@NonNull String str1,@NonNull String str2){
            boolean str1NotChinese,str2IsChinese;
        Pattern p = Pattern.compile("[\u4e00-\u9fa5]");
        Pattern r = Pattern.compile("[\u3040-\u309F\u30A0-\u30FF]");
        str1NotChinese = r.matcher(str1).find()||!p.matcher(str1).find();
        str2IsChinese = !r.matcher(str1).find() && p.matcher(str1).find();
        return  str2IsChinese && str1NotChinese;
    }
    public static String getLrcFilePath(String musicFilePath){
        if (musicFilePath.equals("")|| TextUtils.isEmpty(musicFilePath)) {
            return null;
        }
        String absPath = getLocalPathPictures(musicFilePath);
        return FileExists(absPath) ? absPath : null;
    }
    public static String getLocalPathPictures(String fileName){
        fileName = fileName.replaceAll("/", "&");
        String absPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC)+"/";
        return fileName+absPath;
    }
    public static boolean FileExists(String targetFileAbsPath){
        File file = new File(targetFileAbsPath);
        if (!file.exists())return false;
        return true;
    }
}
