
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jklist/view/categoria/categoria_model.dart';

class CategoriaService {

  Future getCategoria() async {
    CollectionReference _categoriasCR = FirebaseFirestore.instance.collection('categorias');

    try {
      var categoriasDS = await _categoriasCR.orderBy('descricao', descending: false).get();
      if (categoriasDS.docs.isNotEmpty){
        return categoriasDS.docs
            .map((snapshot) => CategoriaModel.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.descricao != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

}