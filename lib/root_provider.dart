import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'db.dart';
import 'model_controller.dart';
import 'theme.dart';

class RootProvider extends StatefulWidget {
  final SharedPreferences prefs;

  final Database db;

  final Widget child;

  const RootProvider({
    required this.child,
    required this.prefs,
    required this.db,
    super.key,
  });

  @override
  State<RootProvider> createState() => _RootProviderState();
}

class _RootProviderState extends State<RootProvider> {
  final ollamaClient = OllamaClient(
    baseUrl: const String.fromEnvironment('OLLAMA_BASE_URL',
        defaultValue: 'http://127.0.0.1:11434/api'),
  );

  late final ConversationService conversationService =
      ConversationService(widget.db);

  late final modelController = ModelController(
    client: ollamaClient,
    prefs: widget.prefs,
  )..init();

  @override
  Widget build(final BuildContext context) => MultiProvider(
        providers: [
          Provider.value(value: conversationService),
          Provider.value(value: ollamaClient),
          Provider.value(value: widget.prefs),
          Provider.value(value: modelController),
          ChangeNotifierProvider(
            create: (context) => ThemeController(Brightness.dark),
          ),
        ],
        child: widget.child,
      );
}
