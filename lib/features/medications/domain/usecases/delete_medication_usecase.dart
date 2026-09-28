import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../repositories/medication_repository.dart';

@lazySingleton
class DeleteMedicationUsecase {
  final MedicationRepository _repository;

  DeleteMedicationUsecase(this._repository);

  /// Ejecuta la acción de eliminar un medicamento existente
  Future<void> call(String medicationId) async {
    if (medicationId.trim().isEmpty) {
      throw const AppException('El ID del medicamento no puede estar vacío.');
    }

    // Aquí pueden ir reglas de negocio adicionales antes de eliminar el medicamento
    await _repository.deleteMedication(medicationId);
  }
}
