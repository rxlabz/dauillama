import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:provider/provider.dart';

import '../../markdown/code_element_builder.dart';
import '../../markdown/highlighter.dart';
import '../../model_controller.dart';
import '../../theme.dart';
import '../../themes.dart';
import '../../widgets/chat_history/chat_history_view.dart';
import '../../widgets/model_drawer.dart';
import '../../widgets/model_info_view.dart';
import '../../widgets/prompt_field.dart';
import 'chat_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    final modelController = context.read<ModelController>();
    final chatController = context.read<ChatController>();

    return Scaffold(
      appBar: const MainAppBar(),
      drawer: const ModelMenuDrawer(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChatHistoryView(
            onChatSelection: (conversation) async {
              /*await */ modelController.selectModelNamed(conversation.model);
              chatController.selectConversation(conversation);
            },
            onDeleteChat: chatController.deleteConversation,
            onNewChat: chatController.newConversation,
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Listenable.merge(
                [
                  chatController.loading,
                  chatController.conversation,
                ],
              ),
              builder: (context, _) {
                final loading = chatController.loading.value;
                final messages = chatController.conversation.value.messages;
                final model = chatController.conversation.value.model;
                final date = chatController.conversation.value.formattedDate;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (messages.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints.tightForFinite(),
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.canvasColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(model),
                            Text(date),
                          ],
                        ),
                      ),
                    Expanded(
                      child: !loading
                          ? ListView(
                              controller: chatController.scrollController,
                              children: [
                                for (final qa in messages) QAView(qa: qa),
                              ],
                            )
                          : ValueListenableBuilder(
                              valueListenable: chatController.lastReply,
                              builder: (context, reply, _) => loading &&
                                      chatController.lastReply.value.$2.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const ChatInteractionView(),
                            ),
                    ),
                    const PromptField(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ModelController>();

    return AppBar(
      scrolledUnderElevation: 0,
      leading: IconButton(
        onPressed: Scaffold.of(context).openDrawer,
        icon: const Icon(Icons.menu),
      ),
      title: Row(
        children: [
          Image.asset('assets/app_icons/tete_32.png', width: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'DauiLlama',
              style: TextStyle(color: Colors.blueGrey.shade700),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller.currentModel,
            builder: (final context, currentModel, _) => currentModel != null
                ? Row(
                    children: [
                      Text(
                        currentModel.name ?? '/',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (final context) =>
                              ModelInfoView(model: currentModel),
                        ),
                        icon: const Icon(Icons.info),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      centerTitle: false,
      actions: const [
        ThemeButton(),
      ],
    );
  }
}

class ChatHeader extends StatelessWidget {
  final String question;

  const ChatHeader({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(Icons.chat, color: Colors.blueGrey),
        ),
        Flexible(
          child: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class QAView extends StatelessWidget {
  final (String, String) qa;

  const QAView({super.key, required this.qa});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatHeader(question: qa.$1),
          const Divider(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Markdown(
              data: qa.$2,
              selectable: true,
              syntaxHighlighter: MdHightLighter(editorHighlighterStyle),
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(14),
              styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
              inlineSyntaxes: const [],
              extensionSet: md.ExtensionSet.gitHubWeb,
              shrinkWrap: true,
              builders: {'code': CodeElementBuilder()},
              onSelectionChanged: (_, __, ___) {},
            ),
          ),
        ],
      ),
    );
  }
}

class ChatInteractionView extends StatelessWidget {
  const ChatInteractionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ChatController>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder(
        valueListenable: controller.lastReply,
        builder: (context, qa, _) => SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChatHeader(question: qa.$1),
              const Divider(),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Markdown(
                  data: qa.$2.isEmpty ? '' : qa.$2,
                  /*selectable: true,*/
                  syntaxHighlighter: MdHightLighter(editorHighlighterStyle),
                  padding: const EdgeInsets.all(42),
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                  inlineSyntaxes: const [],
                  extensionSet: md.ExtensionSet.gitHubWeb,
                  onSelectionChanged: (_, __, ___) {},
                  shrinkWrap: true,
                  builders: {'code': CodeElementBuilder()},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
