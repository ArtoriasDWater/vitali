import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../entities/medication.dart';
import '../repositories/medication_repository.dart';

@lazySingleton
class GetPatientMedicationsUseCase {
  final MedicationRepository _repository;

  GetPatientMedicationsUseCase(this._repository);

  /// Ejecuta la acción de obtener los medicamentos filtrados
  Future<List<Medication>> call(String userId) async {
    if (userId.trim().isEmpty) {
      throw const AppException('El ID de usuario no es válido.');
    }

    // Aquí pueden ir reglas de negocio adicionales antes de consultar los datos
    return await _repository.getMedicationsByUserId(userId);
  }
}
