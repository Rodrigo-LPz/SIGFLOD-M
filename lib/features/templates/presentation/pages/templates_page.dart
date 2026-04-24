import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../domain/models/template_model.dart';
import '../../data/repositories/template_memory_repository.dart';


class TemplatesPage extends StatefulWidget {
  // 🔹 Si es true, la pantalla funciona como selector y devuelve una plantilla
  final bool selectionMode;

  const TemplatesPage({
    super.key,
    this.selectionMode = false,
  });

  @override
  State<TemplatesPage> createState() => _TemplatesPageState();
}

class _TemplatesPageState extends State<TemplatesPage> {
  // 🔹 Repositorio compartido de plantillas en memoria
final TemplateMemoryRepository _templateRepository = TemplateMemoryRepository.instance;

  // 🔹 Evita procesar argumentos más de una vez por reconstrucción
  String? _lastHandledTemplateId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments;

    // 🔹 Si llegamos desde la preview con una plantilla nueva, la añadimos
    if (args is TemplateModel && args.id != _lastHandledTemplateId) {
      final alreadyExists = _templateRepository.existsById(args.id);

      if (!alreadyExists) {
        _templateRepository.addTemplate(args);
        _lastHandledTemplateId = args.id;
      }
    }
  }

  // 🔹 Abre el wizard de creación
  void _openTemplateWizard() {
    Navigator.pushNamed(
      context,
      AppRoutes.templateType,
    );
  }

  // 🔹 Decide qué hacer al pulsar una plantilla según el modo de la pantalla
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode
              ? 'Seleccionar Plantilla'
              : 'Plantillas',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            // 🔹 Solo mostramos el botón de creación en modo normal
            if (!widget.selectionMode) ...[
              AppButton(
                label: 'Crear/Añadir Nueva Actividad',
                onPressed: _openTemplateWizard,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            Text(
              widget.selectionMode
                  ? 'Plantillas Disponibles'
                  : 'Plantillas Disponibles',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            ValueListenableBuilder<List<TemplateModel>>(
              valueListenable: _templateRepository.templates,
              builder: (context, templates, _) {
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

  const _TemplateCard({
    required this.template,
    required this.onTap,
  });

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
                  Text(
                    template.name,
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    template.objective,
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}