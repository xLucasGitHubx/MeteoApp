package com.example.meteoapp.database.dao;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import com.example.meteoapp.model.Weather;
import java.util.List;

@Dao
public interface WeatherDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    void insert(Weather weather);

    @Query("SELECT * FROM Weather WHERE city = :city LIMIT 1")
    LiveData<Weather> getByCity(String city);

    @Query("SELECT * FROM Weather ORDER BY timestamp DESC")
    LiveData<List<Weather>> getAll();
}
