package com.example.meteoapp.controller;

import com.example.meteoapp.model.Weather;
import com.example.meteoapp.model.LocationRepository;

public class MainController {
    private LocationRepository locationRepo;

    public MainController(LocationRepository repo) {
        this.locationRepo = repo;
    }

    public Weather fetchWeatherByGps() {
        // TODO: rÃ©cupÃ©rer position GPS et appeler le webservice
        return null;
    }

    public Weather fetchWeatherByCity(String city) {
        // TODO: appeler le webservice avec la ville
        return null;
    }
}
