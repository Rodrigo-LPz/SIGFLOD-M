import 'package:flutter/material.dart';

// TODO: MIGRACION_PLANTILLAS — Reconstruir esta pantalla en el punto 5 del plan.
//
// La pantalla original gestionaba una lista de palabras común a todas las
// plantillas. Con el nuevo sistema sealed cada subtipo tiene su propio
// contenido (PhonemeItem, MotorPraxia, ComprehensionBlock, etc.), por lo que
// esta pantalla pasará a ser sustituida por seis pantallas especializadas,
// una por cada tipo de plantilla.
//
// Mientras tanto, esta versión placeholder permite que la aplicación compile
// sin necesidad de mantener código antiguo incompatible con el nuevo modelo.
class TemplateWordsPage extends StatelessWidget {
  const TemplateWordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plantillas (en migración)')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Esta pantalla está temporalmente deshabilitada mientras se '
            'completa la migración al nuevo sistema de plantillas '
            'especializadas por tipo.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
