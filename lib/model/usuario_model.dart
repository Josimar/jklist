import 'dart:convert';
import 'package:jklist/preferencias.dart';

class UsuarioModel{

  String login;
  String id;
  String nome;
  String email;
  String urlfoto;
  String token;
  String admin;

  List<String> roles;

  UsuarioModel({
    this.id,
    this.nome,
    this.email,
    this.urlfoto,
    this.roles
  });

  UsuarioModel.fromJson(Map<String, dynamic> map){
    id = map["id"].toString();
    nome = map["nome"];
    email = map["email"];
    urlfoto = map["urlfoto"];
    token = map["token"];
    roles = getRoles(map);
  }

  UsuarioModel.nomeEmail(this.nome, this.email);

  UsuarioModel.fromAll(this.login, this.nome, this.id, this.email, this.token, this.admin);

  @override
  String toString() {
    return 'UsuarioModel{login: $login, nome: $nome, id: $id, email: $email, token: $token, admin: $admin, urlfoto: $urlfoto}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['email'] = this.email;
    data['urlfoto'] = this.urlfoto;
    data['token'] = this.token;
    return data;
  }

  static List<String> getRoles(Map<String, dynamic> map) {
    List list = map["roles"];
    if (list == null)
      return null;

    /*
    List<String> roles = [];
    for (String role in list){
      roles.add(role);
    }
    */

    List<String> roles = list.map((role) => role.toString()).toList();

    return roles;
  }

  void save() {
    Map map = toJson();
    String jsonUser = json.encode(map);
    Preferencias.setString("user.prefs", jsonUser);
  }

  static Future<UsuarioModel> get() async {
    String jsonPrefs = await Preferencias.getString("user.prefs");
    if (jsonPrefs.isEmpty){
      return null;
    }
    Map mapPref = json.decode(jsonPrefs);
    UsuarioModel userModel = UsuarioModel.fromJson(mapPref);
    return userModel;
  }

  static void clear() {
    Preferencias.setString("user.prefs", "");
  }
}