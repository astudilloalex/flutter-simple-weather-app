import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather/providers/measurement_units_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          _AppBar(),
          _SliverList(),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      floating: true,
      title: Text(
        AppLocalizations.of(context)!.settings,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}

class _SliverList extends StatelessWidget {
  const _SliverList();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgets = [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(AppLocalizations.of(context)!.units.toUpperCase()),
      ),
      const _TempUnitPopupMenu(),
      const _PressureUnitPopupMenu(),
      const _WindSpeedUnitPopupMenu(),
    ];
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return _widgets[index];
        },
        childCount: _widgets.length,
      ),
    );
  }
}

class _PressureUnitPopupMenu extends StatelessWidget {
  const _PressureUnitPopupMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          context
              .read<MeasurementUnitsProvider>()
              .setPressureUnit(PressureUnits.hectoPascal);
        } else if (value == 1) {
          context
              .read<MeasurementUnitsProvider>()
              .setPressureUnit(PressureUnits.atmosphere);
        } else if (value == 2) {
          context
              .read<MeasurementUnitsProvider>()
              .setPressureUnit(PressureUnits.millimetersMercury);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 0,
            child: Text('hPa'),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text('atm'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('mmHg'),
          ),
        ];
      },
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.unitAtmosphericPressure),
        trailing: Consumer<MeasurementUnitsProvider>(
          builder: (context, value, child) {
            return Text(value.pressureUnits == PressureUnits.atmosphere
                ? 'atm'
                : value.pressureUnits == PressureUnits.millimetersMercury
                    ? 'mmHg'
                    : 'hPa');
          },
        ),
      ),
    );
  }
}

class _TempUnitPopupMenu extends StatelessWidget {
  const _TempUnitPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          context
              .read<MeasurementUnitsProvider>()
              .setTempUnit(TemperatureUnits.kelvin);
        } else if (value == 1) {
          context
              .read<MeasurementUnitsProvider>()
              .setTempUnit(TemperatureUnits.celsius);
        } else if (value == 2) {
          context
              .read<MeasurementUnitsProvider>()
              .setTempUnit(TemperatureUnits.fahrenheit);
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 0,
            child: Text(AppLocalizations.of(context)!.kelvinDegreesSymbol),
          ),
          PopupMenuItem(
            value: 1,
            child: Text(AppLocalizations.of(context)!.celsiusDegreesSymbol),
          ),
          PopupMenuItem(
            value: 2,
            child: Text(AppLocalizations.of(context)!.fahrenheitDegreesSymbol),
          ),
        ];
      },
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.temperatureUnit),
        trailing: Consumer<MeasurementUnitsProvider>(
          builder: (context, value, child) {
            return Text(
              value.temperatureUnits == TemperatureUnits.celsius
                  ? AppLocalizations.of(context)!.celsiusDegreesSymbol
                  : value.temperatureUnits == TemperatureUnits.kelvin
                      ? AppLocalizations.of(context)!.kelvinDegreesSymbol
                      : AppLocalizations.of(context)!.fahrenheitDegreesSymbol,
            );
          },
        ),
      ),
    );
  }
}

class _WindSpeedUnitPopupMenu extends StatelessWidget {
  const _WindSpeedUnitPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          context
              .read<MeasurementUnitsProvider>()
              .setWindSppedUnit(WindSpeedUnits.metersSecond);
        } else if (value == 1) {
          context
              .read<MeasurementUnitsProvider>()
              .setWindSppedUnit(WindSpeedUnits.kilometersHour);
        } else if (value == 2) {
          context
              .read<MeasurementUnitsProvider>()
              .setWindSppedUnit(WindSpeedUnits.milesHour);
        } else if (value == 3) {
          context
              .read<MeasurementUnitsProvider>()
              .setWindSppedUnit(WindSpeedUnits.knots);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 0,
            child: Text('m/s'),
          ),
          const PopupMenuItem(
            value: 1,
            child: Text('km/h'),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text('mi/h'),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text('kn'),
          ),
        ];
      },
      child: ListTile(
        title: Text(AppLocalizations.of(context)!.unitWindSpeed),
        trailing: Consumer<MeasurementUnitsProvider>(
          builder: (context, value, child) {
            return Text(
              value.windSpeedUnits == WindSpeedUnits.kilometersHour
                  ? 'km/h'
                  : value.windSpeedUnits == WindSpeedUnits.milesHour
                      ? 'mi/h'
                      : value.windSpeedUnits == WindSpeedUnits.knots
                          ? 'kn'
                          : 'm/s',
            );
          },
        ),
      ),
    );
  }
}
