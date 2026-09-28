import 'package:injectable/injectable.dart';
import '../repositories/reminder_repository.dart';

@lazySingleton
class MarkReminderAsTaken {
  final ReminderRepository _repository;

  MarkReminderAsTaken(this._repository);

  Future<void> call(String reminderId, bool isTaken) async {
    return await _repository.markAsTaken(reminderId, isTaken);
  }
}
