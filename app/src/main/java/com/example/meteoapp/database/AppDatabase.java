package com.example.meteoapp.database;

import com.example.meteoapp.model.Weather;

import java.util.ArrayList;
import java.util.List;

public class AppDatabase {
    private final List<Weather> fakeStorage = new ArrayList<>();

    public void insertWeather(Weather weather) {
        fakeStorage.add(weather);
    }

    public List<Weather> getAllWeather() {
        return new ArrayList<>(fakeStorage);
    }
}
