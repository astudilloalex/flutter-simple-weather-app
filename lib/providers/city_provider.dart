import 'package:flutter/material.dart';
import 'package:simple_weather/services/sqlite.dart';

class CityProvider with ChangeNotifier {
  final SQLiteHelper _db = SQLiteHelper();

  List<Map<String, dynamic>> _cities = [];

  Future<void> load() async {
    _cities = (await _db.cities).map((element) {
      return element;
    }).toList();
  }

  Future<void> add(String name, String countryCode) async {
    final int id = await _db.insertCity({
      'name': name,
      'country': countryCode,
    });
    final Map<String, dynamic> _map = {
      'id': id,
      'name': name,
      'country': countryCode,
    };

    if (id != 0) {
      _cities.add(_map);
      notifyListeners();
    }
  }

  Future<void> remove(int id) async {
    _cities.removeWhere((element) => element['id'] as int == id);
    await _db.deleteCity(id);
    notifyListeners();
  }

  List<Map<String, dynamic>> get cities => _cities;
}
