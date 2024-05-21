import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:uuid/uuid.dart';

extension ModelExtensions on Model {
  DateTime? get lastUpdate =>
      modifiedAt == null ? null : DateTime.tryParse(modifiedAt!);

  String get formattedLastUpdate =>
      lastUpdate != null ? DateFormat('dd/MM/yyyy').format(lastUpdate!) : '';
}

class Conversation {
  final String id;

  final String model;

  final double temperature;

  final DateTime lastUpdate;

  String get formattedDate => DateFormat('dd/MM/yyyy').format(lastUpdate);

  final String title;

  final List<(String, String)> messages;

  Conversation({
    required this.lastUpdate,
    required this.model,
    required this.title,
    required this.messages,
    this.temperature = 1.0,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
        'id': id,
        'model': model,
        'temperature': temperature,
        'lastUpdate': lastUpdate.toIso8601String(),
        'title': title,
        'messages': jsonEncode(
          messages.map((e) => [e.$1, e.$2]).toList(),
        ),
      };

  /*String toJson() => jsonEncode({
        'date': lastUpdate.toIso8601String(),
        'messages': messages.map((e) => [e.$1, e.$2]).toList(),
      });*/

  /*factory Conversation.fromJson(String json) {
    final data = Map<String, dynamic>.from(jsonDecode(json));

    return Conversation(
      id: data['date'],
      model: data['model'],
      temperature: data['temperature'],
      lastUpdate: DateTime.parse(data['date']),
      title: data['title'],
      messages: List<List<String>>.from(data['messages'])
          .map((e) => (e.first, e.last))
          .toList(),
    );
  }*/

  factory Conversation.fromMap(Map<String, dynamic> data) {
    final messages = List.from(jsonDecode(data['messages']))
        .map((e) => List<String>.from(e))
        .map((e) => (e.first, e.last))
        .toList();

    return Conversation(
      id: data['id'],
      model: data['model'],
      temperature: data['temperature'],
      lastUpdate: DateTime.parse(data['lastUpdate']),
      title: data['title'],
      messages: messages,
    );
  }

  Conversation copyWith({
    String? newTitle,
    List<(String, String)>? newMessages,
  }) =>
      Conversation(
        id: id,
        model: model,
        lastUpdate: lastUpdate,
        title: newTitle ?? title,
        messages: newMessages ?? messages,
      );

  @override
  String toString() {
    return 'Conversation{id: $id, model: $model, temperature: $temperature, lastUpdate: $lastUpdate, title: $title, messages: $messages}';
  }
}
