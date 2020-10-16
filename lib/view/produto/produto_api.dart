import 'package:dio/dio.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/view/produto/produto_model.dart';
import 'package:jklist/core/logging/logger.dart';

class ProdutoApi{
  static Future<List<ProdutoModel>> getProdutos(listaid) async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.headers["authorization"] = "token $token";
      _dio.options.contentType = 'application/json';
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';

      var url = 'http://josimas.com.br/cakephp/api/v1/produtocompra/lista/' + listaid.toString();

      Map<String, dynamic> qParams = {
        "api_token": token,
        "conditions": "listaid:=:" + listaid.toString()
      };

      // print('URL: $url');
      // print('Token: $token');
      // print('conditions: ' + "listaid:=:" + listaid.toString());

      var response = await _dio.get(url, queryParameters: qParams);

      var objsJson = response.data;

      // print('objsJson: $objsJson');

      ProdutoModelList listDados = ProdutoModelList.fromJson(objsJson);

      // print('listDados: $listDados');

      return listDados.produtos;
    } catch (error, exception) {
      print("Erro no produto API $error > $exception");

      // return ResponseApi.error("Não foi possível fazer o login");
    }
  }

  static Future<ResponseApi<ProdutoModel>> save(ProdutoModel produto) async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.headers["authorization"] = "token $token";
      _dio.options.contentType = 'application/json';
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';

      Map<String, dynamic> qParams = {
        "api_token": token
      };

      var url = 'http://josimas.com.br/cakephp/api/v1/produtocompra';
      if (produto.id == null || produto.id == 'null' || produto.id == ''){

      }else{
        url += "/update/${produto.id}";
      }
      produto.usuarioid = userModel.id;

      // print('produto.id: ${produto.id}');
      // print('URL: $url');
      // print('Token: $token');

      String json = produto.toSaveJson();

      // print('ListaAPI(61) => Save => json ${json}');

      var response = await _dio.post(url, data: json, queryParameters: qParams);

      var objsJson = response.data;

      // print('ListaAPI(67) => Save => objsJson ${objsJson}');

      if (response.statusCode == 200){
        ProdutoModel produto = ProdutoModel.fromJson(objsJson);

        return ResponseApi.ok(produto);
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

  static Future<ResponseApi<ProdutoModel>> updateOrder(ProdutoModel produto) async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var url = 'http://josimas.com.br/cakephp/api/v1/produtocompra';
      if (produto.id != null){
        url += "/order/${produto.id}";
      }
      produto.usuarioid = userModel.id;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.headers["authorization"] = "token $token";
      _dio.options.contentType = 'application/json';
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';

      Map<String, dynamic> qParams = {
        "api_token": token
      };

      String json = produto.toSaveJson();

      print('ListaAPI(61) => Save => json ${json}');

      var response = await _dio.post(url, data: json, queryParameters: qParams);

      var objsJson = response.data;

      print('ListaAPI(67) => Save => objsJson ${objsJson}');

      if (response.statusCode == 200){
        ProdutoModel produto = ProdutoModel.fromJson(objsJson);

        return ResponseApi.ok(produto);
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

  static Future<ResponseApi<ProdutoModel>> delete(ProdutoModel produto) async {
    try {
      UsuarioModel userModel = await UsuarioModel.get();
      String token = userModel.token;

      var _dio = new Dio();
      _dio.options.headers['Authorization'] = 'bearer ' + token;
      _dio.options.headers["authorization"] = "token $token";
      _dio.options.contentType = 'application/json';
      _dio.options.headers['content-Type'] = 'application/json';
      _dio.options.headers['Accept'] = 'application/json';

      Map<String, dynamic> qParams = {
        "api_token": token
      };

      var url = 'http://josimas.com.br/cakephp/api/v1/produtocompra';
      url += "/delete/${produto.id}";

      // print('produto.id: ${produto.id}');
      // print('URL: $url');
      // print('Token: $token');

      String json = produto.toSaveJson();

      // print('ListaAPI(61) => Save => json ${json}');

      var response = await _dio.post(url, data: json, queryParameters: qParams);

      var objsJson = response.data;

      // print('ListaAPI(67) => Save => objsJson ${objsJson}');

      if (response.statusCode == 200){
        ProdutoModel trans = ProdutoModel.fromJson(objsJson);

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