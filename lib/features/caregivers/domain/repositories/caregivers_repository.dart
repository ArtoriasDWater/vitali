import '../entities/caregivers.dart';

abstract class CaregiversRepository {
  //Obtener los cuidadores asociados al usuario que inicio sesion
  Future<List<Caregiver>> getCaregiversByUser(String userId);
  //Obtener el cuidador especifico por ID
  Future<Caregiver> getCaregiversById(String id);
  //Guardar los cuidadores
  Future<void> saveCaregivers(Caregiver cuidador);
  //Actualizar los cuidadores
  Future<void> updateCaregivers(Caregiver cuidador);
  //Elimina al cuidador
  Future<void> deleteCaregivers(String id);
}
