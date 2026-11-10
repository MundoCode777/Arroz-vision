import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/fade_slide.dart';
import '../providers/detection_provider.dart';
import '../widgets/detection_action_card.dart';

/// Contenido de inicio del módulo de detección (sin Scaffold:
/// lo aloja HomeScreen).
class DetectionHomeScreen extends StatelessWidget {
  const DetectionHomeScreen({super.key});

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final detection = context.read<DetectionProvider>();
    final ok = await detection.pickImage(source);

    if (!context.mounted) return;
    if (ok) {
      Navigator.pushNamed(context, AppRoutes.preview);
    } else if (detection.errorMessage != null) {
      AppSnackbar.show(context, detection.errorMessage!, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FadeSlide(
            child: Text(
              'Diagnóstico de hojas',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const FadeSlide(
            delay: Duration(milliseconds: 80),
            child: Text(
              'Fotografía una hoja de arroz para identificar si tiene '
              'Piricularia, Helminthosporium, Bacteriosis o si está sana.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textLight,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 28),
          FadeSlide(
            delay: const Duration(milliseconds: 160),
            child: DetectionActionCard(
              icon: Icons.photo_camera_rounded,
              title: 'Tomar foto',
              subtitle: 'Usa la cámara del celular',
              filled: true,
              onTap: () => _pick(context, ImageSource.camera),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlide(
            delay: const Duration(milliseconds: 240),
            child: DetectionActionCard(
              icon: Icons.photo_library_rounded,
              title: 'Elegir de galería',
              subtitle: 'Selecciona una imagen guardada',
              onTap: () => _pick(context, ImageSource.gallery),
            ),
          ),
          const SizedBox(height: 36),
          const FadeSlide(
            delay: Duration(milliseconds: 320),
            child: Text(
              'Para una buena foto',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const FadeSlide(
            delay: Duration(milliseconds: 380),
            child: _TipRow(
              icon: Icons.wb_sunny_outlined,
              text: 'Usa luz natural y evita sombras fuertes.',
            ),
          ),
          const SizedBox(height: 12),
          const FadeSlide(
            delay: Duration(milliseconds: 440),
            child: _TipRow(
              icon: Icons.center_focus_strong_outlined,
              text: 'Enfoca una sola hoja, de cerca y bien nítida.',
            ),
          ),
          const SizedBox(height: 12),
          const FadeSlide(
            delay: Duration(milliseconds: 500),
            child: _TipRow(
              icon: Icons.filter_none_rounded,
              text: 'Procura un fondo simple, sin otros objetos.',
            ),
          ),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.fieldFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
