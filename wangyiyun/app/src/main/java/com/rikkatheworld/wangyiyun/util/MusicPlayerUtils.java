package com.rikkatheworld.wangyiyun.util;

import android.os.Environment;
import android.util.Log;

import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.MusicCacheBean;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

    public class MusicPlayerUtils {


        // 将List<ListBean>序列化到文件
        public static void serializeList(MusicCacheBean musicCacheBean, String fileName) {


            try {
                FileOutputStream fileOut = new FileOutputStream(fileName,false);
                ObjectOutputStream out = new ObjectOutputStream(fileOut);

                out.writeObject(musicCacheBean);
                out.close();
                fileOut.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 从文件反序列化得到List<ListBean>
        public static MusicCacheBean deserializeList(String filePath) {
            MusicCacheBean musicCacheBean = null;
            try (FileInputStream fis = new FileInputStream(filePath);
                 ObjectInputStream ois = new ObjectInputStream(fis)) {

                musicCacheBean = (MusicCacheBean) ois.readObject();

            } catch (IOException e) {
                Log.e("TAG", "IOException occurred: " + e.getMessage());
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                Log.e("TAG", "ClassNotFoundException occurred: " + e.getMessage());
                e.printStackTrace();
            }
            return musicCacheBean;
        }
    }
