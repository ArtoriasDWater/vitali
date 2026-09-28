import 'package:injectable/injectable.dart';
import '../../domain/entities/caregivers.dart';
import '../../domain/repositories/caregivers_repository.dart';
import '../datasources/caregivers_remote_data_source.dart';
import '../models/caregivers_model.dart';

@LazySingleton(as: CaregiversRepository)
class CaregiversRepositoryImpl implements CaregiversRepository {
  final CaregiversRemoteDataSource _remoteDataSource;

  CaregiversRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Caregiver>> getCaregiversByUser(String userId) async {
    final models = await _remoteDataSource.getCaregiversByUser(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Caregiver> getCaregiversById(String id) async {
    final model = await _remoteDataSource.getCaregiversById(id);
    return model.toEntity();
  }

  @override
  Future<void> saveCaregivers(Caregiver caregiver) async {
    final model = CaregiversModel.fromEntity(caregiver);
    await _remoteDataSource.saveCaregivers(model);
  }

  @override
  Future<void> updateCaregivers(Caregiver caregiver) async {
    final model = CaregiversModel.fromEntity(caregiver);
    await _remoteDataSource.updateCaregivers(model);
  }

  @override
  Future<void> deleteCaregivers(String id) async {
    await _remoteDataSource.deleteCaregivers(id);
  }
}
