package com.example.meteoapp.view.custom;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

public class TemperatureGauge extends View {

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
    private float temperature = 0f;

    public TemperatureGauge(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public void setTemperature(float value) {
        temperature = value;
        invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        paint.setColor(Color.BLUE);
        float radius = Math.min(getWidth(), getHeight()) / 3f;
        canvas.drawCircle(getWidth() / 2f, getHeight() / 2f, radius, paint);
    }
}
