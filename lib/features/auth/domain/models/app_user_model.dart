// Representa los roles posibles dentro del sistema SIGFLOD.
enum UserRole { logopeda, familiar, unknown }

// Modelo de dominio del usuario autenticado en la aplicación.
class AppUserModel {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;

  // Identificadores de los pacientes a los que el familiar está vinculado.
  final List<String> linkedPatientIds;

  const AppUserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.linkedPatientIds = const [],
  });

  // Determina si el usuario tiene permisos de escritura.
  bool get canWrite => role == UserRole.logopeda;

  // Determina si el usuario solo tiene permisos de lectura.
  bool get isReadOnly => role == UserRole.familiar;

  // Reconstruye el modelo desde un mapa de Firestore.
  factory AppUserModel.fromMap(String uid, Map<String, dynamic> map) {
    return AppUserModel(
      uid: uid,
      email: (map['email'] ?? '') as String,
      displayName: (map['displayName'] ?? '') as String,
      role: _parseRole(map['role'] as String?),
      linkedPatientIds: List<String>.from(map['linkedPatientIds'] ?? const []),
    );
  }

  // Convierte el modelo a un mapa apto para Firestore.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'linkedPatientIds': linkedPatientIds,
    };
  }

  // Traduce la cadena recibida de Firestore al enum correspondiente.
  static UserRole _parseRole(String? value) {
    switch (value) {
      case 'logopeda':
        return UserRole.logopeda;
      case 'familiar':
        return UserRole.familiar;
      default:
        return UserRole.unknown;
    }
  }
}
