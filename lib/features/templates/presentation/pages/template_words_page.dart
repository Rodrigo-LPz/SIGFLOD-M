import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/template_model.dart';

// 🔹 Pantalla para gestionar las palabras de la plantilla
class TemplateWordsPage extends StatefulWidget {
  const TemplateWordsPage({super.key});

  @override
  State<TemplateWordsPage> createState() => _TemplateWordsPageState();
}

class _TemplateWordsPageState extends State<TemplateWordsPage> {
  // 🔹 Controlador del campo para añadir nueva palabra
  late final TextEditingController _wordController;

  // 🔹 Plantilla recibida del paso anterior
  TemplateModel? _template;

  // 🔹 Lista editable de palabras
  List<String> _words = [];

  // 🔹 Evita reinicializar al reconstruir
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _wordController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is TemplateModel) {
        _template = args;
        _words = List<String>.from(args.words);
      }

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  // 🔹 Añade una palabra nueva a la lista
  void _addWord() {
    final newWord = _wordController.text.trim();

    if (newWord.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe escribir una palabra antes de añadirla.'),
        ),
      );
      return;
    }

    if (_words.contains(newWord)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esa palabra ya está añadida en la plantilla.'),
        ),
      );
      return;
    }

    setState(() {
      _words.add(newWord);
      _wordController.clear();
    });
  }

  // 🔹 Elimina una palabra concreta
  void _removeWord(String word) {
    setState(() {
      _words.remove(word);
    });
  }

  // 🔹 Continúa al siguiente paso enviando la plantilla actualizada
  void _continueToSettings() {
    if (_template == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo recuperar la plantilla base.'),
        ),
      );
      return;
    }

    if (_words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe añadir al menos una palabra a la plantilla.'),
        ),
      );
      return;
    }

    final updatedTemplate = _template!.copyWith(
      words: _words,
    );

    Navigator.pushNamed(
      context,
      AppRoutes.templateSettings,
      arguments: updatedTemplate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plantilla: Fonemas / Pronunciación'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            const Text(
              'Palabras',
              style: AppTextStyles.title,
            ),

            const SizedBox(height: AppSpacing.md),

            // 🔹 Lista real de palabras
            if (_words.isEmpty)
              const Text(
                'Todavía no se han añadido palabras.',
                style: AppTextStyles.bodySecondary,
              )
            else
              ..._words.map(
                (word) => _WordTile(
                  word: word,
                  onDelete: () => _removeWord(word),
                ),
              ),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Añadir nueva palabra',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.sm),

            AppTextField(
              label: 'Escriba una nueva palabra',
              hint: 'Escriba una palabra...',
              controller: _wordController,
            ),

            const SizedBox(height: AppSpacing.sm),

            AppButton(
              label: 'Añadir Palabra',
              onPressed: _addWord,
            ),

            const SizedBox(height: AppSpacing.xl),

            AppButton(
              label: 'Continuar',
              onPressed: _continueToSettings,
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Tarjeta visual de palabra añadida
class _WordTile extends StatelessWidget {
  final String word;
  final VoidCallback onDelete;

  const _WordTile({
    required this.word,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            word,
            style: AppTextStyles.body,
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}