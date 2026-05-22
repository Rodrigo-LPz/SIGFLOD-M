import 'package:flutter/material.dart';
import '../../../../config/theme/app_spacing.dart';
import '../../../../config/theme/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/models/template_model.dart';
import '../../domain/models/template_enums.dart';

// Pantalla para gestionar las palabras incluidas en la plantilla.
class TemplateWordsPage extends StatefulWidget {
  const TemplateWordsPage({super.key});

  @override
  State<TemplateWordsPage> createState() => _TemplateWordsPageState();
}

class _TemplateWordsPageState extends State<TemplateWordsPage> {
  // Almacena el controlador del campo para añadir una palabra nueva.
  late final TextEditingController _wordController;

  // Almacena la plantilla recibida desde el paso anterior.
  TemplateModel? _template;

  // Mantiene la lista editable de palabras de la plantilla.
  List<String> _words = [];

  // Evita reinicializar la lista al reconstruir el widget.
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

  // Añade una palabra nueva a la lista tras validar la entrada.
  void _addWord() {
    final t = AppLocalizations.of(context)!;
    final newWord = _wordController.text.trim();

    if (newWord.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorEmptyWord)));
      return;
    }

    if (_words.contains(newWord)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorDuplicatedWord)));
      return;
    }

    setState(() {
      _words.add(newWord);
      _wordController.clear();
    });
  }

  // Elimina la palabra recibida de la lista.
  void _removeWord(String word) {
    setState(() {
      _words.remove(word);
    });
  }

  // Continúa al siguiente paso enviando la plantilla con las palabras actualizadas.
  void _continueToSettings() {
    final t = AppLocalizations.of(context)!;

    if (_template == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorTemplateMissing)));
      return;
    }

    if (_words.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.errorEmptyWordList)));
      return;
    }

    final updatedTemplate = _template!.copyWith(words: _words);

    Navigator.pushNamed(
      context,
      AppRoutes.templateSettings,
      arguments: updatedTemplate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.templateConfigTitle(_template?.type.localized(context) ?? ''),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ListView(
          children: [
            const SizedBox(height: AppSpacing.sm),

            Text(t.wordsTitle, style: AppTextStyles.title),

            const SizedBox(height: AppSpacing.md),

            // Muestra la lista actual de palabras o un texto de estado vacío.
            if (_words.isEmpty)
              Text(t.noWordsYet, style: AppTextStyles.bodySecondary)
            else
              ..._words.map(
                (word) =>
                    _WordTile(word: word, onDelete: () => _removeWord(word)),
              ),

            const SizedBox(height: AppSpacing.xl),

            Text(t.addNewWord, style: AppTextStyles.body),

            const SizedBox(height: AppSpacing.sm),

            AppTextField(
              label: t.newWordLabel,
              hint: t.newWordHint,
              controller: _wordController,
            ),

            const SizedBox(height: AppSpacing.sm),

            AppButton(label: t.addWordButton, onPressed: _addWord),

            const SizedBox(height: AppSpacing.xl),

            AppButton(label: t.continueButton, onPressed: _continueToSettings),
          ],
        ),
      ),
    );
  }
}

// Tarjeta visual de una palabra añadida a la plantilla.
class _WordTile extends StatelessWidget {
  final String word;
  final VoidCallback onDelete;

  const _WordTile({required this.word, required this.onDelete});

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
          Text(word, style: AppTextStyles.body),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
