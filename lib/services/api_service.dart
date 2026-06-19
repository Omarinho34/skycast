import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class ApiService {

  static const String _apiKey = 'a3ab250f1a7a538749f3530a5aae2a11';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String cityName) async {
    final url = Uri.parse('$_baseUrl?q=$cityName&appid=$_apiKey&units=metric&lang=fr');

    final response = await http.get(url);

    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        feelsLike: data['main']['feels_like'].toDouble(),
        tempMin: data['main']['temp_min'].toDouble(),
        tempMax: data['main']['temp_max'].toDouble(),
        humidity: data['main']['humidity'],
        windSpeed: data['wind']['speed'].toDouble(),
        pressure: data['main']['pressure'],
        description: data['weather'][0]['description'],
        iconCode: data['weather'][0]['icon'],
        sunrise: DateTime.fromMillisecondsSinceEpoch(data['sys']['sunrise'] * 1000),
        sunset: DateTime.fromMillisecondsSinceEpoch(data['sys']['sunset'] * 1000),
      );
    } else if (response.statusCode == 404) {
      throw Exception('Ville non trouvée !');
    } else {
      throw Exception('Erreur : ${response.statusCode}');
    }
  }

}