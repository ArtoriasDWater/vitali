import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/caregivers.dart';
import '../../domain/usecases/delete_caregivers_usecase.dart';
import '../../domain/usecases/get_caregivers_by_user_usecase.dart';
import '../../domain/usecases/save_caregivers_usecase.dart';
import '../../domain/usecases/update_caregivers_usecase.dart';

@lazySingleton
class CaregiversProvider extends ChangeNotifier {
  final GetCaregiversByUserUsecase _getCaregiversByUserUsecase;
  final SaveCaregiversUsecase _saveCaregiversUsecase;
  final UpdateCaregiversUsecase _updateCaregiversUsecase;
  final DeleteCaregiversUsecase _deleteCaregiversUsecase;

  CaregiversProvider(
    this._getCaregiversByUserUsecase,
    this._saveCaregiversUsecase,
    this._updateCaregiversUsecase,
    this._deleteCaregiversUsecase,
  );

  List<Caregiver> _caregivers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Caregiver> get caregivers => _caregivers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getCaregivers(String userId) async {
    _setLoading(true);
    try {
      _caregivers = await _getCaregiversByUserUsecase(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> saveCaregiver(Caregiver caregiver) async {
    _setLoading(true);
    try {
      await _saveCaregiversUsecase(caregiver);
      await getCaregivers(caregiver.userId);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateCaregiver(Caregiver caregiver) async {
    _setLoading(true);
    try {
      await _updateCaregiversUsecase(caregiver);
      await getCaregivers(caregiver.userId);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteCaregiver(String id, String userId) async {
    _setLoading(true);
    try {
      await _deleteCaregiversUsecase(id);
      await getCaregivers(userId);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }
}
