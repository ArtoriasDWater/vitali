import '../models/caregivers_model.dart';

abstract class CaregiversRemoteDataSource {
  Future<List<CaregiversModel>> getCaregiversByUser(String userId);
  Future<CaregiversModel> getCaregiversById(String id);
  Future<void> saveCaregivers(CaregiversModel caregiver);
  Future<void> updateCaregivers(CaregiversModel caregiver);
  Future<void> deleteCaregivers(String id);
}
