import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'app_colors.dart';

/// Glyphe météo à dessiner sur une carte.
enum WeatherGlyph { sun, moon, cloud, rain, snow, thunder, mist }

/// Traduit une météo en habillage visuel : c'est le cœur de l'identité SkyCast,
/// « la couleur vit avec la météo affichée ». On dérive le tout du code d'icône
/// OpenWeather (ex. `01d`, `10n`) : préfixe = condition, suffixe `d`/`n` = jour
/// ou nuit.
class WeatherVisuals {
  final List<Color> gradient; // fond de la carte
  final Color title; // nom de ville + grande température
  final Color condition; // ligne de description
  final Color meta; // H:/B: (mono)
  final WeatherGlyph glyph;
  final bool isDark; // carte sombre (nuit)

  const WeatherVisuals({
    required this.gradient,
    required this.title,
    required this.condition,
    required this.meta,
    required this.glyph,
    required this.isDark,
  });

  factory WeatherVisuals.of(Weather weather) {
    final code = weather.iconCode;
    final isNight = code.endsWith('n');
    final group = code.length >= 2 ? code.substring(0, 2) : code;
    final glyph = _glyphFor(group, isNight);

    // Nuit : tout s'assombrit vers l'indigo profond, texte clair.
    if (isNight) {
      return WeatherVisuals(
        gradient: const [Color(0xFF3A3D63), Color(0xFF262744)],
        title: Colors.white,
        condition: const Color(0xFFBCB9DC),
        meta: const Color(0xFF9B98C2),
        glyph: glyph,
        isDark: true,
      );
    }

    switch (group) {
      case '01': // ciel dégagé, jour → pêche chaud
        return const WeatherVisuals(
          gradient: [Color(0xFFFFF1DE), Color(0xFFFFE6C8)],
          title: AppColors.ink,
          condition: Color(0xFF9A6A3C),
          meta: Color(0xFFB08A5E),
          glyph: WeatherGlyph.sun,
          isDark: false,
        );
      case '09': // averses
      case '10': // pluie
      case '11': // orage → bleus-gris
        return WeatherVisuals(
          gradient: const [Color(0xFFEDF2F6), Color(0xFFDEE8EF)],
          title: AppColors.ink,
          condition: const Color(0xFF4F7790),
          meta: const Color(0xFF6F93A8),
          glyph: glyph,
          isDark: false,
        );
      case '13': // neige → glacé
        return const WeatherVisuals(
          gradient: [Color(0xFFEEF4F8), Color(0xFFE0ECF3)],
          title: AppColors.ink,
          condition: Color(0xFF5B7E93),
          meta: Color(0xFF7E9BAC),
          glyph: WeatherGlyph.snow,
          isDark: false,
        );
      default: // nuages / brume → gris neutre
        return WeatherVisuals(
          gradient: const [Color(0xFFF2F3F4), Color(0xFFE8EBEE)],
          title: AppColors.ink,
          condition: const Color(0xFF6B7178),
          meta: const Color(0xFF868D94),
          glyph: glyph,
          isDark: false,
        );
    }
  }

  static WeatherGlyph _glyphFor(String group, bool isNight) {
    switch (group) {
      case '01':
        return isNight ? WeatherGlyph.moon : WeatherGlyph.sun;
      case '02':
      case '03':
      case '04':
        return WeatherGlyph.cloud;
      case '09':
      case '10':
        return WeatherGlyph.rain;
      case '11':
        return WeatherGlyph.thunder;
      case '13':
        return WeatherGlyph.snow;
      case '50':
        return WeatherGlyph.mist;
      default:
        return WeatherGlyph.cloud;
    }
  }
}
