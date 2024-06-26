package com.rikkatheworld.wangyiyun.bean.Home;

public class ExclusiveMusicBean {
  private   String type;
  private Value value;

public   class Value {
      public ConcentrationBean.Data.Creatives.Resources.ResourceExtInfo.SongData songData;

      public ConcentrationBean.Data.Creatives.Resources.ResourceExtInfo.SongData getSongData() {
          return songData;
      }

      public void setSongData(ConcentrationBean.Data.Creatives.Resources.ResourceExtInfo.SongData songData) {
          this.songData = songData;
      }
  }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Value getValue() {
        return value;
    }

    public void setValue(Value value) {
        this.value = value;
    }
}
