import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/grocery_item.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('grocery.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        category TEXT NOT NULL,
        imagePath TEXT,
        purchased INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertItem(GroceryItem item) async {
    final db = await database;
    final map = item.toMap();
    // remove id so DB can autoincrement when inserting
    map.remove('id');
    return await db.insert('groceries', map);
  }

  Future<List<GroceryItem>> getItems() async {
    final db = await database;
    final maps = await db.query('groceries', orderBy: 'id DESC');
    return maps.map((m) => GroceryItem.fromMap(m)).toList();
  }

  Future<int> updateItem(GroceryItem item) async {
    final db = await database;
    return await db.update(
      'groceries',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> updatePurchasedStatus(int id, bool purchased) async {
    final db = await database;
    return await db.update(
      'groceries',
      {'purchased': purchased ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'groceries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
