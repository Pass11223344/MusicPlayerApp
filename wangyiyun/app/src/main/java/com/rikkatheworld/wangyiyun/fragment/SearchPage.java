package com.rikkatheworld.wangyiyun.fragment;

import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_ALBUMS;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_EXCLUSIVE_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_MUSIC_RADAR_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_RECOMMEND_SHEET;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.TO_SEARCH;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.TouchType.SEARCH_PAGE;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;

import com.rikkatheworld.wangyiyun.EngineBindings;
import com.rikkatheworld.wangyiyun.R;

import java.util.Map;

import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.RenderMode;
import io.flutter.embedding.engine.FlutterEngineCache;

public class SearchPage extends Fragment implements EngineBindings.EngineBindingsDelegate {

    private FrameLayout view;

    private SecondPage.ToBack back;
  public   EngineBindings searchBindings;
    String SEARCH_PAGE = "search_pages";
    private FlutterFragment searchFragment;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return inflater.inflate(R.layout.search_page,container,false);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        initView();
    }
    private void initView() {
        //type:类型
        //id：id


        view = getView().findViewById(R.id.search_page);
        getSearchBindings();
        FlutterEngineCache.getInstance().put(SEARCH_PAGE,searchBindings.engine);
        searchBindings.attach();


        searchBindings.attach();
        searchFragment = FlutterFragment.withCachedEngine(SEARCH_PAGE)
                .renderMode(RenderMode.texture)
                .build();
        searchBindings.channel.invokeMethod("to_search", "");
        getActivity().getSupportFragmentManager()
                .beginTransaction()
                .add(R.id.search_page,searchFragment)
                .commit();
        back =  new SecondPage.ToBack() {
            @Override
            public void back() {
                    searchBindings.channel.invokeMethod("pressPage","pressPage");

            }
        };






    }
    private void getSearchBindings() {


        if (searchBindings == null) {
            searchBindings = new EngineBindings(getActivity(), this, "SearchPage");
        }

    }
    @Override
    public void onNext() {

    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);

        if (!hidden) {
            searchBindings.channel.invokeMethod("to_search", "");

        }
    }


    public SecondPage.ToBack getBack(){

        return  this.back ;
    }
    public interface ToBack{
        void back( );
    }
}
