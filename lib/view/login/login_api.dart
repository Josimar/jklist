import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:jklist/api/response_api.dart';
import 'package:jklist/model/gravatar_model.dart';
import 'package:jklist/model/usuario_model.dart';

class LoginApi{

  static Future<ResponseApi<UsuarioModel>> login(String login, String senha) async {

    try {
      var url = 'http://josimas.com.br/cakephp/api/v1/usuarios/login';

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map params = {
        "email": login.trim(),
        "password": senha.trim()
      };

      String strParams = json.encode(params);

      var response = await http.post(url, body: strParams, headers: headers);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body);

        String email = mapResponse["email"];
        String nome = mapResponse["nome"];
        String admin = mapResponse["admin"];
        String token = mapResponse["token"];

        var content = new Utf8Encoder().convert(email);
        var md5 = crypto.md5;
        var emailGravatar = md5.convert(content);

        String urlGravatar = 'https://pt.gravatar.com/$emailGravatar.json';
        var responseGravatar = await http.get(urlGravatar);

        String thumbnailUrl;

        if (responseGravatar.statusCode == 200) {
          Map mapResponseGravatar = json.decode(responseGravatar.body);

          GravatarModel gravatarModel = GravatarModel.fromJson(mapResponseGravatar);
          if (gravatarModel.entry.length > 0){
            thumbnailUrl = gravatarModel.entry[0].thumbnailUrl;
            mapResponse["urlfoto"] = thumbnailUrl;
          }
        }

        final user = UsuarioModel.fromJson(mapResponse);
        user.save();

        return ResponseApi.ok(user);
      }
      // final user = UsuarioModel.error(json.decode(response.body));
      return ResponseApi.error(json.decode(response.body));
    }catch(error, exception){
      print("Erro no login $error > $exception");

      // final user = UsuarioModel.error("Não foi possível fazer o login");
      return ResponseApi.error("Não foi possível fazer o login");
    }
  }

  static Future<ResponseApi<UsuarioModel>> cadastro(String uid, String email, String  nome, String photoURL, String phone) async {

    try {
      var url = 'http://josimas.com.br/cakephp/api/v1/usuarios/cadastro';

      Map<String, String> headers = {
        "Content-Type": "application/json"
      };

      Map params = {
        "uid": uid,
        "email": email.trim(),
        "name": nome,
        "foto": photoURL,
        "fone": phone,
        "app": "JKList"
      };

      String strParams = json.encode(params);

      print('strParams: ${strParams}');

      var response = await http.post(url, body: strParams, headers: headers);

      if (response.statusCode == 200) {
        Map mapResponse = json.decode(response.body);

        print('mapResponse: ${mapResponse}');

        final user = UsuarioModel.fromJson(mapResponse);
        user.save();

        return ResponseApi.ok(user);
      }
      // final user = UsuarioModel.error(json.decode(response.body));
      return ResponseApi.error(json.decode(response.body));
    }catch(error, exception){
      print("Erro no login $error > $exception");

      // final user = UsuarioModel.error("Não foi possível fazer o login");
      return ResponseApi.error("Não foi possível fazer o login");
    }
  }

}