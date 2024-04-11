import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperVital {
  static Database? _database;
  static const String tableName = 'patientVital';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'patientsVital_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName (
          patientVitalId INTEGER PRIMARY KEY,
          doctorName TEXT,
          bloodPressure INTEGER,
          pulseRate INTEGER,
          respiratoryRate INTEGER,
          bloodOxygen INTEGER,
          height INTEGER,
          weight INTEGER,
          bmi INTEGER,
          patient_uuid TEXT,
          FOREIGN KEY(patient_uuid) REFERENCES patients(uuid)
         )
          ''',
        );
      },
      version: 1,
    );
  }

  static Future<int> insertPatientVital(
      Map<String, dynamic> patientVital) async {
    final db = await database;
    return await db.insert(tableName, patientVital);
  }

  static Future<List<Map<String, dynamic>>> retrievePatientsVital() async {
    final db = await database;
    return await db.query(tableName);
  }

  static Future<List<Map<String, dynamic>>> retrievePatientVitalsByUUID(
      String patientUUID) async {
    final db = await database;
    return await db
        .query(tableName, where: 'patient_uuid = ?', whereArgs: [patientUUID]);
  }

  static Future<int> updatePatientVital(
      Map<String, dynamic> patientVital) async {
    final db = await database;
    return await db.update(
      tableName,
      patientVital,
      where: 'patientVitalId = ?',
      whereArgs: [patientVital['patientVitalId']],
    );
  }

  static Future<int> deletePatientVital(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'patientVitalId = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllVitals() async {
    final db = await database;
    await db.delete(tableName); // Deletes all records from the table
  }
}
