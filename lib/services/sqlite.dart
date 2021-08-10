import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLite {
  static Database? _db;

  static Future<void> _onCreate(Database db, int ver) async {
    await db.execute(
      "CREATE TABLE cities(id INTEGER PRIMARY KEY, name TEXT NOT NULL, country TEXT)",
    );
  }

  static Future<void> init() async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'cities.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Database get db {
    init();
    return _db!;
  }
}

class SQLiteHelper {
  Future<List<Map<String, dynamic>>> get cities {
    return SQLite.db.query(
      'cities',
      orderBy: 'id ASC',
    );
  }

  Future<int> insertCity(Map<String, dynamic> city) async {
    final List<Map<String, Object?>> data = await SQLite.db.rawQuery(
      'SELECT * FROM cities WHERE name=? AND country=?',
      [city['name'], city['country']],
    );
    if (data.isNotEmpty) {
      return 0;
    }
    return SQLite.db.insert(
      'cities',
      city,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteCity(int id) {
    return SQLite.db.delete(
      'cities',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
