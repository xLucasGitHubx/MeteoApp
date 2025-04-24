package com.example.meteoapp.view;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import com.example.meteoapp.controller.MainController;

public class MainActivity extends AppCompatActivity {
    private MainController controller;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        // TODO: initialiser controller et lier la vue
    }
}
