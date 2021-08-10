import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simple_weather/common/constants.dart';
import 'package:simple_weather/providers/city_provider.dart';

class AddressSearch extends SearchDelegate<Suggestion> {
  final String sessionToken;
  final _PlaceApiProvider _apiClient;

  AddressSearch(
    this.sessionToken,
  ) : _apiClient = _PlaceApiProvider(sessionToken);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: AppLocalizations.of(context)!.clear,
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Suggestion('', ''));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Suggestion>>(
      future: query == ''
          ? null
          : _apiClient.fetchSuggestions(
              query,
              Localizations.localeOf(context).languageCode,
            ),
      builder: (context, snapshot) {
        if (query == '') {
          return Text(
            AppLocalizations.of(context)!.enterLocation,
            textAlign: TextAlign.center,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                final _City? _city =
                    await _apiClient.city(snapshot.data![index].placeId);
                if (_city != null) {
                  await context.read<CityProvider>().add(
                        _city.name,
                        _city.countryCode,
                      );
                }
                close(context, Suggestion('', ''));
              },
              title: Text(
                snapshot.data![index].description,
              ),
            );
          },
        );
      },
    );
  }
}

class _City {
  final String countryCode;
  final String name;

  const _City({required this.countryCode, required this.name});
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class _PlaceApiProvider {
  final String sessionToken;

  const _PlaceApiProvider(this.sessionToken);

  Future<_City?> city(String placeId) async {
    final http.Response response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$placesApiKey&fields=address_component'),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'OK') {
        final List<dynamic> list =
            result['result']['address_components'] as List<dynamic>;
        String? cityName;
        String? country;
        for (int i = 0; i < list.length; i++) {
          if ((list[i]['types'] as List).contains('locality')) {
            cityName = list[i]['long_name'] as String;
          }
          if ((list[i]['types'] as List).contains('country')) {
            country = list[i]['short_name'] as String;
          }
        }
        return _City(countryCode: country!, name: cityName!);
      }
    }
  }

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final http.Response response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=(cities)&language=$lang&key=$placesApiKey&sessiontoken=$sessionToken',
      ),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 'OK') {
        return (result['predictions'] as List<dynamic>)
            .map<Suggestion>(
              (json) => Suggestion(
                json['place_id'] as String,
                json['description'] as String,
              ),
            )
            .toList();
      }
    }
    return Future.value([]);
  }
}
