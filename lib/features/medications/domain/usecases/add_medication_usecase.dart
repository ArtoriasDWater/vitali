import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

@lazySingleton
class AddMedicationUseCase {
  final MedicationRepository _repository;

  AddMedicationUseCase(this._repository);

  /// Ejecuta la acción de agregar un nuevo medicamento
  Future<void> call(Medication medication) async {
    if (medication.name.trim().isEmpty) {
      throw const AppException(
        'El nombre del medicamento no puede estar vacío.',
      );
    }
    if (medication.numberOfPills == 0) {
      throw const AppException('El numero de pildoras no puede estar vacía.');
    }
    if (medication.frequency.trim().isEmpty) {
      throw const AppException(
        'La frecuencia del medicamento no puede estar vacía.',
      );
    }

    // Aquí pueden ir reglas de negocio adicionales antes de registrar el medicamento
    await _repository.addMedication(medication);
  }
}
