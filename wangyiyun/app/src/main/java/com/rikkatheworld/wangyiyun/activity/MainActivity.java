package com.rikkatheworld.wangyiyun.activity;


import static com.rikkatheworld.wangyiyun.adapter.PlayerPageAdapter.playerPageAdapterAnimation;
import static com.rikkatheworld.wangyiyun.fragment.HomeFragment.ADD_OR_REMOVE;
import static com.rikkatheworld.wangyiyun.fragment.HomeFragment.LRC_ID;
import static com.rikkatheworld.wangyiyun.fragment.HomeFragment.RES_ID;
import static com.rikkatheworld.wangyiyun.fragment.HomeFragment.SONG_LIST;
import static com.rikkatheworld.wangyiyun.fragment.HomeFragment.URL_ID;
import static com.rikkatheworld.wangyiyun.service.musicService.notifyBuilderManager;


import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentTransaction;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import androidx.viewpager.widget.PagerAdapter;
import androidx.viewpager.widget.ViewPager;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.Service;
import android.content.ContentValues;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.provider.MediaStore;
import android.support.v4.media.session.MediaSessionCompat;
import android.text.TextUtils;
import android.util.Log;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.google.android.material.bottomnavigation.BottomNavigationView;
import com.google.android.material.bottomsheet.BottomSheetBehavior;
import com.google.android.material.navigation.NavigationBarView;
import com.google.gson.reflect.TypeToken;
import com.rikkatheworld.wangyiyun.AnimationPage.AnimationUtil;

import com.rikkatheworld.wangyiyun.App;
import com.rikkatheworld.wangyiyun.DataModel;
import com.rikkatheworld.wangyiyun.EngineBindings;
import com.rikkatheworld.wangyiyun.PlayerInfo;
import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.adapter.SongListAdapter;
import com.rikkatheworld.wangyiyun.adapter.home.Bottom_navigationAdapter;
import com.rikkatheworld.wangyiyun.adapter.PlayerPageAdapter;
import com.rikkatheworld.wangyiyun.bean.MusicCacheBean;
import com.rikkatheworld.wangyiyun.bean.UrlBeans;
import com.rikkatheworld.wangyiyun.fragment.MsgFragment;
import com.rikkatheworld.wangyiyun.fragment.MyFragment;
import com.rikkatheworld.wangyiyun.fragment.SecondPage;
import com.rikkatheworld.wangyiyun.bean.ListBean;
import com.rikkatheworld.wangyiyun.bean.Home.LrcBean;
import com.rikkatheworld.wangyiyun.bean.My.UserInfoBean;
import com.rikkatheworld.wangyiyun.bean.My.UserSongListBean;
import com.rikkatheworld.wangyiyun.databinding.ActivityMainBinding;

import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.service.IPlayerViewChange;
import com.rikkatheworld.wangyiyun.util.FileUtils;
import com.rikkatheworld.wangyiyun.util.LrcUtil;
import com.rikkatheworld.wangyiyun.util.MediaSessionManager;
import com.rikkatheworld.wangyiyun.util.MusicPlayerUtils;
import com.rikkatheworld.wangyiyun.util.MyGsonUtil;
import com.rikkatheworld.wangyiyun.util.NetworkInfo;
import com.rikkatheworld.wangyiyun.util.NetworkUtils;
import com.rikkatheworld.wangyiyun.util.NotifyBuilderManager;
import com.rikkatheworld.wangyiyun.util.StartS;
import com.rikkatheworld.wangyiyun.util.Utils;
import com.rikkatheworld.wangyiyun.util.beginPlay;
import com.rikkatheworld.wangyiyun.view.CustomToast;
import com.rikkatheworld.wangyiyun.view.LrcView;
import com.rikkatheworld.wangyiyun.view.PlayerAlbumPager;
import com.rikkatheworld.wangyiyun.view.ProhibitSlidingViewPager;


