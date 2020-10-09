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

class ProdutoModel extends Entity {
  String id;
  String nome;
  String ordem;
  String valor;
  String quantidade;
  String unidade;
  String precisao;
  String usuarioid;
  String listaid;
  String categoria;
  String categoriaid;
  String purchased;
  String created;
  String updated;
  String deleted;

  ProdutoModel({this.id, this.nome, this.ordem, this.valor, this.quantidade});

  ProdutoModel.fromView({this.id, this.nome, this.ordem, this.valor, this.quantidade,
                         this.unidade, this.precisao, this.usuarioid,
                         this.listaid, this.categoriaid, this.categoria, this.purchased});

  ProdutoModel.fromJson(dynamic json) {
    id = json['id'].toString();
    nome = json['nome'];
    ordem = json['ordem'].toString();
    valor = json['valor'].toString();
    quantidade = json['quantidade'].toString();
    unidade = json['unidade'].toString();
    precisao = json['precisao'].toString();
    usuarioid = json['usuarioid'].toString();
    listaid = json['listaid'].toString();
    categoriaid = json['categoriaid'].toString();
    purchased = json['purchased'].toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['ordem'] = this.ordem;
    data['valor'] = this.valor;
    data['quantidade'] = this.quantidade;
    data['unidade'] = this.unidade;
    data['precisao'] = this.precisao;
    data['usuarioid'] = this.usuarioid;
    data['listaid'] = this.listaid;
    data['categoriaid'] = this.categoriaid;
    data['purchased'] = this.purchased;
    return data;
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.usuarioid}, ${this.listaid}, ${this.categoriaid}, ${this.nome}, '
           '  ${this.ordem}, ${this.quantidade}, ${this.valor}, ${this.unidade}, '
           '  ${this.precisao}, ${this.purchased} }';
  }

  String toSaveJson(){
    String json = convert.json.encode(toJson());
    return json;
  }
}

class ProdutoModelList {
  String id;
  String nome;
  Meta meta;
  List<ProdutoModel> produtos;

  ProdutoModelList(this.id, this.nome, this.meta, [this.produtos]);

  factory ProdutoModelList.fromJson(dynamic json) {
    if (json['data'] != null) {
      var tagObjsJson = json['data'] as List;
      List<ProdutoModel> _produtos = tagObjsJson.map((tagJson) => ProdutoModel.fromJson(tagJson)).toList();

      return ProdutoModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta']),
          _produtos
      );
    } else {
      return ProdutoModelList(
          json['id'] as String,
          json['nome'] as String,
          Meta.fromJson(json['meta'])
      );
    }
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.nome}, ${this.meta}, ${this.produtos} }';
  }
}

class ProdutoEvent extends Event{
  // create, update, delete
  String acao;

  ProdutoEvent(this.acao);

  @override
  String toString() {
    return 'ProdutoEvent{acao: $acao}';
  }
}