import 'package:flutter/material.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/services/event_bus.dart';
import 'package:jklist/view/lista/lista_api.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/widget/alert.dart';
import 'package:jklist/widget/button_custom.dart';
import 'package:jklist/widget/textForm.dart';

class ListaForm extends StatefulWidget {
  final ListaModel lista;
  const ListaForm({Key key, this.lista}) : super(key: key);

  @override
  _ListaFormState createState() => _ListaFormState();
}

class _ListaFormState extends State<ListaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final tNome = TextEditingController();
  var _showProgress = false;

  ListaModel get lista => widget.lista;

  String _validateString(String value) {
    if (value.isEmpty) {
      return 'Informe o campo';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    // Copia os dados para o form
    if (lista != null) {
      tNome.text = lista.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lista != null ? lista.nome : "Nova lista"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _form(),
      ),
    );
  }

  _form() {
    return Form(
      key: this._formKey,
      child: ListView(
        children: <Widget>[
          TextFormCustom("Nome", "", controller: tNome, keyboardType: TextInputType.text,validator: _validateString),
          Divider(),
          ButtonCustom("Salvar",onPressed: _onClickSalvar, showProgress: _showProgress),
        ],
      ),
    );
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    // Cria model
    var listaAtual = lista ?? ListaModel();
    listaAtual.nome = tNome.text;

    print("ListaForm => $listaAtual");

    setState(() {
      _showProgress = true;
    });

    print("Salvar o registro $listaAtual");

    // await Future.delayed(Duration(seconds: 3));
    ResponseApi<ListaModel> response = await ListaApi.save(listaAtual);

    if (response.ok){
      alert(context, "Success", "Salvo com sucesso", callback: (){
        EventBus.get(context).sendEvent(ListaEvent("registro_save"));

        Navigator.pop(context);
      });
    }else{
      alert(context, "Error", response.msg);
    }

    setState(() {
      _showProgress = false;
    });

    print("Fim.");
  }
}
