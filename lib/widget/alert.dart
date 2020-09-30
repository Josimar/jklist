import 'package:flutter/material.dart';

alert(BuildContext context, String txtTitulo, String txtMensagem,
    {Function callback}) {
  showDialog(
      context: context,
      barrierDismissible: false, // não deixa fechar o alert clicando fora
      builder: (context){
        return WillPopScope(             // widget para o voltar do android
          onWillPop: () async => false,  // não fechar o popup
          child: AlertDialog(
            title: Text(txtTitulo),
            content: Text(txtMensagem),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context);
                  if (callback != null){
                    callback();
                  }
                },
              ),
            ],
          ),
        );
      }
  );
}