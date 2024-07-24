import 'package:noteapp/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 2; // Increment version to handle migration
  static const String _dbName = "Notes.db";

  // Open the database and create it if it does not exist
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async {
        await db.execute(
            '''
          CREATE TABLE Note(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            dateTime TEXT NOT NULL
          );
          '''
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              '''
            ALTER TABLE Note ADD COLUMN dateTime TEXT NOT NULL DEFAULT '2024-01-01T00:00:00.000';
            '''
          );
        }
      },
      version: _version,
    );
  }

  // Insert a new note
  static Future<int> addNote(Note note) async {
    final db = await _getDB();
    return await db.insert(
      "Note",
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing note
  static Future<int> updateNote(Note note) async {
    final db = await _getDB();
    return await db.update(
      "Note",
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a note
  static Future<int> deleteNote(Note note) async {
    final db = await _getDB();
    return await db.delete(
      "Note",
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Retrieve all notes
  static Future<List<Note>?> getAllNotes() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query("Note");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Note.fromJson(maps[index]));
  }
}
