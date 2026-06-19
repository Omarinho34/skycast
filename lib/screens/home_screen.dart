import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cities_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cities = ref.watch(citiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('SkyCast')),

      // Cas liste vide : message d'invite (état important pour la note UI)
      body: cities.isEmpty
          ? const Center(child: Text('Aucune ville. Ajoutes-en une 👇'))
          : ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return ListTile(
                  title: Text(city.cityName),
                  subtitle: Text(city.weather.description),
                  trailing: Text(
                    '${city.weather.temperature.round()}°C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  // Appui long = supprimer (temporaire, juste pour tester removeCity)
                  onLongPress: () {
                    ref.read(citiesProvider.notifier).removeCity(city.cityName);
                  },
                );
              },
            ),

      // Bouton de test : ajoute une ville en dur pour valider toute la chaîne
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // ref.read dans un callback (pas ref.watch !) -> on appelle la méthode
            await ref.read(citiesProvider.notifier).addCity('Tokyo');
          } catch (e) {
            // Affiche l'erreur de l'API (ville introuvable, réseau...)
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur : $e')),
              );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}