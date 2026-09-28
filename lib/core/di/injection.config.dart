// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/provider/auth_provider.dart' as _i840;
import '../../features/caregivers/data/datasources/caregivers_remote_data_source.dart'
    as _i356;
import '../../features/caregivers/data/datasources/caregivers_remote_data_source_impl.dart'
    as _i332;
import '../../features/caregivers/data/repositories/caregivers_repository_impl.dart'
    as _i938;
import '../../features/caregivers/domain/repositories/caregivers_repository.dart'
    as _i620;
import '../../features/caregivers/domain/usecases/delete_caregivers_usecase.dart'
    as _i195;
import '../../features/caregivers/domain/usecases/get_caregivers_by_id_usecase.dart'
    as _i1057;
import '../../features/caregivers/domain/usecases/get_caregivers_by_user_usecase.dart'
    as _i785;
import '../../features/caregivers/domain/usecases/save_caregivers_usecase.dart'
    as _i63;
import '../../features/caregivers/domain/usecases/update_caregivers_usecase.dart'
    as _i358;
import '../../features/caregivers/presentation/providers/caregivers_provider.dart'
    as _i27;
import '../../features/chat/data/repositories/chat_repository_impl.dart'
    as _i504;
import '../../features/chat/domain/repositories/chat_repository.dart' as _i420;
import '../../features/chat/domain/usecases/ask_medication_question_usecase.dart'
    as _i163;
import '../../features/chat/presentation/providers/chat_provider.dart' as _i457;
import '../../features/medications/data/datasources/medications_remote_data_source.dart'
    as _i92;
import '../../features/medications/data/datasources/medications_remote_data_source_impl.dart'
    as _i215;
import '../../features/medications/data/datasources/recipe_ocr_data_source.dart'
    as _i158;
import '../../features/medications/data/datasources/recipe_ocr_data_source_impl.dart'
    as _i224;
import '../../features/medications/data/repositories/medications_repository_impl.dart'
    as _i83;
import '../../features/medications/domain/repositories/medication_repository.dart'
    as _i961;
import '../../features/medications/domain/usecases/add_medication_usecase.dart'
    as _i855;
import '../../features/medications/domain/usecases/delete_medication_usecase.dart'
    as _i707;
import '../../features/medications/domain/usecases/get_medication_by_id_usecase.dart'
    as _i51;
import '../../features/medications/domain/usecases/get_patient_medication_usecase.dart'
    as _i108;
import '../../features/medications/domain/usecases/scan_recipe_ocr_usecase.dart'
    as _i1005;
import '../../features/medications/domain/usecases/update_medication_usecase.dart'
    as _i313;
import '../../features/medications/presentation/providers/medication_provider.dart'
    as _i864;
import '../../features/reminders/data/datasources/reminder_remote_data_source.dart'
    as _i194;
import '../../features/reminders/data/datasources/reminder_remote_data_source_impl.dart'
    as _i968;
import '../../features/reminders/data/repositories/reminder_repository_impl.dart'
    as _i946;
import '../../features/reminders/domain/repositories/reminder_repository.dart'
    as _i488;
import '../../features/reminders/domain/usecases/delete_reminder_usecase.dart'
    as _i690;
import '../../features/reminders/domain/usecases/get_reminders_usecase.dart'
    as _i700;
import '../../features/reminders/domain/usecases/mark_reminder_as_taken.dart'
    as _i219;
import '../../features/reminders/domain/usecases/save_reminder_usecase.dart'
    as _i66;
import '../../features/reminders/domain/usecases/update_reminder_usecase.dart'
    as _i983;
import '../../features/reminders/presentation/providers/reminder_provider.dart'
    as _i416;
