import 'package:flutter/material.dart';

// TODO: MIGRACION_PLANTILLAS — Reconstruir esta pantalla en el punto 5 del plan.
//
// La pantalla original mostraba la previsualización de una plantilla y de una
// actividad asumiendo un modelo común con campo `words`. Con el nuevo sistema
// sealed cada subtipo expone un contenido distinto (items de fonemas, praxias,
// bloques de comprensión, items de vocabulario, pasos de secuencia o items
// libres del tipo personalizado), por lo que esta pantalla pasará a ser una
// previsualización polimórfica capaz de renderizar cada tipo correctamente.
//
// Mientras tanto, esta versión placeholder permite que la aplicación compile
// sin necesidad de mantener código antiguo incompatible con el nuevo modelo.
class TemplatePreviewPage extends StatelessWidget {
  const TemplatePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsualización de plantilla (en migración)'),
      ),
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
