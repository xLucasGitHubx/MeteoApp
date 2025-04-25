package com.example.meteoapp.view;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.example.meteoapp.R;
import com.example.meteoapp.controller.MainController;
import com.example.meteoapp.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {
    private ActivityMainBinding binding;
    private MainController controller;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        controller = new MainController(this);
    }
}
