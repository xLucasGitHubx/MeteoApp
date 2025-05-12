class Weather {
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final int clouds;
  final double uvi;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final double? windGust;
  final String description;
  final String icon;
  final DateTime dateTime;
  final String cityName;

  Weather({
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.clouds,
    required this.uvi,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    this.windGust,
    required this.description,
    required this.icon,
    required this.dateTime,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    final weather =
        json['weather']?.isNotEmpty == true ? json['weather'][0] : {};

    return Weather(
      temp: (json['temp'] ?? 0.0).toDouble(),
      feelsLike: (json['feels_like'] ?? 0.0).toDouble(),
      pressure: json['pressure']?.toInt() ?? 0,
      humidity: json['humidity']?.toInt() ?? 0,
      dewPoint: (json['dew_point'] ?? 0.0).toDouble(),
      clouds: json['clouds']?.toInt() ?? 0,
      uvi: (json['uvi'] ?? 0.0).toDouble(),
      visibility: json['visibility']?.toInt() ?? 0,
      windSpeed: (json['wind_speed'] ?? 0.0).toDouble(),
      windDeg: json['wind_deg']?.toInt() ?? 0,
      windGust: json['wind_gust']?.toDouble(),
      description: weather['description'] ?? '',
      icon: weather['icon'] ?? '01d',
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      cityName: city,
    );
  }

  Map<String, dynamic> toJson() => {
        'temp': temp,
        'feels_like': feelsLike,
        'pressure': pressure,
        'humidity': humidity,
        'dew_point': dewPoint,
        'clouds': clouds,
        'uvi': uvi,
        'visibility': visibility,
        'wind_speed': windSpeed,
        'wind_deg': windDeg,
        if (windGust != null) 'wind_gust': windGust,
        'weather': [
          {
            'description': description,
            'icon': icon,
          }
        ],
        'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      };
}

class HourlyForecast {
  final List<Weather> hourlyList;

  HourlyForecast({required this.hourlyList});

  factory HourlyForecast.fromJson(Map<String, dynamic> json, String city) {
    List<Weather> hourlyList = [];
    if (json['hourly'] != null) {
      json['hourly'].forEach((hourData) {
        hourlyList.add(Weather.fromJson(hourData, city));
      });
    }
    return HourlyForecast(hourlyList: hourlyList);
  }

  Map<String, dynamic> toJson() => {
        'hourly': hourlyList.map((hourly) => hourly.toJson()).toList(),
      };
}
