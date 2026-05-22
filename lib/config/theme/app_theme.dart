import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';


// Clase donde centralizamos todo el estilo global de la app
class AppTheme {
  // Método que devuelve el ThemeData principal
  static ThemeData getTheme() {
    return ThemeData(
      // 🔥 Activamos Material 3 (importante)
      useMaterial3: true,

      // 🎨 Definimos la paleta de colores base
      colorScheme: const ColorScheme(

        brightness: Brightness.light,

        primary: AppColors.primary,        // Color principal (botones, elementos activos)
        onPrimary: Colors.white,           // Color del texto sobre primary

        secondary: AppColors.secondary,      // Color secundario
        onSecondary: Colors.white,

        error: Colors.red,
        onError: Colors.white,

        surface: Colors.white,
        onSurface: Colors.black,
        /*
        background: AppColors.background,
        onBackground: Colors.black,
        */
      ),

      // 🔤 Tipografía global
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headline,
        titleLarge: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.bodySecondary,
      ),

      // 🔘 Estilo global de botones
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(

          backgroundColor: AppColors.primary,

          foregroundColor: Colors.white,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
        ),
      ),

      // 🧱 Scaffold (pantallas)
      scaffoldBackgroundColor: AppColors.background,
    );
  }
}