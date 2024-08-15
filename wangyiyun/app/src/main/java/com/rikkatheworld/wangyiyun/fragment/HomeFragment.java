package com.rikkatheworld.wangyiyun.fragment;


import static android.os.Build.VERSION_CODES.N;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.CURRENT_PLAY_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.SINGLE_PLAY_MODE_ONE;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RANKING;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SONG;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_SEARCH;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.UNLIMITED_PLAYBACK_MODE;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.getLrcString;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.isUpData;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setCurrentPageItem;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setImg;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.setList;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.ViewPager;
import androidx.viewpager2.widget.ViewPager2;

import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.R;

import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.activity.TouchType;
import com.rikkatheworld.wangyiyun.adapter.home.BannerAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.ConcentrationAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.DigitalAlbumsAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.ExclusiveSceneSongListAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.MusicRadarAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.RecommendableMusicAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.SinglesAndAlbumsAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.SpeciallyProducedAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.recommendRecyclerAdapter;
import com.rikkatheworld.wangyiyun.bean.Home.BannerBean;
import com.rikkatheworld.wangyiyun.bean.Home.ConcentrationBean;
import com.rikkatheworld.wangyiyun.bean.Home.ExclusiveMusicBean;
import com.rikkatheworld.wangyiyun.bean.Home.ExclusiveSceneSongListBean;
import com.rikkatheworld.wangyiyun.bean.Home.MusicRadarBean;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendableMusicsBean;
import com.rikkatheworld.wangyiyun.bean.Home.RecommendedPlaylistsBean;
import com.rikkatheworld.wangyiyun.bean.Home.SinglesAndAlbumsBean;
import com.rikkatheworld.wangyiyun.bean.Home.SpeciallyProducedBean;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSheetBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;
import com.rikkatheworld.wangyiyun.util.AsyncTimer;
import com.rikkatheworld.wangyiyun.util.Home_GsonUtil;
import com.rikkatheworld.wangyiyun.util.MyGsonUtil;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;
import com.rikkatheworld.wangyiyun.util.NetworkUtils;
import com.rikkatheworld.wangyiyun.util.Utils;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Type;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Random;
import java.util.Set;

public class HomeFragment extends Fragment implements View.OnTouchListener, View.OnClickListener, ViewPager.OnPageChangeListener {


    public HomeHandler homeHandler;
    public static String moduleTitle;
    public static String radarTitle;
    public static String tvExclusiveSheetTitle;
    public static String concentrationTitle;
    private BannerAdapter bannerAdapter;
    private LinearLayout layout;
    private ViewPager Vp_banner;
    private List<BannerBean> banner_beanList;
    private List<Object> recommended_playlists;
    private LinearLayout lin_point;
    private View point_view;

    public final static int RES_ID = 1;
    private static final int AUTO_PAGER = 2;
    public static final int URL_ID = 3;
    public static final int LRC_ID = 4;

    // public static final int SONG_SHEET_ID = 5;
    public static final int ADD_OR_REMOVE = 6;
    public static final int SONG_LIST = 7;
    public static final int SONGS = 8;
    private RecyclerView horizontalRecycler;
    // private AsyncTimer asyncTimer_banner;
    private Runnable banner_runnable;
    private ViewPager singLessAlbum;
    private SinglesAndAlbumsAdapter singlesAndAlbumsAdapter;
    private recommendRecyclerAdapter recommendRecyclerAdapter;
    private RecyclerView svDish;
    private DigitalAlbumsAdapter digitalAlbumsAdapter;
    private ViewPager vp_recommend_music;
    private RecommendableMusicAdapter recommendableMusicAdapter;
    private static TextView module_title;
    private RecyclerView rvRadar;
    private MusicRadarAdapter musicRadarAdapter;
    private static TextView radar_title;
    private static TextView concentration_title;
    private static TextView TV_exclusive_sheet_title;
    private RecyclerView rv_concentration;
    private RecyclerView rv_exclusive_sheet;
    private RecyclerView rv_specially_produced;
    private ConcentrationAdapter concentrationAdapter;
    private SpeciallyProducedAdapter speciallyProducedAdapter;
    private ExclusiveSceneSongListAdapter exclusiveSceneSongListAdapter;
    private int px;
    private LinearLayout re_home;
    private ImageView img_menu;

