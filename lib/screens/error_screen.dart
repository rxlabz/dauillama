import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model_controller.dart';
import '../widgets/add_model_dialog.dart';
import '../widgets/model_library_button.dart';

class ErrorScreen extends StatelessWidget {
  final String msg;

  final VoidCallback errorAction;

  final IconData errorActionIcon;

  final String errorActionLabel;

  final Widget? secondaryActionButton;

  const ErrorScreen({
    super.key,
    required this.msg,
    required this.errorAction,
    required this.errorActionIcon,
    required this.errorActionLabel,
    this.secondaryActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.warning, color: Colors.deepOrange),
                ),
                Text(msg),
              ],
            ),
            TextButton.icon(
              onPressed: errorAction,
              icon: Icon(errorActionIcon),
              label: Text(errorActionLabel),
            ),
            if (secondaryActionButton != null) ...[
              const Divider(height: 18),
              secondaryActionButton!,
            ]
          ],
        ),
      ),
    );
  }
}

class NollamaScreen extends StatelessWidget {
  const NollamaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modelController = context.read<ModelController>();

    return ErrorScreen(
      msg: "Error : can't load models. Install and launch Ollama",
      errorAction: modelController.loadModels,
      errorActionLabel: 'Retry',
      errorActionIcon: Icons.refresh,
    );
  }
}

class NoModelErrorScreen extends StatelessWidget {
  const NoModelErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modelController = context.read<ModelController>();

    return ErrorScreen(
      msg: 'Error : No model available',
      errorAction: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Provider(
            create: (context) => AddModelController(
              context.read(),
              onDownloadComplete: modelController.loadModels,
            ),
            child: AddModelDialog(),
          ),
        );
      },
      errorActionLabel: 'Pull a Model',
      errorActionIcon: Icons.download,
      secondaryActionButton: const ModelLibraryButton(),
    );
  }
}
