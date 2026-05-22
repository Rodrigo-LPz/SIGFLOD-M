import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/app_user_model.dart';

// Gestiona las operaciones de lectura y escritura del perfil en Firestore.
class UserFirestoreRepository {
  // Constructor privado — patrón Singleton.
  UserFirestoreRepository._();

  // Expone la instancia global reutilizable.
  static final UserFirestoreRepository instance = UserFirestoreRepository._();

  // Almacena la referencia a la colección de usuarios en Firestore.
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'users',
  );

  // Recupera el perfil del usuario por su UID de Firebase Authentication.
  Future<AppUserModel?> getByUid(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return AppUserModel.fromMap(uid, doc.data() as Map<String, dynamic>);
  }

  // Crea el perfil de un nuevo usuario familiar tras registrarse.
  Future<void> createFamiliar({
    required String uid,
    required String email,
    required String displayName,
    required String linkedPatientId,
  }) async {
    final user = AppUserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      role: UserRole.familiar,
      linkedPatientIds: [linkedPatientId],
    );

    await _collection.doc(uid).set(user.toMap());
  }

  // Añade un paciente más a la lista de vinculaciones del usuario familiar.
  Future<void> linkAdditionalPatient({
    required String uid,
    required String linkedPatientId,
  }) async {
    await _collection.doc(uid).update({
      'linkedPatientIds': FieldValue.arrayUnion([linkedPatientId]),
    });
  }
}
