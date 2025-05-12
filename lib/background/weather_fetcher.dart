import 'dart:convert';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meteoappv3/services/prefs_service.dart';
import 'package:meteoappv3/services/weather_service.dart';
import 'package:meteoappv3/models/weather.dart';

class WeatherFetcher {
  static const String _weatherCacheKey = 'weather_cache';
  static const String _forecastCacheKey = 'forecast_cache';
  static const String _lastFetchTimeKey = 'last_fetch_time';

  static Future<void> configureBackgroundFetch() async {
    // Configure BackgroundFetch
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
      ),
      _onBackgroundFetch,
      _onBackgroundFetchTimeout,
    );
    // Démarre le service
    await BackgroundFetch.start();
    // Enregistre la tâche headless
    BackgroundFetch.registerHeadlessTask(_headlessTask);
  }

  // Background fetch task
  static void _onBackgroundFetch(String taskId) async {
    print('[BackgroundFetch] Event received: $taskId');
    bool success = await _updateWeatherInBackground();
    BackgroundFetch.finish(taskId);
    if (!success) {
      BackgroundFetch.scheduleTask(
        TaskConfig(
          taskId: 'com.meteo_app.weather_retry',
          delay: 5 * 60 * 1000,
          periodic: false,
        ),
      );
    }
  }

  static void _onBackgroundFetchTimeout(String taskId) async {
    print('[BackgroundFetch] TIMEOUT: $taskId');
    BackgroundFetch.finish(taskId);
  }

  // Headless task (executed when app is terminated)
  static void _headlessTask(HeadlessTask task) async {
    String taskId = task.taskId;
    bool isTimeout = task.timeout;
    if (isTimeout) {
      print("[BackgroundFetch] Headless task timed out: $taskId");
      BackgroundFetch.finish(taskId);
      return;
    }
    print("[BackgroundFetch] Headless task started: $taskId");
    await _updateWeatherInBackground();
    BackgroundFetch.finish(taskId);
  }

  // Update weather data in background
  static Future<bool> _updateWeatherInBackground() async {
    try {
      // Check the last fetch time to avoid too frequent updates
      final prefs = await SharedPreferences.getInstance();
      final prefsService = PrefsService(prefs);

      final lastFetchTime = prefs.getInt(_lastFetchTimeKey) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch;

      // If it's been less than 30 minutes since the last fetch, skip
      if (now - lastFetchTime < 30 * 60 * 1000) {
        print('[BackgroundFetch] Skipping update, last fetch was recent');
        return true;
      }

      // Check if we have default location saved
      if (!prefsService.hasDefaultLocation()) {
        print('[BackgroundFetch] No default location set, skipping update');
        return false;
      }

      final lat = prefsService.getDefaultLat();
      final lon = prefsService.getDefaultLon();
      final cityName = prefsService.getDefaultCity();
      final units = prefsService.getUnits();

      if (lat == null || lon == null) {
        print('[BackgroundFetch] Invalid location coordinates');
        return false;
      }

      // Fetch weather data
      final weatherService = WeatherService();
      final weatherData =
          await weatherService.getCurrentWeather(lat, lon, units, cityName);
      final forecastData =
          await weatherService.getHourlyForecast(lat, lon, units, cityName);

      // Save to cache
      await prefs.setString(_weatherCacheKey, jsonEncode(weatherData.toJson()));
      await prefs.setString(
          _forecastCacheKey, jsonEncode(forecastData.toJson()));
      await prefs.setInt(_lastFetchTimeKey, now);

      print('[BackgroundFetch] Weather data updated successfully');
      return true;
    } catch (e) {
      print('[BackgroundFetch] Error updating weather: $e');
      return false;
    }
  }

  // Retrieve cached weather data
  static Future<Weather?> getCachedWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final weatherJson = prefs.getString(_weatherCacheKey);

      if (weatherJson != null) {
        final weatherMap = jsonDecode(weatherJson) as Map<String, dynamic>;
        return Weather.fromJson(weatherMap, weatherMap['city_name'] ?? '');
      }
      return null;
    } catch (e) {
      print('Error getting cached weather: $e');
      return null;
    }
  }

  // Retrieve cached forecast data
  static Future<HourlyForecast?> getCachedForecast() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final forecastJson = prefs.getString(_forecastCacheKey);

      if (forecastJson != null) {
        final forecastMap = jsonDecode(forecastJson) as Map<String, dynamic>;
        final city = (forecastMap['hourly'] as List).first['city_name'] ?? '';
        return HourlyForecast.fromJson(forecastMap, city);
      }
      return null;
    } catch (e) {
      print('Error getting cached forecast: $e');
      return null;
    }
  }

  // Force an immediate update
  static Future<bool> forceUpdate() async {
    return await _updateWeatherInBackground();
  }
}
