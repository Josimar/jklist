import 'package:jklist/bloc/simple_bloc.dart';
import 'package:jklist/utilitarios.dart';
import 'package:jklist/view/lista/lista_api.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/lista/lista_sqlite.dart';

class ListaBloc extends SimpleBloc<List<ListaModel>>{

  Future<List<ListaModel>> loadLista() async {
    try{

      bool networkOn = await isNetworkOn();
      if (! networkOn){
        List<ListaModel> listas = await ListaSQLite().findAllByTipo(null);
        addStream(listas);
        return listas;
      }

      List<ListaModel> listas = await ListaApi.getLista();

      // Pega os dados e atualiza ou cadastro no SQLite
      if (listas.isNotEmpty){
        final daoLista = ListaSQLite();
        for (ListaModel lista in listas){
          daoLista.save(lista);
        }
      }

      addStream(listas);
      return listas;
    }catch(error){
      addError(error);
    }

    return new List<ListaModel>();
  }

}

