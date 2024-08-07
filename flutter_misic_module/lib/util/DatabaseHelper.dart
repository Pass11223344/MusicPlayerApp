import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final _dbName = 'my_database.db';
  static final _dbVersion = 1;

  static final table = 'user_table';



  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        userId INTEGER PRIMARY KEY,
        avatarUrl TEXT,
        backgroundUrl TEXT,
        nickname TEXT,
        birthday INTEGER,
        province INTEGER,
        gender INTEGER,
        city INTEGER,
        followeds INTEGER,
        follows INTEGER,
        eventCount INTEGER,
        level INTEGER,
        time TEXT
      )
    ''');
  }


  Future<int> insert(Map<String,dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    Database db = await database;
    return await db.query(table);
  }

  Future<int> updateItem(int id, String key,String value) async {
    Database db = await database;
    return await db.update(table, {key: value}, where: 'userId = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    Database db = await database;
    return await db.delete(table, where: 'userId = ?', whereArgs: [id]);
  }
}
