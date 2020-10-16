import 'package:flutter/material.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/view/produto/produto_api.dart';
import 'package:jklist/widget/alert.dart';
import 'package:jklist/widget/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/produto/produto_add.dart';
import 'package:jklist/view/produto/produto_model.dart';

class ProdutoDados extends StatefulWidget {
  final TipoVisualizacao tipoVisualizacao;
  final ListaModel lista;
  final List<ProdutoModel> produtos;
  ProdutoDados(this.tipoVisualizacao, this.lista, this.produtos);

  @override
  _ProdutoDadosState createState() => _ProdutoDadosState();
}

class _ProdutoDadosState extends State<ProdutoDados> {
  List<ProdutoModel> produtos;
  ProdutoModel produto;

  @override
  Widget build(BuildContext context) {
    produtos = widget.produtos;

    return Container(
        padding: EdgeInsets.all(5),
        child: widget.tipoVisualizacao == TipoVisualizacao.LISTREORD
            ? ReorderableListView(
                onReorder: _onReorder,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: List.generate(
                    produtos.length,
                    (index){
                      return ListViewCard(
                          produtos,
                          index,
                          Key('$index')
                      );
                    }
                ),
              )
            : ListView.builder(
            itemCount: produtos != null ? produtos.length : 0,
            itemBuilder: (context, index){
              ProdutoModel produto = produtos[index];

              String _itemUnit; // = unitInput.keys.first;
              /*
              unitInput.forEach((name, precision) {
                if (precision.toString() == produto.precisao){
                  _itemUnit = name;
                }
              });
              */

              //print('Produto: $produto ');
              //print('ProdutoPurchased: ${produto.purchased} ');
              //print('ProdutoPurchased bool: ' + (produto.purchased == '1').toString());

              _itemUnit = produto.unidade;
              String strValor = produto.valor ?? 0;
              String qtdValStr = produto.quantidade ?? 1;
              bool isChecked = (produto.purchased == '1');

              // print('isChecked bool: ' + (isChecked).toString());

              double realVal = currencyToDouble(strValor);
              double qtdVal = currencyToQuantity(qtdValStr);
              double valTotal = (realVal * qtdVal);
              if (produto.precisao == "1") {
                valTotal = realVal;
              }

              String strTotal = doubleToCurrency(valTotal);

              if (_itemUnit == null || _itemUnit == 'null' || _itemUnit == '' ){
                _itemUnit = 'un';
              }
              if (valTotal == null){
                valTotal = 0;
              }
              if (strTotal == null || strTotal == 'null' || strTotal == '' ){
                strTotal = '0';
              }

              if (widget.tipoVisualizacao == TipoVisualizacao.LIST)
                return ListTile(
                  leading: GestureDetector(
                      child: Icon(
                          isChecked ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 35
                      ),
                      onTap: () async {
                        print('Item Comprado; $produto');

                        produto.purchased = "1";
                        ResponseApi<ProdutoModel> response = await ProdutoApi.save(produto);

                        /*
                        _db.updateItem(itemModel, itemModel.id).then((updated){
                          if (updated){ // Josimar
                            widget.itemsListBloc.getList();
                          }
                        });
                        */
                      },
                  ),
                  title: Text(produto.nome,
                      style: TextStyle(color: Colors.black, fontSize: 18)
                  ),
                  subtitle: Text('$qtdVal $_itemUnit x $strValor = $strTotal'),
                  trailing: PopupMenuButton<ListAction>(
                      onSelected: (ListAction result) async {
                        switch(result){
                          case ListAction.EDIT:
                            push(context, ProdutoAdd(lista: widget.lista, produto: produto));
                            break;
                          case ListAction.DELETE:
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext ctx){
                                  return AlertDialog(
                                    title: Text('Tem Certeza'),
                                    content: Text('Está ação irá remover o item selecionado e não pode ser desfeito'),
                                    actions: <Widget>[
                                      RaisedButton(
                                        // color: Layout.secondary(),
                                        child: Text('Cancelar' /*, style: TextStyle(color: Layout.light())*/ ),
                                        onPressed: (){
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      RaisedButton(
                                        // color: Layout.danger(),
                                        child: Text('Remover' /*, style: TextStyle(color: Layout.light()) */),
                                        onPressed: () async {
                                          /*
                                          _db.deleteItem(item[DBItem.id]);
                                          Navigator.of(ctx).pop();
                                          widget.itemsListBloc.getList(); // Josimar
                                          */
                                          ResponseApi<ProdutoModel> response = await ProdutoApi.delete(produto);
                                          if (response.ok){
                                            alert(context, "Success", "Excluido com sucesso", callback: (){
                                              EventBus.get(context).sendEvent(ProdutoEvent("registro_deleted"));

                                              Navigator.of(ctx).pop();
                                            });
                                          }else{
                                            alert(context, "Error", response.msg);
                                          }
                                          // print('Já eras produto $produto');

                                        },
                                      )
                                    ],
                                  );
                                }
                            );
                            break;
                          case ListAction.CLONE:
                            produto.id = null;
                            ResponseApi<ProdutoModel> response = await ProdutoApi.save(produto);
                            if (response.ok){
                              alert(context, "Success", "Clonado com sucesso", callback: (){
                                EventBus.get(context).sendEvent(ProdutoEvent("registro_clonado"));
                              });
                            }else{
                              alert(context, "Error", response.msg);
                            }
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context){
                        return <PopupMenuEntry<ListAction>>[
                          PopupMenuItem<ListAction>(
                            value: ListAction.EDIT,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.edit),
                                Text(DSStringLocal.editar)
                              ],
                            ),
                          ),
                          PopupMenuItem<ListAction>(
                            value: ListAction.DELETE,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.delete),
                                Text(DSStringLocal.delete)
                              ],
                            ),
                          ),
                          PopupMenuItem<ListAction>(
                            value: ListAction.CLONE,
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.content_copy),
                                Text(DSStringLocal.duplicar)
                              ],
                            ),
                          )
                        ];
                      }
                  ),
                  onTap: (){
                    print('Abrir item: $produto');
                  },
                );


              return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.grey[100],
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              produto.nome,
                              style: TextStyle(fontSize: 16),
                            ),
                            ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: const Text('Detalhe'),
                                  onPressed: () => _onClickEditaLista(context, produto),
                                ),
                                FlatButton(
                                  child: const Text('Excluir'),
                                  onPressed: () => _onClickExcluirLista(context, produto),
                                ),
                              ],
                            ),
                          ]
                      )
                  )
              );
            }
        )
    );
  }

  _onClickEditaLista(context, ProdutoModel produto) {
    print('Edita o produto: $produto');
    // push(context, ListaForm(lista: lista));
  }

  void _onClickExcluirLista(context, ProdutoModel lista) async {
    print('Excluir o produto: $produto');
    /*
    ResponseApi<ProdutoModel> response = await ProdutoApi.delete(lista);

    if (response.ok){
      alert(context, "Success", "Excluido com sucesso", callback: (){
        EventBus.get(context).sendEvent(ProdutoEvent("registro_excluido"));
      });
    }else{
      alert(context, "Error", response.msg);
    }
     */
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState((){
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        print('oldIndex: $oldIndex');
        print('newIndex: $newIndex');
        print('Item: $produtos[oldIndex]');
        print('Item: $produtos[newIndex]');

        // Pegar o item
        // final String item = produtos.removeAt(oldIndex);
        // Trocar posição do item
        // widget.produtos.insert(newIndex, item);
      },
    );
  }
}

class ListViewCard extends StatefulWidget {
  final int index;
  final Key key;
  // final List<String> listItems;
  final List<ProdutoModel> produtos;

  ListViewCard(this.produtos, this.index, this.key);

  @override
  _ListViewCard createState() => _ListViewCard();
}

class _ListViewCard extends State<ListViewCard> {
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.blue,
        onTap: () {
          fToast.showToast(
            child: ToastCustom("Item ${widget.produtos[widget.index]} selected."),
            gravity: ToastGravity.BOTTOM,
            toastDuration: Duration(seconds: 2),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Title ${widget.produtos[widget.index]}',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Description ${widget.produtos[widget.index]}',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                      textAlign: TextAlign.left,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(
                Icons.reorder,
                color: Colors.grey,
                size: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}