import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:meteoappv3/models/weather.dart';
import 'package:meteoappv3/services/weather_service.dart';
import 'package:meteoappv3/services/prefs_service.dart';
import 'package:meteoappv3/utils/location_service.dart';

class WeatherController with ChangeNotifier {
  final WeatherService _weatherService;
  final PrefsService _prefsService;
  final LocationService _locationService;

  Weather? _currentWeather;
  HourlyForecast? _hourlyForecast;
  bool _isLoading = false;
  String _errorMessage = '';

  WeatherController({
    required WeatherService weatherService,
    required PrefsService prefsService,
    required LocationService locationService,
  })  : _weatherService = weatherService,
        _prefsService = prefsService,
        _locationService = locationService;

  Weather? get currentWeather => _currentWeather;
  HourlyForecast? get hourlyForecast => _hourlyForecast;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get hasError => _errorMessage.isNotEmpty;
  WeatherService get weatherService => _weatherService;

  String get temperatureUnit => _prefsService.isMetric() ? '°C' : '°F';
  String get speedUnit => _prefsService.isMetric() ? 'm/s' : 'mph';

  // Load weather data using current location
  Future<void> loadWeatherWithCurrentLocation() async {
    _setLoading(true);
    _clearError();

    try {
      Position? position = await _locationService.getCurrentPosition();

      position ??= await _locationService.getLastKnownPosition();

      if (position == null) {
        // Try to use saved default location if available
        if (_prefsService.hasDefaultLocation()) {
          double? lat = _prefsService.getDefaultLat();
          double? lon = _prefsService.getDefaultLon();
          String city = _prefsService.getDefaultCity();

          if (lat != null && lon != null && city.isNotEmpty) {
            await _fetchWeatherData(lat, lon, city);
            return;
          }
        }

        _setError(
            'Could not get location. Please check your location settings');
        return;
      }

      // Get city name from coordinates
      String cityName = await _weatherService.getCityNameFromCoordinates(
          position.latitude, position.longitude);

      await _fetchWeatherData(position.latitude, position.longitude, cityName);
    } catch (e) {
      _setError('Error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Load weather data for default city
  Future<void> loadWeatherForDefaultCity() async {
    if (!_prefsService.hasDefaultLocation()) {
      _setError('No default city set');
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      double? lat = _prefsService.getDefaultLat();
      double? lon = _prefsService.getDefaultLon();
      String cityName = _prefsService.getDefaultCity();

      if (lat == null || lon == null) {
        _setError('Default location coordinates not found');
        return;
      }

      await _fetchWeatherData(lat, lon, cityName);
    } catch (e) {
      _setError('Error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch weather data
  Future<void> _fetchWeatherData(
      double lat, double lon, String cityName) async {
    final units = _prefsService.getUnits();

    // Fetch both current weather and hourly forecast
    _currentWeather =
        await _weatherService.getCurrentWeather(lat, lon, units, cityName);
    _hourlyForecast =
        await _weatherService.getHourlyForecast(lat, lon, units, cityName);

    notifyListeners();
  }

  // Toggle between Celsius and Fahrenheit
  Future<void> toggleUnits() async {
    final currentUnits = _prefsService.getUnits();
    final newUnits = currentUnits == 'metric' ? 'imperial' : 'metric';

    await _prefsService.setUnits(newUnits);

    // Reload weather data with new units
    if (_currentWeather != null) {
      await loadWeatherForDefaultCity();
    }
  }

  // Save current location as default
  Future<void> saveCurrentLocationAsDefault(
      double lat, double lon, String cityName) async {
    await _prefsService.setDefaultCoordinates(lat, lon);
    await _prefsService.setDefaultCity(cityName);
    notifyListeners();
  }

  // Helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
