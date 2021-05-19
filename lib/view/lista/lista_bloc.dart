import 'package:jklist/api/response_api.dart';
import 'package:jklist/bloc/simple_bloc.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/lista/lista_api.dart';
import 'package:jklist/view/lista/lista_model.dart';
import 'package:jklist/view/lista/lista_sqlite.dart';

class ListaBloc extends SimpleBloc<ListaModelList>{

  Future<ListaModelList> loadLista() async {
    ListaModelList listaModelList = new ListaModelList.newDefault('OK', '200');

    try{
      bool networkOn = await isNetworkOn();

      if (! networkOn){
        List<ListaModel> listas = await ListaSQLite().findAllByTipo(null);
        listaModelList.listas = listas;
        addStream(listaModelList);
        return listaModelList;
      }

      ResponseApi<ListaModelList> listasAPI = await ListaApi.getLista();
      var listas = listasAPI.result.listas;

      if (!listasAPI.ok || listas == null){
        listas = new List<ListaModel>();
        listaModelList.id = 'Erro';
        listaModelList.nome = '401';
        listaModelList.listas = listas;
        addStream(listaModelList);
        return listaModelList;
      }

      // Pega os dados e atualiza ou cadastro no SQLite
      if (listas.isNotEmpty){
        final daoLista = ListaSQLite();
        for (ListaModel lista in listas){
          daoLista.save(lista);
        }
      }

      listaModelList.listas = listas;
      addStream(listaModelList);
      return listaModelList;
    }catch(error){
      listaModelList.id = 'Erro';
      listaModelList.nome = '401';
      addError(error);
    }

    return listaModelList;
  }

}

