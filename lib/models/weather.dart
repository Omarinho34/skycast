class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String iconCode;
  final DateTime sunrise;
  final DateTime sunset;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'tempMin': tempMin,
      'tempMax': tempMax,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'pressure': pressure,
      'description': description,
      'iconCode': iconCode,
      'sunrise': sunrise.toIso8601String(),
      'sunset': sunset.toIso8601String(),
    };
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['cityName'],
      temperature: json['temperature'].toDouble(),
      feelsLike: json['feelsLike'].toDouble(),
      tempMin: json['tempMin'].toDouble(),
      tempMax: json['tempMax'].toDouble(),
      humidity: json['humidity'],
      windSpeed: json['windSpeed'].toDouble(),
      pressure: json['pressure'],
      description: json['description'],
      iconCode: json['iconCode'],
      sunrise: DateTime.parse(json['sunrise']),
      sunset: DateTime.parse(json['sunset']),
    );
  }
}