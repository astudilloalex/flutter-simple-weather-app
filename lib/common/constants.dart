import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String weatherApiKey = '<Your Open Weather Map API Key>';

const String placesApiKey = '<Your Google Places API Key>';

class App {
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        textTheme: TextTheme(
          headline6: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 23.0,
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyText2: GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 18.0,
        ),
        subtitle1: GoogleFonts.poppins(
          color: Colors.black,
        ),
        button: GoogleFonts.poppins(),
        headline6: GoogleFonts.poppins(
          color: Colors.black,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: GoogleFonts.poppins(),
      ),
    );
  }
}

class Ads {
  static const String bannerAd = 'ca-app-pub-3940256099942544/6300978111';
}

/// Keys to use with the shared_preferences package.
class PrefsKeys {
  String get temperatureUnit => 'temperatureUnit';
  String get pressureUnit => 'pressureUnit';
  String get windSpeedUnit => 'windSpeedUnit';
}

/// Units of measurement of atmosferic pressure.
enum PressureUnits {
  atmosphere,
  hectoPascal,
  millimetersMercury,
}

/// Units of measurement of temperature.
enum TemperatureUnits {
  celsius,
  fahrenheit,
  kelvin,
}

/// Units of measurement of wind speed.
enum WindSpeedUnits {
  kilometersHour,
  knots,
  metersSecond,
  milesHour,
}
