import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';

// Navigator page
Future push(BuildContext context, Widget page, {bool replace = false}){

  if (replace){
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
      return page;
    }));
  }

  return Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
    return page;
  }));
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}

Future<bool> isNetworkOn() async {
  if (await ConnectivityWrapper.instance.isConnected) {
    return true;
  }else{
    return false;
  }
}

class Layout {
  static Color primary([double opacity = 1]) => Color.fromRGBO(62, 63, 89, opacity);
  static Color secondary([double opacity = 1]) => Color.fromRGBO(111, 168, 191, opacity);

  static Color light([double opacity = 1]) => Color.fromRGBO(242, 234, 228, opacity);
  static Color dark([double opacity = 1]) => Color.fromRGBO(51, 51, 51, opacity);

  static Color danger([double opacity = 1]) => Color.fromRGBO(217, 74, 74, opacity);
  static Color success([double opacity = 1]) => Color.fromRGBO(5, 100, 50, opacity);
  static Color info([double opacity = 1]) => Color.fromRGBO(100, 150, 255, opacity);
  static Color warning([double opacity = 1]) => Color.fromRGBO(166, 134, 0, opacity);
}

class DSStringLocal{
  final Locale locale;
  DSStringLocal(this.locale);

  static Map<String, Map<String, String>> _localizedValues = {
    'pt': {
      'listaVazia': 'Nenhuma lista ainda',
      'errorLoad': 'Erro carregando os dados'
    },
    'en': {
      'listaVazia': 'List empty',
      'errorLoad': 'Erro carregando os dados',
    },
    'es': {
      'listaVazia': 'Lista vacía',
      'errorLoad': 'Erro carregando os dados'
    },
  };

  String get listaVazia {return _localizedValues[locale.languageCode]['listaVazia'];}
  String get errorLoad {return _localizedValues[locale.languageCode]['errorLoad'];}
}