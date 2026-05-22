import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../data/repositories/template_firestore_repository.dart';
import '../../domain/models/template_model.dart';

class TemplatesPage extends StatefulWidget {
  // Activa el modo selector: al pulsar una plantilla la devuelve a la pantalla anterior.
  final bool selectionMode;

  const TemplatesPage({super.key, this.selectionMode = false});

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  // Almacena la referencia al repositorio Firestore de plantillas.
  final TemplateFirestoreRepository _templateRepository =
      TemplateFirestoreRepository.instance;

  // Evita procesar el mismo argumento de plantilla más de una vez.
  String? _lastHandledTemplateId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    // Persiste la plantilla recibida desde la preview, distinguiendo creación o edición.
    if (args is TemplateModel && args.id != _lastHandledTemplateId) {
      _lastHandledTemplateId = args.id;
      _templateRepository.existsById(args.id).then((exists) {
        if (exists) {
          _templateRepository.updateTemplate(args);
        } else {
          _templateRepository.addTemplate(args);
        }
      });
    }
  }

  // Abre el asistente de creación de plantillas.
  void _openTemplateWizard() {
    Navigator.pushNamed(context, AppRoutes.templateType);
  }

  // Gestiona el tap sobre una plantilla según el modo activo de la pantalla.
  void _handleTemplateTap(TemplateModel template) {
    if (widget.selectionMode) {
      Navigator.pop(context, template);
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.templatePreview,
      arguments: template,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode ? t.templateSelectorTitle : t.templatesTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            // Muestra el botón de creación solo en modo normal y si el usuario puede escribir.
            if (!widget.selectionMode && SessionService.instance.canWrite) ...[
              AppButton(
                label: t.createNewActivity,
                onPressed: _openTemplateWizard,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            Text(t.availableTemplates, style: AppTextStyles.title),
            const SizedBox(height: AppSpacing.md),

            // Escucha los cambios en Firestore y reconstruye la lista automáticamente.
            ValueListenableBuilder<List<TemplateModel>>(
              valueListenable: _templateRepository.templates,
              builder: (context, templates, _) {
                if (templates.isEmpty) {
                  return Text(
                    t.noTemplatesAvailable,
                    style: AppTextStyles.bodySecondary,
                  );
                }

                return Column(
                  children: templates
                      .map(
                        (template) => _TemplateCard(
                          template: template,
                          onTap: () => _handleTemplateTap(template),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final TemplateModel template;
  final VoidCallback onTap;

  const _TemplateCard({required this.template, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(Icons.widgets_outlined, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(template.name, style: AppTextStyles.body),
                  const SizedBox(height: AppSpacing.xs),
                  Text(template.objective, style: AppTextStyles.bodySecondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
