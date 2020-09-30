import 'package:dio/dio.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/view/lista/lista_model.dart';

class ListaApi{
  static Future<List<ListaModel>> getLista() async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.contentType = 'application/json';

      var url = 'http://josimas.com.br/cakephp/api/v1/listas';

      print(url);

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": token
      };
      Map<String, dynamic> qParams = {
        "api_token": token
      };

      var response = await _dio.get(url, queryParameters: qParams);

      // var tagObjsJson = response.data['data'] as List;
      // final transportes = tagObjsJson.map((tagJson) => TransporteModel.fromJson(tagJson)).toList();

      var objsJson = response.data;

      ListaModelList listDados = ListaModelList.fromJson(objsJson);

      return listDados.listas;
    } catch (error, exception) {
      print("Erro no login $error > $exception");

      // return ResponseApi.error("Não foi possível fazer o login");
    }
  }

  static Future<ResponseApi<ListaModel>> save(ListaModel lista) async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var url = 'http://josimas.com.br/cakephp/api/v1/listas';
      if (lista.id != null){
        url += "/update/${lista.id}";
      }
      lista.usuarioid = userModel.id;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.contentType = 'application/json';

      String json = lista.toSaveJson();

      print('ListaAPI(61) => Save => json ${json}');

      var response = await _dio.post(url, data: json);

      var objsJson = response.data;

      print('ListaAPI(67) => Save => objsJson ${objsJson}');

      if (response.statusCode == 200){
        ListaModel lista = ListaModel.fromJson(objsJson);

        return ResponseApi.ok(lista);
      }

      if (objsJson == null){
        return ResponseApi.error("Não foi salvar nenhum registro");
      }

      return ResponseApi.error(objsJson["error"]);
    }catch(error, exception){
      print("Erro no registro $error > $exception");

      return ResponseApi.error("Não foi possível salvar o registro");
    }
  }

  static Future<ResponseApi<ListaModel>> delete(ListaModel lista) async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var url = 'http://josimas.com.br/cakephp/api/v1/listas';
      url += "/delete/${lista.id}";

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.contentType = 'application/json';

      String json = lista.toSaveJson();

      var response = await _dio.post(url, data: json);

      var objsJson = response.data;

      if (response.statusCode == 200){
        ListaModel trans = ListaModel.fromJson(objsJson);

        return ResponseApi.ok(trans);
      }

      if (objsJson == null){
        return ResponseApi.error("Não foi excluido nenhum registro");
      }

      return ResponseApi.error(objsJson["error"]);
    }catch(error, exception){
      print("Erro no registro $error > $exception");

      return ResponseApi.error("Não foi possível excluir o registro");
    }
  }



}