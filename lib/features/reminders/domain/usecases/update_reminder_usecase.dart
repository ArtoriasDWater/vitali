import 'package:injectable/injectable.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

@lazySingleton
class UpdateReminderUsecase {
  final ReminderRepository _repository;

  UpdateReminderUsecase(this._repository);

  Future<void> call(Reminder reminder) async {
    await _repository.updateReminder(reminder);
  }
}
