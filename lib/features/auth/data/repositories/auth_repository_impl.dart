//Importaciones de paquetes de terceros
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

//importaciones de paquetes locales
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final fb.FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  bool _googleSignInReady = false;

  AuthRepositoryImpl({required this.firebaseAuth, required this.firestore});

  //Metodos privados
  AppUser? _toAppUser(fb.User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      username: user.displayName ?? '',
    );
  }

  AppUser _requiredAppUser(fb.User? user) {
    final appUser = _toAppUser(user);
    if (appUser == null) {
      throw AppException('No pudimos obtener el usuario');
    }
    return appUser;
  }

  String _mensajeDeError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres';
      case 'user-not-found':
        return 'No se encontro el usuario';
      case 'wrong-password':
        return 'La contraseña es incorrecta';
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos';
      case 'invalid-email':
        return 'El correo electrónico no es válido';
      default:
        return 'No pudimos completar la operacion';
    }
  }

  Future<void> _ensureGoogleSignInReady() async {
    if (_googleSignInReady) return;
    await GoogleSignIn.instance.initialize();
    _googleSignInReady = true;
  }

  //Fin metodos privados

  @override
  Stream<AppUser?> get authStateChanges =>
      firebaseAuth.authStateChanges().map(_toAppUser);

  @override
  AppUser? get currentUser => _toAppUser(firebaseAuth.currentUser);

  @override
  Future<void> logOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser> register({
    required String email,
    required String password,
    required String username,
    required String role,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credential.user!.uid;

      await firestore.collection('users').doc(uid).set({
        'userName': username,
        'userEmail': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return _requiredAppUser(credential.user);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException(_mensajeDeError(e.code));
    }
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _requiredAppUser(credential.user);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException(_mensajeDeError(e.code));
    }
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    try {
      await _ensureGoogleSignInReady();

      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user == null) {
        throw const AppException('No pudimos iniciar sesion con Google');
      }

      final userDoc = firestore.collection('users').doc(user.uid);
      if (!(await userDoc.get()).exists) {
        await userDoc.set({
          'username': user.displayName ?? 'Usuario',
          'email': user.email ?? '',
          'role': 'paciente',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return _requiredAppUser(user);
    } on fb.FirebaseAuthException catch (e) {
      throw AppException(_mensajeDeError(e.code));
    } catch (_) {
      throw const AppException('Inicio de sesion con Google cancelado');
    }
  }
}
