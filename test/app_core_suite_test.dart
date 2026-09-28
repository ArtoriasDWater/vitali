import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_hospital/core/error/app_exception.dart';
import 'package:proyecto_hospital/features/auth/domain/entities/app_user.dart';
import 'package:proyecto_hospital/features/auth/domain/entities/user_role.dart';
import 'package:proyecto_hospital/features/auth/domain/repositories/auth_repository.dart';
import 'package:proyecto_hospital/features/auth/presentation/provider/auth_provider.dart';
import 'package:proyecto_hospital/features/caregivers/domain/entities/caregivers.dart';
import 'package:proyecto_hospital/features/caregivers/domain/repositories/caregivers_repository.dart';
import 'package:proyecto_hospital/features/caregivers/domain/usecases/delete_caregivers_usecase.dart'
    as caregiver_delete;
import 'package:proyecto_hospital/features/caregivers/domain/usecases/get_caregivers_by_user_usecase.dart';
import 'package:proyecto_hospital/features/caregivers/domain/usecases/save_caregivers_usecase.dart';
import 'package:proyecto_hospital/features/caregivers/domain/usecases/update_caregivers_usecase.dart'
    as caregiver_update;
import 'package:proyecto_hospital/features/caregivers/presentation/providers/caregivers_provider.dart';
import 'package:proyecto_hospital/features/chat/domain/repositories/chat_repository.dart';
import 'package:proyecto_hospital/features/chat/domain/usecases/ask_medication_question_usecase.dart';
import 'package:proyecto_hospital/features/chat/presentation/providers/chat_provider.dart';
import 'package:proyecto_hospital/features/medications/domain/entities/medication.dart';
import 'package:proyecto_hospital/features/medications/domain/repositories/medication_repository.dart';
import 'package:proyecto_hospital/features/medications/domain/usecases/add_medication_usecase.dart';
import 'package:proyecto_hospital/features/medications/domain/usecases/delete_medication_usecase.dart';
import 'package:proyecto_hospital/features/medications/domain/usecases/get_medication_by_id_usecase.dart'
    as medication_by_id;
import 'package:proyecto_hospital/features/medications/domain/usecases/get_patient_medication_usecase.dart'
    as medication_list;
import 'package:proyecto_hospital/features/medications/domain/usecases/scan_recipe_ocr_usecase.dart';
import 'package:proyecto_hospital/features/medications/domain/usecases/update_medication_usecase.dart';
import 'package:proyecto_hospital/features/medications/presentation/providers/medication_provider.dart';
import 'package:proyecto_hospital/features/reminders/domain/entities/reminder.dart';
import 'package:proyecto_hospital/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:proyecto_hospital/features/reminders/domain/usecases/mark_reminder_as_taken.dart';

class _FakeAuthRepository implements AuthRepository {
  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();
  AppUser? currentUserValue;

  void emit(AppUser? user) => _controller.add(user);

  @override
  Stream<AppUser?> get authStateChanges => _controller.stream;

  @override
  AppUser? get currentUser => currentUserValue;

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    if (email.contains('error')) {
      throw const AppException('No se pudo registrar el usuario.');
    }
    final user = AppUser(
      uid: 'new-user',
      email: email,
      username: username,
      role: UserRole.paciente,
    );
    currentUserValue = user;
    emit(user);
    return user;
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.contains('error')) {
      throw const AppException('Credenciales inválidas.');
    }
    final user = AppUser(
      uid: 'user-1',
      email: email,
      username: 'Test',
      role: UserRole.paciente,
    );
    currentUserValue = user;
    emit(user);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    final user = AppUser(
      uid: 'google-user',
      email: 'google@test.com',
      username: 'Google',
      role: UserRole.paciente,
    );
    currentUserValue = user;
    emit(user);
    return user;
  }

  @override
  Future<void> logOut() async {
    currentUserValue = null;
    emit(null);
  }
}

class _FakeMedicationRepository implements MedicationRepository {
  List<Medication> medicationList = [];
  Medication? scannedMedication;
  bool saveCalled = false;
  bool updateCalled = false;
  bool deleteCalled = false;

  @override
  Future<List<Medication>> getMedicationsByUserId(String userId) async {
    if (userId.trim().isEmpty) {
      throw const AppException('El ID de usuario no es válido.');
    }
    return medicationList;
  }

  @override
  Future<Medication> getMedicationById(String id) async {
    final med = medicationList.firstWhere(
      (m) => m.uid == id,
      orElse: () =>
          throw const AppException('El medicamento solicitado no existe.'),
    );
    return med;
  }

