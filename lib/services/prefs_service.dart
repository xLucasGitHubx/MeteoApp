import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  final SharedPreferences _prefs;
  
  // Constants for prefs keys
  static const String _unitsKey = 'weather_units';
  static const String _defaultCityKey = 'default_city';
  static const String _defaultLatKey = 'default_lat';
  static const String _defaultLonKey = 'default_lon';
  static const String _darkModeKey = 'dark_mode';
  
  PrefsService(this._prefs);
  
  // Units (metric for °C, imperial for °F)
  Future<void> setUnits(String units) async {
    await _prefs.setString(_unitsKey, units);
  }
  
  String getUnits() {
    return _prefs.getString(_unitsKey) ?? 'metric'; // Default to metric (°C)
  }
  
  bool isMetric() {
    return getUnits() == 'metric';
  }
  
  // Default city
  Future<void> setDefaultCity(String city) async {
    await _prefs.setString(_defaultCityKey, city);
  }
  
  String getDefaultCity() {
    return _prefs.getString(_defaultCityKey) ?? '';
  }
  
  // Default coordinates
  Future<void> setDefaultCoordinates(double lat, double lon) async {
    await _prefs.setDouble(_defaultLatKey, lat);
    await _prefs.setDouble(_defaultLonKey, lon);
  }
  
  double? getDefaultLat() {
    return _prefs.containsKey(_defaultLatKey) ? _prefs.getDouble(_defaultLatKey) : null;
  }
  
  double? getDefaultLon() {
    return _prefs.containsKey(_defaultLonKey) ? _prefs.getDouble(_defaultLonKey) : null;
  }
  
  bool hasDefaultLocation() {
    return getDefaultLat() != null && getDefaultLon() != null;
  }
  
  // Dark mode
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(_darkModeKey, isDark);
  }
  
  bool isDarkMode() {
    return _prefs.getBool(_darkModeKey) ?? false;
  }
  
  // Clear all preferences
  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 