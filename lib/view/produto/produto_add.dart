import 'package:flutter/material.dart';
import 'package:jklist/view/categoria/categoria_view_model.dart';
import 'package:jklist/widget/alert.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/model/usuario_model.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/produto/produto_api.dart';
import 'package:jklist/view/produto/produto_model.dart';
import 'package:jklist/view/categoria/categoria_model.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:provider/provider.dart';

class ProdutoAdd extends StatefulWidget {
  final ListaModel lista;
  final ProdutoModel produto;
  const ProdutoAdd({Key key, this.lista, this.produto}) : super(key: key);

  @override
  _ProdutoAddState createState() => _ProdutoAddState();
}

class _ProdutoAddState extends State<ProdutoAdd> {
  UsuarioModel userModel;
  List<CategoriaModel> listCategoria;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQtd = TextEditingController();
  final MoneyMaskedTextController _controllerValor = MoneyMaskedTextController(
      thousandSeparator: '.',
      decimalSeparator: ',',
      leftSymbol: 'R\$'
  );

  String _selectedCategoria = unitCategoria.keys.first;
  String _selectedUnit;
  bool _isSelected = false;
  String idProduto = '';
  String _ordem = '0';
  String listaidProduto;
  String categoriaidProduto;

  @override
  void initState() {
    super.initState();

    listaidProduto = widget.lista.id;
    // _selectedUnit = widget.categorias.length == 0 ? "" : widget.categorias[0].id;

    if (widget.produto != null){
      idProduto = widget.produto.id;
      _ordem = widget.produto.ordem;
      categoriaidProduto = widget.produto.categoriaid;

      _controllerName.text = widget.produto.nome;
      _controllerQtd.text = widget.produto.quantidade.toString();
      _controllerValor.text = widget.produto.valor;
      _isSelected = widget.produto.purchased == '1';

      /*
      widget.categorias.forEach((categoriaModel) {
        if (precision.toString() == widget.produto.precisao){
          _selectedUnit = name;
        }
      });
      */

      _selectedUnit = widget.produto.unidade;
    }
  }

