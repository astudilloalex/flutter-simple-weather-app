import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_weather/common/constants.dart';

class UserPreferences {
  SharedPreferences? _preferences;

  Future<void> _initPrefs() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<TemperatureUnits> get temperatureUnits async {
    await _initPrefs();
    return Future.value(
      TemperatureUnits
          .values[_preferences?.getInt(PrefsKeys().temperatureUnit) ?? 0],
    );
  }

  Future<PressureUnits> get pressureUnits async {
    await _initPrefs();
    return Future.value(
      PressureUnits.values[_preferences?.getInt(PrefsKeys().pressureUnit) ?? 1],
    );
  }

  Future<WindSpeedUnits> get windSpeedUnits async {
    await _initPrefs();
    return Future.value(
      WindSpeedUnits
          .values[_preferences?.getInt(PrefsKeys().windSpeedUnit) ?? 2],
    );
  }

  Future<void> saveTemperatureUnits(TemperatureUnits tempUnits) async {
    await _initPrefs();
    _preferences?.setInt(PrefsKeys().temperatureUnit, tempUnits.index);
  }

  Future<void> savePressureUnits(PressureUnits pressureUnits) async {
    await _initPrefs();
    _preferences?.setInt(PrefsKeys().pressureUnit, pressureUnits.index);
  }

  Future<void> saveWindSpeedUnits(WindSpeedUnits windSpeedUnits) async {
    await _initPrefs();
    _preferences?.setInt(PrefsKeys().windSpeedUnit, windSpeedUnits.index);
  }
}
