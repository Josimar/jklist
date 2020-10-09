import 'package:jklist/sqlite/sqlite_dao.dart';
import 'package:jklist/view/produto/produto_model.dart';

class ProdutoSQLite extends SQLiteDAO<ProdutoModel>{

  @override
  String get tableName => "produtos";

  @override
  ProdutoModel fromJson(Map<String, dynamic> map) {
    return ProdutoModel.fromJson(map);
  }

  Future<List<ProdutoModel>> findAllByTipo(T) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from $tableName',);

    return list.map<ProdutoModel>((json) => fromJson(json)).toList();
  }

}