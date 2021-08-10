import 'package:flutter/material.dart';
import 'package:simple_weather/routes/home_page.dart';
import 'package:simple_weather/routes/manage_cities.dart';
import 'package:simple_weather/routes/settings_page.dart';

class Routes {
  static const String addCity = '/add-city';
  static const String home = '/';
  static const String manageCities = '/manage-cities';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case manageCities:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ManageCities(),
        );
      case Routes.settings:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SettingsPage(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomePage(),
        );
    }
  }
}
