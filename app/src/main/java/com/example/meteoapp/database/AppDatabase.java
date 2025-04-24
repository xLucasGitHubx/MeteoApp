package com.example.meteoapp.database;

import androidx.room.Database;
import androidx.room.RoomDatabase;
import com.example.meteoapp.model.Weather;
import com.example.meteoapp.database.dao.WeatherDao;

@Database(entities = {Weather.class}, version = 1)
public abstract class AppDatabase extends RoomDatabase {
    public abstract WeatherDao weatherDao();
}
