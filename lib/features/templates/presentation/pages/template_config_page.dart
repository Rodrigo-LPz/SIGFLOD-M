import 'package:flutter/material.dart';

// TODO: MIGRACION_PLANTILLAS — Reconstruir esta pantalla en el punto 5 del plan.
//
// La pantalla original gestionaba la configuración básica común a todas las
// plantillas (nombre, objetivo, edad recomendada, nivel y observaciones) y
// preparaba el modelo genérico para el siguiente paso del wizard. Con el
// nuevo sistema sealed cada subtipo necesita su propia secuencia de pantallas
// especializadas, por lo que esta pantalla pasará a ser el punto de entrada
// que delegue en el wizard correspondiente al tipo elegido por el logopeda.
//
// Mientras tanto, esta versión placeholder permite que la aplicación compile
// sin necesidad de mantener código antiguo incompatible con el nuevo modelo.
class TemplateConfigPage extends StatelessWidget {
  const TemplateConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de plantilla (en migración)'),
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
