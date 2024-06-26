package com.rikkatheworld.wangyiyun.bean.My;

import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

import com.google.gson.annotations.SerializedName;

public class UserSheetBean implements Parcelable {
private String creatorAvatarUrl;
    private long creatorId;
    private String nickname;
    private long sheetId;
    private String coverImgUrl;
    private long trackCount;
    private String name;

    public UserSheetBean() {

    }

    protected UserSheetBean(Parcel in) {
        creatorAvatarUrl = in.readString();
        creatorId = in.readLong();
        nickname = in.readString();
        sheetId = in.readLong();
        coverImgUrl = in.readString();
        trackCount = in.readLong();
        name = in.readString();
    }

    public static final Creator<UserSheetBean> CREATOR = new Creator<UserSheetBean>() {
        @Override
        public UserSheetBean createFromParcel(Parcel in) {
            return new UserSheetBean(in);
        }

        @Override
        public UserSheetBean[] newArray(int size) {
            return new UserSheetBean[size];
        }
    };

    public String getCreatorAvatarUrl() {
        return creatorAvatarUrl;
    }

    public void setCreatorAvatarUrl(String creatorAvatarUrl) {
        this.creatorAvatarUrl = creatorAvatarUrl;
    }

    public long getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(long creatorId) {
        this.creatorId = creatorId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public long getSheetId() {
        return sheetId;
    }

    public void setSheetId(long sheetId) {
        this.sheetId = sheetId;
    }

    public String getCoverImgUrl() {
        return coverImgUrl;
    }

    public void setCoverImgUrl(String coverImgUrl) {
        this.coverImgUrl = coverImgUrl;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public long getTrackCount() {
        return trackCount;
    }

    public void setTrackCount(long trackCount) {
        this.trackCount = trackCount;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(@NonNull Parcel dest, int flags) {
        dest.writeString(creatorAvatarUrl);
        dest.writeLong(creatorId);
        dest.writeString(nickname);
        dest.writeLong(sheetId);
        dest.writeString(coverImgUrl);
        dest.writeLong(trackCount);
        dest.writeString(name);
    }

    public class Datas{
        public String coverImgUrl;
        public String name;
        public long id;
        public int trackCount;
        @SerializedName("creator")
        public Creator creator;
        public  class Creator {
          public String avatarUrl;
          public long userId;
          public String nickname;
        }
    }
}
