import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_hospital/features/auth/presentation/screens/home_screen.dart';
import 'package:proyecto_hospital/features/reminders/presentation/providers/reminder_provider.dart';

import 'core/di/injection.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/caregivers/presentation/providers/caregivers_provider.dart';
import 'features/chat/presentation/providers/chat_provider.dart';
import 'features/medications/presentation/providers/medication_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Firebase con las opciones de la plataforma
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Configurar la inyección de dependencias con GetIt/Injectable
  configureDependencies();

  // 3. Inicializar y solicitar permisos para notificaciones antes de cargar la app
  await NotificationService().initAndRequestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: getIt<AuthProvider>()),
        ChangeNotifierProvider.value(value: getIt<MedicationProvider>()),
        ChangeNotifierProvider.value(value: getIt<ReminderProvider>()),
        ChangeNotifierProvider.value(value: getIt<CaregiversProvider>()),
        ChangeNotifierProvider.value(value: getIt<ChatProvider>()),
      ],
      child: MaterialApp(
        title: 'Vitali',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        // 4. El AuthGate decide la pantalla inicial según el estado de sesión
        home: const AuthGate(),
      ),
    );
  }
}

/// Decide qué pantalla mostrar según el estado de sesión del usuario.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Escucha el estado del AuthProvider inyectado globalmente
    final authProvider = context.watch<AuthProvider>();

    switch (authProvider.status) {
      case AuthStatus.unknown:
        // Carga inicial mientras Firebase verifica la sesión (evita parpadeos)
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      case AuthStatus.unauthenticated:
        // Si no hay sesión, muestra el LoginScreen
        return const LoginScreen();

      case AuthStatus.authenticated:
        // Si la sesión está activa, redirige a la vista principal
        final String userId = authProvider.currentUser?.uid ?? '';
        return HomeScreen(userId: userId);
    }
  }
}
