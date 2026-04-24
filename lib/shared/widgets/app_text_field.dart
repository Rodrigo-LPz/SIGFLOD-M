import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';


// 🔤 Campo de texto reutilizable de la app
class AppTextField extends StatelessWidget {
  // 🔹 Texto que aparece como nombre del campo
  final String label;

  // 🔹 Texto de ayuda dentro del input
  final String? hint;

  // 🔹 Controlador opcional por si más adelante lo necesitamos
  final TextEditingController? controller;

  // 🔹 Permite ocultar texto, útil para contraseñas
  final bool obscureText;

  // 🔹 Tipo de teclado que se quiere mostrar
  final TextInputType keyboardType;

  // 🔹 Número máximo de líneas
  final int maxLines;

  // 🔹 Callback para escuchar lo que el usuario va escribiendo
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label del campo
        Text(
          label,
          style: AppTextStyles.label,
        ),

        const SizedBox(height: 6),

        // 🔹 Input real
        TextField(
          controller: controller,
          maxLines: maxLines,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}