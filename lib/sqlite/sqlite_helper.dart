import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper.getInstance();
  SQLiteHelper.getInstance();

  factory SQLiteHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();

    return _db;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'listas.db');
    // print("db $path");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    String tableListas = 'CREATE TABLE listas(id INTEGER PRIMARY KEY, nome TEXT, usuarioid INTEGER, created TEXT, updated TEXT, deleted TEXT)';
    String tableProdutos = 'CREATE TABLE produtos(id INTEGER PRIMARY KEY, listaid INTEGER, nome TEXT)';

    await db.execute(tableListas);
    await db.execute(tableProdutos);
  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if(oldVersion == 1 && newVersion == 2) {
      await db.execute("CREATE TABLE produtos(id INTEGER PRIMARY KEY, listaid INTEGER, nome TEXT)");
    }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
