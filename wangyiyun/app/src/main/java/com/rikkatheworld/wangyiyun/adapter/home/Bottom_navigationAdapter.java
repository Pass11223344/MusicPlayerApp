package com.rikkatheworld.wangyiyun.adapter.home;


import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentStatePagerAdapter;

import com.rikkatheworld.wangyiyun.R;
import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.fragment.HomeFragment;
import com.rikkatheworld.wangyiyun.fragment.MsgFragment;
import com.rikkatheworld.wangyiyun.fragment.MyFragment;

import io.flutter.embedding.android.FlutterFragment;
//三个主页面
public class Bottom_navigationAdapter extends FragmentStatePagerAdapter {


    private HomeFragment homeFragment;
    private MyFragment myFragment;
    private MsgFragment msgFragment;

    public Bottom_navigationAdapter(@NonNull FragmentManager fm) {
        super(fm,BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT);
    }

    @NonNull
    @Override
    public Fragment getItem(int position) {
        switch (position){
            case 0:
                if (homeFragment==null) {
                    homeFragment = new HomeFragment();
                }
                return homeFragment;

            case 1:
                if (myFragment==null) {
                    myFragment = new MyFragment();
                }
                int id = myFragment.getId();



                return  myFragment;

            case 2:
                if (msgFragment==null) {
                    msgFragment = new MsgFragment();


                }

                return msgFragment;

            default:
                return null;

        }
    }

    @Override
    public int getCount() {
        return 3;
    }
    @Override
    public int getItemPosition(@NonNull Object object) {
        return POSITION_NONE;
    }
}