  @override
  Widget build(BuildContext context) {
    getUsuario();

    final categoriaProvider = Provider.of<CategoriaViewModel>(context);
    categoriaProvider.fetchCategoria();
    listCategoria = categoriaProvider.categorias;
    if (listCategoria == null){
      listCategoria = new List<CategoriaModel>();
      CategoriaModel modelCategoria = new CategoriaModel(uid:"", id:"", descricao:"Unidade", slug:"unidade", icone:"");
      listCategoria.add(modelCategoria);
    }

    print('Produto_Add - build - $listCategoria');

    String _labelButton = 'Salvar';
    bool _salvar = true;
    if (_controllerQtd.text.isEmpty || _controllerQtd.text == '0'){
      _controllerQtd.text = '1';
    }
    if (widget.produto != null){
      _labelButton = 'Editar';
      _salvar = false;
    }

    final inputName = TextFormField(
        controller: _controllerName,
        autofocus: true,
        decoration: InputDecoration(
            hintText: 'item',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5)
            )
        ),
        validator: (value){
          if (value.isEmpty){
            return 'obrigatório';
          }
          return null;
        }
    );

    final inputQuantidade = TextFormField(
      controller: _controllerQtd,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'quantidade',
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5)
          )
      ),
      validator: (value){
        double valueAsDouble = (double.tryParse(value) ?? 0.0);

        if (valueAsDouble <= 0){
          return 'qtd obrigatória';
        }
        return null;
      },
      inputFormatters: [new QuantityFormater(precision: 0)],
    );

    final inputValor = TextFormField(
        controller: _controllerValor,
        autofocus: false,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
            hintText: 'valor',
            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5)
            )
        ),
        validator: (value){
          if (currencyToDouble(value) < 0.0){
            return 'valor obrigatório';
          }
          return null;
        }
    );

    final inputUnit = DropdownButton<String>(
      value: _selectedUnit,
      onChanged: (String newValue){
        setState(() {
          double valueasDouble = double.tryParse(_controllerQtd.text) ?? 0.0;
          _controllerQtd.text = valueasDouble.toStringAsFixed(0);
          _selectedUnit = newValue;
        });
      },
      items: listCategoria.map<DropdownMenuItem<String>>((CategoriaModel categoriaModel){
        return DropdownMenuItem<String>(
          value: categoriaModel.descricao,
          child: Text(categoriaModel.descricao),
        );
      }).toList(),
    );

    final inputCategoria = DropdownButton<String>(
      value: _selectedCategoria,
      onChanged: (String newValue){
        setState(() {
          _selectedCategoria = newValue;
        });
      },
      items: unitCategoria.keys.map<DropdownMenuItem<String>>((String value){
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto != null ? widget.produto.nome : "Novo produto"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding:EdgeInsets.all(20),
              children: <Widget>[
                Text('Adicionar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Nome'),
                inputName,
                SizedBox(height: 10),
                Text('Quantidade'),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 180,
                      child: inputQuantidade,
                    ),
                    SizedBox(width: 8,),
                    Container(
                        child: inputUnit, width: 100
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text('Valor'),
                inputValor,
                SizedBox(height: 15),
                inputCategoria,
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      // activeColor: Layout.primary(),
                      onChanged: (bool value){
                        setState(() {
                          _isSelected = value;
                        });
                      },
                      value: _isSelected,
                    ),
                    GestureDetector(
                      child: Text('Item já comprado', style: TextStyle(fontSize: 18)),
                      onTap: (){
                        setState(() {
                          _isSelected = !_isSelected;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      // color: Layout.secondary(),
                      child: Text('Cancelar' /*, style: TextStyle(color: Layout.light()) */),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    RaisedButton(
                      // color: Layout.primary(),
                      child: Text(_labelButton /*, style: TextStyle(color: Layout.light())*/ ),
                      padding: EdgeInsets.only(left: 50, right: 50),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          ProdutoModel produtoModel = ProdutoModel.fromView(
                              id: idProduto,
                              nome: _controllerName.text,
                              ordem: _ordem,
                              valor: _controllerValor.text,
                              quantidade: _controllerQtd.text,
                              unidade: _selectedUnit,
                              precisao: '0',
                              categoriaid: categoriaidProduto.toString(),
                              categoria: _selectedCategoria,
                              listaid: listaidProduto.toString(),
                              usuarioid: userModel.id,
                              purchased: _isSelected ? '1' : '0'
                          );

                          if (_salvar){
                            ResponseApi<ProdutoModel> response = await ProdutoApi.save(produtoModel);

                            if (response.ok){
                              alert(context, "Success", "Salvo com sucesso", callback: (){
                                EventBus.get(context).sendEvent(ProdutoEvent("registro_save"));

                                Navigator.pop(context);
                              });
                            }else{
                              alert(context, "Error", response.msg);
                            }

                            print('Salvar item: $produtoModel');
                            /*
                        _db.salvarItem(itemModel).then((saved){
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed(ItemsPage.tag);
                        });
                        */
                          }else{
                            ResponseApi<ProdutoModel> response = await ProdutoApi.save(produtoModel);

                            if (response.ok){
                              alert(context, "Success", "Salvo com sucesso", callback: (){
                                EventBus.get(context).sendEvent(ProdutoEvent("registro_save"));

                                Navigator.pop(context);
                              });
                            }else{
                              alert(context, "Error", response.msg);
                            }

                            print('Update item: $produtoModel');
                            /*
                        itemModel.id = ItemAddPage.itemMap[DBItem.id];
                        _db.updateItem(itemModel, ItemAddPage.itemMap[DBItem.id]).then((saved){
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed(ItemsPage.tag);
                        });
                        */
                          }

                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

  }

  void getUsuario() async {
    UsuarioModel user = await UsuarioModel.get();
    setState(() {
      userModel = user;
    });
  }
}
