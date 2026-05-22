import 'package:flutter/material.dart';
import 'app_colors.dart';


// 🔤 Sistema tipográfico centralizado
class AppTextStyles {

  // 🔝 Títulos grandes (pantallas)
  static const TextStyle headline = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // 🔷 Títulos de sección
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // 📝 Texto principal
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // 🔍 Texto secundario (subtitles, ayudas)
  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // 🧾 Labels pequeños
  static const TextStyle label = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}