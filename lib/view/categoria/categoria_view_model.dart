import 'package:jklist/model/base_model.dart';
import 'package:jklist/services/dialog_service.dart';
import 'package:jklist/utils/locator.dart';
import 'package:jklist/view/categoria/categoria_model.dart';
import 'package:jklist/view/categoria/categoria_service.dart';

class CategoriaViewModel extends BaseModel {
  final CategoriaService _categoriaService = locator<CategoriaService>();
  final DialogService _dialogService = locator<DialogService>();

  CategoriaModel _categoria;
  bool get _editting => _categoria != null;

  List<CategoriaModel> _categorias;
  List<CategoriaModel> get categorias => _categorias;


  Future<List<CategoriaModel>> fetchCategoria() async {
    var result = await _categoriaService.getCategoria();

    if (result == null || result.documents == null){
      _categorias = new List<CategoriaModel>();
      return _categorias;
    }

    _categorias = result.documents
        .map((doc) => CategoriaModel.fromMap(doc.data, doc.documentID))
        .toList();

    if (_categorias == null){
      _categorias = new List<CategoriaModel>();
    }

    if (_categorias is List<CategoriaModel>){
      notifyListeners();
    }else{
      _dialogService.showDialog(
          title: "Update failed",
          description: _categorias != null ? _categorias : "Nenhum registro encontrado"
      );
    }

    return _categorias;
  }
}