import org.jetbrains.annotations.Nullable;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends AppCompatActivity implements NavigationBarView.OnItemSelectedListener, View.OnClickListener, SeekBar.OnSeekBarChangeListener, ViewPager.OnPageChangeListener, DataModel.DataModelObserver, EngineBindings.EngineBindingsDelegate {


    private final int MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE = 1;
    public static final String MY_ENGINE_ID = "my_engine_id";
    public static final String MSG_ENGINE_ID = "msg_engine_id";
    private static final String CHANNEL = "from_flutter";

    private ProhibitSlidingViewPager viewPager;
    public static HomeFragment homeFragment;
    private boolean doubleBackToExitPressedOnce = false;
    public static ActivityMainBinding activityMainBinding;


    public static final int STATE_PLAY = 1;
    public static final int STATE_PAUSE = 2;
    public static final int STATE_STOP = 3;
    public static boolean AUTO_PLAY = true;


    private final int STATUS = 4;
    public static int TOUCH_COUNT = 0;
    public static boolean binderFlag = false;

    private BottomNavigationView bottom_view;

    private Bottom_navigationAdapter adapter;

    public static Boolean StateFlag = false;
    private LinearLayout lin_player;
    public BottomSheetBehavior<FrameLayout> behavior;
    private ImageView player_btn_to_back;
    private int statusBarHeight;

    private LinearLayout player_rootView;
    private View include_player;

    public static SeekBar player_seekBar;

    public static StartS instance;

    private FrameLayout bottomSheet;


    public static beginPlay.TaskImage setImg;
    public static beginPlay.GetListInfo setList;

    private List<ListBean> PlayerList;
    private ImageView ivPlayList;
    private View include_song_list;
    private View blackOverlay;
    private DrawerLayout dlMainDrawer;
    private RelativeLayout reMainContent;
    private FrameLayout song_list_back;
    private static PlayerAlbumPager player_viewPage;
    public static PlayerInfo playerInfo;
    private RecyclerView player_song_list;
    public static beginPlay.CurrentItem setCurrentPageItem;
    public static PlayerPageAdapter playerPageAdapter;
    static int position1 = 0;
    public static AnimationUtil animationUtils;
    private ImageView play_module;
    private ImageView previous_song;
    private ImageView play_btn;
    private ImageView next_song;
    private ImageView main_play;
    public static SongListAdapter songListAdapter;
    public static LrcView mLrcView;
    private static String LrcString;
    public static GetLrcString getLrcString;
    private LinearLayout player_linePosition;
    public static ShowLrcInfoView showLrcInfoView;

    public static boolean isClickEventRegistered = true;

    public static final int SINGLE_PLAY_MODE = 0;
    public static final int SEQUENTIAL_MODE = 1;
    public static final int RANDOM_PLAY_MODE = 2;

    public static final int UNLIMITED_PLAYBACK_MODE = 3;
    public static final int SINGLE_PLAY_MODE_ONE = 4;

    public static int CURRENT_PLAY_MODE = SEQUENTIAL_MODE;
    private boolean hasMove = false;
    public static boolean AnimationFlag = false;
    private final int[] playMode = new int[]{
            R.drawable.sing_circulate,
            R.drawable.list_loop,
            R.drawable.random_play,
    };
    private final int[] ExclusiveMusicMode = new int[]{
            R.drawable.sing_circulate,
            R.drawable.infinite,

    };
    private static ImageView player_stylus;
    private final List<ListBean> listBean = new ArrayList<>();
    private FrameLayout fl_sidebar;
    private static Point screenPoint;
    private static float stylusY;

    public static boolean isOnClick = false;
    public static boolean switchSong = false;

    int p = 0;
    int p1 = 0;
    private ImageView layout_player_list;
    private AnimationUtil animationUtil;
    private boolean isAnimationToShow;
    private FrameLayout playerFl;
    private LinearLayout listPageView;
    private float songListY;
    private int scrollH;
    private LinearLayout scroll_btn;
    private float downY;
    private int lastOffsetY;
    private int scroll;
    int scroll1 = 0;
    private float num = 0;
    private UserInfoBean userInfo;

    private List<UserSongListBean> songLists;
    private ImageView player_heart;
    private boolean likeOrNot;
    private boolean likeOrNot1;
    private boolean heart_isOnClick = false;
    private final List<Long> newLikeList = new ArrayList<>();
    private ImageView player_comment;

    private float y;

    private static Activity activity;
    public SecondPage secondFragment;
    private FragmentTransaction transaction;
    private View player_control;
    private RelativeLayout.LayoutParams playerLayoutParams;

    public static final String TO_SEARCH = "to_search";
    public static final String TO_ALBUMS = "to_albums";

    public static final String TO_RECOMMEND_SHEET = "to_recommend_song_sheet";
    public static final String TO_SHEET = "to_sheet";
    public static final String TO_RANKING = "to_ranking";
    public static final String TO_RECOMMEND_SONG = "to_recommend_song";
    public static final String TO_EXCLUSIVE_SHEET = "to_exclusive_scene_song_sheet";
    public static final String TO_MUSIC_RADAR_SHEET = "to_music_radar_song_sheet";
    public static final String TO_SING_AND_ALBUMS = "to_sing_and_albums";


    public static int isUpData = 0;//单更：1/全更：2
    public static List<UrlBeans> songList = new ArrayList<>();
    private List<ListBean> temporaryList = new ArrayList<>();
    private List<ListBean> orderList = new ArrayList<>();
    private static ImageView main_player_img;
    private ListBean nextPager;
    //private Check check;
    private float offset;
    private Map<?, ?> newData;
    private App app;
    private String sheetId = "";
    public static String oldSheetId = "";
    List<ListBean> Sheetlist = new ArrayList<>();
    ;
    private long currentId = 0;
    float startX = 0;
    float startY = 0;
    int diffOffset;
    boolean inTO = false;
    private TextView list_title;
    private MyFragment myFragment;
    private MsgFragment msgFragment;
    int pIndex = 0;

    long lodDate = 0;
    long nowDate = 0;
    private float deltaX;
    private float deltaY;
    private boolean isScroll = false;
    private Map<?, ?> info;
    private String filePath;
    private String fileName = "songdata.ser";
    private HomeFragment.HomeHandler homeHandler;
    private boolean isFirstScroll = true;
    private float currentPosition;
    private MusicCacheBean musicCacheBean;
    public static setCallback callback;


    @Override
    protected void onActivityResult(int requestCode, int resultCode, @androidx.annotation.Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        myFragment.onActivityResult(requestCode, resultCode, data);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);
        NetworkUtils.makeRequest(NetworkInfo.URL + "/login/status", handler, STATUS, true, this);

        DataModel.getInstance().addObserver(this);
        activity = this;
        animationUtils = new AnimationUtil();
        app = (App) this.getApplication();

        if (savedInstanceState != null) {
            String fileName = savedInstanceState.getString("data");
            app.HomeData = FileUtils.readStringFromFile(this, fileName);
        }
        activityMainBinding = DataBindingUtil.setContentView(this, R.layout.activity_main);
        playerInfo = new PlayerInfo();
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

        //      notifyBuilderManager = new NotifyBuilderManager();


        initView();

        homeFragment.setNavigationToSecond(new HomeFragment.NavigationToSecond() {
            @Override
            public void toSecond(String type, String id) {

                showMyFragment(type, id);
            }
        });

    }


    @SuppressLint("ClickableViewAccessibility")
    private void initView() {
        Log.d("TAGddddddddddddllllllllsss", "initView: sssssssssssss");

        app.touchType = TouchType.HOME_PAGE;
        bottom_view = findViewById(R.id.bottom_navigation);
        dlMainDrawer = findViewById(R.id.DL_main_drawer);
        dlMainDrawer.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
        fl_sidebar = findViewById(R.id.Fl_sidebar);
        reMainContent = findViewById(R.id.RE_main_content);
        bottom_view.setOnItemSelectedListener(this);
        instance = StartS.getInstance();

        viewPager = findViewById(R.id.ViewPager_content);


        Bottom_navigationAdapter adapter = new Bottom_navigationAdapter(getSupportFragmentManager());
        viewPager.setAdapter(adapter);
        viewPager.setOffscreenPageLimit(2);
        homeFragment = (HomeFragment) viewPager.getAdapter().instantiateItem(viewPager, 0);
        homeHandler = homeFragment.getHomeHandler();
        myFragment = (MyFragment) viewPager.getAdapter().instantiateItem(viewPager, 1);
        msgFragment = (MsgFragment) viewPager.getAdapter().instantiateItem(viewPager, 2);

        animationUtil = new AnimationUtil();
        player_control = findViewById(R.id.main_player_control);

        // TextView viewById1 = viewById.findViewById(R.id.TV_main_songName);
        screenPoint = Utils.getScreen(this);
        statusBarHeight = Utils.getStatusBarHeight(this);
        ivPlayList = player_control.findViewById(R.id.IV_play_list);
        main_play = player_control.findViewById(R.id.IV_play_btn);
        dlMainDrawer = findViewById(R.id.DL_main_drawer);
        fl_sidebar = findViewById(R.id.Fl_sidebar);

        reMainContent = findViewById(R.id.RE_main_content);
        bottomSheet = findViewById(R.id.bottom_sheet);
        lin_player = player_control.findViewById(R.id.lin_player);

        include_player = findViewById(R.id.include_player);
        player_btn_to_back = include_player.findViewById(R.id.player_btn_to_back);
        playerFl = include_player.findViewById(R.id.player_FL);
        player_seekBar = include_player.findViewById(R.id.player_seekBar);
        player_viewPage = include_player.findViewById(R.id.player_viewPage);
        playerPageAdapter = new PlayerPageAdapter(this, app);

        play_module = include_player.findViewById(R.id.player_play_module);
        player_heart = include_player.findViewById(R.id.player_heart_off);
        layout_player_list = include_player.findViewById(R.id.layout_player_list);
        play_module.setImageDrawable(getDrawable(playMode[1]));

        previous_song = include_player.findViewById(R.id.player_previous_song);
        player_comment = include_player.findViewById(R.id.player_comment);
        play_btn = include_player.findViewById(R.id.player_play);
        next_song = include_player.findViewById(R.id.player_next_song);
        mLrcView = include_player.findViewById(R.id.player_LrcView);
        player_linePosition = include_player.findViewById(R.id.player_position);

        player_stylus = include_player.findViewById(R.id.player_stylus);
        player_stylus.setTranslationX((float) (screenPoint.x / 4.5));
        stylusY = player_stylus.getY();

        behavior = BottomSheetBehavior.from(bottomSheet);
        behavior.setState(BottomSheetBehavior.STATE_HIDDEN);
        include_song_list = findViewById(R.id.include_song_list);


        song_list_back = include_song_list.findViewById(R.id.song_list_back);
        list_title = include_song_list.findViewById(R.id.player_list_title);
        player_song_list = include_song_list.findViewById(R.id.re_player_song_list);

        scroll_btn = include_song_list.findViewById(R.id.scroll_btn);
        scroll_btn.setOnTouchListener((v, event) -> closeList(null, event, scroll_btn));
        player_song_list.setOnTouchListener((v, event) -> closeList((RecyclerView) v, event, scroll_btn));
//

        LinearLayoutManager song_list_LayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
        player_song_list.setLayoutManager(song_list_LayoutManager);

        ivPlayList.setOnClickListener(this);
        main_play.setOnClickListener(this);
        layout_player_list.setOnClickListener(this);

        player_seekBar.setOnSeekBarChangeListener(this);
        song_list_back.setOnClickListener(this);
        player_viewPage.addOnPageChangeListener(this);
        player_heart.setOnClickListener(this);
        player_comment.setOnClickListener(this);
        bottomSheet.setOnClickListener(this);


        player_viewPage.setOnTouchListener((v, event) -> {

            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    // 记录手指按下时的坐标
                    startX = event.getX();
                    startY = event.getY();
                    lodDate = new Date().getTime();
                    break;
                case MotionEvent.ACTION_MOVE:
                    // 在手指移动时进行判断
                    float endX = event.getX();
                    float endY = event.getY();

                    // 计算水平和垂直方向的位移
                    deltaX = endX - startX;
                    deltaY = endY - startY;

                    // 判断是水平滑动还是垂直滑动
                    if (Math.abs(deltaX) > Math.abs(deltaY)) {
                        // 水平滑动
                        if (deltaX > 0) {
                            diffOffset = 0;
                        } else {
                            diffOffset = 1;
                        }
                    }

                    // 更新起始坐标
                    startX = endX;
                    startY = endY;
                    break;
                case MotionEvent.ACTION_UP:

                    nowDate = new Date().getTime();
                    Log.d("TAG111111111111222", "initView: " + isScroll + "sssss" + getCurrentPagerIdx());

                    new Handler(Looper.getMainLooper()).postDelayed(
                            new Runnable() {
                                @Override
                                public void run() {
                                    if ((nowDate - lodDate) < 300 && !isScroll) {

                                        player_stylus.setVisibility(View.INVISIBLE);
                                        mLrcView.setVisibility(View.VISIBLE);
                                        player_viewPage.setVisibility(View.INVISIBLE);
                                    }
                                    isScroll = false;
                                }
                            }, 100
                    );
                    if (Math.abs(deltaX) > Math.abs(deltaY)) {
                        return false;
                    }


                    break;
            }

//            if (instance.serviceBinder!=null) {
//                if (!instance.serviceBinder.isPlaying()) {
//                    if (!playerInfo.isPlayOrPause()){
//                        return false;
//                    }
//                    return  true;
//                }
//            }


            return false;
        });
        mLrcView.setOnClickListener(this);
        play_module.setOnClickListener(this);
        previous_song.setOnClickListener(this);
        play_btn.setOnClickListener(this);
        next_song.setOnClickListener(this);
        player_btn_to_back.setOnClickListener(this);
        player_linePosition.setOnClickListener(this);
        behavior.addBottomSheetCallback(new BottomSheetBehavior.BottomSheetCallback() {
            @Override
            public void onStateChanged(@NonNull View view, int i) {
                if (i == BottomSheetBehavior.STATE_COLLAPSED || i == BottomSheetBehavior.STATE_HIDDEN) {
                    include_player.setVisibility(View.VISIBLE);
                    behavior.setState(BottomSheetBehavior.STATE_HIDDEN);
                }
                if (mLrcView.getVisibility() == View.VISIBLE || include_song_list.getVisibility() == View.VISIBLE) {
                    if (i == BottomSheetBehavior.STATE_DRAGGING) {
                        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
                    }
                }


            }

            @Override
            public void onSlide(@NonNull View view, float v) {

            }
        });
        main_player_img = player_control.findViewById(R.id.main_player_img);

        setImg = url -> {
            Glide.with(this.getApplicationContext())
                    .asBitmap()
                    .load(url)
                    .error(R.drawable.img_background)
                    .placeholder(R.drawable.img_background)
                    .apply(RequestOptions.bitmapTransform(new RoundedCorners(100)))
                    .addListener(new RequestListener<Bitmap>() {
                        @Override
                        public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
                            // 加载失败时的处理
                            return false;
                        }

                        @Override
                        public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                            // 加载成功时的处理
                            Utils.setColor(resource, player_rootView, "Muted");
                            return false;
                        }
                    })
                    .into(main_player_img);
            if (lin_player.getVisibility() == View.INVISIBLE) {
                lin_player.setVisibility(View.VISIBLE);
            }

        };
        setList = (listBean) -> {

            if (listBean != null) {
                if (PlayerList != null) {
                    PlayerList.clear();
                } else {
                    PlayerList = new ArrayList<>();
                }
                PlayerList.addAll(listBean);
                playerInfo.setListBeans(listBean);
                activityMainBinding.setPlayerInfo(playerInfo);

                playerPageAdapter.setData(PlayerList);
                PagerAdapter pagerAdapter = player_viewPage.getAdapter();
                RecyclerView.Adapter listAdapter = player_song_list.getAdapter();
                if (pagerAdapter == null || listAdapter == null) {
                    player_viewPage.setAdapter(playerPageAdapter);
                    songListAdapter = new SongListAdapter(this);
                    player_song_list.setAdapter(songListAdapter);
                } else {
                    songListAdapter.upData(listBean);
                }


            }

        };
        setCurrentPageItem = current -> {
            Log.d("TAG111111111111111", "initView: 我被调用");

            if (isUpData == 1) {
                isUpData = 2;
                playerPageAdapter.setData(playerInfo.getListBeans());
            }
            player_viewPage.setCurrentItem(current);
            if (animationUtils != null) {
                animationUtils.stopRotate("cancel");
            }
        };
        lin_player.setVisibility(View.INVISIBLE);

        homeFragment.setLoadNetWorkCall((flag, sheetId) -> {
            loadNetWork(flag, null, sheetId);
        });
        homeFragment.setSongLists(songList -> {

            this.songLists = songList;
        });
        callback = () -> new MediaSessionCompat.Callback() {


            @Override
            public void onPlay() {
                setPlay();

                Log.d("MediaSessionManager", "onPlay: ");
            }

            @Override
            public void onPause() {
                setStop();
                Log.d("MediaSessionManager", "onPause: ");
            }

            @Override
            public void onSkipToNext() {
                switchSong = true;
                next_song.setClickable(false);

                if (isUpData == 1) {
                    isUpData = 2;
                    playerPageAdapter.setData(playerInfo.getListBeans());
                    if (pIndex == 0) {
                        player_viewPage.setCurrentItem(position1 + playerInfo.getListBeans().size() + 1, false);
                        pIndex = 1;
                    } else {
                        player_viewPage.setCurrentItem(position1 - playerInfo.getListBeans().size() + 1, false);
                        pIndex = 0;
                    }
                } else {
                    player_viewPage.setCurrentItem(position1 + 1);

                }
                Log.d("MediaSessionManager", "onSkipToNext: ");
            }

            @Override
            public void onSkipToPrevious() {
                switchSong = true;
                previous_song.setClickable(false);


                if (isUpData == 1) {
                    isUpData = 2;
                    playerPageAdapter.setData(playerInfo.getListBeans());
                    if (pIndex == 0) {
                        player_viewPage.setCurrentItem(position1 + playerInfo.getListBeans().size() - 1, false);
                        pIndex = 1;
                    } else {
                        player_viewPage.setCurrentItem(position1 - playerInfo.getListBeans().size() - 1, false);
                        pIndex = 0;
                    }

                } else {
                    player_viewPage.setCurrentItem(position1 - 1);

                }

                Log.d("MediaSessionManager", "onSkipToPrevious: ");
            }

            @Override
            public void onStop() {
                Log.d("MediaSessionManager", "onStop: ");
            }

            @Override
            public void onSeekTo(long pos) {
                instance.serviceBinder.seek2((int) pos);
                Log.d("MediaSessionManager", "onSeekTo: " + pos);
            }
        };

        lin_player.setOnClickListener(this);


        player_rootView = include_player.findViewById(R.id.player_rootView);
        player_rootView.setPadding(0, statusBarHeight, 0, 0);
        ViewGroup.LayoutParams layoutParams = player_rootView.getLayoutParams();
        layoutParams.height = screenPoint.y + statusBarHeight;
        player_rootView.setLayoutParams(layoutParams);
        if (userInfo != null) {
            loadNetWork("playlist", null, 0);
        }
        restoreData();
    }

    public void loadNetWork(String requestFlag, long[] SongId, long sheetId) {
        long songId = playerInfo.getSongId();
        if (homeHandler == null) return;
        switch (requestFlag) {
            case "lyric":
                NetworkUtils.makeRequest(NetworkInfo.URL + "/lyric/new?id=" + songId, homeHandler, LRC_ID, true, this);
                break;
//            case "playlist":
//
//                NetworkUtils.makeRequest(NetworkInfo.URL + "/user/playlist?uid="+userInfo.getUserId(), homeHandler, SONG_SHEET_ID,true,this);
//                break;
            case "addToPlaylist":
                String str = "";
                for (int i = 0; i < SongId.length; i++) {
                    if (i < SongId.length - 1) {
                        str = str + SongId[i] + ",";
                    } else {
                        str = str + SongId[i];
                    }
                }

                NetworkUtils.makeRequest(NetworkInfo.URL + "/playlist/tracks?op=add&pid=" + sheetId + "&tracks=" + str, homeHandler, ADD_OR_REMOVE, true, this);
                break;
            case "removePlaylist":
                String str1 = "";
                for (int i = 0; i < SongId.length; i++) {
                    if (i < SongId.length - 1) {
                        str1 = str1 + SongId[i] + ",";
                    } else {
                        str1 = str1 + SongId[i];
                    }
                }
                NetworkUtils.makeRequest(NetworkInfo.URL + "/playlist/tracks?op=del&pid=" + sheetId + "&tracks=" + str1, homeHandler, ADD_OR_REMOVE, true, this);

                break;
            case "getSongList":

                NetworkUtils.makeRequest(NetworkInfo.URL + "/playlist/track/all?id=" + sheetId, homeHandler, SONG_LIST, true, this);

                break;


        }

    }


    @Override
    public boolean onNavigationItemSelected(@NonNull MenuItem item) {
        int itemId = item.getItemId();
        if (item.isCheckable()) {
            item.setChecked(true);
        }

        if (itemId == R.id.item_home) {
            app.touchType = TouchType.HOME_PAGE;
            viewPager.setCurrentItem(0, false);

        } else if (itemId == R.id.item_my) {
            app.touchType = TouchType.MY_PAGE;
            viewPager.setCurrentItem(1, false);

        } else {
            app.touchType = TouchType.MSG_PAGE;
            viewPager.setCurrentItem(2, false);
            msgFragment.onRefresh();

        }

        return false;
    }


    @Override
    protected void onStart() {
        super.onStart();
        Log.d("TAGpppppppppssss", "onStart: ");

    }

    @Override
    protected void onResume() {

        super.onResume();
        SharedPreferences userInfoData = getSharedPreferences("UserInfoData", Context.MODE_PRIVATE);
        String string = userInfoData.getString("UserInfo", "");
        if ((!string.equals("") || !TextUtils.isEmpty(string)) && playerInfo.getUserInfoBean() == null) {
            try {
                JSONObject info = new JSONObject(string);
                String profile = String.valueOf(info.get("profile"));
                userInfo = (UserInfoBean) MyGsonUtil.getInstance().press(profile, "userInfo", app).get(0);
                ContentValues values = new ContentValues();
                Cursor query = getContentResolver().query(Uri.parse("content://com.rikkatheworld.wangyiyun/saveUser/" + userInfo.getUserId()), null, null, null, null);
                values.put("userId", userInfo.getUserId());
                values.put("avatarUrl", userInfo.getAvatarUrl());
                values.put("backgroundUrl", userInfo.getBackgroundUrl());
                values.put("nickname", userInfo.getNickname());
                values.put("birthday", userInfo.getBirthday());
                values.put("province", userInfo.getProvince());
                values.put("gender", userInfo.getGender());
                values.put("city", userInfo.getCity());
                values.put("followeds", userInfo.getFolloweds());
                values.put("follows", userInfo.getFollows());
                values.put("eventCount", userInfo.getEventCount());
                values.put("level", userInfo.getLevel());

                if (query.getCount() == 0) {
                    getContentResolver().insert(Uri.parse("content://com.rikkatheworld.wangyiyun/saveUser"), values);
                } else {
                    getContentResolver().update(Uri.parse("content://com.rikkatheworld.wangyiyun/saveUser/" + userInfo.getUserId()), values, null, null);
                }

                playerInfo.setUserInfoBean(userInfo);
                activityMainBinding.setPlayerInfo(playerInfo);

            } catch (JSONException e) {
                throw new RuntimeException(e);
            }
        }

        getLrcString = (Lrc, tLrc) -> {
            if (Lrc.equals("") || TextUtils.isEmpty(Lrc)) {
                return;
            }

            LrcString = Lrc;

            List<LrcBean> lrcBeanList = LrcUtil.parseStr2List(Lrc, tLrc);

            mLrcView.setLrc(lrcBeanList);
            mLrcView.init();
        };
        showLrcInfoView = showOrHide -> {
            if (showOrHide) {
                player_linePosition.setVisibility(View.VISIBLE);
            } else {
                player_linePosition.setVisibility(View.INVISIBLE);
            }

        };


    }


    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        Log.d("TAG--------ahaha", "onSaveInstanceState: ");
        FileUtils.writeStringToFile(this, "homeData.text", app.HomeData);

        outState.putString("data", "homeData.text");
        super.onSaveInstanceState(outState);

    }

    @Override
    protected void onDestroy() {
        Log.d("TAGpapapapapapa", "onDestroy: ");

        filePath = getApplicationContext().getFilesDir() + "/" + fileName;
        if (playerInfo.getListBeans() != null) {
            MusicCacheBean bean = new MusicCacheBean(position1 % playerInfo.getListBeans().size(),
                    instance.serviceBinder.getCurrentPosition(), playerInfo.getCurrentPosition(),
                    playerInfo.getDurationNum(), playerInfo.getDuration(), CURRENT_PLAY_MODE, playerInfo.getListBeans());
            MusicPlayerUtils.serializeList(bean, filePath);
        }

        DataModel.getInstance().removeObserver(this);
        if (instance != null && instance.serviceConnection != null) {
            unbindService(instance.serviceConnection);
            stopService(instance.intent);
            instance.serviceBinder.stopPlay();
        }
        notifyBuilderManager.cancelNotification();

        super.onDestroy();
    }


    @SuppressLint("HandlerLeak")
    private final Handler handler = new Handler(Looper.getMainLooper()) {
        private JSONObject data;
        private String account;

        @Override
        public void handleMessage(Message msg) {

            super.handleMessage(msg);
            if (msg.what == STATUS) {
                String string = msg.obj.toString();
                if (string != null) {

                    JSONObject jsonObject = null;
                    try {
                        jsonObject = new JSONObject(string);
                        if (jsonObject.has("data")) {
                            data = (JSONObject) jsonObject.get("data");
                            account = String.valueOf(data.get("account"));
                        } else {
                            account = String.valueOf(jsonObject.get("account"));
                        }

                        if (account.equals("null")) {
                            Intent intent = new Intent(MainActivity.this, LoginPage.class);
                            startActivity(intent);
                        }
//                        else if(json==null){
//                            Log.d("TAG11111111111111111111111", "dispatchMessage: ssss1111");
//
//                            NetworkUtils.makeRequest(NetworkInfo.URL + "/msg/private",MsgFragment.handler,RES_ID,true,getContext());
//
//                        }

                    } catch (JSONException e) {
                        throw new RuntimeException(e);
                    }


                }

            }
        }

        ;
    };

    public void OpenSheet() {
        mLrcView.setVisibility(View.INVISIBLE);
        behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
    }

    @Override
    public void onClick(View v) {

        int id = v.getId();
        if (id == R.id.lin_player) {

            // animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
            fl_sidebar.setVisibility(View.GONE);
            behavior.setState(BottomSheetBehavior.STATE_EXPANDED);
            player_viewPage.setVisibility(View.VISIBLE);
            mLrcView.setVisibility(View.INVISIBLE);
            player_stylus.setVisibility(View.VISIBLE);
        } else if (id == R.id.player_btn_to_back) {
            behavior.setState(BottomSheetBehavior.STATE_COLLAPSED);
            behavior.setState(BottomSheetBehavior.STATE_HIDDEN);

        } else if (id == R.id.song_list_back) {
            animationUtil.hideView(include_song_list);
            reMainContent.setAlpha(1F);
            player_rootView.setAlpha(1F);
        } else if (id == R.id.IV_play_list || id == R.id.layout_player_list) {
            scroll_btn.scrollTo(0, 0);
            animationUtil.showView(include_song_list);
            reMainContent.setAlpha(0.5F);
            player_rootView.setAlpha(0.5F);
        } else if (id == R.id.player_play_module) {
            isUpData = 1;
            Drawable drawable = play_module.getDrawable();
            int drawable_hashCode = drawable.getConstantState().hashCode();


            if (CURRENT_PLAY_MODE == SINGLE_PLAY_MODE_ONE || CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE) {


                if (CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE) {
                    CURRENT_PLAY_MODE = SINGLE_PLAY_MODE_ONE;
                    play_module.setImageDrawable(getDrawable(ExclusiveMusicMode[0]));
                } else {
                    CURRENT_PLAY_MODE = UNLIMITED_PLAYBACK_MODE;
                    play_module.setImageDrawable(getDrawable(ExclusiveMusicMode[1]));
                }

                // ExclusiveMusicMode
            } else for (int i = 0; i < playMode.length; i++) {
                if (drawable_hashCode == getDrawable(playMode[i]).getConstantState().hashCode()) {
                    if (i == playMode.length - 1) {
                        upDataList(0);
                    }
                    upDataList(i + 1);

                }
            }


        } else if (id == R.id.player_previous_song) {
            //上一曲
            AUTO_PLAY = true;
            switchSong = true;
            previous_song.setClickable(false);
            //instance.serviceBinder.playOrPause(STATE_PLAY);
            //  animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);

            if (isUpData == 1) {
                isUpData = 2;
                playerPageAdapter.setData(playerInfo.getListBeans());
                if (pIndex == 0) {
                    player_viewPage.setCurrentItem(position1 + playerInfo.getListBeans().size() - 1, false);
                    pIndex = 1;
                } else {
                    player_viewPage.setCurrentItem(position1 - playerInfo.getListBeans().size() - 1, false);
                    pIndex = 0;
                }

            } else {
                player_viewPage.setCurrentItem(position1 - 1);

            }


        } else if (id == R.id.player_play || id == R.id.IV_play_btn) {

            if (!AUTO_PLAY) {
                notifyBuilderManager.createDateNotification(playerInfo.getImgUrl(),
                        playerInfo.getSongName(), playerInfo.getSingerName(), playerInfo.getDurationNum());
                instance.serviceBinder.seekTo((int) currentPosition);
            }
            AUTO_PLAY = true;
            playerOrStop();
        } else if (id == R.id.player_next_song) {//下一曲

            AUTO_PLAY = true;

//            if(CURRENT_PLAY_MODE==UNLIMITED_PLAYBACK_MODE&&isUpData==1){isUpData = 2;
//                playerPageAdapter.setData(playerInfo.getListBeans());
//                songListAdapter.upData(playerInfo.getListBeans());
//            }
//            if(CURRENT_PLAY_MODE==UNLIMITED_PLAYBACK_MODE&&playerInfo.getListBeans().size()-1==getCurrentPagerIdx())return;
            switchSong = true;
            next_song.setClickable(false);

            if (isUpData == 1) {
                isUpData = 2;
                playerPageAdapter.setData(playerInfo.getListBeans());
                if (pIndex == 0) {
                    player_viewPage.setCurrentItem(position1 + playerInfo.getListBeans().size() + 1, false);
                    pIndex = 1;
                } else {
                    player_viewPage.setCurrentItem(position1 - playerInfo.getListBeans().size() + 1, false);
                    pIndex = 0;
                }
            } else {
                player_viewPage.setCurrentItem(position1 + 1);

            }

            //  instance.serviceBinder.playOrPause(STATE_PLAY);
            // animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
            Log.d("TAGpppppppppppppppppppppppp", "onClick: " + (position1 + 1) + "---------" + (getCurrentPagerIdx()));


        } else if (id == R.id.player_position) {//滑动到歌词处点击跳到选定处播放
            jumpTo jumpTo = mLrcView.setJump();
            if (jumpTo != null) jumpTo.toPosition();
        } else if (id == R.id.player_LrcView) {//隐藏滚动歌词显示唱片
            Log.d("TAG----ssssfff-----", "onClick: ");
            player_stylus.setVisibility(View.VISIBLE);
            mLrcView.setVisibility(View.INVISIBLE);
            player_viewPage.setVisibility(View.VISIBLE);
            showLrcInfoView.ShowLrcInfoView(false);
        } else if (id == R.id.player_heart_off) {
            heart_isOnClick = true;

            likeOrNot1 = !likeOrNot1;
            if (likeOrNot1) {
                if (!newLikeList.contains(playerInfo.getSongId())) {
                    newLikeList.add(playerInfo.getSongId());

                }
            } else {

                newLikeList.remove(playerInfo.getSongId());

            }
            player_heart.setImageDrawable((likeOrNot1 ? getDrawable(R.drawable.baseline_favorite) : getDrawable(R.drawable.baseline_not_favorite)));

        } else if (id == R.id.player_comment) {
            Intent intent = new Intent(this, CommentActivity.class);

            intent.putExtra("songName", playerInfo.getSongName());
            intent.putExtra("Id", playerInfo.getSongId());
            intent.putExtra("singerName", playerInfo.getSingerName());
            intent.putExtra("imgUrl", playerInfo.getImgUrl());
            // Log.d("TAG000011122233344455678", "onClick: "+playerInfo.getUserInfoBean().getUserId());
            intent.putExtra("userId", playerInfo.getUserInfoBean().getUserId());
            intent.putExtras(intent);
            startActivity(intent);


        }


    }

    public void playerOrStop() {
        int state;
        if (playerInfo.isPlayOrPause()) {
            state = STATE_PLAY;
            animationUtils.stopRotate("pause");
            playerPageAdapterAnimation.stopRotate("pause");

        } else {
            state = STATE_PAUSE;
            animationUtils.proceedRotate();
            playerPageAdapterAnimation.proceedRotate();
        }

        instance.serviceBinder.playOrPause(state);
        playerInfo.setPlayOrPause(!playerInfo.isPlayOrPause());
        animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
        activityMainBinding.setPlayerInfo(playerInfo);
    }

    public void setStop() {
        int state;
        if (playerInfo.isPlayOrPause()) {
            state = STATE_PLAY;

            instance.serviceBinder.playOrPause(state);
            playerInfo.setPlayOrPause(!playerInfo.isPlayOrPause());
            animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
            activityMainBinding.setPlayerInfo(playerInfo);
            animationUtils.stopRotate("pause");
            playerPageAdapterAnimation.stopRotate("pause");
        }


    }

    public void setPlay() {
        int state;

        if (!playerInfo.isPlayOrPause() && instance.serviceBinder != null) {
            state = STATE_PAUSE;
            animationUtils.proceedRotate();
            playerPageAdapterAnimation.proceedRotate();
            instance.serviceBinder.playOrPause(state);
            playerInfo.setPlayOrPause(!playerInfo.isPlayOrPause());
            animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
            activityMainBinding.setPlayerInfo(playerInfo);
        }


    }

    public void setCurrentMode(String type) {
        if (type.equals("ExclusiveMusicMode")) {
            CURRENT_PLAY_MODE = UNLIMITED_PLAYBACK_MODE;
            play_module.setImageDrawable(getDrawable(ExclusiveMusicMode[1]));
        } else {

            CURRENT_PLAY_MODE = SEQUENTIAL_MODE;
            play_module.setImageDrawable(getDrawable(playMode[1]));
        }

    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {

    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
        StateFlag = true;
    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

        if (StateFlag) {
            StateFlag = false;
            int progress = seekBar.getProgress();

            if (instance.serviceBinder != null) {
                currentPosition = progress;
                Log.d("TAGpppppcurrentPositionpppp", "onStopTrackingTouch: " + currentPosition);
                instance.serviceBinder.seekTo(progress);

            }
        }
        mLrcView.UpdateMusicProcess();
    }

    public static void beginService(Context context) {
        instance.startS(context);

        mLrcView.setStartS(instance);
    }


    public static final IPlayerViewChange mIPlayerViewChange = new IPlayerViewChange() {


        @Override
        public void onSeekChange(int seek) {
            if (!StateFlag) {
                activity.runOnUiThread((Runnable) () -> player_seekBar.setProgress(seek));
            }
        }

        @Override
        public void RotateView() {
            beginRotate();
        }

        @Override
        public void loadUrl() {
            homeFragment.loadMp3("radio");
        }

        @Override
        public int currentIndex() {
            return player_viewPage.getCurrentItem();
        }
    };


    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

        offset = positionOffset;

        Log.d("TAG----------------ll", "onPageScrolled: " + Math.abs(1 - offset) + "--" + Math.abs(0 - offset));


    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }


    @Override
    public void onPageSelected(int position) {
        Log.d("TAG11111111111122333", "onPageSelected: " + switchSong + isOnClick + CURRENT_PLAY_MODE + position);
        isScroll = true;
        if (instance.serviceBinder != null) {
            instance.serviceBinder.playOrPause(STATE_PLAY);
            animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
            animationUtils.stopRotate("pause");
            playerPageAdapterAnimation.stopRotate("pause");
        }
        if (CURRENT_PLAY_MODE == SINGLE_PLAY_MODE_ONE || CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE) {
            if (playerInfo.getListBeans().size() - 1 == position) {
                homeFragment.loadOk = false;
                //   isUpData = 1;
                homeFragment.loadMp3("radio");

                // return;
            }
            // player_viewPage.setCurrentItem(position1+1);
        }
        if (!isOnClick && !switchSong) {
            if (isFirstScroll) {
                isFirstScroll = false;
            } else AUTO_PLAY = true;

            if (CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE && isUpData == 1) {
                isUpData = 2;
                playerPageAdapter.setData(playerInfo.getListBeans());
                return;
            }
            if (CURRENT_PLAY_MODE != RANDOM_PLAY_MODE) {
                if (inTO) {
                    inTO = false;
                    isUpData = 2;
                    playerPageAdapter.setData(playerInfo.getListBeans());
                    playerPageAdapter.notifyDataSetChanged();
                    if (diffOffset == 1) {
                        player_viewPage.setCurrentItem(position1 + 1, false);
                    } else player_viewPage.setCurrentItem(position1 - 1, false);
                    return;
                }
                play(String.valueOf(playerInfo.getListBeans().get((position) % playerInfo.getListBeans().size()).getSongId()), null);
                currentPlay(position);
                return;
            }

            if (isUpData == 1) {
                isUpData = 2;
                inTO = true;
                playerPageAdapter.setData(playerInfo.getListBeans());
                playerPageAdapter.notifyDataSetChanged();

                if (diffOffset == 1) {
                    player_viewPage.setCurrentItem(position1 + 1, false);
                } else player_viewPage.setCurrentItem(position1 - 1, false);

                return;
            }
            play(String.valueOf(playerInfo.getListBeans().get((position) % playerInfo.getListBeans().size()).getSongId()), null);
            currentPlay(position);
            return;
        }

        if (switchSong) {
            //    CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE
            play(String.valueOf(playerInfo.getListBeans().get((position) % playerInfo.getListBeans().size()).getSongId()), null);
        }
        currentPlay(position);


    }

    private void currentPlay(int position) {
        ListBean listBeans;
        Log.d("TAG111111111111", "currentPlay: " + ((position1 > position || position1 < position) && playerInfo.getSongId() != currentId));
        //     long songId = playerInfo.getListBeans().get(position % playerInfo.getListBeans().size()).getSongId();
        if ((position1 > position || position1 < position) && playerInfo.getSongId() != currentId) {


            position1 = position;
            listBeans = playerInfo.getListBeans().get(position % playerInfo.getListBeans().size());

            Log.d("TAG111111111111", "currentPlay: " + listBeans.getImgUrl() + (AUTO_PLAY && instance != null) + "-----" + AUTO_PLAY);
            songListAdapter.setIndex(position);
            setImg.setImg(listBeans.getImgUrl());
            String name = Utils.getString(listBeans);
            playerInfo.setSongName(listBeans.getSongName());
            playerInfo.setImgUrl(listBeans.getImgUrl());

            if (AUTO_PLAY) {

                playerInfo.setCurrentPosition("00:00");
                player_seekBar.setProgress(0);
                playerInfo.setPlayOrPause(true);
            }
            playerInfo.setSingerName(name);
            playerInfo.setSongId(listBeans.getSongId());
            activityMainBinding.setPlayerInfo(playerInfo);
            setCurrentIdToFlutter(playerInfo.getSongId());
//            isOnClick = false;
//            switchSong = false;
            mLrcView.setTips(true);
            likeOrNot = likeOrNot(playerInfo.getSongId());
            boolean isIn = newLikeList.stream().anyMatch(num -> {
                if (newLikeList.size() == 0) return false;

                return playerInfo.getSongId() == num;
            });

            player_heart.setImageDrawable((likeOrNot || isIn ? getDrawable(R.drawable.baseline_favorite) : getDrawable(R.drawable.baseline_not_favorite)));
            likeOrNot1 = likeOrNot || isIn;
            if (instance.serviceBinder != null) {
                loadNetWork("lyric", null, 0);
            }


        }

    }

    public void setCurrentIdToFlutter(long id) {

        if (msgFragment != null && msgFragment.msgBindings != null) {
            msgFragment.msgBindings.channel.invokeMethod("currentId", id);
        }
        if (myFragment != null && myFragment.myBindings != null) {
            myFragment.myBindings.channel.invokeMethod("currentId", id);
        }
        if (homeFragment.searchFragment != null) {
            homeFragment.searchFragment.searchBindings.channel.invokeMethod("currentId", id);
        }

        if (secondFragment != null) {
            secondFragment.otherBindings.channel.invokeMethod("currentId", id);
        }


    }

    public void upDataList(int mode) {

        switch (mode) {
            case 0://单曲循环

                List<ListBean> list = PlayerList;
                CURRENT_PLAY_MODE = SINGLE_PLAY_MODE;
                play_module.setImageDrawable(getDrawable(playMode[0]));
                songListAdapter.upData(list);
                playerInfo.setListBeans(list);
                activityMainBinding.setPlayerInfo(playerInfo);

                if (orderList != null) {
                    orderList.clear();
                    orderList.addAll(list);
                }

                int nextIndex = (getCurrentPagerIdx() % list.size()) + 1 >= list.size() ?
                        0 : (getCurrentPagerIdx() % list.size()) + 1;
                ListBean nextPager = null;
                ListBean previousPager = null;
                int previousIndex = (getCurrentPagerIdx() % list.size()) - 1 < 0 ?
                        list.size() - 1 : (getCurrentPagerIdx() % list.size()) - 1;
                for (int i = 0; i < list.size(); i++) {
                    if (playerInfo.getSongId() == list.get(i).getSongId()) {
                        nextPager = i + 1 >= list.size() ? list.get(0) : list.get(i + 1);
                        previousPager = i - 1 < 0 ? list.get(list.size() - 1) : list.get(i - 1);
                    }
                }
                orderList.set(nextIndex, nextPager);
                orderList.set(previousIndex, previousPager);
                playerPageAdapter.setData(orderList);
                playerPageAdapter.notifyDataSetChanged();

                for (int i = 0; i < list.size(); i++) {
                    if (listBean.get(position1 % list.size()).getSongId() == list.get(i).getSongId()) {
                        position1 = position1 + i - ((position1 + i) % list.size() - i);
                        songListAdapter.setIndex(position1);
                        break;
                    }
                }

                break;
            case 1://顺序播放
                CURRENT_PLAY_MODE = SEQUENTIAL_MODE;

                play_module.setImageDrawable(getDrawable(playMode[1]));

                break;
            case 2://随机播放
                CURRENT_PLAY_MODE = RANDOM_PLAY_MODE;

                if (listBean != null) listBean.clear();
                listBean.addAll(playerInfo.getListBeans());
                play_module.setImageDrawable(getDrawable(playMode[2]));
                ListBean listBean1 = listBean.get(position1 % listBean.size());
                listBean.remove(listBean1);
                // 对剩余元素进行随机排序
                Collections.shuffle(listBean);
                // 将固定元素放回列表中的原始位置
                listBean.add(0, listBean1);
                songListAdapter.upData(listBean);
                playerInfo.setListBeans(listBean);
                activityMainBinding.setPlayerInfo(playerInfo);
                if (temporaryList != null) {
                    temporaryList.clear();
                    temporaryList.addAll(listBean);
                }

                int nextPagerIdx = (getCurrentPagerIdx() % listBean.size()) + 1 >= listBean.size() ? 0 : (getCurrentPagerIdx() % listBean.size()) + 1;
                int previousPagerIdx = (getCurrentPagerIdx() % listBean.size()) - 1 < 0 ? listBean.size() - 1 : (getCurrentPagerIdx() % listBean.size()) - 1;
                temporaryList.set(nextPagerIdx, listBean.get(1));
                temporaryList.set(previousPagerIdx, listBean.get(listBean.size() - 1));
                playerPageAdapter.setData(temporaryList);
                for (int i = 0; i < listBean.size(); i++) {
                    if (position1 % listBean.size() == 0) {
                        songListAdapter.setIndex(position1);
                        break;
                    } else position1 -= 1;
                }

                break;
        }
    }

    public void upData(long id) {
        if (listBean.size() != 0) {
            listBean.clear();
        }
        listBean.addAll(PlayerList);
        switchSong = false;
        isOnClick = true;
        for (int i = 0; i < listBean.size(); i++) {

            if (listBean.get(i).getSongId() == id) {
                ListBean listBean1 = listBean.get(i);
                listBean.remove(listBean1);
                Collections.shuffle(listBean);
                listBean.add(0, listBean1);
                playerInfo.setListBeans(listBean);
                activityMainBinding.setPlayerInfo(playerInfo);
                songListAdapter.upData(listBean);
                playerPageAdapter.setData(listBean);
                Log.d("TAG11111111111111111111111111", "upData:aaaaa ");

                for (int j = 0; j < listBean.size(); j++) {
                    if (position1 % listBean.size() == 0) {
                        songListAdapter.setIndex(position1);
                        if (pIndex == 0) {
                            player_viewPage.setCurrentItem(position1 + listBean.size());
                            pIndex = 1;
                        } else {
                            player_viewPage.setCurrentItem(position1 - listBean.size());
                            pIndex = 0;
                        }
                        Log.d("TAG11111111111111hh", "upData: 11111sss" + getCurrentPagerIdx());
                        break;
                    } else position1 -= 1;
                }
                break;
            }
        }
    }

    public static void scrollPage() {
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                if (position1 <= 100000 && position1 >= 0) {
                    if (isUpData == 1) {
                        isUpData = 2;
                        playerPageAdapter.setData(playerInfo.getListBeans());
                    }
                    // player_viewPage.getAdapter().notifyDataSetChanged();
                    player_viewPage.setCurrentItem(position1 + 1);
                }
            }
        });


    }


    public boolean likeOrNot(long id) {

        if (songLists == null) return false;

        return songLists.stream().anyMatch((Predicate<UserSongListBean>) userSongListBean ->
                userSongListBean.getSongId() == id);

    }


    public boolean closeList(RecyclerView view, MotionEvent event, View parent) {
        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN:
                downY = event.getY();
                break;
            case MotionEvent.ACTION_MOVE:
                if (downY - event.getY() == 0) {
                    return false;
                }

                scrollH = (int) Math.abs(event.getY() - downY);
                scroll = 0;

                if (event.getY() < downY) {
                    if (parent.getScrollY() == 0) {
                        downY = event.getY();
                    }
                    if (parent.getScrollY() != 0) {
                        if (view == null) {
                            if (parent.getScrollY() == 0) {
                                return false;
                            }
                            parent.scrollTo(0, 0);
                        } else {

                            scroll = Math.min(parent.getScrollY() + scrollH, 0);
                            parent.scrollTo(0, scroll);
                            return false;
                        }
                    }


                } else {
                    if (parent.getScrollY() == 0) {
                        downY = event.getY();

                    }
                    scroll = (int) Math.min(parent.getScrollY() - scrollH, 0);

                    if (view == null) {
                        // scroll = Math.min(parent.getScrollY() - scrollH, 0);
                        parent.scrollTo(0, scroll / 2);
                    } else {
                        if (!view.canScrollVertically(-1)) {

                            parent.scrollTo(0, (int) (scroll));
                            return parent.getScrollY() != 0;
                        } else {

                        }
                        return false;
                    }
                }
                break;
            case MotionEvent.ACTION_UP:
                if (downY - event.getY() == 0) {
                    return true;
                }

                if (parent.getScrollY() < 0) {
                    if (Math.abs(parent.getScrollY()) > 300) {
//
                        animationUtil.hideView(include_song_list);
                        reMainContent.setAlpha(1F);
                        player_rootView.setAlpha(1F);
                    } else {

                        parent.scrollTo(0, 0);
                    }
                }
                break;
        }
        return view == null;
    }


    private void showMyFragment(String type, String id) {
        hideView();
        // 获取FragmentManager
        FragmentManager fragmentManager = getSupportFragmentManager();
        // 开始事务
        transaction = fragmentManager.beginTransaction();
        transaction.setCustomAnimations(
                R.anim.fade_in,
                R.anim.fade_out,
                R.anim.fade_in,
                R.anim.fade_out
        );
        // 检查MyFragment是否已添加，如果没有，则添加
        secondFragment = (SecondPage) fragmentManager.findFragmentByTag("SecondPage_FRAGMENT");
        if (secondFragment == null) {
            secondFragment = new SecondPage();
            // 使用addToBackStack允许用户通过返回按钮回到之前的状态
            transaction.add(R.id.fragment_container, secondFragment, "SecondPage_FRAGMENT")
                    .addToBackStack(null)
                    .commit();
        } else {

            transaction.show(secondFragment).commit();
        }
        secondFragment.setParams(new SecondPage.GetParams() {
            @Override
            public Map<String, Object> getParam() {
                Map<String, Object> map = new HashMap<>();
                map.put("type", type);
                map.put("id", id);
                return map;
            }
        });

    }

    @Override
    public void onNext() {

    }


    public int getCurrentPagerIdx() {

        return player_viewPage.getCurrentItem();
    }

    public void play(String id, SetCurrentMp3 setCurrentMp3) {
        currentId = Long.parseLong(id);


        boolean isHave = false;
        if (songList != null && songList.size() > 0) {
            for (int i = 0; i < songList.size(); i++) {
                if (String.valueOf(songList.get(i).getId()).equals(id)) {
                    Log.d("TAG----", "play:有 ");
                    instance.serviceBinder.setMusicSource(songList.get(i).getUrl());
                    previous_song.setClickable(true);
                    next_song.setClickable(true);

                    if (setCurrentMp3 != null) {
                        setCurrentMp3.setCurrentMp3(songList);
                    }
                    isHave = true;
                    break;
                }
            }
        }


        if (!isHave) {
            Log.d("TAG----", "play:没有 ");
            try {
                NetworkUtils.makeRequest(NetworkInfo.URL + "/song/url/v1?id=" + id + "&level=standard", homeHandler, URL_ID, true, this);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }


        Context context = this;
        homeFragment.setMp3Info(new HomeFragment.GetMp3Info() {
            @Override
            public void getMp3Info(List<UrlBeans> urlBeans) {

                if (songList.size() == 0) {
                    songList.add(urlBeans.get(0));
                } else {
                    for (int i = 0; i < songList.size(); i++) {
                        if (songList.get(i).getId() != urlBeans.get(0).getId()) {
                            songList.add(urlBeans.get(0));
                        }

                    }
                }

                if (TOUCH_COUNT != 0) {
                    Log.d("TAGaaaaaa", "getMp3Info: 入口1");
                    instance.serviceBinder.setMusicSource(urlBeans.get(0).getUrl());
                    previous_song.setClickable(true);
                    next_song.setClickable(true);
                    animationUtils.stopRotate("cancel");
                    //   animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);

                } else {
                    Log.d("TAGaaaaaa", "getMp3Info: 入口2");
                    beginPlay.play(context, () -> {
                                instance.serviceBinder.setMusicSource(urlBeans.get(0).getUrl());
                                previous_song.setClickable(true);
                                next_song.setClickable(true);
                                if (!AUTO_PLAY) {
                                    setStop();
                                }


                                //    animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
                                loadNetWork("lyric", null, 0);
                            }
                    );

                }

                if (setCurrentMp3 != null) {
                    setCurrentMp3.setCurrentMp3(songList);
                }
            }
        });

    }

    public interface SetCurrentMp3 {
        void setCurrentMp3(List<UrlBeans> urlBeans);
    }

    public static void beginRotate() {
        Log.d("TAGpppppaaa", "beginRotate: ");
        animationUtils.Rotate(main_player_img);
        animationUtils.getObjectAnimator(stylusY, player_stylus, screenPoint);
        playerPageAdapterAnimation.proceedRotate();
    }


    @Override
    public void onCountUpdate(Map<?, ?> newData) {

        this.newData = newData;
        formatDate(newData);
    }

    public void formatDate(Map<?, ?> data) {
        if (CURRENT_PLAY_MODE == UNLIMITED_PLAYBACK_MODE || CURRENT_PLAY_MODE == SINGLE_PLAY_MODE_ONE) {
            setCurrentMode("");
        }

        switchSong = false;
        if (data != null) {
            String str = String.valueOf(data.get("SongList"));
            int index = Integer.parseInt(String.valueOf(data.get("SongIndex")));

            String upOrAdd = String.valueOf(data.get("upOrAdd"));
            int currentP = 0;

            String songId;
            Log.d("TAG--------fff----", "formatDatess: " + (!sheetId.equals(oldSheetId) || isOnClick));

            if (!sheetId.equals(oldSheetId) || isOnClick) {
                try {
                    JSONArray array = new JSONArray(str);
                    if (Sheetlist != null) {
                        if (!upOrAdd.equals("add")) {
                            Sheetlist.clear();
                        }
                    }

                    for (int i = 0; i < array.length(); i++) {
                        ListBean listBean = new ListBean();
                        JSONObject jsonObject = array.getJSONObject(i);
                        String ar = String.valueOf(jsonObject.get("ar"));
                        Type token = new TypeToken<List<UserSongListBean.Ar>>() {
                        }.getType();
                        List<UserSongListBean.Ar> SingerInfo = app.gson.fromJson(ar, token);
                        listBean.setSingerInfo(SingerInfo);

                        listBean.setSongName(String.valueOf(jsonObject.get("name")));
                        listBean.setSongId(Long.parseLong(String.valueOf(jsonObject.get("id"))));
                        listBean.setSubTitle(String.valueOf(((JSONObject) jsonObject.get("al")).get("name")));
                        if (((JSONObject) jsonObject.get("al")).has("picUrl")) {
                            listBean.setImgUrl(String.valueOf(((JSONObject) jsonObject.get("al")).get("picUrl")));
                        } else {
                            String pic_str = String.valueOf(((JSONObject) jsonObject.get("al")).get("pic_str"));

                            listBean.setImgUrl(pic_str);
                        }

                        Sheetlist.add(listBean);


                    }
                    assert Sheetlist != null;
                    if (!upOrAdd.equals("add")) {
                        songId = String.valueOf(Sheetlist.get(index).getSongId());
                    } else {
                        songId = String.valueOf(Sheetlist.get(Sheetlist.size() - 1).getSongId());
                    }

                    play(songId, null);
                    setList.setListInfo(Sheetlist);


                    if (Sheetlist.size() <= 10) {
                        currentP = Sheetlist.size() * 500 + index;
                    } else if (Sheetlist.size() <= 100) {
                        currentP = Sheetlist.size() * 50 + index;
                    } else if (Sheetlist.size() <= 1000) {
                        currentP = Sheetlist.size() * 5 + index;
                    } else {
                        currentP = index;
                    }
                    oldSheetId = sheetId;
                } catch (JSONException e) {
                    throw new RuntimeException(e);
                }
                if (CURRENT_PLAY_MODE == RANDOM_PLAY_MODE) {
                    isUpData = 2;
                    Log.d("TAG--------11111", "formatDate: " + Long.parseLong(songId));

                    upData(Long.parseLong(songId));
                } else if (pIndex == 0) {
                    player_viewPage.setCurrentItem(currentP + Sheetlist.size());
                    pIndex = 1;
                } else {
                    player_viewPage.setCurrentItem(currentP - Sheetlist.size());
                    pIndex = 0;
                }

                //player_viewPage.setCurrentItem(currentP);
                if (animationUtils != null) {
                    animationUtils.stopRotate("cancel");
                }


            } else if (playerInfo.getSongId() != Sheetlist.get(index).getSongId()) {
                if (animationUtils != null) {
                    animationUtils.stopRotate("cancel");
                }

                songId = String.valueOf(Sheetlist.get(index).getSongId());

//


                //  play(songId,null);
                int i = currentP % Sheetlist.size();
                if (index > i) {
                    currentP = currentP + index;
                } else {
                    currentP = currentP - index;
                }

                if (pIndex == 0) {
                    player_viewPage.setCurrentItem(currentP + Sheetlist.size());
                    pIndex = 1;
                } else {
                    player_viewPage.setCurrentItem(currentP - Sheetlist.size());
                    pIndex = 0;
                }


            }


        }
    }

    public void setRecommendSheetId(String sheetId) {
        this.sheetId = sheetId;

    }

//    @Override
//    public boolean onKeyDown(int keyCode, KeyEvent event) {
//        if (keyCode==KeyEvent.KEYCODE_BACK){
//            moveTaskToBack(true);
//            return false;
//        }
//        return super.onKeyDown(keyCode, event);
//    }

    @SuppressLint("MissingSuperCall")
    @Override
    public void onBackPressed() {

        Log.d("TAG11111111111111111111111", "onBackPressed: " + app.page);
        if (homeFragment.songSheetFragment != null && homeFragment.songSheetFragment.isVisible()) {
            if (secondFragment != null && secondFragment.isVisible()) {
                getSupportFragmentManager()
                        .beginTransaction()
                        .setCustomAnimations(
                                R.anim.fade_in,
                                R.anim.fade_out,
                                R.anim.fade_in,
                                R.anim.fade_out)
                        .hide(secondFragment)
                        .commit();
                Log.d("TAGwotmzoulzhe", "attach: 2");
                app.page -= 1;
                return;
            }
            homeFragment.hideFragment();
            Log.d("TAG111111111111222333", "onBackPressed: " + app.page);
            showView();
            viewPager.setBackground(getDrawable(R.drawable.home_background));

            return;
        }
        if (behavior.getState() == BottomSheetBehavior.STATE_EXPANDED) {
            behavior.setState(BottomSheetBehavior.STATE_COLLAPSED);
            behavior.setState(BottomSheetBehavior.STATE_HIDDEN);
            return;
        }
        if (app.touchType == TouchType.MY_PAGE && !app.isOpenFence) {
            myFragment.myBindings.channel.invokeMethod("back", "");
            return;
        }
        if (app.touchType == TouchType.SEARCH_PAGE) {
            Log.d("TAG----------aaaaaa", "onBackPressed: ");
            homeFragment.searchFragment.getBack().back();
            return;
        }
        if (secondFragment != null) {
            if (app.touchType == TouchType.RECOMMENDABLE_SHEET || app.touchType == TouchType.RANKING_PAGE || app.touchType == TouchType.EXCLUSIVE_SCENE
                    || app.touchType == TouchType.MUSIC_RADAR || app.touchType == TouchType.SING_AND_ALBUMS) {
                secondFragment.getBack().back();
                return;
            }
        }
        if (app.page > 0) {
            Log.d("TAGwotmzoulzhe", "attach: 3");
            app.page -= 1;
            if (homeFragment.searchFragment != null && homeFragment.searchFragment.isVisible()) {
                getSupportFragmentManager()
                        .beginTransaction()
                        .setCustomAnimations(
                                R.anim.fade_in,
                                R.anim.fade_out,
                                R.anim.fade_in,
                                R.anim.fade_out)
                        .hide(homeFragment.searchFragment)
                        .commit();
                showView();
                return;
            }
            if (secondFragment != null && secondFragment.isVisible()) {

                getSupportFragmentManager()
                        .beginTransaction()
                        .setCustomAnimations(
                                R.anim.fade_in,
                                R.anim.fade_out,
                                R.anim.fade_in,
                                R.anim.fade_out)
                        .hide(secondFragment)
                        .commit();
            } else {
                Log.d("TAG---------", "onBackPressed: " + (myFragment.isVisible() && viewPager.getCurrentItem() == 1));

                if (msgFragment.isVisible() && viewPager.getCurrentItem() == 2) {
                    msgFragment.msgBindings.channel.invokeMethod("back", "");
                    showView();
                    return;
                }

            }
            showView();


            return;
        }


        if (doubleBackToExitPressedOnce) {
            this.doubleBackToExitPressedOnce = false;
            app.isOpenFence = false;
            moveTaskToBack(true);
            return;
        }
        this.doubleBackToExitPressedOnce = true;
        CustomToast.showToast(this, "再按一次退出");

        // 设置延时2秒，如果2秒内再次点击返回按钮，则将 doubleBackToExitPressedOnce 重置为 false
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                doubleBackToExitPressedOnce = false;
                app.isOpenFence = false;
            }
        }, 2000);

    }

    public void setBackColor() {
        viewPager.setBackground(getDrawable(R.color.white));
    }

    public void showView() {
        if (app.page == 0) {
            animationUtil.showView(bottom_view);
        }

        if (playerLayoutParams != null) {
            player_control.setVisibility(View.INVISIBLE);
            new Handler(Looper.getMainLooper()).postDelayed(
                    new Runnable() {
                        @Override
                        public void run() {
                            playerLayoutParams.removeRule(RelativeLayout.ALIGN_PARENT_BOTTOM);
                            player_control.setLayoutParams(playerLayoutParams);
                            animationUtil.showView(player_control);
                        }
                    }
                    , 500);
        }
    }

    public void hideView() {
        //隐藏Bottom_view
        if (bottom_view.getVisibility() == View.GONE || bottom_view.getVisibility() == View.INVISIBLE)
            return;
        animationUtil.hideView(bottom_view);
        bottom_view.setVisibility(View.GONE);
        if (player_control.getVisibility() == View.VISIBLE) {
            player_control.setVisibility(View.GONE);
        }

        playerLayoutParams = (RelativeLayout.LayoutParams) player_control.getLayoutParams();
        playerLayoutParams.addRule(RelativeLayout.ALIGN_PARENT_BOTTOM, RelativeLayout.TRUE);
        player_control.setLayoutParams(playerLayoutParams);

        if (player_control.getVisibility() == View.INVISIBLE ||
                player_control.getVisibility() == View.GONE) {
            animationUtil.showView(player_control);
        }
    }

    public void hide() {
        animationUtil.hideView(player_control);
    }

    public void show() {
        animationUtil.showView(player_control);
    }

    public void requestPermission(Map<?, ?> info) {
        this.info = info;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            String[] strings = {Manifest.permission.READ_MEDIA_AUDIO,
                    Manifest.permission.READ_MEDIA_IMAGES,
                    Manifest.permission.READ_MEDIA_VIDEO};
            for (String string : strings) {
                if (ContextCompat.checkSelfPermission(this, string) != PackageManager.PERMISSION_GRANTED) {

                    ActivityCompat.requestPermissions(this,
                            strings,
                            MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);

                    return;
                    // }
                }
            }

        } else {
            int checked = ContextCompat.checkSelfPermission(MainActivity.this, Manifest.permission.READ_EXTERNAL_STORAGE);
            if (checked == PackageManager.PERMISSION_GRANTED) {
                return;
            }
            if (ActivityCompat.shouldShowRequestPermissionRationale(MainActivity.this, Manifest.permission.READ_EXTERNAL_STORAGE)) {

                showPermissionRationaleDialog();
            } else {
                ActivityCompat.requestPermissions(MainActivity.this,
                        new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                        MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE);
            }
        }

    }

    private void showPermissionRationaleDialog() {
        new AlertDialog.Builder(this)
                .setTitle("权限请求")
                .setMessage("我们需要读取存储的权限来访问您的相册。")
                .setPositiveButton("确定", (dialog, which) -> requestPermission(info))
                .setNegativeButton("取消", null)
                .create()
                .show();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE: {
                if (grantResults.length > 0) {
                    for (int i = 0; i < grantResults.length; i++) {
                        if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                            if (i == grantResults.length - 1) {
                                File downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
                                String downloadsPath = downloadsDir.getAbsolutePath();
                                Map<String, Object> result = new HashMap<>();
                                String action = String.valueOf(info.get("info")).equals("") ? "chooseImg" : "saveImg";                               result.put("isSuccess", true);
                                result.put("action", action);
                                result.put("info", String.valueOf(info.get("info")));
                                result.put("path", downloadsPath);


                                if (action.equals("chooseImg")) {
                                    myFragment.myBindings.channel.invokeMethod("RequestResults", result);
                                    return;
                                }
                                if (String.valueOf(info.get("origin")).equals("myFragment")) {
                                    myFragment.myBindings.channel.invokeMethod("RequestResults", result);

                                } else
                                    secondFragment.otherBindings.channel.invokeMethod("RequestResults", result);


                            }
                        } else {
                            CustomToast.showToast(this, "未授予权限或权限不完整！");
                            return;
                        }
                    }

                    // 权限被用户授予，可以继续操作
                }
                // 权限被用户拒绝，处理这种情况


                break;
            }
            // 其他权限请求处理
            // ...
        }
    }

    public void upImage(String path) {
        sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://" + path)));
    }

    public void restoreData() {
        filePath = getApplicationContext().getFilesDir() + "/" + fileName;

        File file = new File(filePath);
        if (file.exists()) {
            AUTO_PLAY = false;
            musicCacheBean = MusicPlayerUtils.deserializeList(filePath);
            if(musicCacheBean!=null){
                playerInfo.setDuration(musicCacheBean.getDuration());
                playerInfo.setCurrentPosition(musicCacheBean.getStrProgress());
                playerInfo.setListBeans(musicCacheBean.getPlayList());
                activityMainBinding.setPlayerInfo(playerInfo);
                CURRENT_PLAY_MODE = musicCacheBean.getPlayMode();
                int index = musicCacheBean.getIndex();
                int num = musicCacheBean.getPlayList().size();
                if (num <= 10) {
                    index = num * 500 + index;
                } else if (num <= 1000) {
                    index = num * 50 + index;
                } else if (num <= 4000) {
                    index = num * 5 + index;
                }

                currentPosition = (musicCacheBean.getProgress() * 1.0f / musicCacheBean.getDurationNum() * 100);
                player_seekBar.setProgress((int) currentPosition);
                setList.setListInfo(musicCacheBean.getPlayList());
                player_viewPage.setCurrentItem(index);
                switch (CURRENT_PLAY_MODE) {

                    case SINGLE_PLAY_MODE:
                        play_module.setImageDrawable(getDrawable(playMode[0]));
                        break;
                    case SEQUENTIAL_MODE:
                        play_module.setImageDrawable(getDrawable(playMode[1]));
                        break;
                    case RANDOM_PLAY_MODE:
                        play_module.setImageDrawable(getDrawable(playMode[2]));
                        break;
                    case UNLIMITED_PLAYBACK_MODE:
                        play_module.setImageDrawable(getDrawable(ExclusiveMusicMode[1]));
                        break;
                    case SINGLE_PLAY_MODE_ONE:
                        play_module.setImageDrawable(getDrawable(ExclusiveMusicMode[0]));
                        break;
                }
            }

        }

    }

    public interface GetLrcString {
        void setLrc(String Lrc, String tLrc);
    }

    public interface ShowLrcInfoView {
        void ShowLrcInfoView(boolean showOrHide);
    }

    public interface jumpTo {
        void toPosition();
    }

    public interface setCallback {
        MediaSessionCompat.Callback callback();
    }
}
