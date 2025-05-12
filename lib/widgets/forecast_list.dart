import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';

import 'package:meteoappv3/models/weather.dart';

class ForecastList extends StatelessWidget {
  final List<Weather> hourlyForecast;
  final String temperatureUnit;

  const ForecastList({
    Key? key,
    required this.hourlyForecast,
    required this.temperatureUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: hourlyForecast.isEmpty
          ? const Center(child: Text('No forecast data available'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyForecast.length,
              itemBuilder: (context, index) {
                return _buildHourlyItem(context, hourlyForecast[index]);
              },
            ),
    );
  }

  Widget _buildHourlyItem(BuildContext context, Weather weather) {
    return Container(
      width: 80,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('HH:mm').format(weather.dateTime),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          _getWeatherIcon(weather.icon),
          const SizedBox(height: 8),
          Text(
            '${weather.temp.round()}$temperatureUnit',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _getWeatherIcon(String iconCode) {
    // Map OpenWeatherMap icon codes to Weather Icons
    IconData iconData;

    switch (iconCode) {
      case '01d':
        iconData = WeatherIcons.day_sunny;
        break;
      case '01n':
        iconData = WeatherIcons.night_clear;
        break;
      case '02d':
        iconData = WeatherIcons.day_cloudy;
        break;
      case '02n':
        iconData = WeatherIcons.night_cloudy;
        break;
      case '03d':
      case '03n':
        iconData = WeatherIcons.cloud;
        break;
      case '04d':
      case '04n':
        iconData = WeatherIcons.cloudy;
        break;
      case '09d':
      case '09n':
        iconData = WeatherIcons.showers;
        break;
      case '10d':
        iconData = WeatherIcons.day_rain;
        break;
      case '10n':
        iconData = WeatherIcons.night_rain;
        break;
      case '11d':
      case '11n':
        iconData = WeatherIcons.thunderstorm;
        break;
      case '13d':
      case '13n':
        iconData = WeatherIcons.snow;
        break;
      case '50d':
      case '50n':
        iconData = WeatherIcons.fog;
        break;
      default:
        iconData = WeatherIcons.day_sunny;
    }

    return Icon(
      iconData,
      size: 24,
      color: Colors.blue,
    );
  }
}
