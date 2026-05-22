import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/invitation_model.dart';

// Gestiona todas las operaciones de invitaciones contra Firestore.
class InvitationFirestoreRepository {
  // Constructor privado — patrón Singleton.
  InvitationFirestoreRepository._();

  // Expone la instancia global reutilizable.
  static final InvitationFirestoreRepository instance =
      InvitationFirestoreRepository._();

  // Almacena la referencia a la colección de invitaciones en Firestore.
  final CollectionReference _collection = FirebaseFirestore.instance.collection(
    'invitations',
  );

  // Alfabeto utilizado para generar códigos legibles sin caracteres ambiguos.
  static const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  // Genera un código aleatorio en formato XXXX-XXXX evitando caracteres confusos.
  String _generateCode() {
    final random = Random.secure();
    String segment() => List.generate(
      4,
      (_) => _alphabet[random.nextInt(_alphabet.length)],
    ).join();
    return '${segment()}-${segment()}';
  }

  // Crea una nueva invitación vinculada al paciente y al logopeda indicados.
  Future<InvitationModel> createInvitation({
    required String patientId,
    required String createdByUid,
  }) async {
    // Reintenta hasta encontrar un código único en la colección.
    String code = _generateCode();
    while ((await _collection.doc(code).get()).exists) {
      code = _generateCode();
    }

    final invitation = InvitationModel(
      code: code,
      patientId: patientId,
      createdByUid: createdByUid,
      createdAt: DateTime.now(),
    );

    await _collection.doc(code).set(invitation.toMap());
    return invitation;
  }

  // Recupera una invitación a partir de su código.
  Future<InvitationModel?> findByCode(String code) async {
    final doc = await _collection.doc(code).get();
    if (!doc.exists) return null;
    return InvitationModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  // Elimina una invitación tras ser canjeada para impedir su reutilización.
  Future<void> consumeInvitation(String code) async {
    await _collection.doc(code).delete();
  }
}
