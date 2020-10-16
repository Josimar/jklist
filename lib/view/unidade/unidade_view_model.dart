import 'package:jklist/model/base_model.dart';
import 'package:jklist/services/dialog_service.dart';
import 'package:jklist/utils/locator.dart';
import 'package:jklist/view/unidade/unidade_model.dart';
import 'package:jklist/view/unidade/unidade_service.dart';

class UnidadeViewModel extends BaseModel {
  final UnidadeService _unidadeService = locator<UnidadeService>();
  final DialogService _dialogService = locator<DialogService>();

  UnidadeModel _unidade;
  bool get _editting => _unidade != null;

  List<UnidadeModel> _unidades;
  List<UnidadeModel> get unidades => _unidades;


  Future<List<UnidadeModel>> fetchUnidade() async {
    var result = await _unidadeService.getUnidade();

    // print('@ UnidadeViewModel @');
    // print('result');
    // print(result);

    if (result == null){
      _unidades = new List<UnidadeModel>();
      return _unidades;
    }

    /* retorno da API */
    if (result is List<UnidadeModel>){
      _unidades = result;
    }else{
      if (result.documents == null){
        _unidades = new List<UnidadeModel>();
        return _unidades;
      }
      _unidades = result.documents
          .map((doc) => UnidadeModel.fromMap(doc.data, doc.documentID))
          .toList();
    }

    if (_unidades == null){
      _unidades = new List<UnidadeModel>();
    }

    if (_unidades is List<UnidadeModel>){
      notifyListeners();
    }else{
      _dialogService.showDialog(
          title: "Update failed",
          description: _unidades != null ? _unidades : "Nenhum registro encontrado"
      );
    }

    return _unidades;
  }
}