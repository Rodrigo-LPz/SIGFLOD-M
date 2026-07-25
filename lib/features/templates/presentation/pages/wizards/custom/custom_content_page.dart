import 'package:flutter/material.dart';

import '../../../../../../config/theme/app_spacing.dart';
import '../../../../../../config/theme/app_text_styles.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/app_card.dart';
import '../../../../domain/models/items/custom_item_draft.dart';

// Pantalla del wizard donde el logopeda gestiona la lista de items que
// formarán la plantilla Personalizada. Permite añadir nuevos items, editarlos,
// eliminarlos y reordenarlos mediante arrastrar y soltar.
//
// Recibe como argumento el mapa de datos acumulado por el wizard hasta el
// momento y lo enriquece con la lista de items antes de avanzar a la pantalla
// de ajustes funcionales.
class CustomContentPage extends StatefulWidget {
  const CustomContentPage({super.key});

  @override
  State<CustomContentPage> createState() => _CustomContentPageState();
}

class _CustomContentPageState extends State<CustomContentPage> {
  // Datos generales recibidos desde la pantalla anterior del wizard.
  Map<String, dynamic> _wizardData = {};

  // Lista editable de items actualmente añadidos a la plantilla.
  List<CustomItemDraft> _items = [];

  // Evita procesar los argumentos más de una vez por instancia.
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is Map<String, dynamic>) {
        _wizardData = Map<String, dynamic>.from(args);

        // Recupera los items previos si el logopeda ha vuelto desde un paso posterior.
        final previousItems = args['items'];
        if (previousItems is List<CustomItemDraft>) {
          _items = List<CustomItemDraft>.from(previousItems);
        }
      }

      _isInitialized = true;
    }
  }

  // Abre el editor para crear un item nuevo y lo añade al final de la lista.
  Future<void> _addNewItem() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.wizardCustomItemEditor,
    );

    if (result is CustomItemDraft) {
      setState(() {
        _items.add(result);
      });
    }
  }

  // Abre el editor cargando el item existente y reemplaza su versión actual.
  Future<void> _editItem(int index) async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.wizardCustomItemEditor,
      arguments: _items[index],
    );

    if (result is CustomItemDraft) {
      setState(() {
        _items[index] = result;
      });
    }
  }

  // Pide confirmación al logopeda y elimina el item indicado de la lista.
  Future<void> _removeItem(int index) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.customContentConfirmRemoveItemTitle),
          content: Text(t.customContentConfirmRemoveItemMessage),
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

    if (confirmed != true) return;

    setState(() {
      _items.removeAt(index);
    });
  }

  // Reordena la lista cuando el logopeda arrastra y suelta un item.
  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      final moved = _items.removeAt(oldIndex);
      _items.insert(newIndex, moved);
    });
  }

  // Valida la lista y avanza a la pantalla de ajustes funcionales del wizard.
  void _continueToSettings() {
    final t = AppLocalizations.of(context)!;

    if (_items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.customContentErrorEmpty)));
      return;
    }

    // Enriquece el mapa de transferencia con la lista de items actuales.
    final updatedWizardData = Map<String, dynamic>.from(_wizardData)
      ..['items'] = _items;

    Navigator.pushNamed(
      context,
      AppRoutes.wizardCustomSettings,
      arguments: updatedWizardData,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.customContentTitle), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.sm),

            // Cabecera con el contador de items y la pista de reordenacion.
            Text(
              t.customContentItemsCount(_items.length),
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              t.customContentReorderHint,
              style: AppTextStyles.bodySecondary,
            ),

            const SizedBox(height: AppSpacing.md),

            // Lista de items o estado vacio cuando aun no hay ninguno.
            Expanded(
              child: _items.isEmpty ? _buildEmptyState(t) : _buildItemsList(),
            ),

            const SizedBox(height: AppSpacing.md),

            // Boton para añadir un nuevo item al final de la lista.
            AppButton(label: t.customContentAddItem, onPressed: _addNewItem),

            const SizedBox(height: AppSpacing.sm),

            // Boton para avanzar a la siguiente pantalla del wizard.
            AppButton(
              label: t.customContentContinueButton,
              onPressed: _continueToSettings,
            ),
          ],
        ),
      ),
    );
  }

  // Construye la vista de estado vacio cuando no hay ningun item añadido.
  Widget _buildEmptyState(AppLocalizations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: AppSpacing.md),
          Text(
            t.customContentEmpty,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            t.customContentEmptyHint,
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Construye la lista reordenable que muestra todos los items actuales.
  Widget _buildItemsList() {
    return ReorderableListView.builder(
      itemCount: _items.length,
      onReorderItem: _reorderItems,
      buildDefaultDragHandles: false,
      itemBuilder: (context, index) {
        final item = _items[index];
        // La key es obligatoria en ReorderableListView para identificar elementos.
        return _ItemTile(
          key: ValueKey(item.id),
          index: index,
          item: item,
          onEdit: () => _editItem(index),
          onDelete: () => _removeItem(index),
        );
      },
    );
  }
}

// Tarjeta visual de un item dentro de la lista reordenable de la plantilla.
class _ItemTile extends StatelessWidget {
  final int index;
  final CustomItemDraft item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemTile({
    super.key,
    required this.index,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Manija visible para arrastrar el item a otra posicion de la lista.
          ReorderableDragStartListener(
            index: index,
            child: const Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: Icon(Icons.drag_handle),
            ),
          ),

          // Contenido principal del item: texto y badges de multimedia.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: AppTextStyles.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.hasImage || item.hasAudio || item.hasVideo) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      if (item.hasImage)
                        _MediaBadge(
                          icon: Icons.image,
                          label: t.customItemBadgeImage,
                        ),
                      if (item.hasAudio)
                        _MediaBadge(
                          icon: Icons.audiotrack,
                          label: t.customItemBadgeAudio,
                        ),
                      if (item.hasVideo)
                        _MediaBadge(
                          icon: Icons.videocam,
                          label: t.customItemBadgeVideo,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Acciones rapidas de edicion y eliminacion del item.
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

// Etiqueta visual compacta que indica que el item contiene un tipo de archivo.
class _MediaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MediaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}
