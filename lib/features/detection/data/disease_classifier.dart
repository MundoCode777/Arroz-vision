import '../models/disease_type.dart';

/// Contrato que cumplen tanto el clasificador simulado como el real.
abstract class DiseaseClassifier {
  /// true cuando los resultados son datos de prueba.
  bool get isSimulated;

  /// Devuelve la probabilidad (0.0 a 1.0) de cada clase para la imagen.
  Future<Map<DiseaseType, double>> classify(String imagePath);
}
