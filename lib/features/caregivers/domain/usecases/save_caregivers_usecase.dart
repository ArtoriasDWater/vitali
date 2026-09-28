import 'package:injectable/injectable.dart';
import '../entities/caregivers.dart';
import '../repositories/caregivers_repository.dart';

@lazySingleton
class SaveCaregiversUsecase {
  final CaregiversRepository _caregiversRepository;

  SaveCaregiversUsecase(this._caregiversRepository);

  Future<void> call(Caregiver cuidador) async {
    return await _caregiversRepository.saveCaregivers(cuidador);
  }
}
