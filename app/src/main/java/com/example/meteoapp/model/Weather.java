package com.example.meteoapp.model;

import androidx.room.Entity;
import androidx.room.PrimaryKey;

@Entity
public class Weather {

    @PrimaryKey(autoGenerate = true)
    public long id;

    public String city;
    public double temperature;
    public String description;
    public long timestamp;
}
