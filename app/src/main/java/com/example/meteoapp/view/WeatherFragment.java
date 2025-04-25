package com.example.meteoapp.view;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;

import com.example.meteoapp.R;
import com.example.meteoapp.controller.MainController;
import com.example.meteoapp.model.Weather;
import com.example.meteoapp.view.custom.TemperatureGauge;

public class WeatherFragment extends Fragment {

    private MainController controller;
    private TemperatureGauge gauge;
    private TextView tvCity, tvTemp, tvDesc;

    @Nullable @Override
    public View onCreateView(@NonNull LayoutInflater inf, @Nullable ViewGroup ct, @Nullable Bundle bs) {
        View root = inf.inflate(R.layout.fragment_weather, ct, false);
        gauge   = requireActivity().findViewById(R.id.tempGauge);
        tvCity  = root.findViewById(R.id.tvCity);
        tvTemp  = root.findViewById(R.id.tvTemp);
        tvDesc  = root.findViewById(R.id.tvDesc);

        controller = new MainController(requireContext());
        controller.fetchWeatherByGps().observe(getViewLifecycleOwner(), new Observer<Weather>() {
            @Override
            public void onChanged(Weather w) {
                if (w == null) return;
                tvCity.setText("Ville : " + w.city);
                tvTemp.setText(String.format("%.1f°C", w.temperature));
                tvDesc.setText(w.description);
                gauge.setTemperature((float) w.temperature);
            }
        });

        return root;
    }
}
