import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/city_weather.dart';
import '../providers/cities_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/city_weather_card.dart';
import '../widgets/primary_button.dart';
import 'add_city_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);

    void openAddCity() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddCityScreen()),
      );
    }

    void remove(String cityName) =>
        ref.read(citiesProvider.notifier).removeCity(cityName);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      // Cas liste vide : message d'invite (état important pour la note UI)
      body: SafeArea(
        bottom: false,
        child: cities.isEmpty
            ? _EmptyState(onAdd: openAddCity)
            : _CityList(cities: cities, onRemove: remove, onAdd: openAddCity),
      ),
    );
  }
}

/// En-tête de l'accueil : la date du jour en eyebrow, puis « Mes villes ».
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _frenchToday().toUpperCase(),
          style: GoogleFonts.hankenGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.96,
            color: AppColors.eyebrow,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Mes villes',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 34,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.0,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _CityList extends StatelessWidget {
  const _CityList({
    required this.cities,
    required this.onRemove,
    required this.onAdd,
  });

  final List<CityWeather> cities;
  final void Function(String cityName) onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 8, 22, 0),
              child: _Header(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 124),
                itemCount: cities.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return CityWeatherCard(
                    city: city,
                    // Appui long = supprimer (temporaire, juste pour tester removeCity)
                    onLongPress: () => onRemove(city.cityName),
                  );
                },
              ),
            ),
          ],
        ),
        // Bouton d'action principale, posé sur un fondu vers le crème.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _BottomAddBar(onAdd: onAdd),
        ),
      ],
    );
  }
}

class _BottomAddBar extends StatelessWidget {
  const _BottomAddBar({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00FBF7F2), AppColors.canvas],
          stops: [0, 0.42],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: PrimaryButton(
            label: 'Ajouter une ville',
            icon: Icons.add,
            onPressed: onAdd,
          ),
        ),
      ),
    );
  }
}

/// État vide du premier lancement : illustration nuage + soleil, message
/// rassurant et l'action principale.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(44, 0, 44, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _EmptyIllustration(),
            const SizedBox(height: 26),
            Text(
              'Aucune ville suivie',
              textAlign: TextAlign.center,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ajoutez votre première ville pour suivre sa météo '
              'en un coup d’œil, même hors connexion.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 15.5,
                height: 1.55,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Ajouter une ville',
              icon: Icons.add,
              onPressed: onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 128,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 18,
            child: Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment(-0.2, -0.3),
                  colors: [Color(0xFFFFE7A8), Color(0xFFFFC24E)],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 18,
            left: 6,
            child: Container(
              width: 118,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFE4D9CB),
                borderRadius: BorderRadius.circular(23),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 26,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFE4D9CB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 26,
            left: 62,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFEFE7DC),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Date du jour formatée en français, ex. « Jeudi 19 juin ».
String _frenchToday() {
  const jours = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];
  const mois = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];
  final now = DateTime.now();
  return '${jours[now.weekday - 1]} ${now.day} ${mois[now.month - 1]}';
}
