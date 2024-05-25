import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../async_result.dart';
import '../model_controller.dart';
import 'model_library_button.dart';

class AddModelController {
  final _log = Logger('AddModelController');

  ValueNotifier<AsyncData<double?>> pullProgress =
      ValueNotifier(const Data(null));

  VoidCallback? onDownloadComplete;

  final OllamaClient _client;
  OllamaClient get client => _client;

  AddModelController(this._client, {this.onDownloadComplete});

  Future<void> addModel(
    String name, {
    required ValueChanged<String> onComplete,
  }) async {
    try {
      final result = await _downloadModel(name);

      if (result) {
        pullProgress.value = const Data(null);
        onComplete(name);
      }
    } catch (err) {
      pullProgress.value = const DataError();
    }
  }

  Future<bool> _downloadModel(String name) async {
    pullProgress.value = const Pending(0);

    final streamResponse = _client.pullModelStream(
      request: PullModelRequest(
        name: name,
        stream: true,
      ),
    );

    await for (final chunk in streamResponse) {
      _log.info(
        'OllamaController.updateModel... ${chunk.completed}/${chunk.total}',
      );
      pullProgress.value = Pending(
        chunk.total != null ? (chunk.completed ?? 0) / chunk.total! : 0,
      );
    }

    onDownloadComplete?.call();

    return true;
  }
}

class AddModelDialog extends StatelessWidget {
  final TextEditingController fieldController = TextEditingController();

  AddModelDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final controller = context.read<AddModelController>();
    final mainController = context.read<ModelController>();

    Future<void> onDownloadComplete(String newModelName) async {
      await mainController.loadModels();
      mainController.selectModelNamed(newModelName);
      if (context.mounted) {
        Navigator.of(context).popUntil(
          (route) => route.settings.name == '/',
        );
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pull a new model',
                  style: textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    if (controller.pullProgress.value.data == null) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(Icons.close, color: theme.colorScheme.secondary),
                ),
              ],
            ),
            const Divider(height: 28),
            ListenableBuilder(
              listenable:
                  Listenable.merge([fieldController, controller.pullProgress]),
              builder: (context, _) {
                final name = fieldController.text;
                final pullState = controller.pullProgress.value;

                return Row(
                  children: [
                    Expanded(
                      child: _NameField(
                        fieldController: fieldController,
                        onEditingComplete: () {
                          if (name.isNotEmpty && !pullState.isPending) {
                            controller.addModel(
                              name,
                              onComplete: onDownloadComplete,
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    switch (pullState) {
                      Data() => IconButton(
                          onPressed: name.isNotEmpty
                              ? () => controller.addModel(
                                    name,
                                    onComplete: onDownloadComplete,
                                  )
                              : null,
                          icon: Icon(
                            Icons.cloud_download,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      Pending(:final progress) => SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.blueGrey.shade700,
                          ),
                        ),
                      DataError() => const Center(
                          child: Icon(Icons.warning, color: Colors.deepOrange),
                        )
                    },
                  ],
                );
              },
            ),
            const Divider(height: 28),
            const ModelLibraryButton(),
          ],
        ),
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController fieldController;

  final VoidCallback onEditingComplete;

  const _NameField({
    required this.fieldController,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final name = fieldController.text;

    return TextField(
      controller: fieldController,
      decoration: InputDecoration(
        isDense: true,
        suffixIcon: name.isNotEmpty
            ? IconButton(
                onPressed: fieldController.clear,
                icon: const Icon(Icons.close),
                iconSize: 14,
              )
            : null,
        suffixIconConstraints:
            const BoxConstraints(maxHeight: 32, maxWidth: 32),
      ),
      onEditingComplete: onEditingComplete,
    );
  }
}
