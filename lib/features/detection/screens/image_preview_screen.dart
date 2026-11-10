import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/fade_slide.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/detection_provider.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final path = context.watch<DetectionProvider>().imagePath;

    if (path == null) {
      return const Scaffold(
        body: Center(child: Text('No hay una imagen seleccionada')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmar imagen')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: FadeSlide(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const FadeSlide(
                delay: Duration(milliseconds: 150),
                child: Text(
                  'Verifica que la hoja se vea nítida y bien iluminada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textLight, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              FadeSlide(
                delay: const Duration(milliseconds: 250),
                child: PrimaryButton(
                  label: 'Analizar hoja',
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.analyzing,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FadeSlide(
                delay: const Duration(milliseconds: 320),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Elegir otra imagen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
