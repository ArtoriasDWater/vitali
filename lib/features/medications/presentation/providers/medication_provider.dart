import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:proyecto_hospital/core/error/app_exception.dart';
import '../../domain/entities/medication.dart';
import '../../domain/usecases/add_medication_usecase.dart';
import '../../domain/usecases/delete_medication_usecase.dart';
import '../../domain/usecases/get_medication_by_id_usecase.dart';
import '../../domain/usecases/scan_recipe_ocr_usecase.dart';
import '../../domain/usecases/update_medication_usecase.dart';

@lazySingleton
class MedicationProvider extends ChangeNotifier {
  final GetPatientMedicationsUseCase _getPatientMedicationsUseCase;
  final AddMedicationUseCase _addMedicationUseCase;
  final UpdateMedicationUsecase _updateMedicationUsecase;
  final DeleteMedicationUsecase _deleteMedicationUsecase;
  final ScanRecipeOcrUseCase _scanRecipeOcrUseCase;

  MedicationProvider(
    this._addMedicationUseCase,
    this._getPatientMedicationsUseCase,
    this._updateMedicationUsecase,
    this._deleteMedicationUsecase,
    this._scanRecipeOcrUseCase,
  );

  //Variables locales
  List<Medication> _medications = []; //Lista de medicaciones
  Medication? _tempMedication; //Variable en caso de escanear con el OCR
  bool _isLoading = false;
  String? _errorMessage;

  //Getters
  List<Medication> get medication => _medications;
  Medication? get tempMedication => _tempMedication;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  //Metodos privados
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Cargar la lista de medicamentos del usuario
  Future<void> getMedications(String userId) async {
    _setLoading(true);
    try {
      _medications = await _getPatientMedicationsUseCase(userId);
      _errorMessage = null;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } finally {
      _setLoading(false);
    }
  }

  //Escanea una prescripcion usando OCR y asigna el borrador.
  Future<bool> scanRecipe(File imageFile, String userId) async {
    _setLoading(true);
    try {
      _tempMedication = await _scanRecipeOcrUseCase(imageFile, userId);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = "Error inesperado al procesar la imagen de la receta";
      _setLoading(false);
      return false;
    }
  }

  Future<bool> saveMedication(Medication medication) async {
    _setLoading(true);
    try {
      await _addMedicationUseCase(medication);
      _tempMedication = null;
      await getMedications(medication.userId);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo guardar el medicamento.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateMedication(Medication medication) async {
    _setLoading(true);
    try {
      await _updateMedicationUsecase(medication);
      await getMedications(medication.userId);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo actualizar el medicamento.';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteMedication(String id, String userId) async {
    _setLoading(true);
    try {
      await _deleteMedicationUsecase(id);
      await getMedications(userId);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar el medicamento.';
      _setLoading(false);
      return false;
    }
  }
}
