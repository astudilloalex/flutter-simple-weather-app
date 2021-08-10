import 'package:flutter/material.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:simple_weather/preferences/user_preferences.dart';

class MeasurementUnitsProvider with ChangeNotifier {
  late PressureUnits _pressureUnits;
  late TemperatureUnits _temperatureUnits;
  late WindSpeedUnits _windSpeedUnits;

  Future<void> load() async {
    final UserPreferences prefs = UserPreferences();
    _temperatureUnits = await prefs.temperatureUnits;
    _pressureUnits = await prefs.pressureUnits;
    _windSpeedUnits = await prefs.windSpeedUnits;
  }

  Future<void> setTempUnit(TemperatureUnits units) async {
    _temperatureUnits = units;
    await UserPreferences().saveTemperatureUnits(units);
    notifyListeners();
  }

  Future<void> setPressureUnit(PressureUnits units) async {
    _pressureUnits = units;
    await UserPreferences().savePressureUnits(units);
    notifyListeners();
  }

  Future<void> setWindSppedUnit(WindSpeedUnits units) async {
    _windSpeedUnits = units;
    await UserPreferences().saveWindSpeedUnits(units);
    notifyListeners();
  }

  PressureUnits get pressureUnits => _pressureUnits;

  TemperatureUnits get temperatureUnits => _temperatureUnits;

  WindSpeedUnits get windSpeedUnits => _windSpeedUnits;
}
