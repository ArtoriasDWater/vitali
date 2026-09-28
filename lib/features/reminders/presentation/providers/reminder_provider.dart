import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/delete_reminder_usecase.dart';
import '../../domain/usecases/get_reminders_usecase.dart';
import '../../domain/usecases/mark_reminder_as_taken.dart';
import '../../domain/usecases/save_reminder_usecase.dart';
import '../../domain/usecases/update_reminder_usecase.dart';

@lazySingleton
class ReminderProvider extends ChangeNotifier {
  final GetRemindersUsecase _getReminders;
  final SaveReminder _saveReminder;
  final UpdateReminderUsecase _updateReminder;
  final DeleteReminder _deleteReminder;
  final MarkReminderAsTaken _markReminderAsTaken;
  final NotificationService _notificationService;

  ReminderProvider(
    this._getReminders,
    this._saveReminder,
    this._updateReminder,
    this._deleteReminder,
    this._markReminderAsTaken,
    this._notificationService,
  );

  List<Reminder> _reminders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Reminder> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getReminders(String userId) async {
    _setLoading(true);

    try {
      _reminders = await _getReminders(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _safeScheduleReminderNotification(Reminder reminder) async {
    try {
      final now = DateTime.now();
      if (reminder.startHour.isAfter(now)) {
        final notificationId = reminder.uid.hashCode == 0
            ? reminder.reminderName.hashCode
            : reminder.uid.hashCode;

        await _notificationService.scheduleNotification(
          id: notificationId,
          title: 'Recordatorio: ${reminder.reminderName}',
          body: 'Es hora de tomar tu medicamento.',
          scheduledDate: reminder.startHour,
        );
      }
    } catch (e) {
      debugPrint('No se pudo programar la notificación: $e');
    }
  }

  Future<void> _safeCancelReminderNotification(String uid) async {
    try {
      final notificationId = uid.isEmpty ? 0 : uid.hashCode;
      await _notificationService.cancelNotification(notificationId);
    } catch (e) {
      debugPrint('No se pudo cancelar la notificación: $e');
    }
  }

  Future<bool> save(Reminder reminder, String userId) async {
    _setLoading(true);
    try {
      await _saveReminder(reminder);
      await _safeScheduleReminderNotification(reminder);
      await getReminders(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(Reminder reminder, String userId) async {
    _setLoading(true);
    try {
      await _updateReminder(reminder);
      await _safeCancelReminderNotification(reminder.uid);
      await _safeScheduleReminderNotification(reminder);
      await getReminders(userId);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> delete(String uid, String userId) async {
    _setLoading(true);
    try {
      await _deleteReminder(uid);
      await _safeCancelReminderNotification(uid);
      await getReminders(userId);
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaken(String uid, bool taken, String userId) async {
    try {
      await _markReminderAsTaken(uid, taken);
      await getReminders(userId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
