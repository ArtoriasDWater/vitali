import '../entities/reminder.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders(String userId);
  Future<void> saveReminder(Reminder reminder);
  Future<void> updateReminder(Reminder reminder);
  Future<void> deleteReminder(String reminderId);
  Future<void> markAsTaken(String reminderId, bool isTaken);
}
