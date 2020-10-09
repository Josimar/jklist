import 'package:flutter/material.dart';
import 'package:jklist/widget/alert.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_api.dart';
import 'package:jklist/view/lista/lista_form.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/produto/produto_view.dart';
import 'package:jklist/view/categoria/categoria_model.dart';

class ListaCard extends StatelessWidget {
  final TipoVisualizacao tipoVisualizacao;
  final List<ListaModel> listas;
  ListaCard(this.tipoVisualizacao, this.listas);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: listas != null ? listas.length : 0,
        itemBuilder: (context, index){
          ListaModel lista = listas[index];

          if (tipoVisualizacao == TipoVisualizacao.LIST)
            return ListTile(
              leading: Icon(Icons.list),
              title: Text(lista.titulo, style: TextStyle(color: Colors.black, fontSize: 18) ),
              subtitle: Text(lista.descricao ?? '', style: TextStyle(color: Colors.black, fontSize: 14)),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                push(context, ProdutoView(lista), replace: false);
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
                      lista.titulo,
                      style: TextStyle(fontSize: 16),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('Detalhe'),
                          onPressed: () => _onClickEditaLista(context, lista),
                        ),
                        FlatButton(
                          child: const Text('Excluir'),
                          onPressed: () => _onClickExcluirLista(context, lista),
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

  _onClickEditaLista(context, ListaModel lista) {
    push(context, ListaForm(lista: lista));
  }

  void _onClickExcluirLista(context, ListaModel lista) async {
    ResponseApi<ListaModel> response = await ListaApi.delete(lista);

    if (response.ok){
      alert(context, "Success", "Excluido com sucesso", callback: (){
        EventBus.get(context).sendEvent(ListaEvent("registro_excluido"));
      });
    }else{
      alert(context, "Error", response.msg);
    }
  }

}
