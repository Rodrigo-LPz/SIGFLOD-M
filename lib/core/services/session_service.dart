import 'package:flutter/foundation.dart';
import '../../features/auth/domain/models/app_user_model.dart';

// Mantiene el usuario actualmente autenticado y su rol accesibles globalmente.
class SessionService {
  // Constructor privado — patrón Singleton.
  SessionService._();

  // Expone la instancia global reutilizable.
  static final SessionService instance = SessionService._();

  // Mantiene el usuario actual observable para reaccionar a cambios de sesión.
  final ValueNotifier<AppUserModel?> currentUser = ValueNotifier<AppUserModel?>(
    null,
  );

  // Establece el usuario activo tras un inicio de sesión válido.
  void setUser(AppUserModel user) {
    currentUser.value = user;
  }

  // Limpia el usuario activo al cerrar sesión.
  void clearUser() {
    currentUser.value = null;
  }

  // Atajo para comprobar si el usuario actual tiene permisos de escritura.
  bool get canWrite => currentUser.value?.canWrite ?? false;

  // Atajo para comprobar si el usuario actual es de solo lectura.
  bool get isReadOnly => currentUser.value?.isReadOnly ?? false;
}
