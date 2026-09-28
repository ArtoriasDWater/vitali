import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_hospital/core/error/app_exception.dart';
import 'package:proyecto_hospital/features/medications/domain/entities/medication.dart';
import 'package:proyecto_hospital/features/medications/domain/repositories/medication_repository.dart';
import 'package:proyecto_hospital/features/medications/domain/usecases/add_medication_usecase.dart';
import 'package:proyecto_hospital/features/medications/domain/usecases/update_medication_usecase.dart';
import 'package:proyecto_hospital/features/reminders/domain/entities/reminder.dart';
import 'package:proyecto_hospital/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:proyecto_hospital/features/reminders/domain/usecases/mark_reminder_as_taken.dart';

class _FakeMedicationRepository implements MedicationRepository {
  bool wasCalled = false;
  Medication? savedMedication;

  @override
  Future<void> addMedication(Medication medication) async {
    wasCalled = true;
    savedMedication = medication;
  }

  @override
  Future<void> deleteMedication(String id) async {}

  @override
  Future<Medication> getMedicationById(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Medication>> getMedicationsByUserId(String userId) async {
    return const [];
  }

  @override
  Future<Medication> scanRecipeFromImage(File imageFile, String userId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    wasCalled = true;
    savedMedication = medication;
  }
}

class _FakeReminderRepository implements ReminderRepository {
  String? markedId;
  bool? markedValue;

  @override
  Future<void> deleteReminder(String reminderId) async {}

  @override
  Future<List<Reminder>> getReminders(String userId) async {
    return const [];
  }

  @override
  Future<void> markAsTaken(String reminderId, bool isTaken) async {
    markedId = reminderId;
    markedValue = isTaken;
  }

  @override
  Future<void> saveReminder(Reminder reminder) async {}

  @override
  Future<void> updateReminder(Reminder reminder) async {}
}

void main() {
  group('AddMedicationUseCase', () {
    test('permite guardar un medicamento con datos válidos', () async {
      final repository = _FakeMedicationRepository();
      final useCase = AddMedicationUseCase(repository);

      final medication = Medication(
        uid: 'med-1',
        name: 'Losartan',
        numberOfPills: 1,
        frequency: 'Cada 12 horas',
        observations: 'Tomar con agua',
        userId: 'user-1',
      );

      await useCase(medication);

      expect(repository.wasCalled, isTrue);
      expect(repository.savedMedication, equals(medication));
    });

    test('lanza una AppException si el nombre está vacío', () async {
      final repository = _FakeMedicationRepository();
      final useCase = AddMedicationUseCase(repository);

      final medication = Medication(
        uid: 'med-2',
        name: '   ',
        numberOfPills: 1,
        frequency: 'Diario',
        observations: '',
        userId: 'user-1',
      );

      expect(() => useCase(medication), throwsA(isA<AppException>()));
    });

    test('lanza una AppException si la cantidad es cero', () async {
      final repository = _FakeMedicationRepository();
      final useCase = AddMedicationUseCase(repository);

      final medication = Medication(
        uid: 'med-3',
        name: 'Ibuprofeno',
        numberOfPills: 0,
        frequency: 'Cada 8 horas',
        observations: '',
        userId: 'user-1',
      );

      expect(() => useCase(medication), throwsA(isA<AppException>()));
    });
  });

  group('UpdateMedicationUsecase', () {
    test('actualiza un medicamento válido', () async {
      final repository = _FakeMedicationRepository();
      final useCase = UpdateMedicationUsecase(repository);

      final medication = Medication(
        uid: 'med-4',
        name: 'Metformina',
        numberOfPills: 2,
        frequency: 'Cada 24 horas',
        observations: 'Desayuno',
        userId: 'user-1',
      );

      await useCase(medication);

      expect(repository.wasCalled, isTrue);
      expect(repository.savedMedication, equals(medication));
    });

    test('rechaza una frecuencia vacía', () async {
      final repository = _FakeMedicationRepository();
      final useCase = UpdateMedicationUsecase(repository);

      final medication = Medication(
        uid: 'med-5',
        name: 'Amlodipino',
        numberOfPills: 1,
        frequency: '   ',
        observations: '',
        userId: 'user-1',
      );

      expect(() => useCase(medication), throwsA(isA<AppException>()));
    });
  });

  group('MarkReminderAsTaken', () {
    test('envía el estado correcto al repositorio', () async {
      final repository = _FakeReminderRepository();
      final useCase = MarkReminderAsTaken(repository);

      await useCase('reminder-1', true);

      expect(repository.markedId, 'reminder-1');
      expect(repository.markedValue, isTrue);
    });
  });
}
