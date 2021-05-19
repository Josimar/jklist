import 'package:jklist/model/entity.dart';
import 'dart:convert' as convert;

import 'package:jklist/services/event_bus.dart';

class Meta {
  String current_page;
  String total;

  Meta(this.current_page, this.total);

  factory Meta.fromJson(dynamic json) {
    return Meta(json['current_page'].toString(), json['total'].toString());
  }

  @override
  String toString() {
    return '{ ${this.current_page}, ${this.total} }';
  }
}

class ListaModel extends Entity {
  String id;
  String titulo;
  String descricao;
  String usuarioid;
  String created;
  String updated;
  String deleted;

  ListaModel({this.id, this.titulo, this.descricao, this.usuarioid});

  ListaModel.fromJson(dynamic json) {
    id = json['id'].toString();
    titulo = json['titulo'];
    descricao = json['descricao'];
    usuarioid = json['usuarioid'].toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['descricao'] = this.descricao;
    data['usuarioid'] = this.usuarioid;
    return data;
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.titulo}, ${this.descricao}, ${this.usuarioid} }';
  }

  String toSaveJson(){
    String json = convert.json.encode(toJson());
    return json;
  }
}

class ListaModelList {
  String id;
  String nome;
  Meta meta;
  List<ListaModel> listas;

  ListaModelList.newDefault(this.id, this.nome, [this.listas]);

  ListaModelList(this.id, this.nome, this.meta, [this.listas]);

  factory ListaModelList.fromJson(dynamic json) {
    if (json['data'] != null && json['data'].length > 0) {
      var tagObjsJson = json['data'] as List;
      List<ListaModel> _listas = tagObjsJson.map((tagJson) => ListaModel.fromJson(tagJson)).toList();

      return ListaModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta']),
          _listas
      );
    } else {
      return ListaModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta'])
      );
    }
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.nome}, ${this.meta}, ${this.listas} }';
  }
}

class ListaEvent extends Event{
  // create, update, delete
  String acao;

  ListaEvent(this.acao);

  @override
  String toString() {
    return 'ListaEvent{acao: $acao}';
  }
}