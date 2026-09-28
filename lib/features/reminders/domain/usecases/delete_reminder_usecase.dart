import 'package:injectable/injectable.dart';
import '../repositories/reminder_repository.dart';

@lazySingleton
class DeleteReminder {
  final ReminderRepository _repository;

  DeleteReminder(this._repository);

  Future<void> call(String reminderId) async {
    return await _repository.deleteReminder(reminderId);
  }
}
