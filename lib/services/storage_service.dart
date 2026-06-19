import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city_weather.dart';

class StorageService {
  static const String _key = 'cities';

  Future<void> saveCities(List<CityWeather> cities) async {
    final prefs = await SharedPreferences.getInstance();
    
    final jsonList = cities.map((c) => c.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await prefs.setString(_key, jsonString);
  }

  Future<List<CityWeather>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;

      return jsonList.map((item) => CityWeather.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {

      return [];
    }
    
  }
}