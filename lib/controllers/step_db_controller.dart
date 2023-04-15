import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:untitled/models/StepModel.dart';

class StepDbController {
  late final Database _database;

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'reeder_steps.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE steps(uri TEXT PRIMARY KEY, stepCount INTEGER, dateTime INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertStep(StepModel step) async {
    return await _database.insert(
      'steps',
      step.toMap(), // TODO : milisecond int type casting
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
