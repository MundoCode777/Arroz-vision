import 'dart:math';

import '../models/disease_type.dart';
import 'disease_classifier.dart';

/// Clasificador de prueba: no analiza la imagen, solo simula resultados.
/// Recorre en orden: piricularia, helminthosporium, bacteriosis, sana
/// y un resultado de baja confianza.
class MockDiseaseClassifier implements DiseaseClassifier {
  static int _counter = 0;
  final Random _random = Random();

  @override
  bool get isSimulated => true;

  @override
  Future<Map<DiseaseType, double>> classify(String imagePath) async {
    await Future.delayed(const Duration(milliseconds: 2200));

    final step = _counter++ % 5;
    if (step == 4) {
      final winner =
          DiseaseType.values[_random.nextInt(DiseaseType.values.length)];
      return _distribute(winner, 0.38 + _random.nextDouble() * 0.12);
    }

    final winner = DiseaseType.values[step];
    return _distribute(winner, 0.78 + _random.nextDouble() * 0.19);
  }

  Map<DiseaseType, double> _distribute(DiseaseType winner, double top) {
    final others = DiseaseType.values.where((d) => d != winner).toList();
    final weights = others.map((_) => _random.nextDouble() + 0.1).toList();
    final total = weights.reduce((a, b) => a + b);
    final rest = 1 - top;

    final result = <DiseaseType, double>{winner: top};
    for (var i = 0; i < others.length; i++) {
      result[others[i]] = rest * weights[i] / total;
    }
    return result;
  }
}
