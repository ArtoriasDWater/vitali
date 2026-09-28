import '../models/medication_model.dart';

abstract class MedicationsRemoteDataSource {
  Future<List<MedicationModel>> getMedicationsByUserId(String userId);
  Future<MedicationModel> getMedicationById(String id);
  Future<void> addMedication(MedicationModel medication);
  Future<void> updateMedication(MedicationModel medication);
  Future<void> deleteMedication(String id);
}
