import 'package:firebase_auth/firebase_auth.dart';

// Centraliza todas las operaciones de autenticación con Firebase.
class AuthService {
  // Constructor privado — patrón Singleton.
  AuthService._();

  // Expone la instancia global reutilizable.
  static final AuthService instance = AuthService._();

  // Almacena la referencia directa a FirebaseAuth.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Devuelve el usuario actualmente autenticado (null si no hay sesión).
  User? get currentUser => _auth.currentUser;

  // Emite cambios de sesión en tiempo real.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Inicia sesión con correo electrónico y contraseña.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Crea una cuenta nueva con correo electrónico y contraseña.
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Envía un correo de verificación al usuario actualmente autenticado.
  Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // Recarga los datos del usuario para refrescar el estado de verificación.
  Future<void> reloadCurrentUser() async {
    await _auth.currentUser?.reload();
  }

  // Cierra la sesión del usuario actual.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
