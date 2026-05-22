import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/app_text_styles.dart';

// Campo de texto reutilizable y configurable de la aplicación.
class AppTextField extends StatelessWidget {
  // Texto descriptivo que aparece como nombre del campo.
  final String label;

  // Texto de ayuda mostrado en gris dentro del input cuando está vacío.
  final String? hint;

  // Controlador opcional para gestionar el contenido del campo externamente.
  final TextEditingController? controller;

  // Oculta los caracteres tecleados, útil para contraseñas.
  final bool obscureText;

  // Tipo de teclado virtual que se mostrará en dispositivos móviles.
  final TextInputType keyboardType;

  // Número máximo de líneas que ocupa el campo en pantalla.
  final int maxLines;

  // Callback que se ejecuta cada vez que el usuario modifica el texto.
  final ValueChanged<String>? onChanged;

  // Lista de formateadores que restringen la entrada del usuario.
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label),

        const SizedBox(height: 6),

        TextField(
          controller: controller,
          maxLines: maxLines,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
