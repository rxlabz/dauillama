import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../model_controller.dart';

class DeleteModelButton extends StatelessWidget {
  final Model model;

  const DeleteModelButton({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();

    return IconButton(
      tooltip: 'Delete model',
      onPressed: () async {
        final confirm = await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Confirm'),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              CupertinoDialogAction(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        );
        if (confirm == true) {
          controller.deleteModel(model);
        }
      },
      icon: const Icon(Icons.delete),
      color: Colors.deepOrange.shade900,
    );
  }
}
