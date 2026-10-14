import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/constants/app_constants.dart';
import 'database_platform.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init() : _testDatabase = null;

  @visibleForTesting
  AppDatabase.forTesting(Database database) : _testDatabase = database;

  final Database? _testDatabase;

  Future<Database> get database async {
    if (_testDatabase case final testDatabase?) return testDatabase;
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final path = await databasePath(fileName);
    return await appDatabaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: AppConstants.dbVersion,
        onCreate: _createDB,
        onUpgrade: _upgradeDB,
      ),
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const doubleType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE expenses (
  id $idType,
  merchant $textType,
  amount $doubleType,
  category $textType,
  date $textType,
  photoPath $textNullableType,
  rawOcrText $textNullableType,
  isVerified $integerType,
  createdAt $textType
)
''');
    if (version >= 2) await _createIndexes(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2 && newVersion >= 2) await _createIndexes(db);
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_expenses_category_date '
      'ON expenses(category, date)',
    );
  }

  @visibleForTesting
  Future<void> createSchemaForTesting(Database db, {int version = 1}) =>
      _createDB(db, version);

  @visibleForTesting
  Future<void> upgradeForTesting(Database db, int oldVersion, int newVersion) =>
      _upgradeDB(db, oldVersion, newVersion);

  @visibleForTesting
  Future<void> closeForTesting() async {
    if (_testDatabase case final testDatabase?) await testDatabase.close();
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
    _database = null;
  }
}
