import 'package:injectable/injectable.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

@lazySingleton
class SaveReminder {
  final ReminderRepository _repository;

  SaveReminder(this._repository);

  Future<void> call(Reminder reminder) async {
    return await _repository.saveReminder(reminder);
  }
}
