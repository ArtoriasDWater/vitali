import 'dart:io';
import 'package:injectable/injectable.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

@lazySingleton
class ScanRecipeOcrUseCase {
  final MedicationRepository _repository;

  ScanRecipeOcrUseCase(this._repository);

  /// Procesa la receta con OCR y retorna la entidad borrador para confirmación en UI
  Future<Medication> call(File imageFile, String userId) async {
    return await _repository.scanRecipeFromImage(imageFile, userId);
  }
}
