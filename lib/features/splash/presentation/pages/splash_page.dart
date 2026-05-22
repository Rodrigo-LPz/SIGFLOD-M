import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';

// Pantalla de carga inicial mostrada durante el arranque de la aplicación.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Programa la redirección automática tras la duración del splash.
    _scheduleNavigation();
  }

  // Espera 2 segundos y redirige al destino correspondiente según la sesión.
  Future<void> _scheduleNavigation() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Determina la ruta destino en función del estado de autenticación.
    final hasSession = AuthService.instance.currentUser != null;
    final destination = hasSession
        ? AppRoutes.dashboard
        : AppRoutes.roleSelection;

    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Muestra el logo principal del sistema centrado en pantalla.
            Image.asset(
              'assets/images/sigflod_logo.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: AppSpacing.xl),

            // Muestra un indicador de carga sutil bajo el logo.
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
