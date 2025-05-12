import 'package:geolocator/geolocator.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
  
  // Check and request location permission
  Future<LocationPermission> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }
  
  // Get current position with error handling
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
      
      // Check permissions
      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }
      
      // Get the current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }
  
  // Get last known position (faster but potentially less accurate)
  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }
  
  // Open app settings to enable location
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
  
  // Open location settings to enable service
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
} 