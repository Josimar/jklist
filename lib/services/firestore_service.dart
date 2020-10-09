import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jklist/model/usuario_model.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference = FirebaseFirestore.instance.collection('users');
  final CollectionReference _weddingCollectionReference = FirebaseFirestore.instance.collection('wedding');

  FirebaseFirestore _db = FirebaseFirestore.instance;
  String path;
  CollectionReference ref;
  // ref = _db.collection(path);

  Future<QuerySnapshot> getDataCollection() {
    return ref.get() ;
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.doc(id).update(data) ;
  }

  Future createUser(UsuarioModel user) async {
    try {
      await _usersCollectionReference.doc(user.uid).set(user.toResumeMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future createUsuario(Map<String, dynamic> userData, String userID) async {
    try {
      await _usersCollectionReference.doc(userID).set(userData);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UsuarioModel.fromData(userData.data(), uid);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

}
