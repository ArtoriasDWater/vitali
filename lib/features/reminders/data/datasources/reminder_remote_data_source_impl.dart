import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/app_exception.dart';
import '../models/reminder_model.dart';
import 'reminder_remote_data_source.dart';

@LazySingleton(as: ReminderRemoteDataSource)
class ReminderRemoteDataSourceImpl implements ReminderRemoteDataSource {
  final FirebaseFirestore _firestore;

  ReminderRemoteDataSourceImpl(this._firestore);

  // Nombre de la colección centralizada para recordatorios
  CollectionReference<Map<String, dynamic>> get _remindersRef =>
      _firestore.collection('reminders');

  @override
  Future<List<ReminderModel>> getReminders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('reminders')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs
          .map((doc) => ReminderModel.fromSnapshot(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw AppException('Error al obtener los recordatorios: $e');
    }
  }

  @override
  Future<void> saveReminder(ReminderModel reminder) async {
    try {
      await _remindersRef.add(reminder.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error al intentar guardar el recordatorio: $e');
    }
  }

  @override
  Future<void> deleteReminder(String reminderId) async {
    try {
      await _remindersRef.doc(reminderId).delete();
    } on FirebaseException catch (e) {
      throw AppException('Error al intentar eliminar el recordatorio: $e');
    }
  }

  @override
  Future<void> markAsTaken(String reminderId, bool isTaken) async {
    try {
      await _remindersRef.doc(reminderId).update({'taken': isTaken});
    } on FirebaseException catch (e) {
      throw AppException('Error al actualizar el estado de la toma: $e');
    }
  }

  @override
  Future<void> updateReminder(ReminderModel reminder) async {
    try {
      await _remindersRef.doc(reminder.uid).update(reminder.toJson());
    } on FirebaseException catch (e) {
      throw AppException('Error al actualizar el recordatorio: $e');
    }
  }
}
