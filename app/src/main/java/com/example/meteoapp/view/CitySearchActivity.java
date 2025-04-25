package com.example.meteoapp.view;

import android.os.Bundle;
import android.widget.Button;
import android.widget.EditText;
import androidx.appcompat.app.AppCompatActivity;
import com.example.meteoapp.R;
import com.example.meteoapp.controller.CitySearchController;

public class CitySearchActivity extends AppCompatActivity {

    private CitySearchController controller;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_city_search);

        controller = new CitySearchController(this);

        EditText edit = findViewById(R.id.editCity);
        Button btn   = findViewById(R.id.btnSearch);

        btn.setOnClickListener(v -> controller.onSearch(edit.getText().toString()));
    }
}
