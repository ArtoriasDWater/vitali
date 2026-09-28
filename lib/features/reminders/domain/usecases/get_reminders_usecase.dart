import 'package:injectable/injectable.dart';
import '../entities/reminder.dart';
import '../repositories/reminder_repository.dart';

@lazySingleton
class GetRemindersUsecase {
  final ReminderRepository _repository;

  GetRemindersUsecase(this._repository);

  Future<List<Reminder>> call(String userId) async {
    return await _repository.getReminders(userId);
  }
}
