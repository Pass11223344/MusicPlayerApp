package com.rikkatheworld.wangyiyun.provider;

import static com.rikkatheworld.wangyiyun.provider.UserDB.TABLE_NAME;

import android.content.ContentProvider;
import android.content.ContentUris;
import android.content.ContentValues;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class UserProvider extends ContentProvider {


    private static final int USER_TABLE = 1;
    private static final int USER_TABLE_ID = 2;
    private static final UriMatcher uriMatcher;

    static {
        uriMatcher = new UriMatcher(UriMatcher.NO_MATCH);
        uriMatcher.addURI("com.rikkatheworld.wangyiyun", "saveUser", USER_TABLE);
        uriMatcher.addURI("com.rikkatheworld.wangyiyun", "saveUser/#", USER_TABLE_ID);
    }
    private UserDB userDB;
    @Override
    public boolean onCreate() {
        if (userDB ==null) {
            userDB = new UserDB(getContext());
        }
        return true;
    }

    @Nullable
    @Override
    public Cursor query(@NonNull Uri uri, @Nullable String[] projection, @Nullable String selection, @Nullable String[] selectionArgs, @Nullable String sortOrder) {
        SQLiteDatabase db = userDB.getReadableDatabase();
        switch (uriMatcher.match(uri)){
            case  USER_TABLE_ID:
                String id = uri.getLastPathSegment(); // Gets the ID from the URI
                String selectionWithId = "userId = ?";
                String[] selectionArgsWithId = new String[]{id};
                return db.query(TABLE_NAME, projection, selectionWithId, selectionArgsWithId, null, null, sortOrder);
            default:
                throw new IllegalArgumentException("Unknown URI: " + uri);
        }
    }

    @Nullable
    @Override
    public String getType(@NonNull Uri uri) {
        switch (uriMatcher.match(uri)) {
            case USER_TABLE:
                return "vnd.android.cursor.dir/vnd.example.usertable";
            case USER_TABLE_ID:
                return "vnd.android.cursor.item/vnd.example.usertable";
            default:
                throw new IllegalArgumentException("Unsupported URI: " + uri);
        }
    }

    @Nullable
    @Override
    public Uri insert(@NonNull Uri uri, @Nullable ContentValues values) {
        SQLiteDatabase db = userDB.getWritableDatabase();
        long insert = db.insert(TABLE_NAME, null, values);
        return ContentUris.withAppendedId(uri, insert);
    }

    @Override
    public int delete(@NonNull Uri uri, @Nullable String selection, @Nullable String[] selectionArgs) {
        SQLiteDatabase db = userDB.getWritableDatabase();
        return db.delete(TABLE_NAME,selection,selectionArgs);
    }

    @Override
    public int update(@NonNull Uri uri, @Nullable ContentValues values, @Nullable String selection, @Nullable String[] selectionArgs) {
        SQLiteDatabase db = userDB.getWritableDatabase();
        switch (uriMatcher.match(uri)){
            case  USER_TABLE_ID:
                String id = uri.getLastPathSegment(); // Gets the ID from the URI
                String selectionWithId = "userId = ?";
                String[] selectionArgsWithId = new String[]{id};
                return db.update(TABLE_NAME, values, selectionWithId, selectionArgsWithId);
            default:
                throw new IllegalArgumentException("Unknown URI: " + uri);
        }
    }
}
