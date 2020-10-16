import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/produto/produto_compra.dart';
import 'package:jklist/widget/carregando.dart';
import 'package:jklist/widget/list_error.dart';
import 'package:jklist/widget/drawer_list.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/produto/produto_add.dart';
import 'package:jklist/view/produto/produto_bloc.dart';
import 'package:jklist/view/produto/produto_dados.dart';
import 'package:jklist/view/produto/produto_model.dart';

class ProdutoView extends StatefulWidget {
  final ListaModel lista;
  ProdutoView(this.lista);

  @override
  _ProdutoViewState createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> with AutomaticKeepAliveClientMixin<ProdutoView>{

  final _produtoBloc = ProdutoBloc();
  String _filterText = "";

  StreamSubscription<Event> subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _produtoBloc.loadProdutos(widget.lista.id);

    final bus = EventBus.get(context);
    subscription = bus.stream.listen((Event event) {
      print("Event $event");
      ProdutoEvent produtoEvent = event;
      _produtoBloc.loadProdutos(widget.lista.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _produtoBloc.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Locale myLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lista.titulo),
        actions: [
          GestureDetector(
            child: Icon(Icons.launch),
            onTap: (){
              push(context, ProdutoCompra());
            },
          ),
          Padding(padding: EdgeInsets.only(right: 20)),
        ]
      ),
//      drawer: DrawerList(),
      body: Column(
        children: [
          Container(
              color: Color.fromRGBO(230, 230, 230, 0.5),
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 80,
                    child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'pesquisar',
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)
                          )
                      ),
                      onChanged: (text){
                        setState(() {
                          _filterText = text;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: (){
                          push(context, ProdutoAdd(lista: widget.lista, produto: null));
                        },
                        child: Icon(Icons.add),
                      )
                  ),
                ],
              )
          ),
          Container(
            height: MediaQuery.of(context).size.height - 235,
            child: StreamBuilder(
              stream: _produtoBloc.stream,
              builder: (context, snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Carregando();
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return ListError('Não foi possível carregar os dados');
                    }else if(!snapshot.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else{
                      List<ProdutoModel> produtos = snapshot.data;

                      if (produtos.length == 0){
                        return ListTile(
                          leading: Icon(Icons.pages),
                          title: Text(DSStringLocal(myLocale).listaVazia),
                          trailing: Icon(Icons.more_vert),
                        );
                      }

                      return RefreshIndicator(
                        child: ProdutoDados(TipoVisualizacao.LIST, widget.lista, produtos),
                        onRefresh: _onRefresh,
                      );

                      return RefreshIndicator(
                        child: Column(
                          children: [
                            Container(
                                color: Color.fromRGBO(230, 230, 230, 0.5),
                                padding: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 80,
                                      child: TextField(
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintText: "pesquisar",
                                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(32)
                                            )
                                        ),
                                        onChanged: (text){
                                          setState(() {
                                            _filterText = text;
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    SizedBox(
                                        child: FloatingActionButton(
                                          mini: true,
                                          // backgroundColor: Layout.info(),
                                          onPressed: (){
                                            // ItemAddPage.itemMap = null;
                                            // Navigator.of(context).pushNamed(ItemAddPage.tag);
                                          },
                                          child: Icon(Icons.add),
                                        )
                                    ),
                                  ],
                                )
                            ),
                            ProdutoDados(TipoVisualizacao.LIST, widget.lista, produtos)
                          ],
                        ),
                        onRefresh: _onRefresh,
                      );
                    }
                    break;
                  default:
                    return ListError('Não foi possível carregar os dados');
                }
              },
            ),
          ),
          Container(
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromRGBO(100, 150, 255, 0.3),
                        Color.fromRGBO(255, 150, 240, 0.3),
                      ]
                  )
              ),
              child: StreamBuilder(
                  stream: _produtoBloc.stream,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(child: Text('carregando'));
                      default:
                        if (snapshot.hasError){
                          print(snapshot.error);
                          return Text("Error: ${snapshot.error}");
                        }else{

                          List<ProdutoModel> produtos = snapshot.data;

                          // Total de itens
                          int qtdTotal = produtos.length;

                          int qtdChecked = 0;

                          double subTotal = 0.0;
                          double vlrTotal = 0.0;

                          for (ProdutoModel item in produtos){

                            String strValor = item.valor ?? 0;
                            String qtdValStr = item.quantidade ?? 0;
                            bool isChecked = item.purchased == '1';

                            // print(strValor);

                            double realVal = currencyToDouble(strValor);
                            double qtdVal = currencyToQuantity(qtdValStr);

                            // print(realVal);
                            // print(qtdVal);

                            // print('item.precisao');
                            // print(item.precisao);
                            // print('item.precisao == "1"');
                            // print(item.precisao == "1");

                            double valTotal = (realVal * qtdVal);
                            if (item.precisao == "1") {
                              valTotal = realVal;
                            }

                            // print('valTotal');
                            // print(valTotal);

                            // print(valTotal);

                            subTotal += valTotal;

                            if (isChecked){
                              qtdChecked++;
                              vlrTotal += valTotal;
                            }
                          }

                          // Quando todos os itens forem marcados o texto fica verde
                          bool isClosed = (subTotal == vlrTotal);

                          return Row(
                            children: <Widget>[
                              Container(
                                  width: (MediaQuery.of(context).size.width / 2),
                                  padding:EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(children: <Widget>[Text("Items"), Text(qtdTotal.toString(), textScaleFactor: 1.2,)],),
                                      Column(children: <Widget>[Text("Carrinho"), Text(qtdChecked.toString(), textScaleFactor: 1.2,)],),
                                      Column(children: <Widget>[Text("Faltando"), Text((qtdTotal - qtdChecked).toString(), textScaleFactor: 1.2,)],)
                                    ],
                                  )
                              ),
                              Container(
                                color: Color.fromRGBO(0, 0, 0, 0.04),
                                width: (MediaQuery.of(context).size.width / 2),
                                padding: EdgeInsets.only(left:10, top:10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        'Sub: ' + doubleToCurrency(subTotal),
                                        style: TextStyle(
                                          fontSize: 18,
                                          // color: Layout.danger(0.6),
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                        'Total: ' + doubleToCurrency(vlrTotal),
                                        style: TextStyle(
                                          fontSize: 20,
                                          // color: isClosed ? Layout.success() : Layout.info(),
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                    }
                  }
              )
          )
        ],
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onClickAdicionarProduto,
      ),
       */
    );

  }

  Future<void> _onRefresh() {
    return _produtoBloc.loadProdutos(widget.lista.id);
  }

  void _onClickAdicionarProduto() {

  }
}
