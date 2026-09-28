import 'package:injectable/injectable.dart';
import '.././../../../core/error/app_exception.dart';
import '../repositories/caregivers_repository.dart';

@lazySingleton
class DeleteCaregiversUsecase {
  final CaregiversRepository _caregiversRepository;

  DeleteCaregiversUsecase(this._caregiversRepository);

  Future<void> call(String id) async {
    if (id.trim().isEmpty) {
      throw AppException('El Id del cuidador no puede estar vacio');
    }

    return await _caregiversRepository.deleteCaregivers(id);
  }
}