    private static HomeFragment.dataFromAdapter FromAdapter;
    public static List<List<RecommendableMusicsBean>> recommendableMusics;
    private HomeFragment.LoadNetWorkCall LoadNetWorkCall;
    private SongList songLists;
    private NavigationToSecond secondPage;
    private GetMp3Info mp3Info;
    private List<UserSheetBean> sheetList;
    private List<List<SinglesAndAlbumsBean>> singLe_albumsList;
    private List<MusicRadarBean> musicRadar_beanList;
    private List<ConcentrationBean> concentration_beanList;
    private List<ExclusiveSceneSongListBean> exclusiveSceneSongList_beanList;
    private List<SpeciallyProducedBean> speciallyProduced_beanList;
    private App app;
    private FragmentTransaction transaction;
    public SearchPage searchFragment;
    private FragmentManager fragmentManager;
    private LinearLayout btn_recommend;
    private LinearLayout btn_radio;
    private LinearLayout btn_songSheet;
    private LinearLayout btn_rankingList;
    public SongSheetFragment songSheetFragment;
    public boolean loadOk = false;

    int min = -180;
    int max = 180;

    Set<Integer> generated = new HashSet<>();
    SecureRandom secureRandom = new SecureRandom();
    private int number;
    private int currentNumber;
    private View load_page;
    private RelativeLayout home_root;
    private int countItem = 0;

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);


    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //   homeHandler = new HomeHandler();
        banner_runnable = () -> {

            Vp_banner.setCurrentItem(countItem++, true);
            homeHandler.postDelayed(banner_runnable, 5000);
        };
    }

    public HomeHandler getHomeHandler() {
        if (homeHandler == null) {
            homeHandler = new HomeHandler();
        }
        return homeHandler;
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        px = Utils.getStatusBarHeight(getContext());
        return inflater.inflate(R.layout.home_fragment, container, false);

    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        initView();
        app = (App) getContext().getApplicationContext();
        Log.d("TAGpppppaaaaaa", "onViewCreated: "+app.HomeData);

        new DataProcessingTask().execute(app.HomeData);


    }


    public void hideFragment() {
        getActivity().getSupportFragmentManager()
                .beginTransaction()
                .setCustomAnimations(
                        R.anim.fade_in,
                        R.anim.fade_out,
                        R.anim.fade_in,
                        R.anim.fade_out)
                .hide(songSheetFragment)
                .commit();
    }

    private void initView() {

        EditText search_btn = getView().findViewById(R.id.search_btn);
        fragmentManager = getActivity().getSupportFragmentManager();
        // 开始事务

        search_btn.setOnClickListener(this);


        bannerAdapter = new BannerAdapter(getContext(), secondPage);
        banner_beanList = new ArrayList<>();
        re_home = getView().findViewById(R.id.re_home);
        load_page = getView().findViewById(R.id.load_page);
        home_root = getView().findViewById(R.id.home_root);
        layout = getView().findViewById(R.id.lin_tab);
        lin_point = getView().findViewById(R.id.Lin_point);
        singLessAlbum = getView().findViewById(R.id.Vp_Disc);
        horizontalRecycler = getView().findViewById(R.id.ScrV_SongSheet);
        svDish = getView().findViewById(R.id.SV_dish);
        img_menu = getView().findViewById(R.id.img_menu);
        vp_recommend_music = getView().findViewById(R.id.Vp_recommend_music);
        module_title = getView().findViewById(R.id.TV_Module_title);
        radar_title = getView().findViewById(R.id.TV_radar_title);
        rvRadar = getView().findViewById(R.id.RV_radar);
        concentration_title = getView().findViewById(R.id.TV_concentration_title);
        TV_exclusive_sheet_title = getView().findViewById(R.id.TV_exclusive_sheet_title);
        rv_concentration = getView().findViewById(R.id.RV_concentration);
        rv_exclusive_sheet = getView().findViewById(R.id.RV_exclusive_sheet);
        rv_specially_produced = getView().findViewById(R.id.RV_specially_produced);
        btn_recommend = getView().findViewById(R.id.lin_recommend);
        btn_radio = getView().findViewById(R.id.lin_radio);
        btn_songSheet = getView().findViewById(R.id.lin_songSheet);
        btn_rankingList = getView().findViewById(R.id.lin_rankingList);

        btn_recommend.setOnClickListener(this);
        btn_radio.setOnClickListener(this);
        btn_songSheet.setOnClickListener(this);
        btn_rankingList.setOnClickListener(this);

        LinearLayoutManager horizontalRecycler_layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);
        LinearLayoutManager svDish_layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);
        LinearLayoutManager rvRadar_layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);
        LinearLayoutManager rvExclusiveSheet_layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);
        LinearLayoutManager rvSpeciallyProduced_layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);
        LinearLayoutManager rvConcentration_layoutManager = new LinearLayoutManager(getContext(), LinearLayoutManager.HORIZONTAL, false);

        horizontalRecycler.setLayoutManager(horizontalRecycler_layoutManager);
        svDish.setLayoutManager(svDish_layoutManager);
        rvRadar.setLayoutManager(rvRadar_layoutManager);
        rv_concentration.setLayoutManager(rvConcentration_layoutManager);
        rv_exclusive_sheet.setLayoutManager(rvExclusiveSheet_layoutManager);
        rv_specially_produced.setLayoutManager(rvSpeciallyProduced_layoutManager);


        singlesAndAlbumsAdapter = new SinglesAndAlbumsAdapter(getContext(), secondPage);
        digitalAlbumsAdapter = new DigitalAlbumsAdapter(getContext(), secondPage);
        recommendableMusicAdapter = new RecommendableMusicAdapter(getContext());
        musicRadarAdapter = new MusicRadarAdapter(getContext(), secondPage);
        concentrationAdapter = new ConcentrationAdapter(getContext());
        speciallyProducedAdapter = new SpeciallyProducedAdapter(getContext());
        exclusiveSceneSongListAdapter = new ExclusiveSceneSongListAdapter(getContext(), secondPage);

        Vp_banner = getView().findViewById(R.id.Vp_banner);
        Vp_banner.addOnPageChangeListener(this);
        Vp_banner.setOnTouchListener(this);
        // singLessAlbum.setOffscreenPageLimit(1);
        re_home.setPadding(0, px, 0, 0);
        DrawerLayout drawerLayout = getActivity().findViewById(R.id.DL_main_drawer);
        img_menu.setOnClickListener(v -> drawerLayout.openDrawer(GravityCompat.START));


    }


    private void insertPoint() {
        Log.d("TAG111111111111111111111", "insertPoint: " + banner_beanList.size());
        for (int i = 0; i < banner_beanList.size(); i++) {
            point_view = new View(getContext());
            int currentItem = Vp_banner.getCurrentItem() % banner_beanList.size();

            LinearLayout.LayoutParams params;
            if (currentItem == i) {
                params = new LinearLayout.LayoutParams(20, 20);
                params.leftMargin = 25;
                point_view.setBackground(getResources().getDrawable(R.drawable.current_point, getActivity().getTheme()));
            } else {
                params = new LinearLayout.LayoutParams(15, 15);
                params.leftMargin = 25;
                point_view.setBackground(getResources().getDrawable(R.drawable.other_point, getActivity().getTheme()));
            }
            point_view.setLayoutParams(params);
            lin_point.addView(point_view);
        }
    }


    @Override
    public boolean onTouch(View view, MotionEvent motionEvent) {

        switch (motionEvent.getAction()) {
            case MotionEvent.ACTION_MOVE:
            case MotionEvent.ACTION_DOWN:

                homeHandler.removeCallbacks(banner_runnable);
                break;
            case MotionEvent.ACTION_UP:
            case MotionEvent.ACTION_CANCEL:
                // asyncTimer_banner.startTimer(5000, 5000, banner_runnable);
                if (banner_runnable == null) {
                    banner_runnable = () -> {

                        Vp_banner.setCurrentItem(countItem++);
                        homeHandler.postDelayed(banner_runnable, 5000);

                    };
                }
                homeHandler.post(banner_runnable);
                break;
        }

        return false;
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == R.id.lin_recommend) {
            app.page += 1;
            app.touchType = TouchType.RECOMMENDABLE_SHEET;
            ((MainActivity) getContext()).setRecommendSheetId("-1");
            secondPage.toSecond(TO_RECOMMEND_SONG, "-1");
        } else if (id == R.id.lin_radio) {
            if (CURRENT_PLAY_MODE == SINGLE_PLAY_MODE_ONE || CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE) {
                ((MainActivity) getContext()).OpenSheet();
                return;
            }

            //app.touchType = TouchType.EXCLUSIVE_MUSIC;
            ((MainActivity) getActivity()).setCurrentMode("ExclusiveMusicMode");
            //if (playerInfo!=null) {
            if (playerInfo.getListBeans() != null) playerInfo.getListBeans().clear();
            // }


            activityMainBinding.setPlayerInfo(playerInfo);
            loadMp3("radio");
        } else if (id == R.id.lin_songSheet) {
            ((MainActivity) getContext()).hideView();
            ((MainActivity) getContext()).setBackColor();
            ((MainActivity) getContext()).setRecommendSheetId("10086");
            // 获取FragmentManager
            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
            // 开始事务
            transaction = fragmentManager.beginTransaction();
            transaction.setCustomAnimations(
                    R.anim.fade_in,
                    R.anim.fade_out,
                    R.anim.fade_in,
                    R.anim.fade_out
            );
            // 检查MyFragment是否已添加，如果没有，则添加
            songSheetFragment = (SongSheetFragment) fragmentManager.findFragmentByTag("SongShee_FRAGMENT");
            if (songSheetFragment == null) {
                songSheetFragment = new SongSheetFragment(secondPage);
                // 使用addToBackStack允许用户通过返回按钮回到之前的状态
                transaction.
                        add(R.id.home_song_sheet, songSheetFragment, "SongShee_FRAGMENT")
                        .addToBackStack(null)
                        .commit();
            } else {

                transaction.show(songSheetFragment).commit();
            }

        } else if (id == R.id.lin_rankingList) {
            app.page += 1;
            app.touchType = TouchType.RANKING_PAGE;
            secondPage.toSecond(TO_RANKING, "12138");

        } else if (id == R.id.search_btn) {
            app.page += 1;
            app.touchType = TouchType.SEARCH_PAGE;
            transaction = fragmentManager.beginTransaction();
            transaction.setCustomAnimations(
                    R.anim.fade_in,
                    R.anim.fade_out,
                    R.anim.fade_in,
                    R.anim.fade_out
            );
            searchFragment = (SearchPage) fragmentManager.findFragmentByTag("SearchPage_FRAGMENT");
            if (searchFragment == null) {
                searchFragment = new SearchPage();
                // 使用addToBackStack允许用户通过返回按钮回到之前的状态
                transaction.add(R.id.fragment_container, searchFragment, "SearchPage_FRAGMENT")
                        .addToBackStack(null)
                        .commit();
            } else {

                transaction.show(searchFragment).commit();
            }
            ((MainActivity) getActivity()).hideView();
        }
    }

    public void loadMp3(String type) {
        switch (type) {
            case "radio":
                // 生成-180到180之间的随机数
                number = secureRandom.nextInt(363) - 181;
                if (number != currentNumber) {
                    currentNumber = number;
                } else number -= 1;
                generated.add(number);


                NetworkUtils.makeRequest(NetworkInfo.URL + "/aidj/content/rcmd?longitude=" + number + "&latitude=" + (number - 1), homeHandler, SONGS, true, getContext());
                break;
            //   case ""
        }
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        countItem = position;
        int currentItem = Vp_banner.getCurrentItem() % banner_beanList.size();
        for (int i = 0; i < banner_beanList.size(); i++) {
            View childAt = lin_point.getChildAt(i);
            LinearLayout.LayoutParams params;
            if (currentItem == i) {
                params = new LinearLayout.LayoutParams(20, 20);
                params.leftMargin = 25;

                childAt.setBackground(getResources().getDrawable(R.drawable.current_point, getActivity().getTheme()));
            } else {
                params = new LinearLayout.LayoutParams(15, 15);
                params.leftMargin = 25;
                childAt.setBackground(getResources().getDrawable(R.drawable.other_point, getActivity().getTheme()));
            }
            childAt.setLayoutParams(params);
        }

    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }

    public class HomeHandler extends Handler {

        private List<ExclusiveMusicBean> exclusiveMusic;

        @Override
        public void dispatchMessage(@NonNull Message msg) {
            super.dispatchMessage(msg);

            int what = msg.what;
            switch (what) {
                case RES_ID:

                    String s = msg.obj.toString();


                    new DataProcessingTask().execute(s);

                    break;
                case AUTO_PAGER:
                    Log.d("TAG----------zzccc-----------", "onViewCreated: " + (msg.obj) + "00000s" + Vp_banner.getCurrentItem());

                    Vp_banner.setCurrentItem((Integer) msg.obj);
// 在数据变更后调用
                    bannerAdapter.notifyDataSetChanged();

                    break;
                case URL_ID:

                    if (msg.obj != null) {
                        String string = msg.obj.toString();
                        try {
                            //App app = (App)activity.getApplication();
                            // Gson gson = app.gson;
                            JSONObject jsonObject = new JSONObject(string);
                            String data = String.valueOf(jsonObject.get("data"));
                            Gson gson = new Gson();
                            Type listType = new TypeToken<List<UrlBeans>>() {
                            }.getType();
                            List<UrlBeans> urlBeans = gson.fromJson(data, listType);


                            mp3Info.getMp3Info(urlBeans);


                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    break;
                case LRC_ID:
                    if (msg.obj != null) {
                        String obj = msg.obj.toString();

                        try {
                            String translateLyric = "";
                            String lyricT = "";
                            JSONObject jsonObject = new JSONObject(obj);
                            if (!jsonObject.has("lrc")) {
                                return;
                            }

                            if (jsonObject.has("tlyric")) {
                                JSONObject tlyric = (JSONObject) jsonObject.get("tlyric");

                                if (tlyric.has("lyric")) {
                                    translateLyric = String.valueOf(tlyric.get("lyric"));
                                }
                            }
                            JSONObject lrc = (JSONObject) jsonObject.get("lrc");
                            String lyric = String.valueOf(lrc.get("lyric"));


                            getLrcString.setLrc(lyric, translateLyric);

                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    break;

                case ADD_OR_REMOVE:

                    LoadNetWorkCall.DOCall("getSongList", sheetList.get(0).getSheetId());

                    break;
                case SONG_LIST:
                    if (msg.obj != null) {
                        String obj = msg.obj.toString();
                        try {
                            JSONObject object = new JSONObject(obj);
                            String o = String.valueOf(object.get("songs"));
                            List<UserSongListBean> getSongList = (List<UserSongListBean>) MyGsonUtil.getInstance().press(o, "getSongList", app);
                            songLists.setSongList(getSongList);
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    break;
                case SONGS:
                    if (msg.obj != null) {
                        String obj = msg.obj.toString();
                        String result = "";
                        try {
                            JSONObject jsonObject = new JSONObject(obj);
                            JSONObject data = (JSONObject) jsonObject.get("data");
                            result = String.valueOf(data.get("aiDjResources"));
                        } catch (JSONException e) {
                            throw new RuntimeException(e);
                        }
                        if (exclusiveMusic == null) {
                            exclusiveMusic = new ArrayList<>();
                        }
                        List<ListBean> list = new ArrayList<>();

                        for (ExclusiveMusicBean exclusiveMusicBean : app.gson.fromJson(result, ExclusiveMusicBean[].class)) {
                            if (exclusiveMusicBean.getType().equals("song")) {
                                //exclusiveMusic.add(exclusiveMusicBean);
                                ListBean listBean = new ListBean();
                                Log.d("TAGjdjdjfjj", "dispatchMessaaaasddfge: " + exclusiveMusicBean.getValue().songData.artists.size());
                                String ar = app.gson.toJson(exclusiveMusicBean.getValue().songData.artists);
                                Log.d("TAGjdjdjfjj", "dispatchMessaaaasddfge: " + ar);
                                Type token = new TypeToken<List<UserSongListBean.Ar>>() {
                                }.getType();
                                List<UserSongListBean.Ar> SingerInfo = app.gson.fromJson(ar, token);
                                listBean.setSingerInfo(SingerInfo);
                                listBean.setSongName(exclusiveMusicBean.getValue().songData.name);
                                listBean.setSongId(exclusiveMusicBean.getValue().songData.id);
                                listBean.setSubTitle(exclusiveMusicBean.getValue().songData.album.subType);
                                listBean.setImgUrl(exclusiveMusicBean.getValue().songData.album.picUrl);
                                list.add(listBean);

                            }
                        }
                        if (playerInfo.getListBeans() != null) {
                            playerInfo.addListBeans(list);
                            activityMainBinding.setPlayerInfo(playerInfo);
                            isUpData = 2;
                            app.isUpViewpage = true;
                            ((MainActivity) getContext()).playerPageAdapter.setData(playerInfo.getListBeans());
                            ((MainActivity) getContext()).songListAdapter.upData(playerInfo.getListBeans());


                        } else {
                            playerInfo.setListBeans(list);
                            setImg.setImg(list.get(0).getImgUrl());
                            String name = Utils.getString(list.get(0));
                            playerInfo.setSongName(list.get(0).getSongName());
                            playerInfo.setImgUrl(list.get(0).getImgUrl());
                            playerInfo.setCurrentPosition("00:00");
                            // player_seekBar.setProgress(0);
                            playerInfo.setPlayOrPause(true);
                            playerInfo.setSingerName(name);
                            playerInfo.setSongId(list.get(0).getSongId());
                            activityMainBinding.setPlayerInfo(playerInfo);
                            ((MainActivity) getContext()).OpenSheet();
                            ((MainActivity) getContext())
                                    .play(String.valueOf(playerInfo.getListBeans().get(0).getSongId()), null);

                            setList.setListInfo(playerInfo.getListBeans());

                        }


                        //  setCurrentPageItem.setCurrentItem(0);
                    }
                    break;

            }


        }


    }

    public static void UpDateText(String text, String code) {
        switch (code) {

            case "module_title":
                moduleTitle = text;

                module_title.setText(text);
                break;
            case "radar_title":
                radarTitle = text;
                radar_title.setText(text);
                break;
            case "exclusive_sheet":
                tvExclusiveSheetTitle = text;
                TV_exclusive_sheet_title.setText(text);
                break;
            case "concentration_title":
                concentrationTitle = text;
                concentration_title.setText(text);
                break;
            default:
                throw new IllegalStateException("Unexpected value: " + code);
        }


    }

    @SuppressLint("ClickableViewAccessibility")
    private void Draw_recommended_sheet() {
        recommendRecyclerAdapter = new recommendRecyclerAdapter(getContext(), recommended_playlists, secondPage, app);
        horizontalRecycler.setAdapter(recommendRecyclerAdapter);


    }


    @Override
    public void onPause() {

        super.onPause();

//        if (asyncTimer_banner!=null) {
//            asyncTimer_banner.stopTimer();
//        }
        homeHandler.removeCallbacks(banner_runnable);
    }

    @Override
    public void onResume() {
        super.onResume();
        Log.d("TAG----------qqqqqqq", "onResume: ");
        if (banner_runnable == null) {
            banner_runnable = () -> {
                // countItem = Vp_banner.getCurrentItem();
                Vp_banner.setCurrentItem(countItem++);
                homeHandler.postDelayed(banner_runnable, 5000);

            };
        }
        homeHandler.post(banner_runnable);


//        if (asyncTimer_banner!=null) {
//            asyncTimer_banner.startTimer(5000, 5000, banner_runnable);
//        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (recommendRecyclerAdapter != null) {
            recommendRecyclerAdapter.stop();
        }

        homeHandler.removeCallbacks(banner_runnable);

    }

    public void setDataFromAdapter(dataFromAdapter dataFromAdapter) {
        FromAdapter = dataFromAdapter;

        Bundle bundle = FromAdapter.fromAdapter();
        this.setArguments(bundle);
    }

    public interface dataFromAdapter {
        Bundle fromAdapter();
    }

    public void setLoadNetWorkCall(LoadNetWorkCall loadNetWorkCall) {
        LoadNetWorkCall = loadNetWorkCall;
    }

    public interface LoadNetWorkCall {
        void DOCall(String flag, long sheetId);
    }

    public void setSongLists(SongList songList) {
        songLists = songList;
    }

    public interface SongList {
        void setSongList(List<UserSongListBean> songList);
    }


    public GHandler getHandler() {
        GHandler gHandler = () -> {


        };
        return gHandler;
    }

    public interface GHandler {
        void initGHandler();
    }

    public interface NavigationToSecond {
        void toSecond(String type, String id);
    }

    public void setNavigationToSecond(NavigationToSecond secondPage) {
        this.secondPage = secondPage;
    }

    public interface GetMp3Info {
        void getMp3Info(List<UrlBeans> urlBeans);
    }

    public void setMp3Info(GetMp3Info mp3Info) {
        this.mp3Info = mp3Info;
    }

    private class DataProcessingTask extends AsyncTask<String, Void, Boolean> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected void onPostExecute(Boolean aBoolean) {
            //super.onPostExecute(aBoolean);

            if (aBoolean) {
                singlesAndAlbumsAdapter.setData(singLe_albumsList);
                singLessAlbum.setAdapter(singlesAndAlbumsAdapter);
                singlesAndAlbumsAdapter.notifyDataSetChanged();
                digitalAlbumsAdapter.setData(singLe_albumsList);
                svDish.setAdapter(digitalAlbumsAdapter);
                recommendableMusicAdapter.setData(recommendableMusics);
                UpDateText(recommendableMusics.get(0).get(0).getModuleTitle(), "module_title");
                //recommendableMusicAdapter.setUrlData(urlBeans);
                vp_recommend_music.setAdapter(recommendableMusicAdapter);
                recommendableMusicAdapter.notifyDataSetChanged();

                musicRadarAdapter.setData(musicRadar_beanList);
                UpDateText(musicRadar_beanList.get(0).getRadarTitle(), "radar_title");
                rvRadar.setAdapter(musicRadarAdapter);


                exclusiveSceneSongListAdapter.setData(exclusiveSceneSongList_beanList);
                UpDateText(exclusiveSceneSongList_beanList.get(0).getModuleTitle(), "exclusive_sheet");
                rv_exclusive_sheet.setAdapter(exclusiveSceneSongListAdapter);


                speciallyProducedAdapter.setData(speciallyProduced_beanList);
                rv_specially_produced.setAdapter(speciallyProducedAdapter);


                concentrationAdapter.setData(concentration_beanList);
                UpDateText(concentration_beanList.get(0).getModuleTitle(), "concentration_title");
                rv_concentration.setAdapter(concentrationAdapter);


                bannerAdapter.setData(banner_beanList);
                Draw_recommended_sheet();
                if (lin_point.getChildAt(0) == null) {
                    insertPoint();
                }
                Vp_banner.setAdapter(bannerAdapter);
                Vp_banner.setCurrentItem(10000 / 2, false);
                countItem = Vp_banner.getCurrentItem();


            }

            if (load_page.getVisibility() != View.GONE) {
                load_page.setVisibility(View.GONE);
                home_root.setVisibility(View.VISIBLE);
            }


        }

        @Override
        protected Boolean doInBackground(String... strings) {
            String s = strings[0];
            banner_beanList = Home_GsonUtil.getInstance().press(s, BannerBean.class, "HOMEPAGE_BANNER", getContext());
            recommended_playlists = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_PLAYLIST_RCMD", getContext());
            singLe_albumsList = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_NEW_ALBUM_NEW_SONG", getContext());
            recommendableMusics = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_STYLE_RCMD", getContext());
            musicRadar_beanList = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_MGC_PLAYLIST", getContext());
            concentration_beanList = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_NEW_HOT_COMMENT", getContext());
            exclusiveSceneSongList_beanList = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_OFFICIAL_PLAYLIST", getContext());
            speciallyProduced_beanList = Home_GsonUtil.getInstance().press(s, null, "HOMEPAGE_BLOCK_YUNCUN_PRODUCED", getContext());
            Log.d("TAG-----sssfffff", "onPostExecute: "+(banner_beanList != null)+"-----" +
                    ""+(recommended_playlists != null)+"-----"+(singLe_albumsList != null)+"----"+
                    (recommendableMusics != null)+"-----"+(musicRadar_beanList != null)+"----"+(concentration_beanList != null)
            +(exclusiveSceneSongList_beanList != null)+"-----"+(speciallyProduced_beanList != null));

            return banner_beanList != null
                    && recommended_playlists != null
                    && singLe_albumsList != null  && musicRadar_beanList != null
                    && concentration_beanList != null &&
                    exclusiveSceneSongList_beanList != null && speciallyProduced_beanList != null;
        }

    }

}
