package com.rikkatheworld.wangyiyun.util;

import android.content.Context;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;

public class FileUtils {
    public static void writeStringToFile(Context context, String fileName, String content) {
        FileOutputStream fos = null;
        try {
            File file = new File(context.getFilesDir(), fileName);
            fos = new FileOutputStream(file,false);
            fos.write(content.getBytes());
        } catch (IOException e) {
            e.printStackTrace(); // 处理异常
        } finally {
            if (fos != null) {
                try {
                    fos.close();
                } catch (IOException e) {
                    e.printStackTrace(); // 处理异常
                }
            }
        }
    }
    public static String readStringFromFile(Context context, String fileName) {
        StringBuilder stringBuilder = new StringBuilder();
        FileInputStream fis = null;
        BufferedReader reader = null;
        try {
            File file = new File(context.getFilesDir(), fileName);
            fis = new FileInputStream(file);
            reader = new BufferedReader(new InputStreamReader(fis));
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
                stringBuilder.append('\n');
            }
        } catch (IOException e) {
            e.printStackTrace(); // 处理异常
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    e.printStackTrace(); // 处理异常
                }
            }
        }
        return stringBuilder.toString();
    }
}
