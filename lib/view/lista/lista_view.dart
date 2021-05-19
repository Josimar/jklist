import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_api.dart';
import 'package:jklist/view/lista/lista_bloc.dart';
import 'package:jklist/view/lista/lista_card.dart';
import 'package:jklist/view/lista/lista_form.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/login/login_view.dart';
import 'package:jklist/widget/carregando.dart';
import 'package:jklist/widget/drawer_list.dart';
import 'package:jklist/widget/list_error.dart';

class ListaView extends StatefulWidget {
  @override
  _ListaViewState createState() => _ListaViewState();
}

class _ListaViewState extends State<ListaView> with AutomaticKeepAliveClientMixin<ListaView>{

  final _listaBloc = ListaBloc();
  bool _voltaLogin = false;

  StreamSubscription<Event> subscription;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _tTitulo = TextEditingController();
  final _tDescricao = TextEditingController();

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

    if (_voltaLogin){
      push(context, LoginView(), replace: true);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Listas'),
        actions: [
          GestureDetector(
            child: Icon(Icons.add),
            onTap: (){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext ctx){

                    final _inputTitulo = Form(
                      key: _formKey,
                      child: TextFormField(
                          autofocus: true,
                          controller: _tTitulo,
                          decoration: InputDecoration(
                            hintText: "Nome da lista",
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          validator: (value){
                            if (value.isEmpty){
                              return "nome obrigatório";
                            }
                            return null;
                          }
                      ),
                    );

                    return AlertDialog(
                      title: Text("Nome da lista"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            _inputTitulo,
//                            _inputDescricao,
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Cancelar',
                            style: TextStyle(color: Layout.light()),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        ),
                        RaisedButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            'Adicionar',
                            style: TextStyle(color: Layout.light()),
                          ),
                          onPressed: () async {

                            if (_formKey.currentState.validate()){
                              var listaAtual = ListaModel();
                              listaAtual.titulo = _tTitulo.text;
                              listaAtual.descricao = _tDescricao.text;

                              ResponseApi<ListaModel> response = await ListaApi.save(listaAtual);

                              if (response.ok){
                                Navigator.of(ctx).pop();
                                push(ctx, ListaView());
                              }
                            }

                          },
                        )
                      ],
                    );

                  });
            },
          ),
          Padding(padding: EdgeInsets.only(right: 20)),
        ],
      ),
      drawer: DrawerList(),
      body: StreamBuilder(
        stream: _listaBloc.stream,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Carregando();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError){
                return ListError('Não foi possível carregar os dados');
              }else{
                ListaModelList listaModel = snapshot.data;
                List<ListaModel> listas = listaModel.listas;

                if (listaModel.id == 'Erro' && listaModel.nome == '401'){
                  push(context, ListaView(), replace: true);
                  // return ListTile(
                  //   leading: Icon(Icons.error),
                  //   title: Text(DSStringLocal.deslogarDados),
                  //   trailing: Icon(Icons.exit_to_app),
                  // );
                }

                if (listas.length == 0){
                  // return ListError(DSStringLocal.emptyDados);
                  return ListTile(
                    leading: Icon(Icons.pages),
                    title: Text(DSStringLocal.emptyDados),
                    trailing: Icon(Icons.more_vert),
                  );
                }
                return RefreshIndicator(
                  child: ListaCard(TipoVisualizacao.LIST, listas),
                  onRefresh: _onRefresh,
                );
              }
              break;
            default:
              return ListError('Não foi possível carregar os dados');
          }
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
