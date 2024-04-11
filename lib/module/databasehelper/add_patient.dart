import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tableName = 'patients';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'patients_database.db'),
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName (
            uuid TEXT PRIMARY KEY,
            name TEXT,
            age INTEGER,
            email TEXT,
            address TEXT,
            phoneNumber TEXT,
            sex TEXT,
            bloodGroup TEXT,
            birthDate TEXT,
            doctorName TEXT,
            adharNumber TEXT,
            abhaNumber TEXT,
            insurance TEXT,
            mmuId TEXT,
            password TEXT,
            city TEXT,
            village TEXT
          )
          ''',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 3) {
          db.execute('ALTER TABLE $tableName ADD COLUMN password TEXT');
          db.execute('ALTER TABLE $tableName ADD COLUMN city TEXT');
          db.execute('ALTER TABLE $tableName ADD COLUMN village TEXT');
          db.execute('ALTER TABLE $tableName ADD COLUMN uuid TEXT');
        }
      },
      version: 3, // Increment the version number
    );
  }

  static Future<int> insertPatient(Map<String, dynamic> patient) async {
    final db = await database;
    return await db.insert(tableName, patient);
  }

  static Future<List<Map<String, dynamic>>> retrievePatients() async {
    final db = await database;
    return await db.query(tableName);
  }

  static Future<int> updatePatient(Map<String, dynamic> patient) async {
    final db = await database;
    return await db.update(
      tableName,
      patient,
      where: 'uuid = ?',
      whereArgs: [patient['uuid']],
    );
  }

  static Future<int> deletePatient(String uuid) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }
  static Future<void> deleteAllPatients() async {
    final db = await database;
    await db.delete(tableName); // Deletes all records from the table
  }
}
