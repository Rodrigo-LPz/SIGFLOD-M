import 'package:flutter/widgets.dart';

// Mantiene el idioma actualmente activo de la aplicación de forma reactiva.
class LocaleService {
  // Constructor privado — patrón Singleton.
  LocaleService._();

  // Expone la instancia global reutilizable.
  static final LocaleService instance = LocaleService._();

  // Mantiene el locale actual observable para reconstruir la app al cambiar.
  final ValueNotifier<Locale> currentLocale = ValueNotifier<Locale>(
    const Locale('es'),
  );

  // Cambia el idioma activo a español.
  void setSpanish() {
    currentLocale.value = const Locale('es');
  }

  // Cambia el idioma activo a inglés.
  void setEnglish() {
    currentLocale.value = const Locale('en');
  }

  // Alterna entre los dos idiomas disponibles.
  void toggle() {
    if (currentLocale.value.languageCode == 'es') {
      setEnglish();
    } else {
      setSpanish();
    }
  }
}
