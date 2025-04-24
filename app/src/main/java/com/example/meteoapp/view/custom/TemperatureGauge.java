package com.example.meteoapp.view.custom;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;

public class TemperatureGauge extends View {
    private float temperature = 0;
    private final Paint bar = new Paint(Paint.ANTI_ALIAS_FLAG);

    public TemperatureGauge(Context c, AttributeSet a){ super(c,a); bar.setStrokeWidth(40); }
    public void setTemperature(float t){ temperature=t; invalidate(); }

    @Override protected void onDraw(Canvas c){
        super.onDraw(c);
        int h = getHeight();
        int top = (int) (h*(1 - (temperature+30)/80)); // –30..50°C range
        bar.setColor(0xFF2196F3); // blue
        c.drawLine(getWidth()/2, h, getWidth()/2, top, bar);
    }
}