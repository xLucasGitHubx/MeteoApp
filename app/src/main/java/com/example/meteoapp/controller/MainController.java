package com.example.meteoapp.controller;

import android.content.Context;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import com.example.meteoapp.model.Weather;

public class MainController {
    private final MutableLiveData<Weather> weatherLiveData = new MutableLiveData<>();

    public MainController(Context context) {
        // Valeur par défaut
        Weather defaultWeather = new Weather();
        defaultWeather.city = "Toulouse";
        defaultWeather.temperature = 21.0;
        defaultWeather.description = "Ensoleillé";
        defaultWeather.timestamp = System.currentTimeMillis();

        weatherLiveData.setValue(defaultWeather);
    }

    public LiveData<Weather> fetchWeatherByGps() {
        return weatherLiveData;
    }

    public LiveData<Weather> fetchWeatherByCity(String city) {
        Weather weather = new Weather();
        weather.city = city;
        weather.temperature = 21.0; // Simulé
        weather.description = "Ensoleillé"; // Simulé
        weather.timestamp = System.currentTimeMillis();

        weatherLiveData.setValue(weather);
        return weatherLiveData;
    }
}
