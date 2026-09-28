import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/reminder.dart';

class ReminderModel extends Reminder {
  const ReminderModel({
    required super.uid,
    required super.reminderName,
    required super.userId,
    required super.medicationId,
    required super.startHour,
    required super.taken,
  });

  factory ReminderModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    return ReminderModel(
      // Asignar explícitamente el ID del documento
      uid: doc.id,
      medicationId: data['medicationId'] as String? ?? '',
      reminderName: data['reminderName'] as String? ?? '',
      // Parsear la fecha con salvaguarda por si viene en String ISO o Timestamp
      startHour: (data['startHour'] as Timestamp?)?.toDate() ?? DateTime.now(),
      taken: data['taken'] as bool? ?? false,
      userId: data['userId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminderName': reminderName,
      'userId': userId,
      'medicationId': medicationId,
      'startHour': Timestamp.fromDate(startHour),
      'taken': taken,
    };
  }

  Reminder toEntity() {
    return Reminder(
      uid: uid,
      reminderName: reminderName,
      userId: userId,
      medicationId: medicationId,
      startHour: startHour,
      taken: taken,
    );
  }

  factory ReminderModel.fromEntity(Reminder entity) {
    return ReminderModel(
      uid: entity.uid,
      userId: entity.userId,
      medicationId: entity.medicationId,
      reminderName: entity.reminderName,
      startHour: entity.startHour,
      taken: entity.taken,
    );
  }
}
