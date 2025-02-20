import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // Singleton
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_SNO = "s_no";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  Database? _database;

  // Get database instance
  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $TABLE_NOTE ("
          "$COLUMN_NOTE_SNO INTEGER PRIMARY KEY AUTOINCREMENT, "
          "$COLUMN_NOTE_TITLE TEXT, "
          "$COLUMN_NOTE_DESC TEXT)",
        );
      },
    );
  }

  // Insert a note
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    final db = await database;
    int rowsAffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc,
    });
    return rowsAffected > 0;
  }

  // Get all notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final db = await database;
    return await db.query(TABLE_NOTE);
  }

  // Update a note
  Future<bool> updateNote({
    required int id,
    required String mTitle,
    required String mDesc,
  }) async {
    final db = await database;
    int rowsAffected = await db.update(
      TABLE_NOTE,
      {COLUMN_NOTE_TITLE: mTitle, COLUMN_NOTE_DESC: mDesc},
      where: "$COLUMN_NOTE_SNO = ?",
      whereArgs: [id],
    );
    return rowsAffected > 0;
  }

  // Delete a note
  Future<bool> deleteNote({required int sno}) async {
    final db = await database;
    int rowsAffected = await db.delete(
      TABLE_NOTE,
      where: "$COLUMN_NOTE_SNO = ?",
      whereArgs: [sno],
    );
    return rowsAffected > 0;
  }
}
