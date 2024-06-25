package com.rikkatheworld.wangyiyun.view;


import static com.rikkatheworld.wangyiyun.activity.MainActivity.activityMainBinding;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.playerInfo;
import static com.rikkatheworld.wangyiyun.activity.MainActivity.showLrcInfoView;


import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.text.TextUtils;
import android.util.AttributeSet;

import android.util.Log;
import android.view.MotionEvent;
import android.view.View;

import androidx.annotation.NonNull;

import com.rikkatheworld.wangyiyun.R;

import com.rikkatheworld.wangyiyun.activity.MainActivity;
import com.rikkatheworld.wangyiyun.bean.Home.LrcBean;
import com.rikkatheworld.wangyiyun.service.IPlayerControl;
import com.rikkatheworld.wangyiyun.util.StartS;
import com.rikkatheworld.wangyiyun.util.Utils;

import java.util.Date;
import java.util.List;

public class LrcView extends View {
    private static final String TAG = "LrcView";
    private List<LrcBean> list;
    private TextPaint gPaint;
    private TextPaint hPaint;
    private int width = 0 ,height = 0;
    private int currentPosition = 0 ;
    private int lastPosition = 0;
    private int highLineColor ;
    private int lrcColor ;
    private int mode = 0;
    private StartS startS;

    private static final int textSize = 42;
    private static final int rowSpacing = 110;
    private boolean isTouched = false,Tips = false,isFirstShow = true;
    private IPlayerControl serviceBinder;
    private float[] mRowSpacing;
    private float lastDistance = 0,distanceAll =0;
    private String translate;
    private float intercept_X,intercept_Y;
    private float lastOffsetY = 0,touchedDistance = 0;
    private long touchTime = 0,delayTime = 800;
    public int scrollPosition;
    private MainActivity.jumpTo jump;
    private long clickTime;
    private long unTime;
    private boolean hasMove = false;
    long lodDate = 0;
    long nowDate = 0;

    public void setHighLineColor(int highLineColor) {
        this.highLineColor = highLineColor;
    }

    public void setLrcColor(int lrcColor) {
        this.lrcColor = lrcColor;
    }

    public void setMode(int mode) {
        this.mode = mode;
    }

    public void setTouched(boolean touched) {
        isTouched = touched;
    }

    public void setStartS(StartS startS) {
        if (startS == null|| !startS.equals(this.startS)) {
            this.startS = startS;
        }

    }

    public void setTips(boolean tips) {
        if(Tips) return;
        this.Tips = tips;
        if (list!=null){
            if(list.size()>0)list.clear();
        }
        init();
    }

    public boolean setLrc(List<LrcBean> lrcBeans) {
        if(!MatchesLrcBeans(lrcBeans)){
            if (list != null&& list.size()>0) list.clear();
            this.list = lrcBeans;
            if (Tips ) Tips = false;

          //  if(isFirstShow)  isFirstShow = false;

            return true;
        }else {
            return false;
        }

    }

    public void UpdateMusicProcess(){
        if (list!=null&&list.size()>0){
            touchTime = 1;
            touchedDistance = getScrollY();
        }
    }
    public boolean MatchesLrcBeans(List<LrcBean> lrcBeans) {
        if (lrcBeans==null&&this.list==null)  return false;
        if (this.list == null || lrcBeans ==null || this.list.size()!=lrcBeans.size()) return  false;
        if (this.list.size() == 0) return true;
        for (int i = 0; i < list.size(); i++) {
            if (list.get(i).getLrc()!=lrcBeans.get(i).getLrc()) return false;
            if (list.get(i).getStart()!=lrcBeans.get(i).getStart()) return false;
            if (list.get(i).getEnd()!=lrcBeans.get(i).getEnd()) return false;
        }
        return true;
    }

    public void init() {
        currentPosition = 0;
        lastPosition = 0;
        lastDistance = 0;
       setScrollY(0);
        invalidate();

    }