  @override
  Future<void> addMedication(Medication medication) async {
    saveCalled = true;
    medicationList.add(medication);
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    updateCalled = true;
    final index = medicationList.indexWhere((m) => m.uid == medication.uid);
    if (index >= 0) {
      medicationList[index] = medication;
    }
  }

  @override
  Future<void> deleteMedication(String id) async {
    deleteCalled = true;
    medicationList.removeWhere((m) => m.uid == id);
  }

  @override
  Future<Medication> scanRecipeFromImage(File imageFile, String userId) async {
    if (userId.trim().isEmpty) {
      throw const AppException('El ID de usuario no es válido.');
    }
    final med = Medication(
      uid: 'ocr-1',
      name: 'Aspirina',
      numberOfPills: 1,
      frequency: 'Diario',
      observations: 'OCR',
      userId: userId,
    );
    scannedMedication = med;
    return med;
  }
}

class _FakeCaregiversRepository implements CaregiversRepository {
  List<Caregiver> caregivers = [];

  @override
  Future<List<Caregiver>> getCaregiversByUser(String userId) async {
    return caregivers.where((c) => c.userId == userId).toList();
  }

  @override
  Future<Caregiver> getCaregiversById(String id) async {
    return caregivers.firstWhere((c) => c.uid == id);
  }

  @override
  Future<void> saveCaregivers(Caregiver caregiver) async {
    caregivers.add(caregiver);
  }

  @override
  Future<void> updateCaregivers(Caregiver caregiver) async {
    final index = caregivers.indexWhere((c) => c.uid == caregiver.uid);
    if (index >= 0) {
      caregivers[index] = caregiver;
    }
  }

  @override
  Future<void> deleteCaregivers(String id) async {
    caregivers.removeWhere((c) => c.uid == id);
  }
}

class _FakeChatRepository implements ChatRepository {
  String? lastQuestion;
  List<String>? lastMedicationNames;
  String? lastUserId;

  @override
  Future<String> askMedicationQuestion(
    String question, {
    List<String>? medicationNames,
    String? userId,
  }) async {
    lastQuestion = question;
    lastMedicationNames = medicationNames;
    lastUserId = userId;
    return 'Respuesta de prueba para: $question';
  }
}

