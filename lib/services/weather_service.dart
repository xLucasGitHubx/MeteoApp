import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:meteoappv3/models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/3.0';
  static const String _geoUrl = 'https://api.openweathermap.org/geo/1.0';
  
  Future<Map<String, dynamic>> fetchWeatherData(double lat, double lon, String units) async {
    final apiKey = dotenv.env['OWM_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found. Make sure .env file contains OWM_API_KEY');
    }
    
    final url = Uri.parse('$_baseUrl/onecall?lat=$lat&lon=$lon&units=$units&appid=$apiKey');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Weather API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Weather API Error: $e');
      throw Exception('Error fetching weather data: $e');
    }
  }
  
  Future<Weather> getCurrentWeather(double lat, double lon, String units, String cityName) async {
    final data = await fetchWeatherData(lat, lon, units);
    final currentData = data['current'];
    return Weather.fromJson(currentData, cityName);
  }
  
  Future<HourlyForecast> getHourlyForecast(double lat, double lon, String units, String cityName) async {
    final data = await fetchWeatherData(lat, lon, units);
    return HourlyForecast.fromJson(data, cityName);
  }
  
  Future<String> getCityNameFromCoordinates(double lat, double lon) async {
    final apiKey = dotenv.env['OWM_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found. Make sure .env file contains OWM_API_KEY');
    }
    
    final url = Uri.parse(
      '$_geoUrl/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey'
    );
    
    try {
      print('Geocoding request URL: $url');
      final response = await http.get(url);
      print('Geocoding response status: ${response.statusCode}');
      print('Geocoding response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final String name = data[0]['name'] ?? 'Unknown Location';
          final String country = data[0]['country'] ?? '';
          return country.isEmpty ? name : '$name, $country';
        }
        return 'Unknown Location';
      } else {
        print('Geocoding API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get location name: ${response.statusCode}');
      }
    } catch (e) {
      print('Geocoding API Error: $e');
      throw Exception('Error getting location name: $e');
    }
  }
} 