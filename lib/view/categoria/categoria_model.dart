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

class CategoriaModel extends Entity {
  String id;
  String uid;
  String categoriaid;
  String descricao;
  String slug;
  String nivel;
  String icone;
  String hoverbackgroundcolor;
  String backgroundcolor;
  String created;
  String updated;
  String deleted;

  CategoriaModel({this.uid, this.id, this.descricao, this.slug, this.icone});

  CategoriaModel.fromJson(dynamic json) {
    id = json['id'].toString();
    descricao = json['descricao'];
    slug = json['slug'];
    icone = json['icone'].toString();
  }

  static CategoriaModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return CategoriaModel(
      uid: documentId,
      id: documentId,
      descricao: map['descricao'],
      slug: map['slug'],
      icone: map['icone']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['slug'] = this.slug;
    data['icone'] = this.icone;
    return data;
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.descricao}, ${this.slug}, ${this.icone} }';
  }

  String toSaveJson(){
    String json = convert.json.encode(toJson());
    return json;
  }
}

class CategoriaModelList {
  String id;
  String nome;
  Meta meta;
  List<CategoriaModel> categorias;

  CategoriaModelList(this.id, this.nome, this.meta, [this.categorias]);

  factory CategoriaModelList.fromJson(dynamic json) {
    if (json['data'] != null && json['data'].length > 0) {
      var tagObjsJson = json['data'] as List;
      List<CategoriaModel> _listas = tagObjsJson.map((tagJson) => CategoriaModel.fromJson(tagJson)).toList();

      return CategoriaModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta']),
          _listas
      );
    } else {
      return CategoriaModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta'])
      );
    }
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.nome}, ${this.meta}, ${this.categorias} }';
  }
}

class CategoriaEvent extends Event{
  // create, update, delete
  String acao;

  CategoriaEvent(this.acao);

  @override
  String toString() {
    return 'CategoriaEvent{acao: $acao}';
  }
}