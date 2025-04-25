package com.example.meteoapp.controller;

import android.content.Context;
import androidx.lifecycle.LiveData;
import com.example.meteoapp.model.LocationRepository;
import com.example.meteoapp.model.Weather;

public class MainController {
    private final LocationRepository locationRepo;

    public MainController(Context context) {
        this.locationRepo = new LocationRepository(context);
    }

    public LiveData<Weather> fetchWeatherByGps() {
        return locationRepo.getWeatherForCurrentLocation();
    }

    public LiveData<Weather> fetchWeatherByCity(String city) {
        return locationRepo.getWeatherForCity(city);
    }
}
