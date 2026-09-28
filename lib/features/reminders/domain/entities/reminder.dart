class Reminder {
  final String uid;
  final String reminderName;
  final String userId;
  final String medicationId;
  final DateTime startHour;
  final bool taken;

  const Reminder({
    required this.uid,
    required this.reminderName,
    required this.userId,
    required this.medicationId,
    required this.startHour,
    required this.taken,
  });
}
