import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:simple_weather/common/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:simple_weather/providers/city_provider.dart';
import 'package:simple_weather/providers/measurement_units_provider.dart';
import 'package:simple_weather/services/sqlite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await MobileAds.instance.initialize();
  await SQLite.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CityProvider()),
      ChangeNotifierProvider(create: (context) => MeasurementUnitsProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: App.lightTheme,
      initialRoute: Routes.home,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