import '../services/notification_service.dart' as _i941;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
      () => registerModule.firebaseFirestore,
    );
    gh.lazySingleton<_i941.NotificationService>(
      () => registerModule.notificationService,
    );
    gh.lazySingleton<_i420.ChatRepository>(() => _i504.ChatRepositoryImpl());
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        firestore: gh<_i974.FirebaseFirestore>(),
      ),
    );
    gh.lazySingleton<_i158.RecipeOcrDataSource>(
      () => _i224.RecipeOcrDataSourceImpl(),
    );
    gh.lazySingleton<_i194.ReminderRemoteDataSource>(
      () => _i968.ReminderRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i356.CaregiversRemoteDataSource>(
      () => _i332.CaregiversRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i840.AuthProvider>(
      () => _i840.AuthProvider(gh<_i787.AuthRepository>()),
    );
    gh.lazySingleton<_i488.ReminderRepository>(
      () => _i946.ReminderRepositoryImpl(gh<_i194.ReminderRemoteDataSource>()),
    );
    gh.lazySingleton<_i92.MedicationsRemoteDataSource>(
      () =>
          _i215.MedicationsRemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i690.DeleteReminder>(
      () => _i690.DeleteReminder(gh<_i488.ReminderRepository>()),
    );
    gh.lazySingleton<_i700.GetRemindersUsecase>(
      () => _i700.GetRemindersUsecase(gh<_i488.ReminderRepository>()),
    );
    gh.lazySingleton<_i219.MarkReminderAsTaken>(
      () => _i219.MarkReminderAsTaken(gh<_i488.ReminderRepository>()),
    );
    gh.lazySingleton<_i66.SaveReminder>(
      () => _i66.SaveReminder(gh<_i488.ReminderRepository>()),
    );
    gh.lazySingleton<_i983.UpdateReminderUsecase>(
      () => _i983.UpdateReminderUsecase(gh<_i488.ReminderRepository>()),
    );
    gh.lazySingleton<_i163.AskMedicationQuestionUseCase>(
      () => _i163.AskMedicationQuestionUseCase(gh<_i420.ChatRepository>()),
    );
    gh.lazySingleton<_i416.ReminderProvider>(
      () => _i416.ReminderProvider(
        gh<_i700.GetRemindersUsecase>(),
        gh<_i66.SaveReminder>(),
        gh<_i983.UpdateReminderUsecase>(),
        gh<_i690.DeleteReminder>(),
        gh<_i219.MarkReminderAsTaken>(),
        gh<_i941.NotificationService>(),
      ),
    );
    gh.lazySingleton<_i620.CaregiversRepository>(
      () => _i938.CaregiversRepositoryImpl(
        gh<_i356.CaregiversRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i961.MedicationRepository>(
      () => _i83.MedicationsRepositoryImpl(
        gh<_i92.MedicationsRemoteDataSource>(),
        gh<_i158.RecipeOcrDataSource>(),
      ),
    );
    gh.lazySingleton<_i457.ChatProvider>(
      () => _i457.ChatProvider(gh<_i163.AskMedicationQuestionUseCase>()),
    );
    gh.lazySingleton<_i855.AddMedicationUseCase>(
      () => _i855.AddMedicationUseCase(gh<_i961.MedicationRepository>()),
    );
    gh.lazySingleton<_i707.DeleteMedicationUsecase>(
      () => _i707.DeleteMedicationUsecase(gh<_i961.MedicationRepository>()),
    );
    gh.lazySingleton<_i51.GetPatientMedicationsUseCase>(
      () => _i51.GetPatientMedicationsUseCase(gh<_i961.MedicationRepository>()),
    );
    gh.lazySingleton<_i108.GetPatientMedicationsUseCase>(
      () =>
          _i108.GetPatientMedicationsUseCase(gh<_i961.MedicationRepository>()),
    );
    gh.lazySingleton<_i1005.ScanRecipeOcrUseCase>(
      () => _i1005.ScanRecipeOcrUseCase(gh<_i961.MedicationRepository>()),
    );
    gh.lazySingleton<_i313.UpdateMedicationUsecase>(
      () => _i313.UpdateMedicationUsecase(gh<_i961.MedicationRepository>()),
    );
    gh.lazySingleton<_i864.MedicationProvider>(
      () => _i864.MedicationProvider(
        gh<_i855.AddMedicationUseCase>(),
        gh<_i51.GetPatientMedicationsUseCase>(),
        gh<_i313.UpdateMedicationUsecase>(),
        gh<_i707.DeleteMedicationUsecase>(),
        gh<_i1005.ScanRecipeOcrUseCase>(),
      ),
    );
    gh.lazySingleton<_i195.DeleteCaregiversUsecase>(
      () => _i195.DeleteCaregiversUsecase(gh<_i620.CaregiversRepository>()),
    );
    gh.lazySingleton<_i1057.GetCaregiversByIdUsecase>(
      () => _i1057.GetCaregiversByIdUsecase(gh<_i620.CaregiversRepository>()),
    );
    gh.lazySingleton<_i785.GetCaregiversByUserUsecase>(
      () => _i785.GetCaregiversByUserUsecase(gh<_i620.CaregiversRepository>()),
    );
    gh.lazySingleton<_i63.SaveCaregiversUsecase>(
      () => _i63.SaveCaregiversUsecase(gh<_i620.CaregiversRepository>()),
    );
    gh.lazySingleton<_i358.UpdateCaregiversUsecase>(
      () => _i358.UpdateCaregiversUsecase(gh<_i620.CaregiversRepository>()),
    );
    gh.lazySingleton<_i27.CaregiversProvider>(
      () => _i27.CaregiversProvider(
        gh<_i785.GetCaregiversByUserUsecase>(),
        gh<_i63.SaveCaregiversUsecase>(),
        gh<_i358.UpdateCaregiversUsecase>(),
        gh<_i195.DeleteCaregiversUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
