import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperPrescription {
  static Database? _database;
  static const String tableName = 'patientsPrescription';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'patientsPrescription_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            doctorName TEXT,
            symptom TEXT,
            medicine TEXT,
            note TEXT,
            mmuId INTEGER,
            date TEXT,
            advice TEXT,
            state TEXT,
            patient_uuid TEXT,
            FOREIGN KEY(patient_uuid) REFERENCES patients(uuid)
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE $tableName ADD COLUMN advice TEXT');
          db.execute('ALTER TABLE $tableName ADD COLUMN state TEXT');
        }
      },
      version: 2, // Increment the version number
    );
  }

  static Future<int> insertPatientPrescription(
      Map<String, dynamic> patientsPrescription) async {
    final db = await database;
    return await db.insert(tableName, patientsPrescription);
  }

  static Future<List<Map<String, dynamic>>>
      retrievePatientsPrescription() async {
    final db = await database;
    return await db.query(tableName);
  }

  static Future<List<Map<String, dynamic>>> retrievePatientPrescriptionsByUUID(
      String patientUUID) async {
    final db = await database;
    return await db
        .query(tableName, where: 'patient_uuid = ?', whereArgs: [patientUUID]);
  }

  static Future<int> updatePatientPrescription(
      Map<String, dynamic> patientsPrescription) async {
    final db = await database;
    return await db.update(
      tableName,
      patientsPrescription,
      where: 'id = ?',
      whereArgs: [patientsPrescription['id']],
    );
  }

  static Future<int> deletePatientPrescription(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAllPrescription() async {
    final db = await database;
    await db.delete(tableName); // Deletes all records from the table
  }
}

// import 'dart:async';
// import 'dart:io';
//
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
//
// class PatientPrescriptionHelper {
//   static Database? _database;
//   static final _dbName = 'example.db';
//   static final _dbVersion = 2;
//
//   static Future<Database> get database async {
//     if (_database != null) return _database!;
//
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   static Future<Database> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _dbName);
//     return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
//   }
//
//   static Future<void> _onCreate(Database db, int version) async {
//     await db.execute(
//       'CREATE TABLE PatientPrescription(id INTEGER PRIMARY KEY,doctorName TEXT,note TEXT,symptom TEXT,medicine TEXT,date TEXT,patientId INTEGER)',
//     );
//   }
//
//   static Future<int> insertUser(Map<String, dynamic> patient) async {
//     Database db = await database;
//     return await db.insert('PatientPrescription', patient,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   static Future<List<Map<String, dynamic>>> retrieveUsers() async {
//     Database db = await database;
//     return await db.query('PatientPrescription');
//   }
// }
