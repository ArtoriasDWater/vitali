//Imports de paquetes de flutter
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

//Imports de archivos locales
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_role.dart';

//Estado de la pantalla para saber que mostrar
enum AuthStatus {
  //Todavia no llego nada a Firebase
  unknown,
  //Hay un usuario con sesion activa
  authenticated,
  //No hay sesion (Salio o nunca inicio)
  unauthenticated,
}

@lazySingleton
class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository) {
    _authRepository.authStateChanges.listen(_onAuthStateChange);
  }

  //Variables de la clase
  AuthStatus status = AuthStatus.unknown;
  AppUser? currentUser;
  bool isLoading = false;
  String? errorMessage;
  UserRole? _selectedRole = UserRole.paciente;
  UserRole? get selectedRole => _selectedRole;

  //Metodos Privados
  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<bool> _run(Future<AppUser> Function() action) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on AppException catch (e) {
      errorMessage = e.message;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _onAuthStateChange(AppUser? user) {
    currentUser = user;
    status = user == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;

    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String username,
    required String role,
  }) => _run(
    () => _authRepository.register(
      email: email,
      password: password,
      username: username,
      role: role,
    ),
  );

  Future<bool> signInWithEmailAndPassword(String email, String password) =>
      _run(
        () => _authRepository.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      );

  Future<bool> signInWithGoogle() => _run(_authRepository.signInWithGoogle);

  Future<void> logOut() => _authRepository.logOut();
}
