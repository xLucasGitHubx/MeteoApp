package com.example.meteoapp.database.dao;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;

import com.example.meteoapp.model.Weather;

import java.util.ArrayList;
import java.util.List;

public class WeatherDao {

    private final List<Weather> storage = new ArrayList<>();
    private final MutableLiveData<List<Weather>> liveDataList = new MutableLiveData<>(new ArrayList<>());
    private final MutableLiveData<Weather> liveDataCity = new MutableLiveData<>();

    public void insert(Weather weather) {
        storage.removeIf(w -> w.city.equalsIgnoreCase(weather.city)); // remplace si même ville
        storage.add(weather);
        liveDataList.setValue(new ArrayList<>(storage));
    }

    public LiveData<Weather> getByCity(String city) {
        for (Weather w : storage) {
            if (w.city.equalsIgnoreCase(city)) {
                liveDataCity.setValue(w);
                break;
            }
        }
        return liveDataCity;
    }

    public LiveData<List<Weather>> getAll() {
        return liveDataList;
    }
}
