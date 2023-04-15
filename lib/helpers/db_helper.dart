import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();

    return _database;
  }

  Future<Database> initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'step_count.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE step_counts(id INTEGER PRIMARY KEY AUTOINCREMENT, steps INTEGER, date TEXT)');
  }

  Future<int> insertStepCount(int steps, String date) async {
    final db = await database;

    return await db!.insert('step_counts', {'steps': steps, 'date': date});
  }

  Future<List<Map<String, dynamic>>> getStepCounts(String date) async {
    final db = await database;

    return await db!.query('step_counts', where: 'date = ?', whereArgs: [date]);
  }
}
