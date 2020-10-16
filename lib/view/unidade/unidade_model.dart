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

class UnidadeModel extends Entity {
  String id;
  String uid;
  String descricao;
  String precisao;
  String slug;
  String created;
  String updated;
  String deleted;

  UnidadeModel({this.uid, this.id, this.descricao, this.precisao, this.slug});

  UnidadeModel.fromJson(dynamic json) {
    id = json['id'].toString();
    descricao = json['descricao'];
    precisao = json['precisao'];
    slug = json['slug'];
  }

  static UnidadeModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return UnidadeModel(
        uid: documentId,
        id: documentId,
        descricao: map['descricao'],
        precisao: map['precisao'],
        slug: map['slug']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descricao'] = this.descricao;
    data['precisao'] = this.precisao;
    data['slug'] = this.slug;
    return data;
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.uid}, ${this.descricao}, ${this.precisao}, ${this.slug} }';
  }

  String toSaveJson(){
    String json = convert.json.encode(toJson());
    return json;
  }
}

class UnidadeModelList {
  String id;
  String nome;
  Meta meta;
  List<UnidadeModel> unidades;

  UnidadeModelList(this.id, this.nome, this.meta, [this.unidades]);

  factory UnidadeModelList.fromJson(dynamic json) {

    print('@ UnidadeModel @');
    print('json[data]');
    print(json['data']);

    if (json['data'] != null && json['data'].length > 0) {
      var tagObjsJson = json['data'] as List;
      List<UnidadeModel> _listas = tagObjsJson.map((tagJson) => UnidadeModel.fromJson(tagJson)).toList();

      return UnidadeModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta']),
          _listas
      );
    } else {
      return UnidadeModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta'])
      );
    }
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.nome}, ${this.meta}, ${this.unidades} }';
  }
}

class UnidadeEvent extends Event{
  // create, update, delete
  String acao;

  UnidadeEvent(this.acao);

  @override
  String toString() {
    return 'UnidadeEvent{acao: $acao}';
  }
}