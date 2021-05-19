import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum TipoLogin{
  API,
  FIREBASE,
  GOOGLE,
  TWITTER,
  FACEBOOK
}

enum TipoVisualizacao{
  LIST,
  LISTREORD,
  CARD
}

enum TamanhoCaixa{
  PEQ,
  MED,
  GND
}

enum FilterOptions{
  FAVORITE,
  ALL
}

enum ListAction {EDIT, DELETE, CLONE}

Map<String, int> unitCategoria = Map.from({
  'frios': 0,
  'padaria': 1,
  'açougue': 2,
  'higiêne': 3
});

Map<String, int> unitUnidade = Map.from({
  'unidade': 0,
  'caixa': 0,
  'grama': 0,
  'kilo': 3
});

class RouteArguments {
  dynamic systemModel;
  dynamic userModel;

  RouteArguments(this.systemModel, this.userModel);
}

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

double currencyToDouble(String value){
  value = value.replaceFirst('R\$', '');
//  value = value.replaceAll(RegExp(r'\.'), '');
  value = value.replaceAll(RegExp(r'\,'), '.');

  return double.tryParse(value) ?? 0.0;
}

double currencyToFloat(String value){
  return currencyToDouble(value);
}

double currencyToQuantity(String value){
  value = value.replaceFirst('R\$', '');

  return double.tryParse(value) ?? 0.0;
}

String doubleToCurrency(double value){

  NumberFormat nf = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', customPattern: '###.0#');
  return nf.format(value);
}

class QuantityFormater extends TextInputFormatter {
  final int precision;
  QuantityFormater({this.precision}) : super();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String cleanText = newValue.text.replaceAll(new RegExp(r'[^0-9.]'), '');
    double theValue = double.tryParse(cleanText) ?? 0.0;

//    print([cleanText, theValue, this.precision.toString()]);

    if (this.precision != 0) {
      int oldAfterDot = (oldValue.text.replaceAll(new RegExp(r'.+\.'), '')).length;
      int newAfterDot = (newValue.text.replaceAll(new RegExp(r'.+\.'), '')).length;

      if (oldAfterDot < newAfterDot) {
        theValue *= 10;
      } else if (oldAfterDot > newAfterDot) {
        theValue /= 10;
      }
    }

    String resultValue = theValue.toStringAsFixed(this.precision);

    TextEditingValue result = newValue.copyWith(
        text: resultValue,
        selection: newValue.selection.copyWith(
            baseOffset: resultValue.length,
            extentOffset: resultValue.length
        )
    );

    return result;
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

  static const String wt1 = "Listas para qualquer momento";
  static const String wc1 = "Crie suas listas para qualquer tipo de controle";
  static const String wt2 = "Lista de convidados";
  static const String wc2 = "RSVP mais rápido";
  static const String wt3 = "Não se perca entre as tarefas";
  static const String wc3 = "Com checklists personalizáveis, as tarefas têm prazos, status e responsabilidade de execução.";
  static const String wt4 = "Lista de compras";
  static const String wc4 = "Lista de supermercado sempre ao seu alcance";
  static const String wt5 = "Compartilhe com quem vocë quiser";
  static const String wc5 = "Compartilhar sua lista de forma simples";
  static const String skip = "Pula";
  static const String next = "Próximo";
  static const String gotIt = "Iniciar";

  static const String carregando = "Carregando...";
  static const String emptyDados = "Nenhum registro encontrado...";
  static const String deslogarDados = "Favor clicar em sair e logar novamente";
  static const String error = "Erro encontrado, favor tentar depois";
  static const String editar = "Editar";
  static const String delete = "Delete";
  static const String duplicar = "Duplicar";
}