import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/template_model.dart';

// 🔹 Pantalla reutilizable de previsualización
class TemplatePreviewPage extends StatelessWidget {
  const TemplatePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Recuperamos los argumentos enviados a la pantalla
    final args = ModalRoute.of(context)?.settings.arguments;

    TemplateModel? template;
    String previewMode = 'template';

    // 🔹 Compatibilidad con el flujo antiguo: si llega directamente una plantilla
    if (args is TemplateModel) {
      template = args;
    }

    // 🔹 Nuevo formato: mapa con plantilla + modo de preview
    if (args is Map<String, dynamic>) {
      final rawTemplate = args['template'];
      final rawPreviewMode = args['previewMode'];

      if (rawTemplate is TemplateModel) {
        template = rawTemplate;
      }

      if (rawPreviewMode is String && rawPreviewMode.trim().isNotEmpty) {
        previewMode = rawPreviewMode;
      }
    }

    // 🔹 Determinamos si estamos en preview de actividad
    final isActivityPreview = previewMode == 'activity';

    // 🔹 Si no llega una plantilla válida, mostramos una vista controlada
    if (template == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isActivityPreview
                ? 'Previsualización de Actividad'
                : 'Previsualización',
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No se pudo cargar la plantilla para la previsualización.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: isActivityPreview
                    ? 'Volver a la Actividad'
                    : 'Volver a Plantillas',
                onPressed: () {
                  if (isActivityPreview) {
                    Navigator.pop(context);
                    return;
                  }

                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(AppRoutes.templates),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // 🔹 Lista real de palabras configuradas por el usuario
    final words = template.words;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isActivityPreview
              ? 'Previsualización de Actividad'
              : 'Previsualización',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),

            // 🔹 Nombre real de la plantilla
            Text(
              template.name,
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // 🔹 Tipo real de plantilla seleccionado en el wizard
            Text(
              'Tipo: ${template.type}',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // 🔹 Objetivo real de la plantilla
            Text(
              template.objective,
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Repite las palabras:',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.xl),

            // 🔹 Si no hay palabras, mostramos mensaje; si las hay, mostramos grid
            Expanded(
              child: words.isEmpty
                  ? const Center(
                      child: Text(
                        'La plantilla no contiene palabras.',
                        style: AppTextStyles.bodySecondary,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : GridView.builder(
                      itemCount: words.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: AppSpacing.md,
                        crossAxisSpacing: AppSpacing.md,
                      ),
                      itemBuilder: (context, index) {
                        final word = words[index];

                        return _WordCard(word: word);
                      },
                    ),
            ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 Botón final según el contexto de uso
            AppButton(
              label: isActivityPreview
                  ? 'Cerrar Previsualización'
                  : 'Guardar',
              onPressed: () {
                if (isActivityPreview) {
                  Navigator.pop(context);
                  return;
                }

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.templates,
                  ModalRoute.withName(AppRoutes.dashboard),
                  arguments: template,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Tarjeta visual de palabra
class _WordCard extends StatelessWidget {
  final String word;

  const _WordCard({required this.word});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Center(
        child: Text(
          word,
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}