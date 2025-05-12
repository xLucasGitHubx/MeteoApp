import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:meteoappv3/views/home_view.dart';
import 'package:meteoappv3/background/weather_fetcher.dart';
import 'package:meteoappv3/services/prefs_service.dart';
import 'package:meteoappv3/services/weather_service.dart';
import 'package:meteoappv3/utils/location_service.dart';
import 'package:meteoappv3/controllers/weather_controller.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Debug: Print API key
  print('API Key loaded: ${dotenv.env['OWM_API_KEY']?.substring(0, 5)}...');

  // Initialize services
  final prefs = await SharedPreferences.getInstance();
  final prefsService = PrefsService(prefs);
  final weatherService = WeatherService();
  final locationService = LocationService();

  // Configure background fetch
  await WeatherFetcher.configureBackgroundFetch();

  runApp(
    MultiProvider(
      providers: [
        Provider<PrefsService>.value(value: prefsService),
        Provider<WeatherService>.value(value: weatherService),
        Provider<LocationService>.value(value: locationService),
        ChangeNotifierProvider(
          create: (context) => WeatherController(
            weatherService: weatherService,
            prefsService: prefsService,
            locationService: locationService,
          ),
        ),
      ],
      child: MyApp(prefsService: prefsService),
    ),
  );
}

class MyApp extends StatefulWidget {
  final PrefsService prefsService;

  const MyApp({Key? key, required this.prefsService}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final isDark = widget.prefsService.isDarkMode();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: const HomeView(),
    );
  }
}
