import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/utilitarios.dart';
import 'package:jklist/view/lista/lista_bloc.dart';
import 'package:jklist/view/lista/lista_card.dart';
import 'package:jklist/view/lista/lista_form.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/widget/drawer_list.dart';
import 'package:jklist/widget/list_error.dart';

class ListaView extends StatefulWidget {
  @override
  _ListaViewState createState() => _ListaViewState();
}

class _ListaViewState extends State<ListaView> with AutomaticKeepAliveClientMixin<ListaView>{

  final _listaBloc = ListaBloc();

  StreamSubscription<Event> subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _listaBloc.loadLista();

    final bus = EventBus.get(context);
    subscription = bus.stream.listen((Event event) {
      print("Event $event");
      ListaEvent listaEvent = event;
      _listaBloc.loadLista();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _listaBloc.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Listas'),
      ),
      drawer: DrawerList(),
      body: StreamBuilder(
        stream: _listaBloc.stream,
        builder: (context, snapshot){
          if (snapshot.hasError){
            ListError('Não foi possível carregar os dados');
          }
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<ListaModel> listas = snapshot.data;

          return RefreshIndicator(
            child: ListaCard(listas),
            onRefresh: _onRefresh,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onClickAdicionarLista,
      ),
    );

  }

  Future<void> _onRefresh() {
    return _listaBloc.loadLista();
  }


  void _onClickAdicionarLista() {
    push(context, ListaForm());
  }
}
