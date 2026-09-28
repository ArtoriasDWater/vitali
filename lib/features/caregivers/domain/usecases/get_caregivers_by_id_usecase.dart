import 'package:injectable/injectable.dart';
import '.././../../../core/error/app_exception.dart';
import '../entities/caregivers.dart';
import '../repositories/caregivers_repository.dart';

@lazySingleton
class GetCaregiversByIdUsecase {
  final CaregiversRepository _caregiversRepository;

  GetCaregiversByIdUsecase(this._caregiversRepository);

  Future<Caregiver> call(String id) async {
    if (id.trim().isEmpty) {
      throw AppException('El ID del cuidador no es valido');
    }

    return await _caregiversRepository.getCaregiversById(id);
  }
}
