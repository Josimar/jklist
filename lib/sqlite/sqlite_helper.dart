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

    var db = await openDatabase(path, version: 6, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    String tableUnidades = 'CREATE TABLE unidades(id INTEGER PRIMARY KEY, uid TEXT, descricao TEXT, precisao TEXT, slug TEXT, created TEXT, updated TEXT, deleted TEXT)';
    String tableCategorias = 'CREATE TABLE categorias(id INTEGER PRIMARY KEY, uid TEXT, categoriaid INTEGER, descricao TEXT, slug TEXT, nivel TEXT, icone TEXT, created TEXT, updated TEXT, deleted TEXT)';
    String tableListas = 'CREATE TABLE listas(id INTEGER PRIMARY KEY, uid TEXT, titulo TEXT, descricao TEXT, usuarioid INTEGER, created TEXT, updated TEXT, deleted TEXT)';
    String tableProdutos = 'CREATE TABLE produtos(id INTEGER PRIMARY KEY, uid TEXT, listaid INTEGER, categoriaid INTEGER, usuarioid INTEGER, ordem TEXT, nome TEXT, valor TEXT, quantidade TEXT, unidade TEXT, precisao TEXT, purchased TEXT, created TEXT, updated TEXT, deleted TEXT)';

    await db.execute(tableUnidades);
    await db.execute(tableCategorias);
    await db.execute(tableListas);
    await db.execute(tableProdutos);
  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    //if (oldVersion == 1 && newVersion == 2) {
      await db.execute("DROP TABLE IF EXISTS unidades");
      await db.execute("DROP TABLE IF EXISTS categorias");
      await db.execute("DROP TABLE IF EXISTS produtos");
      await db.execute("DROP TABLE IF EXISTS listas");
    //}

    String tableUnidades = 'CREATE TABLE unidades(id INTEGER PRIMARY KEY, uid TEXT, descricao TEXT, precisao TEXT, slug TEXT, created TEXT, updated TEXT, deleted TEXT)';
    String tableCategorias = 'CREATE TABLE categorias(id INTEGER PRIMARY KEY, uid TEXT, categoriaid INTEGER, descricao TEXT, slug TEXT, nivel TEXT, icone TEXT, created TEXT, updated TEXT, deleted TEXT)';
    String tableListas = 'CREATE TABLE listas(id INTEGER PRIMARY KEY, uid TEXT, titulo TEXT, descricao TEXT, usuarioid INTEGER, created TEXT, updated TEXT, deleted TEXT)';
    String tableProdutos = 'CREATE TABLE produtos(id INTEGER PRIMARY KEY, uid TEXT, listaid INTEGER, categoriaid INTEGER, usuarioid INTEGER, ordem TEXT, nome TEXT, valor TEXT, quantidade TEXT, unidade TEXT, precisao TEXT, purchased TEXT, created TEXT, updated TEXT, deleted TEXT)';

    await db.execute(tableUnidades);
    await db.execute(tableCategorias);
    await db.execute(tableListas);
    await db.execute(tableProdutos);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
