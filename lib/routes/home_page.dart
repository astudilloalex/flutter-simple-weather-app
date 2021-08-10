import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_weather_map_client/open_weather_map_client.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:simple_weather/common/routes.dart';
import 'package:simple_weather/providers/city_provider.dart';
import 'package:simple_weather/providers/measurement_units_provider.dart';
import 'package:simple_weather/widgets/google_ads.dart';
import 'package:simple_weather/widgets/settings_popup_menu.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_weather/widgets/slider_sunrise_sunset.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        context.read<CityProvider>().load(),
        context.read<MeasurementUnitsProvider>().load(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return DefaultTabController(
          length: context.watch<CityProvider>().cities.length,
          child: const _Main(),
        );
      },
    );
  }
}

class _Main extends StatelessWidget {
  const _Main();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: context.watch<CityProvider>().cities.isEmpty
          ? null
          : AppBar(
              centerTitle: true,
              elevation: 0.0,
              title: Text(
                AppLocalizations.of(context)!.appTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.add,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.manageCities);
                },
              ),
              actions: const [
                SettingsPopupMenu(),
              ],
              bottom: TabBar(
                tabs: List<Widget>.generate(
                  context.watch<CityProvider>().cities.length,
                  (index) => Text(
                    '.',
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
      body: TabBarView(
        children: List<Widget>.generate(
            context.watch<CityProvider>().cities.length,
            (index) => _Body(index)),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final int cityIndex;

  const _Body(this.cityIndex);

  @override
  Widget build(BuildContext context) {
    final OpenWeatherMap _api = OpenWeatherMap(
      apiKey: weatherApiKey,
      langCode: Localizations.localeOf(context).languageCode,
    );
    return context.watch<CityProvider>().cities.isEmpty
        ? const _AddCity()
        : FutureBuilder<Weather?>(
            future: _api.currentWeatherByCity(
              name: context.watch<CityProvider>().cities[cityIndex]['name']
                  as String,
              countryCode: context.watch<CityProvider>().cities[cityIndex]
                  ['country'] as String,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_image(snapshot.data!.condition)),
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: ListView(
                    children: [
                      Center(
                        child: Text(
                          context.watch<CityProvider>().cities[cityIndex]
                              ['name'] as String,
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      _CurrentTemperature(weather: snapshot.data!),
                      Center(
                        child: Text(
                          snapshot.data!.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                      _WeatherDetailCard(
                        _api,
                        weather: snapshot.data,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  String _image(String condition) {
    switch (condition) {
      case 'Tornado':
        return 'assets/images/tornado_background.jpg';
      case 'Squall':
        return 'assets/images/squall_background.jpg';
      case 'Ash':
        return 'assets/images/ash_background.jpg';
      case 'Sand':
        return 'assets/images/sand_background.jpg';
      case 'Dust':
        return 'assets/images/dust_background.jpg';
      case 'Smoke':
        return 'assets/images/smoke_background.jpg';
      case 'Fog':
        return 'assets/images/mist_background.jpg';
      case 'Haze':
        return 'assets/images/mist_background.jpg';
      case 'Mist':
        return 'assets/images/mist_background.jpg';
      case 'Snow':
        return 'assets/images/snow_background.jpg';
      case 'Rain':
        return 'assets/images/rain_background.jpg';
      case 'Drizzle':
        return 'assets/images/drizzle_background.jpg';
      case 'Thunderstorm':
        return 'assets/images/thunderstorm_background.jpg';
      case 'Clouds':
        return 'assets/images/clouds_background.jpg';
      default:
        return 'assets/images/clear_background.jpg';
    }
  }
}

class _WeatherDetailCard extends StatelessWidget {
  final OpenWeatherMap _api;
  final Weather? weather;

  const _WeatherDetailCard(this._api, {this.weather});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380.0),
        child: Card(
          color: Colors.black.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Table(
              children: [
                const TableRow(
                  children: [
                    SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    SliderSunriseSunset(
                      api: _api,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    FutureBuilder<City>(
                      future: _api.detailedCity,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final String sunset = DateFormat('HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data!.sunset!
                                      .toUtc()
                                      .millisecondsSinceEpoch +
                                  snapshot.data!.timezone! * 1000,
                            ).toUtc(),
                          );
                          final String sunrise = DateFormat('HH:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data!.sunrise!
                                      .toUtc()
                                      .millisecondsSinceEpoch +
                                  snapshot.data!.timezone! * 1000,
                            ).toUtc(),
                          );
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${AppLocalizations.of(context)!.sunrise}\n$sunrise',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${AppLocalizations.of(context)!.sunset}\n$sunset',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                        return const Center();
                      },
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<MeasurementUnitsProvider>(
                          builder: (context, value, child) {
                            if (value.temperatureUnits ==
                                TemperatureUnits.celsius) {
                              return Text(
                                '${AppLocalizations.of(context)!.realFeeling}\n${weather!.temperatureFeelsLikeInCelsius?.toStringAsFixed(2)} ${AppLocalizations.of(context)!.celsiusDegreesSymbol}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              );
                            }
                            if (value.temperatureUnits ==
                                TemperatureUnits.fahrenheit) {
                              return Text(
                                '${AppLocalizations.of(context)!.realFeeling}\n${weather!.temperatureFeelsLikeInFahrenheit?.toStringAsFixed(2)} ${AppLocalizations.of(context)!.fahrenheitDegreesSymbol}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              );
                            }
                            return Text(
                              '${AppLocalizations.of(context)!.realFeeling}\n${weather!.temperatureFeelsLike} ${AppLocalizations.of(context)!.kelvinDegreesSymbol}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                        Text(
                          '${AppLocalizations.of(context)!.humidity}\n${weather?.humidity} %',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
                TableRow(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<MeasurementUnitsProvider>(
                        builder: (context, value, child) {
                          if (value.windSpeedUnits ==
                              WindSpeedUnits.kilometersHour) {
                            return Text(
                              '${AppLocalizations.of(context)!.windSpeed}\n${weather?.windSpeedInKilometersPerHour.toStringAsFixed(2)} km/h',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          if (value.windSpeedUnits ==
                              WindSpeedUnits.milesHour) {
                            return Text(
                              '${AppLocalizations.of(context)!.windSpeed}\n${weather?.windSpeedInMilesPerHour.toStringAsFixed(2)} mi/h',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          if (value.windSpeedUnits == WindSpeedUnits.knots) {
                            return Text(
                              '${AppLocalizations.of(context)!.windSpeed}\n${weather?.windSpeedInKnots.toStringAsFixed(2)} kn',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          return Text(
                            '${AppLocalizations.of(context)!.windSpeed}\n${weather?.windSpeed} m/s',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                      Consumer<MeasurementUnitsProvider>(
                        builder: (context, value, child) {
                          if (value.pressureUnits == PressureUnits.atmosphere) {
                            return Text(
                              '${AppLocalizations.of(context)!.pressure}\n${weather?.pressureInAtmosphere} atm',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          if (value.pressureUnits ==
                              PressureUnits.millimetersMercury) {
                            return Text(
                              '${AppLocalizations.of(context)!.pressure}\n${weather?.pressureInMillimetersOfMercury} mmHg',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            );
                          }
                          return Text(
                            '${AppLocalizations.of(context)!.pressure}\n${weather?.pressure} hPa',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CurrentTemperature extends StatelessWidget {
  final Weather weather;

  const _CurrentTemperature({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<MeasurementUnitsProvider>(
        builder: (context, value, child) {
          if (value.temperatureUnits == TemperatureUnits.celsius) {
            return Text(
              '${weather.temperatureInCelsius.toStringAsFixed(2)} ${AppLocalizations.of(context)!.celsiusDegreesSymbol}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50.0,
              ),
            );
          }
          if (value.temperatureUnits == TemperatureUnits.fahrenheit) {
            return Text(
              '${weather.temperatureInFahrenheit.toStringAsFixed(2)} ${AppLocalizations.of(context)!.fahrenheitDegreesSymbol}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50.0,
              ),
            );
          }
          return Text(
            '${weather.temperature.toStringAsFixed(2)} ${AppLocalizations.of(context)!.kelvinDegreesSymbol}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 50.0,
            ),
          );
        },
      ),
    );
  }
}

class _AddCity extends StatelessWidget {
  const _AddCity();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const CustomBannerAd(),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0.0,
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.manageCities);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
          label: Text(
            AppLocalizations.of(context)!.addCity,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
        const CustomBannerAd(),
      ],
    );
  }
}
