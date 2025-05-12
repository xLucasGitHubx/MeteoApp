import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:meteoappv3/controllers/weather_controller.dart';
import 'package:meteoappv3/services/prefs_service.dart';
import 'package:meteoappv3/utils/location_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final TextEditingController _cityController = TextEditingController();
  bool _isDarkMode = false;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
  
  Future<void> _loadSettings() async {
    final prefsService = Provider.of<PrefsService>(context, listen: false);
    
    setState(() {
      _cityController.text = prefsService.getDefaultCity();
      _isDarkMode = prefsService.isDarkMode();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final weatherController = Provider.of<WeatherController>(context);
    final prefsService = Provider.of<PrefsService>(context);
    
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temperature Units
              _buildSectionTitle('Temperature Units'),
              _buildUnitToggle(weatherController, prefsService),
              
              const SizedBox(height: 24),
              
              // Default City
              _buildSectionTitle('Default Location'),
              _buildCityInput(),
              
              const SizedBox(height: 8),
              
              // Use current location button
              _buildUseCurrentLocationButton(weatherController),
              
              const SizedBox(height: 24),
              
              // Theme settings
              _buildSectionTitle('App Theme'),
              _buildThemeToggle(prefsService),
              
              const SizedBox(height: 24),
              
              // About section
              _buildSectionTitle('About'),
              const ListTile(
                title: Text('Weather App'),
                subtitle: Text('Version 1.0.0'),
                leading: Icon(Icons.info_outline),
              ),
              
              const SizedBox(height: 16),
              
              // Credits
              const ListTile(
                title: Text('Data provided by OpenWeatherMap'),
                leading: Icon(Icons.cloud_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildUnitToggle(WeatherController weatherController, PrefsService prefsService) {
    final isMetric = prefsService.isMetric();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Temperature Unit'),
            ToggleButtons(
              onPressed: (index) {
                setState(() {
                  if ((index == 0 && !isMetric) || (index == 1 && isMetric)) {
                    weatherController.toggleUnits();
                  }
                });
              },
              isSelected: [isMetric, !isMetric],
              borderRadius: BorderRadius.circular(8),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('°C'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('°F'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCityInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'Default City',
            hintText: 'Enter city name',
            prefixIcon: Icon(Icons.location_city),
            border: OutlineInputBorder(),
          ),
          onSubmitted: _updateDefaultCity,
        ),
      ),
    );
  }
  
  Widget _buildUseCurrentLocationButton(WeatherController weatherController) {
    return ElevatedButton.icon(
      onPressed: () async {
        final locationService = LocationService();
        final position = await locationService.getCurrentPosition();
        
        if (position != null) {
          final weatherService = weatherController.weatherService;
          final cityName = await weatherService.getCityNameFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          setState(() {
            _cityController.text = cityName;
          });
          
          if (mounted) {
            await weatherController.saveCurrentLocationAsDefault(
              position.latitude,
              position.longitude,
              cityName,
            );
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Location set to: $cityName')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Could not get current location. Check permissions.'),
              ),
            );
          }
        }
      },
      icon: const Icon(Icons.my_location),
      label: const Text('Use Current Location'),
    );
  }
  
  Widget _buildThemeToggle(PrefsService prefsService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Dark Mode'),
            Switch(
              value: _isDarkMode,
              onChanged: (value) async {
                setState(() {
                  _isDarkMode = value;
                });
                await prefsService.setDarkMode(value);
                // Need to restart app or use Provider to apply theme change
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _updateDefaultCity(String cityName) async {
    if (cityName.isEmpty) return;
    
    final weatherController = Provider.of<WeatherController>(context, listen: false);
    
    try {
      // This is a simplified version - in a real app, we would use a geocoding service
      // to convert the city name to coordinates
      await Provider.of<PrefsService>(context, listen: false).setDefaultCity(cityName);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Default city set to: $cityName')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting default city: $e')),
      );
    }
  }
} 