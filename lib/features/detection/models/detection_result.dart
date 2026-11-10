import 'disease_type.dart';

class DetectionResult {
  /// Confianza mínima para considerar fiable un diagnóstico (60 %).
  static const double minConfidence = 0.6;

  final DiseaseType disease;
  final double confidence; // de 0.0 a 1.0
  final String imagePath;
  final DateTime analyzedAt;
  final Map<DiseaseType, double> probabilities;

  const DetectionResult({
    required this.disease,
    required this.confidence,
    required this.imagePath,
    required this.analyzedAt,
    required this.probabilities,
  });

  bool get isReliable => confidence >= minConfidence;

  int get confidencePercent => (confidence * 100).round();

  List<MapEntry<DiseaseType, double>> get sortedProbabilities {
    final entries = probabilities.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}
