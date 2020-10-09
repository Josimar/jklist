import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jklist/api/response_api.dart';
import 'package:jklist/services/firestore_service.dart';
import 'package:jklist/utils/locator.dart';
import 'package:jklist/view/login/login_api.dart';
import 'package:jklist/model/usuario_model.dart';

class FirebaseService{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  User _firebaseUser;
  bool get userLogged => _firebaseUser != null;

  UsuarioModel _currentUser;
  UsuarioModel get currentUser => _currentUser;

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
    @required String role,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      /* ToDo: Tratar o user model
      _currentUser = UserModel(
        uid: authResult.user.uid,
        email: email,
        fullName: fullName,
        userRole: role,
      );
      */

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserLoggedIn() async {
    if (_firebaseUser == null) {
      _firebaseUser = await _firebaseAuth.currentUser;
      await _populateCurrentUser(_firebaseUser);
    }

    return _firebaseUser != null;
  }

  Future<bool> isUserViewIntro(String userId) async{
    return false; // ToDo: Pegar do lugar certo para aparecer 1 vez apenas
  }

  Future<ResponseApi> loginFirebase(String email, String password) async{
    try{
      final UserCredential googleUserCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final User fuser = googleUserCredential.user;
      // print("Nome: ${fuser.displayName}");
      // print("E-mail: ${fuser.email}");
      // print("Foto: ${fuser.photoURL}");
      // print("Fone: ${fuser.phoneNumber}");
      // print("uid: ${fuser.uid}");

      ResponseApi response = await LoginApi.cadastro(fuser.uid, fuser.email, fuser.displayName, fuser.photoURL, fuser.phoneNumber);

      return ResponseApi.ok("Logado com sucesso");

    }catch(error){
      print("Firebase error $error");
    }
  }

  Future<ResponseApi> loginGoogle() async{
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('Google user: ${googleUser.email}');

      final GoogleAuthCredential  credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );

      final UserCredential googleUserCredential = await _firebaseAuth.signInWithCredential(credential);
      final User fuser = googleUserCredential.user;
      // print("Nome: ${fuser.displayName}");
      // print("E-mail: ${fuser.email}");
      // print("Foto: ${fuser.photoURL}");
      // print("Fone: ${fuser.phoneNumber}");
      // print("uid: ${fuser.uid}");

      ResponseApi response = await LoginApi.cadastro(fuser.uid, fuser.email, fuser.displayName, fuser.photoURL, fuser.phoneNumber);

      return ResponseApi.ok("Logado com sucesso");

    }catch(error){
      print("Firebase error $error");
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future _populateCurrentUser(User user) async {
    if (user != null) {
      _currentUser = await _firestoreService.getUser(user.uid);

      if (_currentUser == null){
        _currentUser = UsuarioModel.fromAll(
            user.email,
            user.displayName,
            user.uid,
            user.uid,
            user.email,
            user.email,
            "1"
        );
      }else if (_currentUser.nome == null){
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        _currentUser = UsuarioModel.fromData(docUser.data(), user.uid);
      }

      // _currentUser.isAdmin = await verifyPrivileges(user.uid);
    }
  }

}