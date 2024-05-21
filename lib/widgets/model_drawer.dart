import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../async_result.dart';
import '../model.dart';
import '../model_controller.dart';
import 'add_model_dialog.dart';
import 'delete_model_button.dart';
import 'model_info_view.dart';
import 'model_list.dart';

class ModelMenuDrawer extends StatelessWidget {
  const ModelMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();
    final filterNotifier = ValueNotifier('');

    return Drawer(
      width: 420,
      child: ListenableBuilder(
        listenable: Listenable.merge(
          [controller.models, controller.currentModel],
        ),
        builder: (context, _) {
          final models = controller.models.value;

          return switch (models) {
            Data(:final data) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _FilterField(
                          onFilterChanged: (value) =>
                              filterNotifier.value = value,
                        ),
                      ),
                      const _AddModelButton(),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: filterNotifier,
                      builder: (context, filter, _) {
                        bool match(Model element) => (element.name ?? '/')
                            .toLowerCase()
                            .contains(filter.toLowerCase());

                        final models =
                            filter.isEmpty ? data : data.where(match).toList();

                        return _ModelList(
                          currentModel: controller.currentModel.value,
                          models: models,
                        );
                      },
                    ),
                  ),
                ],
              ),
            DataError() => const Icon(Icons.warning, color: Colors.deepOrange),
            Pending() => Center(
                child: SizedBox.fromSize(
                  size: const Size.fromWidth(24),
                  child: const CircularProgressIndicator(),
                ),
              ),
          };
        },
      ),
    );
  }
}

class _AddModelButton extends StatelessWidget {
  const _AddModelButton();

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        icon: const Icon(Icons.add),
        tooltip: 'Pull a new model',
        onPressed: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Provider(
              create: (context) => AddModelController(context.read()),
              child: AddModelDialog(),
            ),
          );
        },
      );
}

class _ModelList extends StatelessWidget {
  final List<Model> models;

  final Model? currentModel;

  const _ModelList({
    required this.models,
    required this.currentModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: models
          .map(
            (model) => _ModelTile(
              model: model,
              selected: currentModel == model,
            ),
          )
          .toList(),
    );
  }
}

class _ModelTile extends StatefulWidget {
  final Model model;

  final bool selected;

  const _ModelTile({required this.model, required this.selected});

  @override
  _ModelTileState createState() => _ModelTileState();
}

class _ModelTileState extends State<_ModelTile> {
  bool hovered = false;

  late Model model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();

    return MouseRegion(
      onHover: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: ListTile(
        selectedColor: Colors.blueGrey.shade300,
        title: Text(model.name ?? '/'),
        subtitle: Text(
          '${(model.size ?? 0).asDiskSize()} - updated ${model.formattedLastUpdate}',
        ),
        dense: true,
        selectedTileColor: Colors.blueGrey.shade900,
        leading: const Icon(Icons.psychology),
        trailing: hovered || widget.selected
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => unawaited(
                      showDialog(
                        context: context,
                        builder: (final context) => ModelInfoView(model: model),
                      ),
                    ),
                    icon: const Icon(Icons.info),
                    color: Colors.cyan.shade700,
                  ),
                  DeleteModelButton(model: model),
                ],
              )
            : null,
        selected: widget.selected,
        onTap: () => unawaited(controller.selectModel(model)),
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  final ValueChanged<String> onFilterChanged;

  final TextEditingController controller = TextEditingController();

  _FilterField({required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          fillColor: Theme.of(context).canvasColor,
          filled: true,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
              onFilterChanged('');
            },
            icon: const Icon(Icons.close),
            iconSize: 14,
          ),
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 32, maxWidth: 32),
          isDense: true,
        ),
        onChanged: onFilterChanged,
      ),
    );
  }
}
