import 'dart:io';
import 'package:injectable/injectable.dart';
import '../../domain/entities/medication.dart';
import '../../domain/repositories/medication_repository.dart';
import '../datasources/medications_remote_data_source.dart';
import '../datasources/recipe_ocr_data_source.dart';
import '../models/medication_model.dart';

@LazySingleton(as: MedicationRepository)
class MedicationsRepositoryImpl implements MedicationRepository {
  final MedicationsRemoteDataSource _remoteDataSource;
  final RecipeOcrDataSource _ocrDataSource;

  MedicationsRepositoryImpl(this._remoteDataSource, this._ocrDataSource);

  @override
  Future<List<Medication>> getMedicationsByUserId(String userId) async {
    final models = await _remoteDataSource.getMedicationsByUserId(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Medication> getMedicationById(String id) async {
    final model = await _remoteDataSource.getMedicationById(id);
    return model.toEntity();
  }

  @override
  Future<void> addMedication(Medication medication) async {
    final model = MedicationModel.fromEntity(medication);
    await _remoteDataSource.addMedication(model);
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    final model = MedicationModel.fromEntity(medication);
    await _remoteDataSource.updateMedication(model);
  }

  @override
  Future<void> deleteMedication(String id) async {
    await _remoteDataSource.deleteMedication(id);
  }

  @override
  Future<Medication> scanRecipeFromImage(File imageFile, String userId) async {
    final model = await _ocrDataSource.processRecipeImage(imageFile, userId);
    return model.toEntity();
  }
}
