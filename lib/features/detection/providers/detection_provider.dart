import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../data/disease_classifier.dart';
import '../models/detection_result.dart';

enum DetectionStatus { idle, imageSelected, analyzing, done, error }

class DetectionProvider extends ChangeNotifier {
  final DiseaseClassifier _classifier;
  final ImagePicker _picker = ImagePicker();

  DetectionProvider(this._classifier);

  DetectionStatus _status = DetectionStatus.idle;
  String? _imagePath;
  DetectionResult? _result;
  String? _errorMessage;

  DetectionStatus get status => _status;
  String? get imagePath => _imagePath;
  DetectionResult? get result => _result;
  String? get errorMessage => _errorMessage;
  bool get isSimulated => _classifier.isSimulated;

  /// Abre la cámara o la galería. Devuelve true si se eligió una imagen.
  Future<bool> pickImage(ImageSource source) async {
    _errorMessage = null;
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 90,
      );
      if (file == null) return false; // el usuario canceló

      _imagePath = file.path;
      _result = null;
      _status = DetectionStatus.imageSelected;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'No se pudo acceder a la cámara o a la galería.';
      _status = DetectionStatus.error;
      notifyListeners();
      return false;
    }
  }

  /// Analiza la imagen seleccionada. Devuelve true si salió bien.
  Future<bool> analyze() async {
    final path = _imagePath;
    if (path == null) return false;

    _status = DetectionStatus.analyzing;
    _errorMessage = null;
    notifyListeners();

    try {
      final probabilities = await _classifier.classify(path);
      final best = probabilities.entries.reduce(
        (a, b) => a.value >= b.value ? a : b,
      );

      _result = DetectionResult(
        disease: best.key,
        confidence: best.value,
        imagePath: path,
        analyzedAt: DateTime.now(),
        probabilities: probabilities,
      );
      _status = DetectionStatus.done;
      notifyListeners();
      return true;
    } catch (_) {
      _errorMessage = 'No se pudo analizar la imagen. Intenta de nuevo.';
      _status = DetectionStatus.error;
      notifyListeners();
      return false;
    }
  }
}
