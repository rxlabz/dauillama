import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';

import '../async_result.dart';
import '../model.dart';
import '../model_controller.dart';
import 'delete_model_button.dart';
import 'model_list.dart';

class ModelInfoView extends StatelessWidget {
  final Model model;

  const ModelInfoView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    //final info = controller.modelInfo.value.data;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      /*backgroundColor: theme.scaffoldBackgroundColor,*/
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: ListenableBuilder(
            listenable: Listenable.merge(
              [controller.modelInfo, controller.currentModel],
            ),
            builder: (context, _) {
              final modelInfo = controller.modelInfo.value;

              return switch (modelInfo) {
                DataError() =>
                  const Icon(Icons.warning, color: Colors.deepOrange),
                Pending() => Center(
                    child: SizedBox.fromSize(
                      size: const Size.fromWidth(24),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                Data(:final data) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              model.model ?? '/',
                              style: textTheme.titleMedium,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _PullModelButton(model: model),
                              DeleteModelButton(model: model),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      if (data != null) ...[
                        Row(
                          children: [
                            Flexible(
                              child: _InfoTile(
                                title: 'Modified at',
                                data: model.formattedLastUpdate,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (model.size != null)
                              Flexible(
                                child: _InfoTile(
                                  title: 'Size',
                                  data: model.size!.asDiskSize(),
                                ),
                              ),
                          ],
                        ),
                        if (data.template != null)
                          _InfoTile(title: 'Template', data: data.template!),
                        if (data.modelfile != null)
                          _InfoTile(title: 'ModelFile', data: data.modelfile!),
                        if (data.parameters != null)
                          _InfoTile(
                            title: 'Parameters',
                            data: data.parameters!,
                          ),
                      ],
                    ],
                  ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _PullModelButton extends StatelessWidget {
  final Model model;

  const _PullModelButton({required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();

    return ValueListenableBuilder(
      valueListenable: controller.pullProgress,
      builder: (context, progress, _) => progress == null
          ? IconButton(
              tooltip: 'Update model',
              onPressed: () => controller.updateModel(model),
              icon: const Icon(Icons.refresh),
              color: Colors.cyan.shade700,
            )
          : Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.blueGrey.shade700,
                ),
              ),
            ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String data;

  const _InfoTile({required this.title, required this.data});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(data),
            ),
          ],
        ),
      );
}
