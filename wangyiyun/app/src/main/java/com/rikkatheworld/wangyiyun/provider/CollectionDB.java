package com.rikkatheworld.wangyiyun.provider;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

public class CollectionDB extends SQLiteOpenHelper {
   private static final int DB_VERSION = 1;
   private static final String DB_NAME = "music_db";
   public static final String TABLE_NAME = "collection_table";
    public CollectionDB(@Nullable Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
           String sql = "CREATE TABLE "+TABLE_NAME +"(_id INTEGER PRIMARY KEY," +
                   "songName VARCHAR(30))";
           db.execSQL(sql);
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
