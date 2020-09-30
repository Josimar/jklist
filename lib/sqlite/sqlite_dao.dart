import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:jklist/model/entity.dart';
import 'package:jklist/sqlite/sqlite_helper.dart';

// Data Access Object
abstract class SQLiteDAO<T extends Entity> {

  Future<Database> get db => SQLiteHelper.getInstance().db;

  String get tableName;

  T fromJson(Map<String, dynamic> map);

  Future<int> save(T entity) async {
    var dbClient = await db;
    var id = await dbClient.insert(tableName, entity.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    // print('id: $id');
    return id;
  }

  Future<List<T>> query(String sql, [List<dynamic> arguments]) async {
    final dbClient = await db;
    final list = await dbClient.rawQuery(sql, arguments);
    return list.map<T>((json) => fromJson(json)).toList();
  }

  Future<List<T>> findAll() async {
    return query('select * from $tableName');
    /*
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from $tableName');

    return list.map<T>((json) => fromJson(json)).toList();
   */
  }

  Future<T> findById(String id) async {
    var dbClient = await db;
    final list =
    await dbClient.rawQuery('select * from $tableName where id = ?', [id]);

    if (list.length > 0) {
      return fromJson(list.first);
    }

    return null;
  }

  Future<bool> exists(String id) async {
    T c = await findById(id);
    var exists = c != null;
    return exists;
  }

  Future<int> count() async {
    final dbClient = await db;
    final list = await dbClient.rawQuery('select count(*) from $tableName');
    return Sqflite.firstIntValue(list);
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from $tableName where id = ?', [id]);
  }

  Future<int> deleteAll() async {
    var dbClient = await db;
    return await dbClient.rawDelete('delete from $tableName');
  }
}
