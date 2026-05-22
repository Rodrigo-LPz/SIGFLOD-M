import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Centraliza los formateadores reutilizables que restringen la entrada del usuario.
class AppInputFormatters {
  // Constructor privado: la clase se utiliza solo como contenedor de utilidades estáticas.
  AppInputFormatters._();

  // Conjunto de letras latinas extendidas que cubren las lenguas más comunes.
  static const String _latinLetters =
      r"a-zA-ZáéíóúÁÉÍÓÚàèìòùÀÈÌÒÙäëïöüÄËÏÖÜâêîôûÂÊÎÔÛãõÃÕñÑçÇßåÅøØæÆ"
      r"łŁąĄęĘćĆńŃśŚźŹżŻ"
      r"șȘțȚăĂîÎâÂ"
      r"čČďĎěĚšŠťŤžŽůŮőŐűŰ"
      r"ğĞşŞıİ";

  // Permite solo letras, espacios, guiones y apóstrofes (nombres y apellidos).
  static NotifyingFormatter nameFormatter({
    required BuildContext context,
    required String errorMessage,
  }) {
    return NotifyingFormatter(
      pattern: RegExp("[$_latinLetters \\-']"),
      context: context,
      errorMessage: errorMessage,
    );
  }

  // Permite letras, números, espacios, guiones y guiones bajos (nombres de plantilla).
  static NotifyingFormatter templateNameFormatter({
    required BuildContext context,
    required String errorMessage,
  }) {
    return NotifyingFormatter(
      pattern: RegExp("[$_latinLetters 0-9\\-_]"),
      context: context,
      errorMessage: errorMessage,
    );
  }

  // Permite solo números, espacios y guiones (rangos de edad recomendada).
  static NotifyingFormatter ageRangeFormatter({
    required BuildContext context,
    required String errorMessage,
  }) {
    return NotifyingFormatter(
      pattern: RegExp(r'[0-9 \-]'),
      context: context,
      errorMessage: errorMessage,
    );
  }
}

// Formatter que filtra caracteres no permitidos y avisa con un SnackBar al usuario.
class NotifyingFormatter extends TextInputFormatter {
  final RegExp pattern;
  final BuildContext context;
  final String errorMessage;

  // Controla la frecuencia con la que se muestra el aviso para no saturar al usuario.
  static DateTime _lastShown = DateTime.fromMillisecondsSinceEpoch(0);

  NotifyingFormatter({
    required this.pattern,
    required this.context,
    required this.errorMessage,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Filtra el texto recibido conservando solo los caracteres permitidos.
    final filtered = newValue.text
        .split('')
        .where((c) => pattern.hasMatch(c))
        .join();

    // Si se eliminó al menos un carácter, notifica al usuario brevemente.
    if (filtered.length < newValue.text.length) {
      _notifyOnce();
      return TextEditingValue(
        text: filtered,
        selection: TextSelection.collapsed(offset: filtered.length),
      );
    }

    return newValue;
  }

  // Muestra el mensaje de error como mucho una vez cada dos segundos.
  void _notifyOnce() {
    final now = DateTime.now();
    if (now.difference(_lastShown).inSeconds < 2) return;
    _lastShown = now;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
