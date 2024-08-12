package com.rikkatheworld.wangyiyun.util;




import android.content.Context;
import android.util.Log;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonParser;
import com.google.gson.reflect.TypeToken;
import com.rikkatheworld.wangyiyun.adapter.home.RecommendableMusicAdapter;
import com.rikkatheworld.wangyiyun.bean.Home.ConcentrationBean;
import com.rikkatheworld.wangyiyun.bean.Home.ExclusiveSceneSongListBean;
import com.rikkatheworld.wangyiyun.bean.Home.MusicRadarBean;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendableMusicsBean;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendedPlaylistsBean;
import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.bean.Home.SpeciallyProducedBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;
//使用这种方式是因为想让类直接获取不需要总是往下链接:A.B.C.name
public class Home_GsonUtil {
    private static Home_GsonUtil gson;

    private String id="";
    private Context context;
    private List<ConcentrationBean.Data.Creatives.Resources.ResourceExtInfo.SongData.Artists> artists;

    public Home_GsonUtil() {
    }

    public static Home_GsonUtil getInstance() {
        if (gson == null) {
            return new Home_GsonUtil();
        }
        return gson;
    }

    public <T> List<T> press(String str, Class<T> clazz, String code, Context context) {
        this.context = context;
        Gson gson = new Gson();

        try {
            JSONObject object = new JSONObject(str);
            JSONObject data = (JSONObject) object.get("data");
            JSONArray blocks = (JSONArray) data.get("blocks");
            for (int i = 0; i < blocks.length(); i++) {

                JSONObject jsonObject = blocks.getJSONObject(i);
                String blockCode = (String) jsonObject.get("blockCode");
                switch (code) {
                    case "HOMEPAGE_BANNER":
                        List<T> bannerList = new ArrayList<>();
                        if (blockCode.equals(code)) {
                            JSONObject extInfo = (JSONObject) jsonObject.get("extInfo");
                            JsonElement jsonElement = JsonParser.parseString(extInfo.get("banners").toString());
                            JsonArray banners = jsonElement.getAsJsonArray();
                            for (JsonElement e : banners) {
                                bannerList.add(gson.fromJson(e, clazz));
                            }

                            return bannerList;
                        }
                        break;
                    case "HOMEPAGE_BLOCK_PLAYLIST_RCMD":

                        if (code.equals(blockCode)) {
                            JSONArray creatives = (JSONArray) jsonObject.get("creatives");
                            List<Object> recommended_playlist = new ArrayList<>();
                            List<RecommendedPlaylistsBean> internal_list = new ArrayList<>();
                            for (int j = 0; j < creatives.length(); j++) {
                                JSONObject scroll_Item = creatives.getJSONObject(j);
                                JSONArray resources = (JSONArray) scroll_Item.get("resources");

                                if (j == 0) {

                                    for (int k = 0; k < resources.length(); k++) {

                                        JSONObject resources_json = resources.getJSONObject(k);
                                        JSONObject uiElement = (JSONObject) resources_json.get("uiElement");
                                        JSONObject mainTitle = (JSONObject) uiElement.get("mainTitle");

                                        String resourceId = (String) resources_json.get("resourceId");
                                        String title = (String) mainTitle.get("title");
                                        JSONObject image = (JSONObject) uiElement.get("image");
                                        String imageUrl = (String) image.get("imageUrl");
                                        JSONObject resourceExtInfo = (JSONObject) resources_json.get("resourceExtInfo");
                                        long playCount = Long.parseLong(String.valueOf(resourceExtInfo.get("playCount")));
                                        RecommendedPlaylistsBean internal_bean = new RecommendedPlaylistsBean(playCount, title, imageUrl,resourceId);
                                        internal_list.add(internal_bean);


                                    }
                                    recommended_playlist.add(internal_list);

                                } else {

                                    JSONObject resources_json = resources.getJSONObject(0);
                                    JSONObject uiElement = (JSONObject) resources_json.get("uiElement");
                                    String resourceId = (String) resources_json.get("resourceId");

                                    JSONObject mainTitle = (JSONObject) uiElement.get("mainTitle");
                                    String title = (String) mainTitle.get("title");

                                    JSONObject image = (JSONObject) uiElement.get("image");
                                    String imageUrl = (String) image.get("imageUrl");

                                    JSONObject resourceExtInfo = (JSONObject) resources_json.get("resourceExtInfo");

                                    long playCount = Long.parseLong(String.valueOf(resourceExtInfo.get("playCount"))) ;

                                    RecommendedPlaylistsBean  bean = new RecommendedPlaylistsBean(playCount, title, imageUrl,resourceId);
                                    recommended_playlist.add(bean);

                                }

                            }

                            return (List<T>) recommended_playlist;


                        }
                        break;
                    case "HOMEPAGE_BLOCK_NEW_ALBUM_NEW_SONG":

                        if (blockCode.equals(code)) {

                            String creatives = String.valueOf(jsonObject.get("creatives"));
                            String title, picUrl, transName, singerName = "";
                            String[] split = creatives.split(",");

                            SinglesAndAlbumsBean.Data[] json = gson.fromJson(creatives, SinglesAndAlbumsBean.Data[].class);
                            List<List<SinglesAndAlbumsBean>> singLess_albumsList = new ArrayList<>();
                            List<SinglesAndAlbumsBean> list;
                            for (SinglesAndAlbumsBean.Data data1 : json) {
                                String creativeType = data1.creativeType;
                                list = new ArrayList<>();
                                for (SinglesAndAlbumsBean.Resources resource : data1.resources) {

                                    title = resource.uiElement.mainTitle.title;
                                    picUrl = resource.uiElement.image.imageUrl;
                                    transName = resource.uiElement.subTitle.title;
                                    String resourceType = resource.resourceType;
                                    String resourceId = resource.resourceId;

                                    SinglesAndAlbumsBean singlesAndAlbumsBean = new SinglesAndAlbumsBean(resource.action,resource.resourceExtInfo.artists,picUrl,title,transName,resourceType,resourceId,creativeType);
                                    list.add(singlesAndAlbumsBean);
                                }

                                singLess_albumsList.add(list);


                            }


                            return (List<T>) singLess_albumsList;

                        }
                    case "HOMEPAGE_BLOCK_STYLE_RCMD":
                        if (blockCode.equals(code)) {
                            JSONObject uiElement = (JSONObject) jsonObject.get("uiElement");
                            JSONObject subTitle = (JSONObject) uiElement.get("subTitle");
                            String ModuleTitle = (String) subTitle.get("title");

                            String SongTitle, SubTitle, imageUrl, name = "";
                            long SongId = 0;
                          //  HomeFragment.UpDateText(ModuleTitle, "module_title");
                            RecommendableMusicsBean.Res[] creatives = gson.fromJson(String.valueOf(jsonObject.get("creatives")), RecommendableMusicsBean.Res[].class);
                            List<List<RecommendableMusicsBean>> Recommendable_music_list = new ArrayList<>();
                            List<RecommendableMusicsBean> list;
                            for (int j = 0;j<creatives.length;j++) {
                                RecommendableMusicsBean.Res res = creatives[j];
                                list = new ArrayList<>();
                                for (int k=0;k<res.resources.size();k++) {
                                    RecommendableMusicsBean.Resources resource = res.resources.get(k);
                                    SongTitle = resource.uiElement.mainTitle.title;
                                    if (resource != null && resource.uiElement != null) {
                                        if (resource.uiElement.subTitle != null) {
                                            if (resource.uiElement.subTitle.title != null) {
                                                // 字段存在，可以进行操作
                                                SubTitle = resource.uiElement.subTitle.title;
                                                // 其他操作...
                                            } else {
                                                // subTitle.title 不存在的情况下的处理
                                                SubTitle = "";
                                            }
                                        } else {
                                            // subTitle 不存在的情况下的处理
                                            SubTitle = "";
                                        }
                                    } else {
                                        // 其他字段不存在的处理
                                        SubTitle = "";
                                    }


                                    imageUrl = resource.uiElement.image.imageUrl;
                                    SongId = resource.resourceExtInfo.song.id;


                                    List<RecommendableMusicsBean.Artists> artist_list = new ArrayList<>();
                                    for (RecommendableMusicsBean.Artists artist : resource.resourceExtInfo.artists) {
                                        long id = artist.id;
                                        name = artist.name;
                                        RecommendableMusicsBean.Artists artists = new RecommendableMusicsBean.Artists(name, id);
                                        artist_list.add(artists);

                                    }
                                    RecommendableMusicsBean recommendableMusicsBean = new RecommendableMusicsBean(SongTitle, SubTitle, imageUrl, artist_list, SongId);
                                    recommendableMusicsBean.setModuleTitle(ModuleTitle);
                                    list.add(recommendableMusicsBean);


                                }
                                Recommendable_music_list.add(list);


                            }

//                            try {
//                                NetworkUtils.makeRequest(NetworkInfo.URL + "/song/url/v1?id="+id+"&level=standard", homeHandler, URL_ID,true,context);
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                            }
                            return (List<T>) Recommendable_music_list;

                        }
                    case "HOMEPAGE_BLOCK_MGC_PLAYLIST":
                        if (blockCode.equals(code)) {
                            List<MusicRadarBean> list = new ArrayList<>();

                            String title = null, imageUrl = null, radarType = null, creativeId;
                            int playCount = 0;
                            MusicRadarBean.Res res = gson.fromJson(String.valueOf(jsonObject), MusicRadarBean.Res.class);
                            String radarTitle = res.uiElement.subTitle.title;
                           // HomeFragment.UpDateText(radarTitle, "radar_title");

                            for (MusicRadarBean.Creatives creative : res.creatives) {

                                creativeId = creative.creativeId;
                                Log.d("TAGpppppp", "press: "+creativeId);
                                for (MusicRadarBean.Resources resource : creative.resources) {
                                    title = resource.uiElement.mainTitle.title;
                                    imageUrl = resource.uiElement.image.imageUrl;
                                    playCount = resource.resourceExtInfo.playCount;

                                }
                                MusicRadarBean musicRadar_bean = new MusicRadarBean(title, imageUrl, creativeId, playCount,radarTitle);
                                list.add(musicRadar_bean);
                            }
                            return (List<T>) list;
                        }

                    case "HOMEPAGE_BLOCK_YUNCUN_PRODUCED":
                        if (blockCode.equals(code)) {

                            String Title = "", imageUrl = "", subTitle = "", action = "";
                            Log.d("TAG", "speciallyProducedAdapter: "+(String.valueOf(jsonObject.get("creatives"))));
                            List<SpeciallyProducedBean> list = new ArrayList<>();
                            SpeciallyProducedBean.Res[] creatives = gson.fromJson(String.valueOf(jsonObject.get("creatives")), SpeciallyProducedBean.Res[].class);
                            for (SpeciallyProducedBean.Res creative : creatives) {
                                for (SpeciallyProducedBean.Resources resource : creative.resources) {
                                    imageUrl = resource.uiElement.image.imageUrl;
                                    Title = resource.uiElement.mainTitle.title;
                                    subTitle = resource.uiElement.subTitle.title;
                                    action = resource.action;
                                }
                                SpeciallyProducedBean speciallyProducedBean = new SpeciallyProducedBean(Title,subTitle,imageUrl,action);
                                list.add(speciallyProducedBean);
                            }
                            return (List<T>) list;
                        }
                    case "HOMEPAGE_BLOCK_OFFICIAL_PLAYLIST":
                        if (blockCode.equals(code)) {
                            JSONObject uiElement = (JSONObject) jsonObject.get("uiElement");
                            JSONObject subTitle = (JSONObject) uiElement.get("subTitle");
                            String ModuleTitle = (String) subTitle.get("title");
                            String SheetTitle = "", imageUrl = "", resourceId = "";
                            int playCount = 0;
                           // HomeFragment.UpDateText(ModuleTitle, "exclusive_sheet");
                            List<ExclusiveSceneSongListBean> list = new ArrayList<>();
                            ExclusiveSceneSongListBean.Res[] creatives = gson.fromJson(String.valueOf(jsonObject.get("creatives")), ExclusiveSceneSongListBean.Res[].class);
                            for (ExclusiveSceneSongListBean.Res creative : creatives) {
                                for (ExclusiveSceneSongListBean.Resources resource : creative.resources) {
                                    resourceId = resource.resourceId;
                                    SheetTitle = resource.uiElement.mainTitle.title;
                                    imageUrl = resource.uiElement.image.imageUrl;
                                    playCount = resource.resourceExtInfo.playCount;

                                }
                                ExclusiveSceneSongListBean exclusiveSceneSongList_bean = new ExclusiveSceneSongListBean(SheetTitle, imageUrl, playCount, resourceId,ModuleTitle);
                                list.add(exclusiveSceneSongList_bean);

                            }
                            return (List<T>) list;
                        }
                    case "HOMEPAGE_BLOCK_NEW_HOT_COMMENT":
                        if (blockCode.equals(code)) {
                            JSONObject uiElement = (JSONObject) jsonObject.get("uiElement");
                            JSONObject subTitle = (JSONObject) uiElement.get("subTitle");
                            String ModuleTitle = (String) subTitle.get("title");
                            String titleDesc="", songName="", imageUrl="", singer = "",creativeId="";
                            long songId = 0,singerId=0;
                         //   HomeFragment.UpDateText(ModuleTitle, "concentration_title");
                            List<ConcentrationBean>list= new ArrayList<>();
                            ConcentrationBean.Data info = gson.fromJson(String.valueOf(jsonObject), ConcentrationBean.Data.class);
                            for (ConcentrationBean.Data.Creatives creative : info.creatives) {
                               creativeId= creative.creativeId;
                                for (ConcentrationBean.Data.Creatives.Resources resource : creative.resources) {
                                  songName=  resource.resourceExtInfo.songData.name;
                                   songId= resource.resourceExtInfo.songData.id;
                                  titleDesc= resource.uiElement.mainTitle.titleDesc;
                                 imageUrl= resource.resourceExtInfo.songData.album.picUrl;
                                    artists = resource.resourceExtInfo.songData.artists;

                                }
                                ConcentrationBean concentration_bean =
                                        new ConcentrationBean(creativeId,titleDesc,songName,imageUrl,songId,artists,ModuleTitle);

                                list.add(concentration_bean);;

                            }
                            return (List<T>) list;
                        }


                }

            }

            return null;

        } catch (JSONException e) {
            throw new RuntimeException(e);
        }


    }
}
