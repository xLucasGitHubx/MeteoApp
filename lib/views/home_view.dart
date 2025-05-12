import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

import 'package:meteoappv3/controllers/weather_controller.dart';
import 'package:meteoappv3/views/settings_view.dart';
import 'package:meteoappv3/widgets/forecast_list.dart';
import 'package:meteoappv3/models/weather.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Load weather data when the view is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeatherData();
    });
  }

  Future<void> _loadWeatherData() async {
    final controller = Provider.of<WeatherController>(context, listen: false);
    await controller.loadWeatherWithCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherController>(
      builder: (context, weatherController, child) {
        final weather = weatherController.currentWeather;
        final hourlyForecast = weatherController.hourlyForecast;

        return Scaffold(
          appBar: AppBar(
            title: Text(weather?.cityName ?? 'Weather App'),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'settings') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsView()),
                    );
                  } else if (value == 'refresh') {
                    _loadWeatherData();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'refresh',
                    child: ListTile(
                      leading: Icon(Icons.refresh),
                      title: Text('Refresh'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: _buildBody(weatherController),
        );
      },
    );
  }

  Widget _buildBody(WeatherController weatherController) {
    if (weatherController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (weatherController.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${weatherController.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWeatherData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final weather = weatherController.currentWeather;
    if (weather == null) {
      return const Center(child: Text('No weather data available'));
    }

    final hourlyForecast = weatherController.hourlyForecast;
    final temperatureUnit = weatherController.temperatureUnit;
    final speedUnit = weatherController.speedUnit;

    return RefreshIndicator(
      onRefresh: _loadWeatherData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationHeader(weather),
            const SizedBox(height: 24),
            _buildCurrentWeather(weather, temperatureUnit),
            const SizedBox(height: 24),
            _buildWeatherDetails(weather, speedUnit),
            const SizedBox(height: 32),
            Text(
              'Hourly Forecast',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (hourlyForecast != null && hourlyForecast.hourlyList.isNotEmpty)
              ForecastList(
                hourlyForecast: hourlyForecast.hourlyList,
                temperatureUnit: temperatureUnit,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationHeader(Weather weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  weather.cityName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Text(
              DateFormat('EEEE, d MMMM y').format(DateTime.now()),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: _loadWeatherData,
          tooltip: 'Refresh location',
        ),
      ],
    );
  }

  Widget _buildCurrentWeather(Weather weather, String temperatureUnit) {
    return Center(
      child: Column(
        children: [
          _getWeatherIcon(weather.icon, size: 80),
          const SizedBox(height: 16),
          Text(
            '${weather.temp.round()}$temperatureUnit',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          Text(
            weather.description,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Feels like ${weather.feelsLike.round()}$temperatureUnit',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(Weather weather, String speedUnit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(
            context,
            WeatherIcons.strong_wind,
            '${weather.windSpeed} $speedUnit',
            'Wind',
          ),
          _buildDetailItem(
            context,
            WeatherIcons.humidity,
            '${weather.humidity}%',
            'Humidity',
          ),
          _buildDetailItem(
            context,
            WeatherIcons.barometer,
            '${weather.pressure} hPa',
            'Pressure',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _getWeatherIcon(String iconCode, {double size = 24}) {
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
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
