import 'package:injectable/injectable.dart';
import '.././../../../core/error/app_exception.dart';
import '../entities/caregivers.dart';
import '../repositories/caregivers_repository.dart';

@lazySingleton
class UpdateCaregiversUsecase {
  final CaregiversRepository _caregiversRepository;

  UpdateCaregiversUsecase(this._caregiversRepository);

  Future<void> call(Caregiver cuidador) async {
    if (cuidador.name.trim().isEmpty) {
      throw AppException('El nombre del cuidador no puede estar vacio');
    }

    return await _caregiversRepository.updateCaregivers(cuidador);
  }
}
