import 'package:flutter/material.dart';

/// Palette SkyCast — reprise des fondations « Stone » chaudes du design system
/// Stamply : un crème canvas, une couleur signature corail, des neutres jamais
/// froids.
class AppColors {
  AppColors._();

  // Marque · Coral "Stamp"
  static const coral = Color(0xFFF1573D);
  static const coralHover = Color(0xFFDA442C);

  // Neutres chauds
  static const canvas = Color(0xFFFBF7F2); // fond d'app (crème)
  static const surface = Color(0xFFFFFFFF); // cartes / champs
  static const sunken = Color(0xFFF6F0E8);
  static const ink = Color(0xFF1F1B18); // texte fort / titres
  static const textBody = Color(0xFF322C28);
  static const textMuted = Color(0xFF877A6C);
  static const textSubtle = Color(0xFFAC9E8E); // placeholders
  static const eyebrow = Color(0xFFA3937F); // overlines
  static const borderSubtle = Color(0xFFEFE7DC);

  // Sémantiques
  static const error = Color(0xFFD42A35);
  static const success = Color(0xFF1F9D63);
}
