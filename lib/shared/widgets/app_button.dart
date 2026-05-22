import 'package:flutter/material.dart';
import '../../config/theme/app_text_styles.dart';

// Botón reutilizable y configurable de la aplicación.
class AppButton extends StatelessWidget {
  // Texto que se muestra dentro del botón.
  final String label;

  // Callback que se ejecuta al pulsar el botón.
  final VoidCallback? onPressed;

  // Indica si el botón debe mostrar un spinner de carga en lugar del texto.
  final bool isLoading;

  // Indica si el botón ocupa todo el ancho disponible o solo el contenido.
  final bool isExpanded;

  // Indica si el botón representa una acción destructiva e irreversible.
  final bool isDestructive;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isExpanded = true,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determina el estilo del botón según su naturaleza destructiva.
    final style = isDestructive
        ? ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          )
        : null;

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(label, style: AppTextStyles.body),
    );

    // Devuelve el botón expandido a todo el ancho o con tamaño natural.
    if (isExpanded) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }
}
