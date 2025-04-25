package com.example.meteoapp.controller;

import android.content.Context;
import androidx.lifecycle.LiveData;
import com.example.meteoapp.model.Weather;

public class CitySearchController extends MainController {
    public CitySearchController(Context context) {
        super(context);
    }

    public LiveData<Weather> onSearch(String city) {
        return fetchWeatherByCity(city);
    }
}
