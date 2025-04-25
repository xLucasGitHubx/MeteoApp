package com.example.meteoapp.model;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import com.example.meteoapp.database.AppDatabase;
import com.example.meteoapp.database.dao.WeatherDao;

public class LocationRepository {

    private final Context context;
    private final WeatherDao dao;

    public LocationRepository(Context context) {
        this.context = context.getApplicationContext();
        this.dao = AppDatabase.get(this.context).weatherDao();
    }

    @SuppressLint("MissingPermission")
    public LiveData<Weather> getWeatherForCurrentLocation() {
        MutableLiveData<Weather> live = new MutableLiveData<>();
        LocationManager lm = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        Location loc = lm != null ? lm.getLastKnownLocation(LocationManager.NETWORK_PROVIDER) : null;
        if (loc != null) {
            live = (MutableLiveData<Weather>) getWeatherForCity("gps:" + loc.getLatitude() + "," + loc.getLongitude());
        }
        return live;
    }

    public LiveData<Weather> getWeatherForCity(String city) {
        return dao.getByCity(city);
    }
}
