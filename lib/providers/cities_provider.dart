import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/city_weather.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CitiesNotifier extends Notifier<List<CityWeather>> {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  @override
  List<CityWeather> build() {
    _chargerVillesSauvegardees();
    return [];
  }

  Future<void> _chargerVillesSauvegardees() async {
    final villes = await _storage.loadCities();
    if (villes.isNotEmpty) {
      state = villes;
    }
  }

  Future<void> addCity(String cityName) async {
    final dejaPresente = state.any(
      (c) => c.cityName.toLowerCase() == cityName.toLowerCase(),
    );

    if (dejaPresente) {
      throw Exception('La ville est déjà présente dans la liste.');
    }

    final weather = await _api.fetchWeather(cityName);

    final nouvelle = CityWeather(
      cityName: cityName,
      weather: weather,
      fetchedAt: DateTime.now(),
    );

    state = [...state, nouvelle];
    _storage.saveCities(state);

  }

  void removeCity(String cityName){
    state = state.where((c) => c.cityName.toLowerCase() != cityName.toLowerCase()).toList();
    _storage.saveCities(state);
  }
}

final citiesProvider = NotifierProvider<CitiesNotifier, List<CityWeather>>(() {
  return CitiesNotifier();
});
