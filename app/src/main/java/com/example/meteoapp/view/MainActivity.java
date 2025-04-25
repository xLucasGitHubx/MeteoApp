package com.example.meteoapp.view;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.example.meteoapp.controller.MainController;
import com.example.meteoapp.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private MainController controller;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // on utilise ViewBinding
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        controller = new MainController(this);

        // Affiche un exemple statique dans le gauge
        binding.tempGauge.setTemperature(22.5f);

        // Charge le fragment météo sous le gauge
        getSupportFragmentManager()
                .beginTransaction()
                .replace(binding.fragmentContainer.getId(), new WeatherFragment())
                .commit();
    }
}
