import 'package:jklist/sqlite/sqlite_dao.dart';
import 'package:jklist/view/lista/lista_model.dart';

class ListaSQLite extends SQLiteDAO<ListaModel>{

  @override
  String get tableName => "listas";

  @override
  ListaModel fromJson(Map<String, dynamic> map) {
    return ListaModel.fromJson(map);
  }

  Future<List<ListaModel>> findAllByTipo(T) async {
    final dbClient = await db;

    final list = await dbClient.rawQuery('select * from $tableName',);

    return list.map<ListaModel>((json) => fromJson(json)).toList();
  }

}