import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../datasources/reminder_remote_data_source.dart';
import '../models/reminder_model.dart';

@LazySingleton(as: ReminderRepository)
class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderRemoteDataSource _remoteDataSource;

  ReminderRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Reminder>> getReminders(String userId) async {
    try {
      final models = await _remoteDataSource.getReminders(userId);
      // Convierte explícitamente cada ReminderModel a su entidad de Dominio Reminder
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw AppException('Error al obtener los recordatorios: $e');
    }
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {
    try {
      final model = ReminderModel.fromEntity(reminder);
      await _remoteDataSource.saveReminder(model);
    } catch (e) {
      throw AppException('Error al guardar el recordatorio: $e');
    }
  }

  @override
  Future<void> updateReminder(Reminder reminder) async {
    try {
      final model = ReminderModel.fromEntity(reminder);
      await _remoteDataSource.updateReminder(model);
    } catch (e) {
      throw AppException('Error al actualizar el recordatorio: $e');
    }
  }

  @override
  Future<void> deleteReminder(String uid) async {
    try {
      await _remoteDataSource.deleteReminder(uid);
    } catch (e) {
      throw AppException('Error al eliminar el recordatorio: $e');
    }
  }

  @override
  Future<void> markAsTaken(String uid, bool taken) async {
    try {
      await _remoteDataSource.markAsTaken(uid, taken);
    } catch (e) {
      throw AppException('Error al actualizar la toma: $e');
    }
  }
}