void main() {
  group('GetPatientMedicationsUseCase', () {
    test('devuelve la lista cuando el usuario es válido', () async {
      final repository = _FakeMedicationRepository();
      final medication = Medication(
        uid: 'm1',
        name: 'Losartan',
        numberOfPills: 1,
        frequency: 'Cada 12h',
        observations: '',
        userId: 'user-1',
      );
      repository.medicationList.add(medication);

      final useCase = medication_list.GetPatientMedicationsUseCase(repository);
      final result = await useCase('user-1');

      expect(result, hasLength(1));
      expect(result.first.name, 'Losartan');
    });

    test('lanza AppException con userId vacío', () {
      final repository = _FakeMedicationRepository();
      final useCase = medication_list.GetPatientMedicationsUseCase(repository);

      expect(() => useCase('   '), throwsA(isA<AppException>()));
    });
  });

  group('DeleteMedicationUsecase', () {
    test('cuenta como válido un identificador no vacío', () async {
      final repository = _FakeMedicationRepository();
      final useCase = DeleteMedicationUsecase(repository);

      await useCase('med-1');

      expect(repository.deleteCalled, isTrue);
    });

    test('rechaza IDs vacíos', () {
      final repository = _FakeMedicationRepository();
      final useCase = DeleteMedicationUsecase(repository);

      expect(() => useCase('   '), throwsA(isA<AppException>()));
    });
  });

  group('AuthProvider', () {
    test('cambia de estado a autenticado cuando llega un usuario', () async {
      final repository = _FakeAuthRepository();
      final provider = AuthProvider(repository);

      final user = AppUser(
        uid: 'u1',
        email: 'test@test.com',
        username: 'Ana',
        role: UserRole.paciente,
      );
      repository.emit(user);
      await Future<void>.delayed(Duration.zero);

      expect(provider.status, AuthStatus.authenticated);
      expect(provider.currentUser, user);
    });

    test('setRole actualiza el rol seleccionado', () {
      final repository = _FakeAuthRepository();
      final provider = AuthProvider(repository);

      provider.setRole(UserRole.paciente);

      expect(provider.selectedRole, UserRole.paciente);
    });

    test('register devuelve false y guarda el mensaje cuando falla', () async {
      final repository = _FakeAuthRepository();
      final provider = AuthProvider(repository);

      final result = await provider.register(
        email: 'error@test.com',
        password: '123456',
        username: 'Error',
        role: 'paciente',
      );

      expect(result, isFalse);
      expect(provider.errorMessage, 'No se pudo registrar el usuario.');
    });
  });

  group('MedicationProvider', () {
    test('getMedications carga medicamentos del usuario', () async {
      final repository = _FakeMedicationRepository();
      final medication = Medication(
        uid: 'm2',
        name: 'Metformina',
        numberOfPills: 2,
        frequency: 'Cada 24h',
        observations: 'Almuerzo',
        userId: 'user-9',
      );
      repository.medicationList.add(medication);

      final provider = MedicationProvider(
        AddMedicationUseCase(repository),
        medication_by_id.GetPatientMedicationsUseCase(repository),
        UpdateMedicationUsecase(repository),
        DeleteMedicationUsecase(repository),
        ScanRecipeOcrUseCase(repository),
      );

      await provider.getMedications('user-9');

      expect(provider.medication, hasLength(1));
      expect(provider.medication.first.name, 'Metformina');
    });

    test('scanRecipe guarda el borrador temporal si OCR funciona', () async {
      final repository = _FakeMedicationRepository();
      final provider = MedicationProvider(
        AddMedicationUseCase(repository),
        medication_by_id.GetPatientMedicationsUseCase(repository),
        UpdateMedicationUsecase(repository),
        DeleteMedicationUsecase(repository),
        ScanRecipeOcrUseCase(repository),
      );

      final result = await provider.scanRecipe(
        File('test/assets/mock_recipe.png'),
        'user-1',
      );

      expect(result, isTrue);
      expect(provider.tempMedication, isNotNull);
      expect(provider.tempMedication!.name, 'Aspirina');
    });

    test('saveMedication devuelve false con error de dominio', () async {
      final repository = _FakeMedicationRepository();
      final provider = MedicationProvider(
        AddMedicationUseCase(repository),
        medication_by_id.GetPatientMedicationsUseCase(repository),
        UpdateMedicationUsecase(repository),
        DeleteMedicationUsecase(repository),
        ScanRecipeOcrUseCase(repository),
      );
      final medication = Medication(
        uid: 'm3',
        name: '  ',
        numberOfPills: 1,
        frequency: 'Diario',
        observations: '',
        userId: 'user-1',
      );

      final result = await provider.saveMedication(medication);

      expect(result, isFalse);
      expect(provider.errorMessage, contains('nombre del medicamento'));
    });
  });

  group('CaregiversProvider', () {
    test('saveCaregiver persiste y recarga la lista', () async {
      final repository = _FakeCaregiversRepository();
      final provider = CaregiversProvider(
        GetCaregiversByUserUsecase(repository),
        SaveCaregiversUsecase(repository),
        caregiver_update.UpdateCaregiversUsecase(repository),
        caregiver_delete.DeleteCaregiversUsecase(repository),
      );

      final caregiver = Caregiver(
        uid: 'c1',
        userId: 'user-1',
        name: 'María',
        email: 'maria@test.com',
        phone: '3001234567',
        relationship: 'Esposa',
      );

      final result = await provider.saveCaregiver(caregiver);

      expect(result, isTrue);
      expect(provider.caregivers, hasLength(1));
      expect(provider.caregivers.first.name, 'María');
    });
  });

  group('ChatProvider', () {
    test(
      'sendMessage crea el mensaje del usuario y la respuesta del asistente',
      () async {
        final repository = _FakeChatRepository();
        final provider = ChatProvider(AskMedicationQuestionUseCase(repository));

        await provider.sendMessage(
          '¿Cuánto tomar?',
          medicationNames: ['Losartan'],
          userId: 'user-1',
        );

        expect(provider.messages.length, greaterThan(2));
        expect(provider.messages.last.role, 'assistant');
        expect(provider.messages.last.text, contains('Respuesta de prueba'));
        expect(repository.lastQuestion, '¿Cuánto tomar?');
      },
    );

    test('sendMessage con pregunta vacía no agrega respuesta', () async {
      final repository = _FakeChatRepository();
      final provider = ChatProvider(AskMedicationQuestionUseCase(repository));
      final before = provider.messages.length;

      await provider.sendMessage('   ');

      expect(provider.messages.length, before);
    });
  });

  group('MarkReminderAsTaken', () {
    test('envía el estado correctamente al repositorio', () async {
      final repository = _FakeReminderRepository();
      final useCase = MarkReminderAsTaken(repository);

      await useCase('reminder-1', true);

      expect(repository.markedId, 'reminder-1');
      expect(repository.markedValue, isTrue);
    });
  });
}

class _FakeReminderRepository implements ReminderRepository {
  String? markedId;
  bool? markedValue;

  @override
  Future<void> deleteReminder(String reminderId) async {}

  @override
  Future<List<Reminder>> getReminders(String userId) async => const [];

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
