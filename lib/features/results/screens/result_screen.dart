import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/fade_slide.dart';
import '../../../core/widgets/primary_button.dart';
import '../../detection/models/detection_result.dart';
import '../../detection/models/disease_type.dart';
import '../../detection/providers/detection_provider.dart';

/// Pantalla de resultado provisional. El módulo 3 la amplía.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final detection = context.watch<DetectionProvider>();
    final result = detection.result;

    if (result == null) {
      return const Scaffold(
        body: Center(child: Text('Todavía no hay resultados')),
      );
    }

    final reliable = result.isReliable;
    final color = reliable ? result.disease.color : AppColors.textLight;
    final minPercent = (DetectionResult.minConfidence * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen analizada
              FadeSlide(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.file(
                    File(result.imagePath),
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (detection.isSimulated)
                const FadeSlide(
                  delay: Duration(milliseconds: 80),
                  child: _SimulatedTag(),
                ),
              if (detection.isSimulated) const SizedBox(height: 16),

              // Enfermedad detectada
              FadeSlide(
                delay: const Duration(milliseconds: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            reliable
                                ? result.disease.icon
                                : Icons.help_outline_rounded,
                            size: 18,
                            color: color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            reliable
                                ? (result.disease.isHealthy
                                      ? 'Sin enfermedad'
                                      : 'Enfermedad detectada')
                                : 'Poco confiable',
                            style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reliable
                          ? result.disease.label
                          : 'Resultado no concluyente',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (reliable && result.disease.scientificName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          result.disease.scientificName!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Nivel de confianza
              FadeSlide(
                delay: const Duration(milliseconds: 220),
                child: _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nivel de confianza',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: result.confidence),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${(value * 100).round()} %',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: value,
                                minHeight: 10,
                                color: color,
                                backgroundColor: AppColors.fieldFill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Estado del cultivo y resumen
              FadeSlide(
                delay: const Duration(milliseconds: 300),
                child: _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estado del cultivo',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reliable
                            ? result.disease.cropStatus
                            : 'No se pudo determinar',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        reliable
                            ? result.disease.summary
                            : 'La confianza (${result.confidencePercent} %) '
                                  'está por debajo del mínimo ($minPercent %). '
                                  'Toma otra foto con buena luz y la hoja bien '
                                  'enfocada.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Probabilidades por clase
              FadeSlide(
                delay: const Duration(milliseconds: 380),
                child: _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Probabilidad por clase',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (final entry in result.sortedProbabilities)
                        _ProbabilityRow(disease: entry.key, value: entry.value),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Fecha y hora
              FadeSlide(
                delay: const Duration(milliseconds: 440),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      Formatters.dateTime(result.analyzedAt),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const FadeSlide(
                delay: Duration(milliseconds: 480),
                child: Text(
                  'Este resultado es una ayuda de apoyo. Ante la duda, '
                  'consulta a un técnico agrícola.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              FadeSlide(
                delay: const Duration(milliseconds: 540),
                child: PrimaryButton(
                  label: 'Nuevo análisis',
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SimulatedTag extends StatelessWidget {
  const _SimulatedTag();

  @override
  Widget build(BuildContext context) {
    const tagColor = Color(0xFF8A6100);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.science_outlined, size: 18, color: tagColor),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Modo simulado: son datos de prueba, no un diagnóstico real.',
              style: TextStyle(
                color: tagColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProbabilityRow extends StatelessWidget {
  final DiseaseType disease;
  final double value;

  const _ProbabilityRow({required this.disease, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              disease.label,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
            ),
          ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: value),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutCubic,
              builder: (_, v, __) => ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: v,
                  minHeight: 8,
                  color: disease.color,
                  backgroundColor: AppColors.fieldFill,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              '${(value * 100).round()} %',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