    public int getCurrentPosition(){
        int currentMills = 0;
        if (this.startS.serviceBinder==null) return 0;
        serviceBinder = this.startS.serviceBinder;
        try {

            if (serviceBinder.isPlaying()||serviceBinder!=null) {

                currentMills = (int) serviceBinder.getCurrentPosition();


            }
            if (currentMills < list.get(0).getStart()){
                currentPosition = 0;
                return currentMills;
            }
            if(currentMills>list.get(list.size()-1).getStart()){
                currentPosition = list.size()-1;
                return currentMills;
            }
            for (int i = 0; i < list.size(); i++) {
                if (currentMills>=list.get(i).getStart()&&currentMills<list.get(i).getEnd()) {
                    currentPosition = i;
                    return currentMills;
                }
            }
        } catch (Exception e) {
                postInvalidateDelayed(100);
        }

return 0;

    }
    public LrcView(Context context) {
        this(context,null);
    }
    public LrcView(Context context, AttributeSet attrs){
        this(context,attrs,0);
    }
    public LrcView(Context context, AttributeSet attrs,int defStyleAttr){
        super(context,attrs,defStyleAttr);
        setClickable(true);
        TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.lrcView);
        int highLineColor = ta.getColor(R.styleable.lrcView_highLineColor, getResources().getColor(R.color.white, context.getTheme()));
        int lrcColor = ta.getColor(R.styleable.lrcView_lrcColor, getResources().getColor(android.R.color.darker_gray, context.getTheme()));
        mode = ta.getInt(R.styleable.lrcView_lrcMode, mode);
        ta.recycle();
        gPaint = new TextPaint();
        gPaint.setAntiAlias(true);
        gPaint.setColor(lrcColor);
        gPaint.setTextSize(textSize);
        gPaint.setTextAlign(Paint.Align.CENTER);
        hPaint = new TextPaint();
        hPaint.setAntiAlias(true);
        hPaint.setColor(highLineColor);
        hPaint.setTextSize(textSize);
        hPaint.setTextAlign(Paint.Align.CENTER);

    }

    @Override
    protected void onDraw(@NonNull Canvas canvas) {

            if(width==0||height == 0){
                width = getMeasuredWidth();
                height = getMeasuredHeight();
            }
            if (list == null ||list.size()==0) {
                if (!Tips) {
                    gPaint.setFlags(Paint.UNDERLINE_TEXT_FLAG);
                    canvas.drawText("暂无歌词",width>>1,height>>1,gPaint);

                }else {canvas.drawText("歌词加载中......",width>>1,height>>1,gPaint);}

                return;
            }
                gPaint.setFlags(Paint.LINEAR_TEXT_FLAG|Paint.SUBPIXEL_TEXT_FLAG);
                int currentMills = getCurrentPosition();
                drawLrc(canvas);
        if (serviceBinder.isPlaying()) {

            if (!isTouched){
                float distance = 0;
                for (int i = 0; i < currentPosition; i++){
                    distance += mRowSpacing[i];
                }
                if (touchTime==0)
                    touchTime = System.currentTimeMillis();
                else if(touchTime == 1)touchTime =  System.currentTimeMillis() - delayTime;
                if (System.currentTimeMillis() -touchTime >delayTime
                        && System.currentTimeMillis() - touchTime<delayTime+1000){

                    showLrcInfoView.ShowLrcInfoView(false);
                    float percentDistance = (float) (System.currentTimeMillis()-touchTime-delayTime)/1000;
                    float scrollY;

                    if (distance>touchedDistance){
                        if (percentDistance*distance - touchedDistance+touchedDistance<-1000) {
                            scrollY = percentDistance*Math.abs(distance - touchedDistance)+touchedDistance;
                        }else
                        scrollY = percentDistance*distance - touchedDistance+touchedDistance;

                    }else { scrollY = touchedDistance - percentDistance*Math.abs(distance - touchedDistance) ;}
                    setScrollY((int) scrollY);

                }else if(System.currentTimeMillis() - touchTime>delayTime+1000){

                    long start = list.get(currentPosition).getStart();
                    long different = currentMills - start;
                    float v = different > 500 ? distance : Math.abs(different / 500f * (distance - lastDistance) + lastDistance);
                    int scrollY = v > distance ? (int) distance : (int)v;
                    setScrollY( scrollY);
                }
                if (getScrollY() == distance) {
                    lastPosition = currentPosition;
                    lastDistance = distance;
                }
            }
        }

            postInvalidateDelayed(1000);
    }

    private void drawLrc(Canvas canvas) {
        distanceAll = 0;
        float x = width>>1,nextY = height>>1,layoutY = 0,translateY  = 0,lastY = 0;

        String lrc;
        TextPaint paint;
        mRowSpacing = new float[list.size()];
        for (int i = 0; i < list.size(); i++) {

            lrc = list.get(i).getLrc();
            translate = list.get(i).getTranslateLrc();

            paint = i ==currentPosition ? hPaint :gPaint;

            if (width<  paint.measureText(lrc)) {
                StaticLayout staticLayout =
                        new StaticLayout(lrc, paint, canvas.getWidth(),
                                Layout.Alignment.ALIGN_NORMAL,
                                1.0f, 0.0f, true);

                canvas.save();
                canvas.translate(x, nextY - (rowSpacing>>1));
                staticLayout.draw(canvas);
                canvas.restore();
                layoutY = staticLayout.getHeight();
            }else canvas.drawText(lrc,x,nextY,paint);
            if(translate!=null&& !TextUtils.isEmpty(translate)){
                translateY  =    layoutY>0?nextY+layoutY : nextY + textSize * 1.5f;
                if (width<  paint.measureText(translate)) {
                    StaticLayout staticLayout =
                            new StaticLayout(lrc, paint, canvas.getWidth(),
                                    Layout.Alignment.ALIGN_NORMAL,
                                    1.0f, 0.0f, true);

                    canvas.save();
                    canvas.translate(x, nextY - (rowSpacing>>1));
                    staticLayout.draw(canvas);
                    canvas.restore();
                    nextY = translateY + rowSpacing - textSize * 1.5f + staticLayout.getHeight();
                }else {
                    canvas.drawText(translate,x,translateY,paint);
                    nextY = translateY + rowSpacing;
                }
            }else nextY += width < paint.measureText(lrc) ? layoutY + rowSpacing - textSize * 1.5f :rowSpacing;

            mRowSpacing[i] = i == 0 ? nextY - (height>>1) : nextY - lastY;
            distanceAll +=nextY-lastY;
            lastY = nextY;
            layoutY = 0;
            translateY = 0;
        }

    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        if(startS!=null)startS = null;
        if(list!=null){list.clear();list=null;}

        if(gPaint!=null){
            gPaint.reset();
            gPaint = null;

        }
        if(hPaint!=null){
            hPaint.reset();
            hPaint = null;

        }
        mRowSpacing=null;
        System.gc();
    }


    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        if (list.size()!=0) {
            switch (event.getAction()){
                case MotionEvent.ACTION_DOWN:
                    clickTime = System.currentTimeMillis();
                    isTouched = true;
                    intercept_X = event.getX();
                    intercept_Y = event.getY();
                    touchTime = 0;
                    lodDate = new Date().getTime();
                    break;
                case MotionEvent.ACTION_MOVE:
                    //  if (list != null && list.size() <= 0) return dispatchTouchEvent(event);
                    float offsetY = event.getY() - intercept_Y;
                    if (delayTime<800) {
                        delayTime = 5000;
                    }
                    int scrollY;
                    if(offsetY-lastOffsetY<0){
                        scrollY = (int) (getScrollY()+Math.abs(offsetY-lastOffsetY));
                    }else
                        scrollY = (int) (getScrollY()-Math.abs(offsetY-lastOffsetY));
                    scrollY = (int) Math.min(scrollY, distanceAll - mRowSpacing[list.size() - 1]-200);


                    setScrollY(Math.max(scrollY,0));
                    lastOffsetY = offsetY;
                    scrollPosition = getScrollPosition(scrollY);
                    long start = list.get(scrollPosition).getStart();
                    jump = () -> serviceBinder.seek2((int) start+500);
                    playerInfo.setSeekTime(Utils.getTime((int) start+500));
                    activityMainBinding.setPlayerInfo(playerInfo);
                    nowDate = new Date().getTime();
                    if ((nowDate-lodDate)<=100) {
                        showLrcInfoView.ShowLrcInfoView(false);

                    }else
                    showLrcInfoView.ShowLrcInfoView(true);

                    break;

                case MotionEvent.ACTION_UP:
                    nowDate = new Date().getTime();

                    lastOffsetY = 0;
                    unTime = System.currentTimeMillis();
                    isTouched = false;
                    touchedDistance = getScrollY();
                    if ((nowDate-lodDate)>=100) {
                        return  true;
                    }
                    break;
            }
        }


        return super.dispatchTouchEvent(event);
    }

    private int getScrollPosition(int scrollY){
        if(list == null || list.size() <= 0) return 0;

        //1.首先通过里程获得当前滚动到哪句歌词了（scrollPosition）
        float distance = 0;
        for (int i = 0; i < list.size(); i++){
            if (scrollY < distance + (rowSpacing >> 1)) {
                return i;
            }
            else distance += mRowSpacing[i];
        }
        return 0;
    }
public MainActivity.jumpTo setJump(){
    if (this.jump!=null) {
        return this.jump;
    }
       return  null;
}


}
