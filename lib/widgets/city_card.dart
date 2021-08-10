import 'package:flutter/material.dart';
import 'package:open_weather_map_client/open_weather_map_client.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:simple_weather/providers/city_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_weather/providers/measurement_units_provider.dart';

class CityCard extends StatelessWidget {
  final OpenWeatherMap _api;
  final String countryCode;
  final String name;
  final int id;

  const CityCard(
    this._api, {
    Key? key,
    required this.countryCode,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: FutureBuilder<Weather>(
        future: _api.currentWeatherByCity(name: name, countryCode: countryCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onLongPress: () async {
                await showDialog(
                  context: context,
                  builder: (context) => _AlertDialog(id),
                );
              },
              title: Text('$name, $countryCode'),
              trailing: Consumer<MeasurementUnitsProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.temperatureUnits == TemperatureUnits.celsius
                        ? '${snapshot.data!.temperatureInCelsius.toStringAsFixed(2)}°'
                        : value.temperatureUnits == TemperatureUnits.fahrenheit
                            ? '${snapshot.data!.temperatureInFahrenheit.toStringAsFixed(2)}°'
                            : snapshot.data!.temperature.toString(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AlertDialog extends StatelessWidget {
  final int id;

  const _AlertDialog(this.id);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.areYouSureDelete),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            await Provider.of<CityProvider>(context, listen: false).remove(id);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
