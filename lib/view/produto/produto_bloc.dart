import 'package:jklist/bloc/simple_bloc.dart';
import 'package:jklist/utils/utilitarios.dart';
import 'package:jklist/view/produto/produto_api.dart';
import 'package:jklist/view/produto/produto_model.dart';
import 'package:jklist/view/produto/produto_sqlite.dart';

class ProdutoBloc extends SimpleBloc<List<ProdutoModel>>{

  Future<List<ProdutoModel>> loadProdutos(listaid) async {
    try{

      bool networkOn = await isNetworkOn();
      if (! networkOn){
        List<ProdutoModel> listas = await ProdutoSQLite().findAllByTipo(null);
        addStream(listas);
        return listas;
      }

      List<ProdutoModel> produtos = await ProdutoApi.getProdutos(listaid);

      // Pega os dados e atualiza ou cadastro no SQLite
      if (produtos.isNotEmpty){
        final daoProduto = ProdutoSQLite();
        for (ProdutoModel produto in produtos){
          daoProduto.save(produto);
        }
      }

      addStream(produtos);
      return produtos;
    }catch(error){
      addError(error);
    }

    return new List<ProdutoModel>();
  }

}

