import 'package:flutter/material.dart';

// TODO: MIGRACION_PLANTILLAS — Reconstruir esta pantalla en el punto 5 del plan.
//
// La pantalla original gestionaba los ajustes finales comunes a todas las
// plantillas (repeticiones, tiempo límite, modo guiado, sonidos, feedback,
// refuerzo positivo). Con el nuevo sistema sealed cada subtipo tiene su
// propio conjunto de ajustes específico, por lo que esta pantalla pasará a
// integrarse dentro del wizard especializado de cada tipo de plantilla.
//
// Mientras tanto, esta versión placeholder permite que la aplicación compile
// sin necesidad de mantener código antiguo incompatible con el nuevo modelo.
class TemplateSettingsPage extends StatelessWidget {
  const TemplateSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes de plantilla (en migración)')),
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
