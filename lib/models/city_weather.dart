import 'weather.dart';

class CityWeather {
  final String cityName;
  final Weather weather;
  final DateTime fetchedAt;

  CityWeather({
    required this.cityName,
    required this.weather,
    required this.fetchedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'weather': {
        'temperature': weather.temperature,
        'feelsLike': weather.feelsLike,
        'tempMin': weather.tempMin,
        'tempMax': weather.tempMax,
        'humidity': weather.humidity,
        'windSpeed': weather.windSpeed,
        'pressure': weather.pressure,
        'description': weather.description,
        'iconCode': weather.iconCode,
        'sunrise': weather.sunrise.toIso8601String(),
        'sunset': weather.sunset.toIso8601String(),
      },
      'fetchedAt': fetchedAt.toIso8601String(),
    };
  }

  factory CityWeather.fromJson(Map<String, dynamic> json) {
    return CityWeather(
      cityName: json['cityName'],
      weather: Weather.fromJson(json['weather']),
      fetchedAt: DateTime.parse(json['fetchedAt']),
    );
  }
}