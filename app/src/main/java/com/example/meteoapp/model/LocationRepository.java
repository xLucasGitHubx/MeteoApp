package com.example.meteoapp.model;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import com.example.meteoapp.database.dao.WeatherDao;

import java.util.Random;

public class LocationRepository {

    private final WeatherDao weatherDao;
    private final Handler handler = new Handler(Looper.getMainLooper());

    public LocationRepository(Context context) {
        this.weatherDao = new WeatherDao(); // version sans Room
    }

    public LiveData<Weather> getWeatherForCurrentLocation() {
        // Simule une météo en fonction de la localisation GPS (aléatoire ici)
        Weather simulated = createFakeWeather("Ma Position");
        weatherDao.insert(simulated);
        return weatherDao.getByCity("Ma Position");
    }

    public LiveData<Weather> getWeatherForCity(String city) {
        // Simule une météo pour une ville
        Weather simulated = createFakeWeather(city);
        weatherDao.insert(simulated);
        return weatherDao.getByCity(city);
    }

    private Weather createFakeWeather(String city) {
        Weather weather = new Weather();
        weather.city = city;
        weather.temperature = 10 + new Random().nextDouble() * 15;
        weather.description = "Ensoleillé";
        weather.timestamp = System.currentTimeMillis();
        return weather;
    }
}
