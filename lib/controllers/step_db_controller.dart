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
          'CREATE TABLE userSteps(uri TEXT PRIMARY KEY, stepCount INTEGER, date INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertStep(StepModel step) async {
    print(step.toJson());
    return await _database.insert(
      'userSteps',
      step.toJson(), // TODO : milisecond int type casting
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  getStepsAt(DateTime date) async {
    var epochTimeLast =
        DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    var epochTimeFirst =
        DateTime(date.year, date.month, date.day + 1).millisecondsSinceEpoch;
    var timeLast = await _database.query(
      'userSteps',
      where: '"date" > $epochTimeLast',
      orderBy: 'date ASC',
    );
    var timeFirst = await _database.query(
      'userSteps',
      where: '"date" < $epochTimeFirst',
      orderBy: 'date DESC',
    );
/*    print("TimeLast: " + timeLast[0]["stepCount"].toString());
    print("TimeFirst: " + timeFirst[0]["stepCount"].toString());*/
    int? firstStep = timeFirst.length > 0
        ? int.tryParse(timeFirst[0]["stepCount"].toString())
        : 0;
    int? lastStep = timeLast.length > 0
        ? int.tryParse(timeLast[0]["stepCount"].toString())
        : 0;
    //   print("Total Steps: " + ((firstStep ?? 0) - (lastStep ?? 0)).toString());
    return ((firstStep ?? 0) - (lastStep ?? 0) > 0
        ? (firstStep ?? 0) - (lastStep ?? 0)
        : 0);
  }
}
