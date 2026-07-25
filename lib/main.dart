import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'app/app.dart';
import 'firebase_options.dart';

void main() async {
  // Garantiza que los bindings de Flutter estén listos antes de inicializar Firebase.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con la configuración generada por FlutterFire CLI.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inicializa media_kit registrando sus bindings nativos en cada plataforma.
  MediaKit.ensureInitialized();

  // Lanza a ejecución la aplicación.
  runApp(const SigflodApp());
}
