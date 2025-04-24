package com.example.meteoapp.database.dao;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;
import com.example.meteoapp.model.Weather;
import java.util.List;

@Dao
public interface WeatherDao {
    @Insert
    void insert(Weather weather);

    @Query(\"SELECT * FROM Weather ORDER BY city\")
    List<Weather> getAll();
}
