import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../models/caregivers_model.dart';
import 'caregivers_remote_data_source.dart';

@LazySingleton(as: CaregiversRemoteDataSource)
class CaregiversRemoteDataSourceImpl implements CaregiversRemoteDataSource {
  final FirebaseFirestore _firestore;

  CaregiversRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _caregiversRef =>
      _firestore.collection('caregivers');

  @override
  Future<List<CaregiversModel>> getCaregiversByUser(String userId) async {
    try {
      final querySnapshot = await _caregiversRef
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => CaregiversModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw AppException('Error al consultar los cuidadores del usuario: $e');
    }
  }

  @override
  Future<CaregiversModel> getCaregiversById(String id) async {
    try {
      final docSnapshot = await _caregiversRef.doc(id).get();
      if (!docSnapshot.exists) {
        throw const AppException('El cuidador solicitado no existe.');
      }
      return CaregiversModel.fromSnapshot(docSnapshot);
    } on FirebaseException catch (e) {
      throw AppException('Error al obtener el detalle del cuidador: $e');
    }
  }

  @override
  Future<void> saveCaregivers(CaregiversModel caregiver) async {
    try {
      await _caregiversRef.add(caregiver.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error al guardar el cuidador: $e');
    }
  }

  @override
  Future<void> updateCaregivers(CaregiversModel caregiver) async {
    try {
      await _caregiversRef.doc(caregiver.uid).update(caregiver.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error al actualizar el cuidador: $e');
    }
  }

  @override
  Future<void> deleteCaregivers(String id) async {
    try {
      await _caregiversRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw AppException('Error al eliminar el cuidador: $e');
    }
  }
}
