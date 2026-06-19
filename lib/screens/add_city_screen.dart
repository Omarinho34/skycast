import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/cities_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/primary_button.dart';

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
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Ajouter une ville',
                      style: GoogleFonts.bricolageGrotesque(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.coral,
                      textStyle: GoogleFonts.hankenGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SearchField(
                controller: _controller,
                // Permet de valider avec la touche "Entrée" du clavier
                onSubmitted: (_) => _ajouterVille(),
              ),
              const SizedBox(height: 16),
              // On désactive le bouton pendant le chargement
              PrimaryButton(
                label: 'Ajouter',
                expand: true,
                loading: _isLoading,
                onPressed: _ajouterVille,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Champ de recherche du design : surface blanche, coin arrondi, hairline
/// discrète, et l'anneau corail au focus.
class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: onSubmitted,
      cursorColor: AppColors.coral,
      style: GoogleFonts.hankenGrotesk(fontSize: 16, color: AppColors.ink),
      decoration: InputDecoration(
        hintText: 'Ex : Marseille',
        hintStyle: GoogleFonts.hankenGrotesk(
          fontSize: 16,
          color: AppColors.textSubtle,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.textMuted,
          size: 22,
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.coral, width: 1.6),
        ),
      ),
    );
  }
}
