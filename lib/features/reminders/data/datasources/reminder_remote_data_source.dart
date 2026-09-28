import '../models/reminder_model.dart';

abstract class ReminderRemoteDataSource {
  Future<List<ReminderModel>> getReminders(String userId);
  Future<void> saveReminder(ReminderModel reminder);
  Future<void> deleteReminder(String reminderId);
  Future<void> updateReminder(ReminderModel reminder);
  Future<void> markAsTaken(String reminderId, bool isTaken);
}
