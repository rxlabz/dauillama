import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'model.dart';

const dbFileName = 'db.db';

final _log = Logger('Db');

enum Table { conversation }

/// sqlite DB abstraction
Future<Database> initDB() async {
  if( Platform.isWindows) sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  final documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join(documentsDirectory.path, dbFileName);
  _log.info('DbPath : $path');

  return openDatabase(path, onCreate: _createDb, version: 1);
}

Future<void> _createDb(Database db, [int? version]) => db.execute('''
CREATE TABLE IF NOT EXISTS ${Table.conversation.name}(
  id TEXT NOT NULL PRIMARY KEY,
  model TEXT NOT NULL,
  temperature REAL NOT NULL,
  lastUpdate TEXT NOT NULL,
  title TEXT NOT NULL,
  messages TEXT
)
''');

class ConversationService {
  final Database _db;

  ConversationService(this._db);

  Future<void> saveConversation(Conversation conversation) async {
    await _db.insert(
      Table.conversation.name,
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteConversation(Conversation conversation) async {
    await _db.delete(
      Table.conversation.name,
      where: 'id = ?',
      whereArgs: [conversation.id],
    );
  }

  Future<List<Conversation>> loadConversations() async {
    final rawConversations =
        await _db.query(Table.conversation.name, orderBy: 'lastUpdate DESC');

    return rawConversations.map(Conversation.fromMap).toList();
  }
}
