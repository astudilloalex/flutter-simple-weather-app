import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_weather_map_client/open_weather_map_client.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:simple_weather/providers/city_provider.dart';
import 'package:simple_weather/services/address_search.dart';
import 'package:simple_weather/widgets/city_card.dart';
import 'package:uuid/uuid.dart';

class ManageCities extends StatelessWidget {
  const ManageCities({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.manageCities,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        bottom: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          title: const SearchTextField(),
        ),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> list =
        context.watch<CityProvider>().cities;
    final OpenWeatherMap _api = OpenWeatherMap(
      apiKey: weatherApiKey,
      langCode: Localizations.localeOf(context).languageCode,
    );
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return CityCard(
          _api,
          countryCode: list[index]['country'] as String,
          id: list[index]['id'] as int,
          name: list[index]['name'] as String,
        );
      },
    );
  }
}

class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.enterLocation,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(60.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
      ),
      onTap: () async {
        await showSearch(
          context: context,
          delegate: AddressSearch(const Uuid().v4()),
        );
      },
    );
  }
}
