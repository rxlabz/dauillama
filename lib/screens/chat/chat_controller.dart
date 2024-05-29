import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:ollama_dart/ollama_dart.dart';

import '../../async_result.dart';
import '../../db.dart';
import '../../model.dart';

Conversation emptyConversationWith(String model) => Conversation(
      lastUpdate: DateTime.now(),
      model: model,
      title: 'Chat',
      messages: [],
    );

class ChatController {
  final _log = Logger('ChatController');

  final OllamaClient _client;

  final ConversationService _conversationService;

  final promptFieldController = TextEditingController();

  ScrollController scrollController = ScrollController();

  ValueNotifier<XFile?> selectedImage = ValueNotifier(null);

  final ValueNotifier<Model?> model;

  final ValueNotifier<Conversation> conversation;

  final ValueNotifier<(String, String)> lastReply = ValueNotifier(('', ''));

  final ValueNotifier<bool> loading = ValueNotifier(false);

  final ValueNotifier<AsyncData<List<Conversation>>> conversations =
      ValueNotifier(const Data([]));

  ChatController({
    required OllamaClient client,
    required this.model,
    required ConversationService conversationService,
    Conversation? initialConversation,
  })  : _client = client,
        _conversationService = conversationService,
        conversation = ValueNotifier(
          initialConversation ??
              emptyConversationWith(model.value?.model ?? '/'),
        );

  Future<void> loadHistory() async {
    conversations.value = const Pending();

    try {
      conversations.value =
          Data(await _conversationService.loadConversations());
    } catch (err) {
      _log.severe('ERROR !!! loadHistory $err');
      //conversations.value = AsErr
    }
  }

  /*Future<void> generate() async {
    final name = model.name;

    final image = selectedImage.value;
    String? b64Image;

    if (image != null) {
      b64Image = base64Encode(await image.readAsBytes());
    }

    if (name != null) {
      loading.value = true;
      lastReply.value = (promptFieldController.text, '');
      final request = GenerateCompletionRequest(
        model: name,
        prompt: promptFieldController.text,
        images: b64Image != null ? [b64Image] : null,
      );
      final streamResponse = _client.generateCompletionStream(request: request);

      await for (final chunk in streamResponse) {
        lastReply.value = (
          lastReply.value.$1,
          '${lastReply.value.$2}${chunk.response ?? ''}'
        );
      }

      final messages = conversation.value.messages;
      conversation.value = conversation.value
          .copyWith(newMessages: messages..add(lastReply.value));

      loading.value = false;
      promptFieldController.clear();
    }
  }*/

  Future<void> chat() async {
    if (model.value == null) return;
    scrollController = ScrollController();

    final name = model.value!.model;
    loading.value = true;

    if (name != null) {
      loading.value = true;
      final question = promptFieldController.text;
      lastReply.value = (question, '');

      final image = selectedImage.value;
      String? b64Image;

      if (image != null) {
        b64Image = base64Encode(await image.readAsBytes());
      }

      final generateChatCompletionRequest = GenerateChatCompletionRequest(
        model: name,
        messages: [
          for (final qa in conversation.value.messages) ...[
            Message(role: MessageRole.user, content: qa.$1),
            Message(role: MessageRole.assistant, content: qa.$2),
          ],
          Message(
            role: MessageRole.user,
            content: question,
            images: b64Image != null ? [b64Image] : null,
          ),
        ],
      );

      final streamResponse = _client.generateChatCompletionStream(
        request: generateChatCompletionRequest,
      );

      await for (final chunk in streamResponse) {
        lastReply.value = (
          lastReply.value.$1,
          '${lastReply.value.$2}${chunk.message?.content ?? ''}'
        );

        scrollToEnd();
      }

      final messages = conversation.value.messages;

      final firstQuestion = messages.isNotEmpty ? messages.first.$1 : question;
      conversation.value = conversation.value.copyWith(
        newMessages: messages..add(lastReply.value),
        newTitle:
            firstQuestion /*firstQuestion.substring(0, min(firstQuestion.length, 20))*/,
      );

      _conversationService.saveConversation(conversation.value);
      loadHistory();

      loading.value = false;
      promptFieldController.clear();

      Future.delayed(const Duration(milliseconds: 100), scrollToEnd);
    }
  }

  void scrollToEnd() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.decelerate,
      );
    }
  }

  Future<void> addImage(XFile? image) async {
    selectedImage.value = image;
  }

  void deleteImage() {
    selectedImage.value = null;
  }

  void selectConversation(Conversation value) {
    conversation.value = value;
  }

  void newConversation() {
    conversation.value = Conversation(
      lastUpdate: DateTime.now(),
      model: model.value?.model ?? '/',
      title: 'New Chat',
      messages: [],
    );
  }

  Future<void> deleteConversation(Conversation deletecConversation) async {
    conversation.value = emptyConversationWith(model.value?.model ?? '/');
    await _conversationService.deleteConversation(deletecConversation);
    loadHistory();
  }
}
