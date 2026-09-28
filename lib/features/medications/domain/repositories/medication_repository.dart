import 'dart:io';
import '../entities/medication.dart';

abstract class MedicationRepository {
  /// Obtiene la lista de medicamentos asociados al id del paciente
  Future<List<Medication>> getMedicationsByUserId(String userId);

  /// Obtiene el detalle de un medicamento específico por su ID
  Future<Medication> getMedicationById(String id);

  /// Registra un nuevo medicamento en el sistema
  Future<void> addMedication(Medication medication);

  /// Actualiza los datos de un tratamiento (dosis, horarios, estados)
  Future<void> updateMedication(Medication medication);

  /// Elimina o da de baja un tratamiento de la lista activa del usuario
  Future<void> deleteMedication(String id);

  /// Escanea una imagen de receta médica usando OCR (ML Kit local)
  /// Devuelve una entidad Medication con los datos extraídos (en borrador)
  Future<Medication> scanRecipeFromImage(File imageFile, String userId);
}
