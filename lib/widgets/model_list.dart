import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ollama_dart/ollama_dart.dart';

class ModelMenu extends StatelessWidget {
  final Model selection;
  final List<Model> models;

  final ValueChanged<Model> onSelected;
  final VoidCallback onReload;

  const ModelMenu({
    super.key,
    required this.selection,
    required this.models,
    required this.onSelected,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownMenu<Model>(
          label: const Text('Model'),
          dropdownMenuEntries: models
              .map(
                (model) => DropdownMenuEntry(
                  value: model,
                  leadingIcon: const Icon(Icons.psychology),
                  label:
                      '${model.model ?? ' ? '}(${(model.size ?? 0).asDiskSize()})',
                ),
              )
              .toList(),
          leadingIcon: const Icon(Icons.psychology),
          initialSelection: selection,
          onSelected: (newSelection) => onSelected(newSelection ?? selection),
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade800),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            filled: true,
            contentPadding: const EdgeInsets.all(4.0),
          ),
        ),
        IconButton(
          onPressed: onReload,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}

class ModelTile extends StatelessWidget {
  final bool selected;

  final Model model;

  final VoidCallback onTap;

  const ModelTile(
    this.model, {
    required this.selected,
    super.key,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) => ListTile(
        selected: selected,
        title: Text(model.model ?? 'Undefined name'),
        subtitle: Text(
          '${(model.size ?? 0).asDiskSize()} - '
          '${model.date == null ? '/' : DateFormat('dd/MM/yyyy').format(model.date!)}',
        ),
        onTap: onTap,
        subtitleTextStyle: const TextStyle(color: Colors.grey),
        dense: true,
      );
}

extension on Model {
  DateTime? get date => DateTime.tryParse(modifiedAt ?? '');
}

extension SizeHelper on int {
  String asDiskSize() {
    final size = this;
    return switch (size) {
      < 1000 => '${size}o',
      < 1000000 => '${(size / 1000).toStringAsFixed(2)}ko',
      < 1000000000 => '${(size / 1000000).toStringAsFixed(2)}Mo',
      _ => '${(size / 1000000000).toStringAsFixed(2)}Go',
    };
  }
}
