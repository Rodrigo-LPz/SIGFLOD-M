import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/app_user_model.dart';
import 'login_page.dart';
import 'register_page.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  // Navega a la pantalla de acceso pasándole el rol seleccionado.
  void _openLogin(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Muestra el selector de idioma en la esquina superior derecha.
              const Align(
                alignment: Alignment.topRight,
                child: _LanguageSelector(),
              ),

              const SizedBox(height: AppSpacing.md),

              // Muestra el logo principal del sistema.
              Image.asset(
                'assets/images/sigflod_logo.png',
                width: 200,
                height: 200,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                t.portalTitle,
                style: AppTextStyles.headline,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              Text(
                t.accessAs,
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              // Acceso como logopeda (permisos completos).
              GestureDetector(
                onTap: () => _openLogin(context, UserRole.logopeda),
                child: AppCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    child: Center(
                      child: Text(t.roleLogopeda, style: AppTextStyles.body),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Acceso como familiar (permisos de solo lectura).
              GestureDetector(
                onTap: () => _openLogin(context, UserRole.familiar),
                child: AppCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    child: Center(
                      child: Text(t.roleFamiliar, style: AppTextStyles.body),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              AppButton(
                label: t.createAccount,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),

              const Spacer(),

              Text(
                t.developedBy,
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

// Selector visual del idioma activo con dos banderas pulsables.
class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleService.instance.currentLocale,
      builder: (context, locale, _) {
        final isSpanish = locale.languageCode == 'es';

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bandera de España: activa el idioma castellano.
            GestureDetector(
              onTap: () => LocaleService.instance.setSpanish(),
              child: Opacity(
                opacity: isSpanish ? 1.0 : 0.4,
                child: CountryFlag.fromCountryCode(
                  'ES',
                  theme: const ImageTheme(
                    width: 40,
                    height: 28,
                    shape: RoundedRectangle(6),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            // Bandera del Reino Unido: activa el idioma inglés.
            GestureDetector(
              onTap: () => LocaleService.instance.setEnglish(),
              child: Opacity(
                opacity: isSpanish ? 0.4 : 1.0,
                child: CountryFlag.fromCountryCode(
                  'GB',
                  theme: const ImageTheme(
                    width: 40,
                    height: 28,
                    shape: RoundedRectangle(6),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
