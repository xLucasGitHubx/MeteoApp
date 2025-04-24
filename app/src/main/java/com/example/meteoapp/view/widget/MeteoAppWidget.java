package com.example.meteoapp.view.widget;

import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.widget.RemoteViews;
import com.example.meteoapp.R;

public class MeteoAppWidget extends AppWidgetProvider {
    @Override
    public void onUpdate(Context context, android.appwidget.AppWidgetManager mgr, int[] ids) {
        for (int id : ids) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_meteo);
            // TODO: mettre Ã  jour le widget
            mgr.updateAppWidget(id, views);
        }
    }
}
