import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jklist/view/unidade/unidade_model.dart';

class UnidadeService {

  Future getUnidade() async {
    List<UnidadeModel> unidades = new List<UnidadeModel>();

    UnidadeModel unidade1 = new UnidadeModel(uid:'u1', id:'1', descricao:'Unidade', precisao:'1', slug:'unidade');
    unidades.add(unidade1);
    UnidadeModel unidade2 = new UnidadeModel(uid:'u2', id:'2', descricao:'Grama', precisao:'1', slug:'grama');
    unidades.add(unidade2);
    UnidadeModel unidade3 = new UnidadeModel(uid:'u3', id:'3', descricao:'Quilo', precisao:'1', slug:'quilo');
    unidades.add(unidade3);
    UnidadeModel unidade4 = new UnidadeModel(uid:'u4', id:'4', descricao:'Caixa', precisao:'1', slug:'caixa');
    unidades.add(unidade4);
    UnidadeModel unidade5 = new UnidadeModel(uid:'u5', id:'5', descricao:'Litro', precisao:'1', slug:'litro');
    unidades.add(unidade5);
    UnidadeModel unidade6 = new UnidadeModel(uid:'u6', id:'6', descricao:'ML', precisao:'1', slug:'ml');
    unidades.add(unidade6);
    /*
    Fardos, Frascos, Garrafas, Latas, Pacotes, Pedaços, Potes, Rolos
    */
    return unidades;
  }

  Future getUnidadeFirebase() async {
    CollectionReference _unidadeCR = FirebaseFirestore.instance.collection('unidades');

    try {
      var unidadesDS = await _unidadeCR.orderBy('descricao', descending: false).get();
      if (unidadesDS.docs.isNotEmpty){
        return unidadesDS.docs
            .map((snapshot) => UnidadeModel.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.descricao != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUnidadeAPI() async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.headers["authorization"] = "token $token";
      _dio.options.contentType = 'application/json';
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';

      var url = 'http://josimas.com.br/cakephp/api/v1/unidadecompra';

      Map<String, dynamic> qParams = {
        "api_token": token
      };

      // print('URL: $url');
      // print('Token: $token');

      var response = await _dio.get(url, queryParameters: qParams);

      var objsJson = response.data;

//      print('objsJson: $objsJson');

      UnidadeModelList listDados = UnidadeModelList.fromJson(objsJson);

      print('listDados: $listDados');

      return listDados.unidades;
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      // return ResponseApi.error("Não foi possível fazer o login");
    }
  }

  Future getUnidadeSQLite() async {

  }

}