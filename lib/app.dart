import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'async_result.dart';
import 'model_controller.dart';
import 'screens/chat/chat_controller.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/error_screen.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(final BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final modelController = context.read<ModelController>();

    return MaterialApp(
      home: ValueListenableBuilder(
        valueListenable: modelController.models,
        builder: (context, modelListResult, _) => switch (modelListResult) {
          Pending() =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
          Data(:final data) when data.isEmpty => const NoModelErrorScreen(),
          Data(:final data) when data.isNotEmpty => ValueListenableBuilder(
              valueListenable: modelController.currentModel,
              builder: (context, model, _) => model == null
                  ? const Center(child: CircularProgressIndicator())
                  : Provider(
                      create: (context) => ChatController(
                        client: modelController.client,
                        conversationService: context.read(),
                        model: modelController.currentModel,
                      )..loadHistory(),
                      child: const ChatScreen(),
                    ),
            ),
          _ => const NollamaScreen(),
        },
      ),
      theme: themeController.theme,
      debugShowCheckedModeBanner: false,
    );
  }
}
