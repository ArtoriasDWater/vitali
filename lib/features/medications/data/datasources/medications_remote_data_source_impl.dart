import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../models/medication_model.dart';
import 'medications_remote_data_source.dart';

@LazySingleton(as: MedicationsRemoteDataSource)
class MedicationsRemoteDataSourceImpl implements MedicationsRemoteDataSource {
  final FirebaseFirestore _firestore;

  MedicationsRemoteDataSourceImpl(this._firestore);

  // Nombre de la colección centralizada para medicamentos
  CollectionReference<Map<String, dynamic>> get _medicationsRef =>
      _firestore.collection('medications');

  @override
  Future<List<MedicationModel>> getMedicationsByUserId(String userId) async {
    try {
      // Filtrado directo por el ID del usuario para aislamiento de datos
      final querySnapshot = await _medicationsRef
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => MedicationModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw AppException('Error al consultar los medicamentos del usuario: $e');
    }
  }

  @override
  Future<MedicationModel> getMedicationById(String id) async {
    try {
      final docSnapshot = await _medicationsRef.doc(id).get();
      if (!docSnapshot.exists) {
        throw const AppException('El medicamento solicitado no existe.');
      }
      return MedicationModel.fromSnapshot(docSnapshot);
    } on FirebaseException catch (e) {
      throw AppException('Error al obtener el detalle del medicamento: $e');
    }
  }

  @override
  Future<void> addMedication(MedicationModel medication) async {
    try {
      await _medicationsRef.add(medication.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error al guardar el medicamento: $e');
    }
  }

  @override
  Future<void> updateMedication(MedicationModel medication) async {
    try {
      await _medicationsRef.doc(medication.uid).update(medication.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error al actualizar el medicamento: $e');
    }
  }

  @override
  Future<void> deleteMedication(String id) async {
    try {
      await _medicationsRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw AppException('Error al eliminar el medicamento: $e');
    }
  }
}
