package com.example.meteoapp.view.widget;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.widget.RemoteViews;

import com.example.meteoapp.R;

public class MeteoAppWidget extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager manager, int[] appWidgetIds) {
        for (int id : appWidgetIds) {
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.widget_meteo);

            // Valeurs par défaut
            views.setTextViewText(R.id.textWidgetCity, "Chargement...");
            views.setTextViewText(R.id.textWidgetTemp, "--°C");

            // ➕ Tu peux rajouter une action de rafraîchissement ici plus tard
            manager.updateAppWidget(id, views);
        }
    }
}
