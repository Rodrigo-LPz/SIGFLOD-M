import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../data/repositories/template_firestore_repository.dart';
import '../../domain/models/template_enums.dart';
import '../../domain/models/template_model.dart';

// Pantalla reutilizable de previsualización de plantillas y actividades.
class TemplatePreviewPage extends StatefulWidget {
  const TemplatePreviewPage({super.key});

  @override
  State<TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends State<TemplatePreviewPage> {
  // Almacena la plantilla recibida desde los argumentos de navegación.
  TemplateModel? _template;

  // Almacena el modo activo de la pantalla, plantilla o actividad.
  String _previewMode = 'template';

  // Evita reinicializar los argumentos al reconstruir el widget.
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Resuelve una sola vez los argumentos recibidos por la ruta.
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is TemplateModel) {
        _template = args;
      }

      if (args is Map<String, dynamic>) {
        final rawTemplate = args['template'];
        final rawPreviewMode = args['previewMode'];

        if (rawTemplate is TemplateModel) {
          _template = rawTemplate;
        }

        if (rawPreviewMode is String && rawPreviewMode.trim().isNotEmpty) {
          _previewMode = rawPreviewMode;
        }
      }

      _isInitialized = true;
    }
  }

  // Abre el wizard en modo edición con todos los datos de la plantilla actual.
  void _editTemplate() {
    final template = _template;
    if (template == null) return;

    Navigator.pushNamed(context, AppRoutes.templateConfig, arguments: template);
  }

  // Pide confirmación al usuario y, si la da, elimina la plantilla en Firestore.
  Future<void> _confirmDeleteTemplate() async {
    final t = AppLocalizations.of(context)!;
    final template = _template;

    if (template == null) return;

    // Muestra el diálogo modal de confirmación.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.confirmDeleteTemplateTitle),
          content: Text(t.confirmDeleteTemplateMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.cancelAction),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                t.confirmAction,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    // Si el usuario canceló o cerró el diálogo, no hace nada.
    if (confirmed != true) return;

    // Ejecuta el borrado de la plantilla en Firestore.
    await TemplateFirestoreRepository.instance.deleteTemplate(template.id);

    if (!mounted) return;

    // Informa al usuario y cierra la previsualización.
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.templateDeleted)));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Determina si la pantalla actúa como previsualización de actividad real.
    final isActivityPreview = _previewMode == 'activity';
    final template = _template;

    // Si no llega una plantilla válida muestra una vista controlada.
    if (template == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            isActivityPreview ? t.activityPreviewTitle : t.previewTitle,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.errorPreviewTemplateMissing,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: isActivityPreview ? t.backToActivity : t.backToTemplates,
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

    // Mantiene la lista real de palabras configuradas en la plantilla.
    final words = template.words;

    // Indica si el botón de borrado debe mostrarse en la pantalla actual.
    final canDelete = !isActivityPreview && SessionService.instance.canWrite;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isActivityPreview ? t.activityPreviewTitle : t.previewTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),

            // Muestra el nombre real de la plantilla.
            Text(
              template.name,
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // Muestra el tipo de plantilla traducido al idioma activo.
            Text(
              '${t.typeLabel}: ${template.type.localized(context)}',
              style: AppTextStyles.body,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            // Muestra el objetivo real de la plantilla.
            Text(
              template.objective,
              style: AppTextStyles.bodySecondary,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(t.repeatWordsLabel, style: AppTextStyles.body),

            const SizedBox(height: AppSpacing.xl),

            // Muestra la lista de palabras como cuadrícula o un mensaje vacío.
            Expanded(
              child: words.isEmpty
                  ? Center(
                      child: Text(
                        t.noWordsInTemplate,
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

            // Botón final adaptado al contexto de uso de la pantalla.
            AppButton(
              label: isActivityPreview ? t.closePreview : t.saveButton,
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

            // Botones de edición y borrado disponibles solo para logopedas.
            if (canDelete) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(label: t.editTemplate, onPressed: _editTemplate),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: t.deleteTemplate,
                onPressed: _confirmDeleteTemplate,
                isDestructive: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Tarjeta visual reutilizable para mostrar una palabra de la plantilla.
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
