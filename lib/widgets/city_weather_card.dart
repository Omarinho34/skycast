import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city_weather.dart';
import '../theme/weather_visuals.dart';
import 'weather_icon.dart';

/// Carte ville de l'écran d'accueil : l'essentiel d'un coup d'œil, avec un fond
/// qui s'adapte à la condition météo.
class CityWeatherCard extends StatelessWidget {
  const CityWeatherCard({super.key, required this.city, this.onLongPress});

  final CityWeather city;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final w = city.weather;
    final v = WeatherVisuals.of(w);

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: v.gradient,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F1F1B18),
              blurRadius: 7,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.cityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: v.title,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _capitalize(w.description),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 13.5,
                      color: v.condition,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'H:${w.tempMax.round()}°  B:${w.tempMin.round()}°',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: v.meta,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            WeatherIcon(glyph: v.glyph, size: 44, onDark: v.isDark),
            const SizedBox(width: 12),
            Text(
              '${w.temperature.round()}°',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: -1.3,
                color: v.title,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
