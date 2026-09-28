// lib/core/utils/validators.dart
import '../../features/auth/domain/entities/user_role.dart';

class Validators {
  /// Valida que un campo de texto no esté vacío
  static String? requiredField(String? value, {String? customMessage}) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? 'Este campo es requerido';
    }
    return null;
  }

  /// Valida el formato de correo electrónico
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El correo es requerido';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  /// Valida la selección de un Enum (ej. UserRole)
  static String? requiredRole(UserRole? role) {
    if (role == null) {
      return 'Por favor seleccione un tipo de usuario';
    }
    return null;
  }

  /// Valida la contraseña con longitud mínima
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }
    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }
    return null;
  }
}
