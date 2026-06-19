import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// Action principale du design : un bouton corail en forme de pilule, avec son
/// halo coloré. Une seule par écran.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.coral,
        disabledBackgroundColor: AppColors.coral,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        minimumSize: const Size(0, 54),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.hankenGrotesk(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: loading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );

    final glow = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: AppColors.coral.withValues(alpha: 0.45),
            blurRadius: 26,
            spreadRadius: -6,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: button,
    );

    return expand ? SizedBox(width: double.infinity, child: glow) : glow;
  }
}
