import 'package:flutter/material.dart';
import 'package:jklist/view/categoria/categoria_view_model.dart';
import 'package:jklist/view/unidade/unidade_model.dart';
import 'package:jklist/view/unidade/unidade_view_model.dart';
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
  List<UnidadeModel> listUnidade;

  UnidadeModel modelUnidadeOne;
  CategoriaModel modelCategoriaOne;

  DropdownButton<String> inputUnidade;
  DropdownButton<String> inputCategoria;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerQtd = TextEditingController();
  final MoneyMaskedTextController _controllerValor = MoneyMaskedTextController(
      thousandSeparator: '.',
      decimalSeparator: ',',
      leftSymbol: 'R\$'
  );

  String _selectedCategoria;
  String _selectedUnidade;
  bool _isSelected = false;
  String idProduto = '';
  String _ordem = '0';
  String listaidProduto;
  String categoriaidProduto;

  bool _checkDados() => true;
  bool _carregaComboUnidade = true;
  bool _carregaComboCategoria = true;

  @override
  void initState() {
    super.initState();
    if (_checkDados()){
      Future.delayed(Duration.zero,() {
        final unidadeProvider = Provider.of<UnidadeViewModel>(context, listen: false);
        final categoriaProvider = Provider.of<CategoriaViewModel>(context, listen: false);

        unidadeProvider.fetchUnidade().then((value){
          // _selectedUnidade = value.firstWhere((element) => element.id == "1").descricao;
          _selectedUnidade = value.first.descricao;
          /*
          unidadeProvider.unidades.forEach((unidadeModel) {
              _selectedUnidade = unidadeModel.descricao;
          });
          */
        });
        categoriaProvider.fetchCategoria().then((value){
          _selectedCategoria = value.first.descricao;
        });

        listUnidade = unidadeProvider.unidades;
        listCategoria = categoriaProvider.categorias;
        if (listUnidade != null && listUnidade.length > 0){
          _carregaComboUnidade = true;
        }
        if (listCategoria != null && listCategoria.length > 0){
          _carregaComboCategoria = true;
        }

        // print('listCategoria_Add - build - 4');
        // print('ListCategoria: $listCategoria');
        // print('listUnidade_Add - build - 3');
        // print('ListUnidade: $listUnidade');
      });
    }

    _getThingsOnStartup().then((value){
      getUsuario();
    });

    listaidProduto = widget.lista.id;

    if (widget.produto != null){
      idProduto = widget.produto.id;
      _ordem = widget.produto.ordem;
      categoriaidProduto = widget.produto.categoriaid;
      _controllerName.text = widget.produto.nome;
      _controllerQtd.text = widget.produto.quantidade.toString();
      _controllerValor.text = widget.produto.valor;
      _isSelected = widget.produto.purchased == '1';
      _selectedUnidade = widget.produto.unidade;
    }
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    if ((listUnidade == null || listUnidade.length == 0) &&(modelUnidadeOne == null)) {
      listUnidade = new List<UnidadeModel>();
      modelUnidadeOne = new UnidadeModel(uid: "u0", id: "0", descricao: "Un", precisao: "1",slug: "un");
      listUnidade.add(modelUnidadeOne);
    } else if (listUnidade == null && modelUnidadeOne != null) {
      // print('@1@');
      listUnidade = new List<UnidadeModel>();
      listUnidade.add(modelUnidadeOne);
      modelUnidadeOne = null;
      // listUnidade.clear();
      _carregaComboUnidade = false;
    }

    if ((listCategoria == null || listCategoria.length == 0) && (modelCategoriaOne == null)) {
      listCategoria = new List<CategoriaModel>();
      modelCategoriaOne = new CategoriaModel(uid: "u0", id: "0", descricao: "Diversos", slug: "diversos", icone: "");
      listCategoria.add(modelCategoriaOne);
    } else if (listCategoria == null && modelCategoriaOne != null) {
      // print('@2@');
      listCategoria = new List<CategoriaModel>();
      listCategoria.add(modelCategoriaOne);
      modelCategoriaOne = null;
      _carregaComboCategoria = false;
    }

    // print('Produto_Add - build - 1');
    // print('Unidades: $listUnidade');
    // print('Produto_Add - build - 2');
    // print('Categorias: $listCategoria');
    // print('modelUnidadeOne: $modelUnidadeOne');

    if (_carregaComboUnidade){
      inputUnidade = DropdownButton<String>(
        value: _selectedUnidade,
        onChanged: (String newValue) {
          setState(() {
            double valueasDouble = double.tryParse(_controllerQtd.text) ?? 0.0;
            _controllerQtd.text = valueasDouble.toStringAsFixed(0);
            _selectedUnidade = newValue;
          });
        },
        items: listUnidade.map<DropdownMenuItem<String>>((UnidadeModel unidadeModel) {
          // print('Produto_Add - build - 5');
          // print('unidadeModel: $unidadeModel');
          // print('Produto_Add - build - 6');
          // print('unidadeModel.descricao: ${unidadeModel.descricao}');

          return DropdownMenuItem<String>(
            value: unidadeModel.descricao,
            child: Text(unidadeModel.descricao),
          );
        }).toList(),
      );
    }

    if (_carregaComboCategoria) {
      inputCategoria = DropdownButton<String>(
        value: _selectedCategoria,
        onChanged: (String newValue) {
          setState(() {
            _selectedCategoria = newValue;
          });
        },
        items: listCategoria.map<DropdownMenuItem<String>>((
            CategoriaModel categoriaModel) {
          return DropdownMenuItem<String>(
            value: categoriaModel.descricao,
            child: Text(categoriaModel.descricao),
          );
        }).toList(),
      );
    }

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
                        child: inputUnidade, width: 100
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
                              unidade: _selectedUnidade,
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
