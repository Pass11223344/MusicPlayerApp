package com.rikkatheworld.wangyiyun.azimuth;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.RectF;

import androidx.annotation.NonNull;

import com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool;
import com.bumptech.glide.load.resource.bitmap.BitmapTransformation;

import java.security.MessageDigest;

public class MarginTransformation extends BitmapTransformation {
    private int margin;
    private int cornerRadius;
    public MarginTransformation(int margin, int cornerRadius) {
        super();
        this.margin = margin;
        this.cornerRadius = cornerRadius;
    }


    @Override
    protected Bitmap transform(@NonNull BitmapPool pool, @NonNull Bitmap toTransform, int outWidth, int outHeight) {
        int width = toTransform.getWidth();
        int height = toTransform.getHeight();

        // 计算新的宽度和高度
        int newWidth = width + 2 * margin;
        int newHeight = height + 2 * margin;

        // 创建一个新的带有边距的 Bitmap
        Bitmap result = pool.get(newWidth, newHeight, Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(result);
        Paint paint = new Paint();
        paint.setAntiAlias(true);
        RectF rectF = new RectF(margin, margin, newWidth - margin, newHeight - margin);
        canvas.drawRoundRect(rectF, cornerRadius, cornerRadius, paint);

        // 设置 Xfermode 为 SRC_IN，将图片裁剪成与圆角矩形相同的形状
        paint.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.SRC_IN));
        canvas.drawBitmap(toTransform, margin, margin, paint);

        return result;
    }

    @Override
    public void updateDiskCacheKey(@NonNull MessageDigest messageDigest) {
        // 空实现
    }

}