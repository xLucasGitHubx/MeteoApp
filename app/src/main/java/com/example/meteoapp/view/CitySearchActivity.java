package com.example.meteoapp.view;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.example.meteoapp.controller.CitySearchController;

public class CitySearchActivity extends AppCompatActivity {
    private CitySearchController controller;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_city_search);
        // TODO: initialiser controller et la saisie
    }
}
