import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cities_provider.dart';

class AddCityScreen extends ConsumerStatefulWidget {
  const AddCityScreen({super.key});

  @override
  ConsumerState<AddCityScreen> createState() => _AddCityScreenState();
}

class _AddCityScreenState extends ConsumerState<AddCityScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ajouterVille() async {
    final nom = _controller.text.trim();

    if(nom.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom de la ville ne peut pas être vide.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {

      await ref.read(citiesProvider.notifier).addCity(nom);
      if (mounted) Navigator.pop(context);

    } catch (e) {

      if (mounted) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }

    } finally {

      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une ville')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                labelText: 'Nom de la ville',
                hintText: 'Ex : Marseille',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              // Permet de valider avec la touche "Entrée" du clavier
              onSubmitted: (_) => _ajouterVille(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // On désactive le bouton pendant le chargement
                onPressed: _isLoading ? null : _ajouterVille,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Ajouter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}