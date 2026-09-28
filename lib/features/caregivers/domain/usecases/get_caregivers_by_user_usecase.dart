import 'package:injectable/injectable.dart';
import '.././../../../core/error/app_exception.dart';
import '../entities/caregivers.dart';
import '../repositories/caregivers_repository.dart';

@lazySingleton
class GetCaregiversByUserUsecase {
  final CaregiversRepository _caregiversRepository;

  GetCaregiversByUserUsecase(this._caregiversRepository);

  Future<List<Caregiver>> call(String userId) async {
    if (userId.trim().isEmpty) {
      throw AppException('El ID del usuario no es valido');
    }

    return await _caregiversRepository.getCaregiversByUser(userId);
  }
}
