import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum DiseaseType { piricularia, helminthosporium, bacteriosis, healthy }

extension DiseaseTypeX on DiseaseType {
  String get label {
    switch (this) {
      case DiseaseType.piricularia:
        return 'Piricularia';
      case DiseaseType.helminthosporium:
        return 'Helminthosporium';
      case DiseaseType.bacteriosis:
        return 'Bacteriosis';
      case DiseaseType.healthy:
        return 'Hoja sana';
    }
  }

  String? get scientificName {
    switch (this) {
      case DiseaseType.piricularia:
        return 'Pyricularia oryzae';
      case DiseaseType.helminthosporium:
        return 'Bipolaris oryzae';
      case DiseaseType.bacteriosis:
        return 'Burkholderia glumae';
      case DiseaseType.healthy:
        return null;
    }
  }

  Color get color {
    switch (this) {
      case DiseaseType.piricularia:
        return const Color(0xFFE67E22);
      case DiseaseType.helminthosporium:
        return const Color(0xFF8E5B3A);
      case DiseaseType.bacteriosis:
        return const Color(0xFFD64545);
      case DiseaseType.healthy:
        return AppColors.primary;
    }
  }

  IconData get icon {
    return isHealthy ? Icons.check_circle_rounded : Icons.warning_amber_rounded;
  }

  bool get isHealthy => this == DiseaseType.healthy;

  String get cropStatus {
    return isHealthy
        ? 'Cultivo sin signos de enfermedad'
        : 'Se detectan síntomas de $label';
  }

  String get summary {
    switch (this) {
      case DiseaseType.piricularia:
        return 'Enfermedad causada por un hongo. Suele verse como manchas '
            'en forma de huso o diamante, con el centro grisáceo y el '
            'borde más oscuro.';
      case DiseaseType.helminthosporium:
        return 'Enfermedad causada por un hongo. Suele verse como manchas '
            'ovaladas de color café sobre las hojas.';
      case DiseaseType.bacteriosis:
        return 'Enfermedad causada por una bacteria. Provoca lesiones y '
            'decoloración en la planta.';
      case DiseaseType.healthy:
        return 'La hoja no muestra síntomas visibles de las enfermedades '
            'que evalúa el sistema.';
    }
  }
}
