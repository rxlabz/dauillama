import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../async_result.dart';
import '../../model.dart';
import '../../screens/chat/chat_controller.dart';

class ChatHistoryView extends StatefulWidget {
  final ValueChanged<Conversation> onChatSelection;

  final ValueChanged<Conversation> onDeleteChat;

  final VoidCallback onNewChat;

  const ChatHistoryView({
    super.key,
    required this.onChatSelection,
    required this.onDeleteChat,
    required this.onNewChat,
  });

  @override
  State<ChatHistoryView> createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  bool minimized = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.read<ChatController>();

    return Container(
      color: theme.canvasColor,
      constraints: const BoxConstraints(maxWidth: 280),
      child: ValueListenableBuilder(
        valueListenable: controller.conversations,
        builder: (context, conversations, _) => switch (conversations) {
          Pending() => const Center(child: CircularProgressIndicator()),
          DataError() =>
            const Center(child: Icon(Icons.warning, color: Colors.orange)),
          Data(:final data) => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (minimized)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () => setState(() => minimized = false),
                      icon: const Icon(Icons.history),
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => setState(() => minimized = true),
                          icon: const RotatedBox(
                            quarterTurns: 1,
                            child: Icon(Icons.expand_circle_down),
                          ),
                        ),
                        TextButton.icon(
                          label: const Text('New conversation'),
                          onPressed: widget.onNewChat,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: controller.conversation,
                      builder: (context, selectedConversation, _) =>
                          ListView.separated(
                        itemBuilder: (context, index) {
                          final conversation = data[index];

                          final subtitle =
                              '${conversation.formattedDate} - ${conversation.model}';

                          return Material(
                            child: ListTile(
                              dense: true,
                              selected: conversation == selectedConversation,
                              selectedColor: theme.colorScheme.onSurface,
                              selectedTileColor: theme.dialogBackgroundColor,
                              contentPadding: const EdgeInsets.only(left: 8),
                              title: Text(
                                conversation.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                subtitle,
                                style: const TextStyle(color: Colors.blueGrey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(
                                Icons.chat,
                                color: Colors.blueGrey,
                              ),
                              trailing: IconButton(
                                onPressed: () =>
                                    widget.onDeleteChat(conversation),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => widget.onChatSelection(conversation),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(
                          height: 1,
                        ),
                        itemCount: data.length,
                      ),
                    ),
                  ),
                ],
              ],
            ),
        },
      ),
    );
  }
}
